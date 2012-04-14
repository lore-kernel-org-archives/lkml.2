Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2DNI2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:28:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46499 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2DNI2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <201204141021.28906.l.lunak@suse.cz>
References: <201204132124.21294.l.lunak@suse.cz> <201204140843.08671.l.lunak@suse.cz>
 <CA+55aFwCY0jkFGAzOP5SFb8THQts7BDb_ivChT7K6LvVn6OqoQ@mail.gmail.com> <201204141021.28906.l.lunak@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 01:27:58 -0700
X-Google-Sender-Auth: cdhtLIMdpf2Q8S2fGBoSqggl378
Message-ID: <CA+55aFwmZiWfqEF3-Lb_d1jHZQf2Od+oGQ_hfe0CYu8fBTU8nw@mail.gmail.com>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
To: Lubos Lunak <l.lunak@suse.cz>
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 1:21 AM, Lubos Lunak <l.lunak@suse.cz> wrote:
>
>  How about the patch? Are there any *actual* problems with it or can it please
> go in?

If we're going to change that thing, I'd actually prefer to just move
it inside the #ifdef __KERNEL__ entirely, and get rid of the cplusplus
case.

IOW, something like this (obviously white-space-mangled) patch:

    diff --git a/include/linux/stddef.h b/include/linux/stddef.h
    index 6a40c76bdcf1..1747b6787b9e 100644
    --- a/include/linux/stddef.h
    +++ b/include/linux/stddef.h
    @@ -3,14 +3,10 @@

     #include <linux/compiler.h>

    +#ifdef __KERNEL__
    +
     #undef NULL
    -#if defined(__cplusplus)
    -#define NULL 0
    -#else
     #define NULL ((void *)0)
    -#endif
    -
    -#ifdef __KERNEL__

     enum {
     	false	= 0,

which protects the kernel NULL definition along with the whole
offsetof and true/false ones too. And just gets rid of the insane C++
case entirely.

                Linus
