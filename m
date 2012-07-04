Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2GDURc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 16:17:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52356 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2GDUR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:17:29 -0400
MIME-Version: 1.0
Date: Wed, 4 Jul 2012 22:17:28 +0200
X-Google-Sender-Auth: fSnoVGa5fLZ-se8kh0LAI1x5uQw
Message-ID: <CAMuHMdVJTUF3r=MKzpkvj6y_xdVdw=zEgAy2_wm_hG94jdrhBA@mail.gmail.com>
Subject: size_t/ssize_t warnings (was: Re: Build regressions/improvements in v3.5-rc5)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 3:34 PM, Jan Kara <jack@suse.cz> wrote:
>>   + fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:  => 372:4
>>   + fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]:  => 66:92
>   These really look like false positives (there are quite a few of this
> kind). Can we possibly silence them?

These 2 warnings happen on cris only, because size_t is unsigned int and
ssize_t is (signed) long. They go away if I make ssize_t int.

I had a look at the various definitions of size_t and ssize_t:

                        __kernel_size_t                         __kernel_ssize_t
                        ---------------                         ----------------

generic 32-bit:         unsigned int                            int
generic 64-bit:         __kernel_ulong_t (unsigned long)
__kernel_long_t (long)

Exceptions:

avr32:                  unsigned long                           long
blackfin:               unsigned long                           long
cris:                   __SIZE_TYPE__ (unsigned int)            long
mn10300/__GNUC__ == 4:  unsigned int                            signed int
mn10300/__GNUC__ != 4:  unsigned long                           signed long
s390 (32-bit):          unsigned long                           int
x32:                    __kernel_ulong_t (unsigned long long)
__kernel_long_t (long long)

On cris, I get the warning if ssize_t != int.
Whether size_t is unsigned int or unsigned long doesn't matter.
So it's not just a mismatch between int and long.

I also tried blackfin, which has matching unsigned long/long, and it doesn't
give the warning. Presumably the toolchain has size_t hardcoded to long for
printf-style format checking?

I haven't tried s390 yet, which also has a non-matching combination (unsigned
long vs. int).

Cris-people: __SIZE_TYPE__ turned out to be hardcoded in my compiler (gcc
4.6.3 from Tony's collection) to unsigned int. Is that correct?

And why do some 32-bit architectures use unsigned long/long?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
