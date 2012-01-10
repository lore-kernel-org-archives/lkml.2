Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2AJFHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 00:07:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54360 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2AJFHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 00:07:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
	<CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
Date: Mon, 9 Jan 2012 21:07:48 -0800
X-Google-Sender-Auth: 0c_Oim-YXo6DNmJcPIM-Y0wOSVs
Message-ID: <CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 6:41 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>
> I have posted some information to bugzilla (see [0]), but not with
> pci=earlydump. It seems that bugzilla doesn't want to mail me a reset
> e-mail, but while I am waiting, I posted this on my homepage (see
> [1]).

cool.
your system have bridge 00:10.0, and under it there is 05:07.0 and it
is one card bus bridge

for pci bridge, BIOS only allocate small range to mmio, and does not
allocate mmio_pref to it.

looks like bridge 00:10.0 does not like kernel probe its mmio pref register.

with the transparent bridge skip patch, kernel will not touch mmio
pref register,

and cardbus bridge will get allocation from root bus resource range...

[    0.162791] pci 0000:05:07.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
[    0.162863] pci 0000:05:07.0: BAR 9: assigned [mem
0x88000000-0x8bffffff pref]
[    0.162946] pci 0000:05:07.0: BAR 8: assigned [io  0x1000-0x10ff]
[    0.163016] pci 0000:05:07.0: BAR 7: assigned [io  0x1400-0x14ff]
[    0.163083] pci 0000:05:07.0: CardBus bridge to [bus 06-09]
[    0.163150] pci 0000:05:07.0:   bridge window [io  0x1400-0x14ff]
[    0.163220] pci 0000:05:07.0:   bridge window [io  0x1000-0x10ff]
[    0.163290] pci 0000:05:07.0:   bridge window [mem
0x88000000-0x8bffffff pref]
[    0.163331] pci 0000:05:07.0:   bridge window [mem 0x84000000-0x87ffffff]
[    0.163402] pci 0000:00:10.0: PCI bridge to [bus 05-06]
[    0.163471] pci 0000:00:10.0:   bridge window [mem 0xb3200000-0xb32fffff]

I have some pending patches that may fix bridge resource resizing.

Can you try them at

      git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci2

also please boot with "debug ignore_loglevel"

BTW, did you try boot with "pci=use_crs" and not with "acpi=off" ?

Thanks

Yinghai
