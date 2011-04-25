Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1DYUOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:14:46 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:53582 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903Ab1DYUOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:14:44 -0400
Date: Mon, 25 Apr 2011 22:14:17 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: =?iso-8859-1?Q?Germ=E1n?= Sanchis <eaglecros@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: PCIE-to-PCI bridge doesn't pass mem resources downstream [Re:
 yenta cardbus problem]
Message-ID: <20110425201417.GB1268@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	=?iso-8859-1?Q?Germ=E1n?= Sanchis <eaglecros@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
 <20110425140035.GA27159@comet.dominikbrodowski.net>
 <BANLkTinaCZcxDEwn-z4u1CmQRm2h+Kkocw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinaCZcxDEwn-z4u1CmQRm2h+Kkocw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

thanks for the additional debug information. It seems to me to be not a
bug with the yenta driver, but with the parent PCI bridge instead.
Therefore, I've added Jesse and the linux-pci list as recipients. Germán's
problem relates to Ubuntu's 2.6.35-derived kernel; lspci snippets follow.

Let's look at the (grand-)parent bridge: It offers some, if not much I/O and
memory resources for its childs to be used:

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=09, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: d6100000-d70fffff
        Prefetchable memory behind bridge: 00000000d5100000-00000000d60fffff

The PCI bridge, however, does only pass the I/O resources downstream, but
_no_ memory at all.

04:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=04, secondary=05, subordinate=09, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: fff00000-000fffff

The CardBus bridge then has I/O resources to use, but cannot enable memory
resources:

05:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
        Memory window 0: 00000000-00000000 [disabled] (prefetchable)
        Memory window 1: 00000000-00000000 [disabled] (prefetchable)
        I/O window 0: 00001000-000010ff
        I/O window 1: 00001400-000014ff

So my question to the PCI folks: why does the PCI bridge fail to pass memory
regions downstream, and assign them properly to the CardBus bridge?

@Germán: assign_busses won't be needed, AFAICT, and possibly override_bios
neither (if we get the PCI bridge to work, that is...) -- it gets into
action much later during yenta_cardbus initialization.

Best,
	Dominik


On Mon, Apr 25, 2011 at 07:13:12PM +0200, Germán Sanchis wrote:
> Hi again.
> 
> First of all, thanks for your help.
> 
> Then, one small note: in my first message, the lspci info might have
> been slightly incorrect: when I first posted this error in the ubuntu
> forums, lspci reported the devices as:
> ...
> 04:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI
> Express-to-PCI Bridge (rev 03)
> 05:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 
> whereas this morning it was reporting them at 05:00.0 and 06:00.0. I
> changed that part of the post, but didn't think about changing the
> rest. Right now, and with the assign_busses and override_bios options,
> lspci is reporting them on 04:00.0 and 05:00.0. Just in case you
> notice a small inconsistency in that sense.
> 
> I tried the "override_bios=1" parameter when loading yenta_socket, but
> that does not seem to help. I did this by:
> 
> $ echo "options yenta_socket override_bios=1" >
> /etc/modprobe.d/yenta_socket.conf
> 
> and rebooted. Just to let you know what was done, since it is the
> first time I do this and googled for it, so I want to make sure that I
> am not reporting to have tried something which I might have done
> incorrectly.
> 
> I am attaching three files to this email:
> 
> - A.log is the dmesg output when the switch is in position A
> - B.log is the dmesg output when the switch is in position B
> - lspci.log is the output of lspci -vvv with the switch in position A.
> When the switch is in position B, lspci does not report the devices 04
> and 05 above.
> 
> All the files were collected with  'ddebug_query="module yenta_socket
> +p" pci=assign-busses' kernel options, and with yenta_socket
> override_bios option.
> 
> Thanks again for your help,
> 
> best regards,
> 
> Germán Sanchis Trilles
