Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1KITwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:52:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52684 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1KITwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:52:36 -0500
MIME-Version: 1.0
In-Reply-To: <1320744887.14409.379.camel@x61.thuisdomein>
References: <1320673476.14409.367.camel@x61.thuisdomein>
	<alpine.LNX.2.00.1111081025470.1964@pobox.suse.cz>
	<1320744887.14409.379.camel@x61.thuisdomein>
Date: Wed, 9 Nov 2011 20:52:35 +0100
X-Google-Sender-Auth: ZRmRhVrTsTeVTWfHlKLoHKmTlxk
Message-ID: <CAMuHMdVMkLgqjwb7yvFR-tLR2pHcckxkTLDkjNSNjAat9NZ1Mg@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] 8250_hp300: Fix warning typo 'CONFIG_8250'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Philip Blundell <philb@gnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Nov 8, 2011 at 10:34, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2011-11-08 at 10:26 +0100, Jiri Kosina wrote:
>> On Mon, 7 Nov 2011, Paul Bolle wrote:
>> > 1) If SERIAL_8250_HP300 is set but neither HPDCA nor HPAPCI are set we
>> > end up with an elaborate nop, don't we? Initialization should always
>> > fail in that case. So effectively SERIAL_8250_HP300 depends on HPDCA
>> > and/or HPAPCI. Was there perhaps some problem in translating that
>> > dependency into a Kconfig dependency?
>
> [...]
>
>> > --- a/drivers/tty/serial/8250_hp300.c
>> > +++ b/drivers/tty/serial/8250_hp300.c
>> > @@ -21,7 +21,7 @@
>> >  #include "8250.h"
>> >
>> >  #if !defined(CONFIG_HPDCA) && !defined(CONFIG_HPAPCI)
>> > -#warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
>> > +#warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
>> >  #endif
>>
>> What is the point of this warning anyway? Shouldn't everything necessary
>> be taken care of by Kconfig rules?
>
> That's exactly what I'm trying to find out with my questions (aimed at
> the m68k people, see 1) above).

I have this reminder in my local tree:

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 6033f5d..354ce91 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -109,6 +109,7 @@ config MULTIFACE_III_TTY
          To compile this driver as a module, choose M here.

 config HPDCA
+       # FIXME Should be bool and select SERIAL_8250_HP300?
        tristate "HP DCA serial support"
        depends on DIO && SERIAL_8250
        help
@@ -116,6 +117,7 @@ config HPDCA
          machine, say Y here.

 config HPAPCI
+       # FIXME Should be bool and select SERIAL_8250_HP300?
        tristate "HP APCI serial support"
        depends on HP300 && SERIAL_8250 && EXPERIMENTAL
        help

However, if these two options are bool, SERIAL_8250_HP300 can never
be m anymore.

Ah, if we just kill SERIAL_8250_HP300, we can put in the Makefile:

obj-$(CONFIG_HPDCA) += 8250_hp300.o
obj-$(CONFIG_HPAPCI) += 8250_hp300.o

Does that make sense?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
