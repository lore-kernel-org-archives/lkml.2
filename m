Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1DFIlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:41:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39653 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab1DFIlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:41:15 -0400
Date: Wed, 6 Apr 2011 10:41:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Gabriel Paubert <paubert@iram.es>
Cc: Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110406084101.GB13963@pengutronix.de>
References: <20110404235259.GA30132@iram.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110404235259.GA30132@iram.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

On Tue, Apr 05, 2011 at 01:52:59AM +0200, Gabriel Paubert wrote:
> I've had the following funny crashes on PPC machines, with
> cataleptic X server as a consequence:
> 
> kernel: [drm] Setting GART location based on new memory map
> kernel: Oops: Exception in kernel mode, sig: 4 [#1]
> kernel: CHRP
> kernel: last sysfs file: /sys/devices/pci0001:01/0001:01:08.0/resource
> kernel: NIP: c05648fc LR: c0226f58 CTR: 00000008
> kernel: REGS: ddb53d20 TRAP: 0700   Not tainted  (2.6.38)
> kernel: MSR: 00089032 <EE,ME,IR,DR>  CR: 48044482  XER: 00000000
> kernel: TASK = ddab12b0[3040] 'Xorg' THREAD: ddb52000
> kernel: GPR00: c0226f34 ddb53dd0 ddab12b0 00000000 c0509e6c 00000000 00000000 00000000 
> kernel: GPR08: 00000000 00000000 00000000 00000000 28044488 101f3d8c bf8166b4 00002c00 
> kernel: GPR16: 101b9458 1006f1a0 101ebe0c 00000001 101ebe08 00000000 df9efc20 df9efc00 
> kernel: GPR24: c0591e54 80546440 ddacf660 df9efc00 c0506048 c0480210 00a00000 df9ef800 
> kernel: NIP [c05648fc] platform_device_register_resndata+0x4/0xa4
> kernel: LR [c0226f58] radeon_cp_init+0xd08/0x10c4
> kernel: Call Trace:
> kernel: [ddb53dd0] [c0226f34] radeon_cp_init+0xce4/0x10c4 (unreliable)
> kernel: [ddb53df0] [c020801c] drm_ioctl+0x2c0/0x3e4
> kernel: [ddb53eb0] [c0091264] do_vfs_ioctl+0x674/0x710
> kernel: [ddb53f10] [c0091340] sys_ioctl+0x40/0x70
> kernel: [ddb53f40] [c00111a8] ret_from_syscall+0x0/0x38
> kernel: --- Exception: c01 at 0xfc54a78
> kernel:     LR = 0xfc549dc
> kernel: Instruction dump:
> kernel: 736f2e31 32002f75 73722f6c 69622f6c 6962786b 6c617669 65722e73 6f2e3132 
> kernel: 006c6962 786b6266 696c652e 736f2e31 <002f7573> 722f6c69 622f6c69 62786b62 
> kernel: ---[ end trace ed79daba161e31d9 ]---
> 
> As you can see, the processor is trying to execute ASCII strings like
> "/usr/lib/libxkb" and has trouble digesting them :-) 
> 
> The backtrace is actually missing radeon_cp_init_microcode and radeon_do_init_cp
> which are inlined inside radeon_cp_init.
> 
> The trouble is that radeon_cp_init_microcode calls platform_device_register_simple
> which is a simple inline wrapper around platform_device_register_resndata, which
> happens to be already freed and overwritten with something looking like a list
> of filenames, since I have a non modular kernel.
> 
> For now I have locally reverted 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8
> which simply added an _init_or_module section attribute to 
> platform_device_register_resndata, and X is up again... 
> 
> Now it may be that it is the ioctl that does not have the right to do
> this. Actually I thought that the name radeon_cp that is registered there
> would appear somwhere under /sys (or /proc) but failed to find it...
I don't know for sure, but it looks strange to me that an ioctl can
register a device. But the fear for such code in the kernel made me
choose not to squash 737a3bb941 into 44f28bdea094. So my POV is that if
the maintainer of the radeon driver thinks registering the device is OK,
reverting 737a3bb9416 is fine for me.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
