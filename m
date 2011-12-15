Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab1LOIbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:31:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58398 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOIbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:31:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAOvLkw08BQjexftPZbKCL83uuSaAS7Cn2q2rAamewDDbVtPcxw@mail.gmail.com>
References: <CAOvLkw08BQjexftPZbKCL83uuSaAS7Cn2q2rAamewDDbVtPcxw@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 15 Dec 2011 09:30:45 +0100
Message-ID: <CAK1hOcPd0ubEOPQDtey71giaj0aBTp-k5ZSROQJDakOq=zgUuQ@mail.gmail.com>
Subject: Re: a problem in cpucheck.c on x86
To: ttlxzz ccc <boyzccc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 8:51 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
> Hi,all:
>
> In arch/x86/boot/cpucheck.c
> static int has_eflag(u32 mask)
> {
>        u32 f0, f1;
>
>        asm("pushfl ; "
>            "pushfl ; "
>            "popl %0 ; "
>            "movl %0,%1 ; "
>            "xorl %2,%1 ; "
>            "pushl %1 ; "
>            "popfl ; "
>            "pushfl ; "
>            "popl %1 ; "
>            "popfl"
>            : "=&r" (f0), "=&r" (f1)
>            : "ri" (mask));
>
>        return !!((f0^f1) & mask);
> }
>
>            "pushl %1 ; "
>            "popfl ; "
>            "pushfl ; "
>            "popl %1 ; "
> I don't know what does above 4 instructions do,

They move value from register %1 to EFLAGS register, and back.
Some bits in EFLAGS are immutable, thus this operation
can change %1.

Basically, this operation checks whether bit we flipped by xor
is really mutable in EFLAGS, or not.

> and I rewirte it like this:
>
> static int has_eflag(u32 mask)
> {
>        u32 f0;
>
>        asm("pushfl ; "
>            "pushfl ; "
>            "popl %0 ; "
>            "popfl"
>            : "=&r" (f0));

Well, you can get rid of outer pair of pushfl/popfl too, then...

>        return ~f0 & mask;
>
> }
> It works well, and I just want to know is there some special meanings
> of the 4 instructions?

Maybe it works on your particular CPU (meaning: kernel doesn't
misdetect anything dangerous on your CPU), but in general
what you did is wrong, and will surely cause breakage on other CPUs.

-- 
vda
