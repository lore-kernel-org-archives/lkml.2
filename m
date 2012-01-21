Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2AUJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:26:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38467 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2AUJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:26:19 -0500
Date: Sat, 21 Jan 2012 17:26:05 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?M=E1rcia?= Coutinho de Brito 
	<mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120121092605.GA2313@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <CAOtrxKN4FQSPUJpP47=4+XzjTpcOQj=Dy+MUWBVYu7mQHNaSXA@mail.gmail.com>
 <CAOtrxKM_ijORTP_5C4z0R79jy5O=_eX5iNJ_GmAqXf6d8OGe9g@mail.gmail.com>
 <CAE9FiQWbtByxJopU_SHLpiAJt_91qTs_=9dBFTYDHFh5OQQydg@mail.gmail.com>
 <CAOtrxKOy1msY_49GiVaaZ3GnORx8ifJYkiTjzDOe-Rk7LLD8rA@mail.gmail.com>
 <CAE9FiQV++kCaA-2Y0-zuR0NMzwcvd4LJ+5fdTECBPkZkhWD50Q@mail.gmail.com>
 <CAOtrxKNDTQVcg6wRJGxt_inva1YSDXG5YiO1EhH1Fs5ZDy+q3Q@mail.gmail.com>
 <CAE9FiQVPLQp+GzGsgON-nW6JKPE2_P6Aua8wHcgkOiLnhuJh4A@mail.gmail.com>
 <CAOtrxKNrMXkztu4Gtv_GFD_163fr18Au7DqyXEK-nacpu=-_eQ@mail.gmail.com>
 <CAOtrxKP6OQyf8TX8BYk+wTFNSZmLOZjHq-NBJqfnyh=PdAKSow@mail.gmail.com>
 <CAE9FiQWi5pMaKtyf_kwszO_m7fb15=d_2GpupNnSvbN61=X6bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWi5pMaKtyf_kwszO_m7fb15=d_2GpupNnSvbN61=X6bQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012109-4242-0000-0000-000000937089
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:48:29AM -0800, Yinghai Lu wrote:
> 2012/1/19 Rogério Brito <rbrito@ime.usp.br>:
> >
> > OK, now it seems that we are getting farther. The system boots, even
> > mounts the root filesystem, udev starts and, then, when it seems that
> > some USB messages are going to appear on the screen, the notebook
> > crashes with the same distortion that happened before (with some of
> > the last messages appearing being related to OHCI).
> 
> in that case, Can you try to disable OHCI in .config
> 
> CONFIG_USB_OHCI_HCD
> 
> OHCI controller 00:0b.0 is using
> Memory at b0004000 (32-bit, non-prefetchable) [size=4K]
> 
> VGA controller 00:05.0
> 	Memory at b2000000 (32-bit, non-prefetchable) [size=16M]
> 	Memory at c0000000 (64-bit, prefetchable) [size=256M]
> 	Memory at b1000000 (64-bit, non-prefetchable) [size=16M]
> 	[virtual] Expansion ROM at 80000000 [disabled] [size=128K]
> 
> it seems not related. or could be ioremap etc have problem?
> 
> So can you try to boot with nopat?

Yinghai/Bjorn,

	After carefully examination of the allocations done by the vanilla upstream
kernel; the one without the 'skip transparent bridge while sizing' code, 
I find that the allocation to one of the Bar; BAR[16], of the CardBus Bridge at 05:07.0
does not overlap that of the parent transparent bridge at 00:10.0

	Here is what I see in the video at  
	http://www.youtube.com/watch?v=_dYhkWHfep0&feature=youtu.be

[268.002554] pci 0000:05:07.0: Cardbus bridge to  [bus 06-09]
[269.002582] pci 0000:05:07.0:  bridge window [io  0x1400-0x14ff]
[270.009090] pci 0000:05:07.0:  bridge window [io  0x1000-0x10ff]
[271.012358] pci 0000:05:07.0:  bridge window [mem  0x84000000-0x87ffffff pref]
[272.015626] pci 0000:05:07.0:  bridge window [mem  0x88000000-0x8bffffff]
		                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ offending allocation

[273.018894] pci 0000:00:10.0: PCI bridge to [bus  05-06]
[274.022162] pci 0000:00:10.0:  bridge window [io  0x1000-0x1fff]
[275.025430] pci 0000:00:10.0:  bridge window [mem  0xb3200000-0xb32fffff]
[276.028698] pci 0000:00:10.0:  bridge window [mem  0xb8400000-0x87ffffff pref]


To me, the issue seems to be that due to some reason the OS either fails to Or does not try to
reallocate the addresses assigned to the the non-pref mem BAR of the  the transparent bridge
at 00:10.0.

In any case since you have deeper knowledge in this area, I will let you verify my theory.
RP

> 
> Thanks
> 
> Yinghai

