Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0IRMsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 08:48:51 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31285 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172Ab0IRMsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 08:48:50 -0400
Subject: Re: [PATCH] drm/edid: Don't repeatedly log hex dumps of bad EDIDs
 by default
From: Andy Walls <awalls@md.metrocast.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
In-Reply-To: <20100918115043.GB2953@joi.lan>
References: <1284764006.13604.21.camel@morgan.silverblock.net>
	 <20100918115043.GB2953@joi.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 08:48:26 -0400
Message-ID: <1284814106.2053.51.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-17_13:2010-09-18,2010-09-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009180035
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 13:50 +0200, Marcin Slusarz wrote:
> On Fri, Sep 17, 2010 at 06:53:26PM -0400, Andy Walls wrote:
> > On my system, every 10 seconds drm_edid_block_valid() gets called 4
> > times by radeon_dvi_detect().  This results in 4 instances of a
> > multi-line hex dump of the same EDID (non-)data being logged every 10
> > seconds.
> > 
> > Silence the hex dump from drm_edid_block_valid() unless a drm_debug
> > module parameter flag is set.
> > 
> > Signed-of-by: Andy Walls <awalls@md.metrocast.net>
> > 
> > diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> > index dce5c4a..33a748c 100644
> > --- a/drivers/gpu/drm/drm_edid.c
> > +++ b/drivers/gpu/drm/drm_edid.c
> > @@ -173,9 +173,12 @@ drm_edid_block_valid(u8 *raw_edid)
> >  
> >  bad:
> >         if (raw_edid) {
> > -               DRM_ERROR("Raw EDID:\n");
> > -               print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
> > -               printk("\n");
> > +               DRM_DEBUG("Raw EDID:\n");
> > +               if (drm_debug & DRM_UT_CORE) {
> > +                       print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE,
> > +                                            raw_edid, EDID_LENGTH);
> > +                       printk("\n");
> > +               }
> >         }
> >         return 0;
> >  }
> > 
> 
> Why not print it only once on original error level?
> Something like:
> static bool printed = false;
> if (!printed) {
> 	...
> 	printed = true;
> }
> 
> It has the same effect for you (no spamming by default) and it's still provide some information.

That's acceptable to me.  I'm assuming that if the radeon.ko and drm.ko
modules get loaded early (from initrd), that the log instance will still
be in the dmesg ring buffer for when the OS can finally log dmesg to
disk.

I'm still getting spammed every 10 seconds.  It's just not as bad now:

        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: radeon 0000:01:05.0: DVI-D-1: EDID invalid.
        Sep 17 11:56:26 morgan kernel: [drm:radeon_dvi_detect] *ERROR* DVI-D-1: probed a monitor but no|invalid EDID
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
        Sep 17 11:56:26 morgan kernel:
        Sep 17 11:56:26 morgan kernel: radeon 0000:01:05.0: DVI-D-1: EDID invalid.
        Sep 17 11:56:26 morgan kernel: [drm:radeon_dvi_detect] *ERROR* DVI-D-1: probed a monitor but no|invalid EDID


My MSI-7302 motherboard apparently has a graphics chipset that supports
DVI, but the motherboard has no physical DVI connector - only a VGA
connector.  The invalid EDID data is just junk, and not real data from
that I2C(?) bus.   lspci output on the PCIe graphics chipset is below.

If there's any easy way to just stop all the spam about the DVI
connector, I'd be interested.

Regards,
Andy


# lspci -tvnn
-[0000:00]-+-00.0  ATI Technologies Inc RS690 Host Bridge [1002:7911]
           +-01.0-[01]----05.0  ATI Technologies Inc Radeon 2100 [1002:796e]
           +-04.0-[02]----00.0  Conexant Systems, Inc. Device [14f1:8880]
           +-05.0-[03]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168]
           +-11.0  ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode] [1002:4390]
           +-12.0  ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
           +-12.1  ATI Technologies Inc SB700 USB OHCI1 Controller [1002:4398]
           +-12.2  ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
           +-13.0  ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
           +-13.1  ATI Technologies Inc SB700 USB OHCI1 Controller [1002:4398]
           +-13.2  ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
           +-14.0  ATI Technologies Inc SBx00 SMBus Controller [1002:4385]
           +-14.1  ATI Technologies Inc SB700/SB800 IDE Controller [1002:439c]
           +-14.2  ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
           +-14.3  ATI Technologies Inc SB700/SB800 LPC host controller [1002:439d]
           +-14.4-[04]----02.0  Internext Compression Inc iTVC15 MPEG-2 Encoder [4444:0803]
           +-14.5  ATI Technologies Inc SB700/SB800 USB OHCI2 Controller [1002:4399]
           +-18.0  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
           +-18.1  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
           +-18.2  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
           \-18.3  Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]

# lspci -vnn
00:00.0 Host bridge [0600]: ATI Technologies Inc RS690 Host Bridge [1002:7911]
	Subsystem: ATI Technologies Inc Device [1002:7910]
	Flags: bus master, 66MHz, medium devsel, latency 0

00:01.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx) [1002:7912] (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fe600000-fe7fffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000dfffffff
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx) [1002:7912]
	Kernel modules: shpchp
[...]
01:05.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon 2100 [1002:796e] (prog-if 00 [VGA controller])
	Subsystem: Micro-Star International Co., Ltd. Device [1462:7302]
	Flags: bus master, fast devsel, latency 64, IRQ 28
	Memory at d8000000 (64-bit, prefetchable) [size=128M]
	Memory at fe7f0000 (64-bit, non-prefetchable) [size=64K]
	I/O ports at d000 [size=256]
	Memory at fe600000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 2
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Kernel driver in use: radeon
	Kernel modules: radeon
[...]




