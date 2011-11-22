Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1KVMHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:07:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39728 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1KVMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:07:53 -0500
Date: Tue, 22 Nov 2011 13:09:09 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Meelis Roos <mroos@linux.ee>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
Message-ID: <20111122120909.GC3901@phenom.ffwll.local>
Mail-Followup-To: Meelis Roos <mroos@linux.ee>,
	David Woodhouse <dwmw2@infradead.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:15:24PM +0200, Meelis Roos wrote:
> 3.0 worked fine, 3.1-rc9 worked fine, I think -rc10 too. 3.1 release 
> hangs in random places while using X.
> 
> Core i5 660, lspci below. Running 64-bit Debian unstable.
> 
> lspci -nn
> 
> 00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0040] (rev 02)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0042] (rev 02)
> 00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
> 00:16.3 Serial controller [0700]: Intel Corporation 5 Series/3400 Series Chipset KT Controller [8086:3b67] (rev 06)
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82578DM Gigabit Network Connection [8086:10ef] (rev 05)
> 00:1a.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 05)
> 00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 05)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 05)
> 00:1c.4 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 [8086:3b4a] (rev 05)
> 00:1c.6 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 7 [8086:3b4e] (rev 05)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 05)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev a5)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 5 Series Chipset LPC Interface Controller [8086:3b0a] (rev 05)
> 00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller [8086:3b22] (rev 05)
> 3f:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c61] (rev 05)
> 3f:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 05)
> 3f:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 05)
> 3f:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 05)
> 3f:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 05)
> 3f:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 05)
> 
> 
> Bisected it to the following commit. Bisection may not be 100% correct 
> because the issue happens at random, and most of the "good" revisions 
> got some usage without problems. The "bad" bisects are the ones that 
> hang.
> 
> 6fbcfb3e467adb414e235eeefaeaf51ad12f2461 is the first bad commit
> commit 6fbcfb3e467adb414e235eeefaeaf51ad12f2461
> Author: David Woodhouse <dwmw2@infradead.org>
> Date:   Sun Sep 25 19:11:14 2011 -0700
> 
>     intel-iommu: Workaround IOTLB hang on Ironlake GPU
>     
>     To work around a hardware issue, we have to submit IOTLB flushes while
>     the graphics engine is idle. The graphics driver will (we hope) go to
>     great lengths to ensure that it gets that right on the affected
>     chipset(s)... so let's not screw it over by deferring the unmap and
>     doing it later. That wouldn't be very helpful.
>     
>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Can you retry with Keith's latest drm-intel-fixes, please? This workaround
turned out to be a bit buggy, unfortunately. It's strange though that your
bisect ended up on this commit, so maybe it's something else. Also please
attach the full dmesg of a broken kernel (before it hangs).

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
