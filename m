Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0H2TYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 15:24:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52969 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0H2TYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 15:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HAmW0K39zi6j/hBZ2QIVxHC/e/pQ5mkHLweQsL4gwqr5wOIt2AxRvcqPFwF/67KFxp
         ffu3iovmy/YR9ZRpz63Q7/ZYVbvqzGN7KO5ELaLjsfC68HK0GfDqj6PasHHReXKPLD7d
         EMqFOTlehDiMgMaTzgFH3mORDy77XXwL9tHlg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
Date: Sun, 29 Aug 2010 21:24:43 +0200
Message-ID: <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com>
Subject: Re: Linux 2.6.36-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 7:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> You all know the drill by now: another week, another -rc.

I'm still seeing the regression from -rc1 that the start of the early
serial output only contains garbage.

I'm blaming commit 8fee13a48e4879fba57725f6d9513df4bfa8e9f3 (x86,
setup: enable early console output from the decompressor), because if
I'm disabling the new serial_putchar() in
arch/x86/boot/compressed/misc.c by putting "return;" in its first
line, the output returns to normal.

Here the different outputs from the serial console:
Start of output from 2.6.35:
[    0.000000] Linux version 2.6.35 (root@treogen) (gcc version 4.4.4
(Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #1 SMP Mon Aug 2 19:54:57 CEST
2010
[    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
video=1280x1024
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)

Start of output from 2.6.36-rc1..3:
{binary garbage}00000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)

Start of output with disabled serial_putchar():
[    0.000000] Linux version 2.6.36-rc3 (root@treogen) (gcc version
4.4.4 (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #1 SMP Sun Aug 29 19:03:00
CEST 2010
[    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
video=1280x1024
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)

I can't see anything wrong with this commit, but it looks to me, as if
the newly added decompressor output gets corrupted somewhere. Could it
be my nondefault baud rate at 115200?

Thanks for looking at this,
              Torsten
