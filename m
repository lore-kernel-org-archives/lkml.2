Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2GFHS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:18:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2GFHSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <201207060112.q661CaG4002389@ignucius.se.axis.com>
References: <CAMuHMdVJTUF3r=MKzpkvj6y_xdVdw=zEgAy2_wm_hG94jdrhBA@mail.gmail.com>
	<201207060112.q661CaG4002389@ignucius.se.axis.com>
Date: Fri, 6 Jul 2012 09:18:52 +0200
X-Google-Sender-Auth: bmNk3a25yx-L14JiCxTzM2qbBMg
Message-ID: <CAMuHMdU+GdPnEgdJJFezPET5y4Q0-fqBJZZZ1cNZyPOG6_d4Ug@mail.gmail.com>
Subject: Re: size_t/ssize_t warnings (was: Re: Build regressions/improvements
 in v3.5-rc5)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Cc: jack@suse.cz, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans-Peter,

On Fri, Jul 6, 2012 at 3:12 AM, Hans-Peter Nilsson
<hans-peter.nilsson@axis.com> wrote:
>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> Date: Wed, 4 Jul 2012 22:17:28 +0200
>
>> On Wed, Jul 4, 2012 at 3:34 PM, Jan Kara <jack@suse.cz> wrote:
>> >>   + fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 372:4
>> >>   + fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 66:92
>> >   These really look like false positives (there are quite a few of this
>> > kind). Can we possibly silence them?
>>
>> These 2 warnings happen on cris only, because size_t is unsigned int and
>> ssize_t is (signed) long.
>
> Um, no, ssize_t isn't long.  Do you mean __kernel_ssize_t?

In the kernel, (s)size_t == __kernel_(s)size_t

> (Or are you looking at cris-axis-elf?  ...no, that can't be it,
> as you see __SIZE_TYPE__ being unsigned int.)
>
>> They go away if I make ssize_t int.
>
> But ssize_t already is int...
>
> N.B. size_t is different between cris-axis-elf and
> cris-axis-linux-gnu.  The former uses the default definition in
> gcc/defaults.h (long unsigned int) and the latter sets it
> specifically to "unsigned int", in gcc/config/cris/linux.h (or
> before 2010-12-09, from config/svr4.h).  The ssize_t definition
> comes from glibc, where it is "int".

OK, so (s)size_t should be (unsigned) int for Linux.

>>                         __kernel_size_t                         __kernel_ssize_t
>>                         ---------------                         ----------------
>
>> cris:                   __SIZE_TYPE__ (unsigned int)            long
>
> A bit odd; __kernel_ssize_t should probably change to int, to
> match ssize_t.

In the kernel, ssize_t == __kernel_ssize_t.

Probably the "long" dates from the time people used cris-axis-elf
instead of cris-axis-linux-gnu, and "__SIZE_TYPE" from the time
people started using cris-axis-linux-gnu?
Ah, yes, commit ac505a9fd19c99fdb622fe4896446f995151babc
("[PATCH] CRIS architecture update for 2.5.74") in full-history-linux
changed size_t from "unsigned long" to __SIZE_TYPE, but didn't
update ssize_t. Probably "signed __SIZE_TYPE" doesn't work?

So I guess they should be changed to (explicit) "unsigned int", resp.
"int". Or does it make sense to retain __SIZE_TYPE?

>> Cris-people: __SIZE_TYPE__ turned out to be hardcoded in my compiler (gcc
>> 4.6.3 from Tony's collection) to unsigned int. Is that correct?
>
> Correct, for cris-axis-linux-gnu.
>
>> And why do some 32-bit architectures use unsigned long/long?
>
> I'd guess from the gcc default.

OK, that makes sense.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
