Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab0K2O7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:59:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63822 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0K2O67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:58:59 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=UuO6cx77fMcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=GUc9dAzyX-I65v3z8T4A:9 a=1wvEiauP5XdK-Bf0_CgA:7 a=hmGbxmerc_qlZasORh0Ces3Jv1UA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF30B46.4000203@pavlinux.ru>
References: <4CF30B46.4000203@pavlinux.ru>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 29 Nov 2010 09:58:57 -0500
Message-ID: <1291042737.30543.730.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 05:09 +0300, Pavel Vasilyev wrote:
> This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).

But these are not the same. strncmp() will stop when a or b hit a null.
I'm not sure if memcmp() must do so, It may for some reason check
anything within the memory of a+c-1 or b+c-1. What happens if a or b are
right at the end of a vmalloc page, and is just a single character and
null?

	x = vmalloc(32);
	strcpy(x, "some 31 byte string + null");

	call_func(x + 31);

in call_func we have:

	call_func(char *a) {

	strncmp(a, "this is some big string", 23);

With strncmp() when we hit a+1, it will stop comparing because a+1 is
null. With memcmp there's no such guarantee. We can then take a kernel
oops.

That will be a nice thing to try to debug.

Yes the above is contrived, but it demonstrates a possible problem with
this conversion.

-- Steve

> 
> I test on x86_64 (AMD Opteron 285).
> 
> #include <string.h>
> char *A = "0000";
> void test_memcmp(void) {
>         memcmp(A, "TEST", 4);
> }
> void test_strn(void) {
>         strncmp(A, "TEST", 4);
> }
> # gcc -c -O2 test.c
> # objdump -d test.o
> ...
> 
> 0000000000000020 <test_strncmp>:
>   20:   f3 c3                   repz retq
>   22:   66 66 66 66 66 2e 0f    data32 data32 data32 data32 nopw
> %cs:0x0(%rax,%rax,1)
>   29:   1f 84 00 00 00 00 00
> 
> 0000000000000030 <test_memcmp>:
>   30:   f3 c3                   repz retq
> 
> Wow, minus  one commad :)
> 


