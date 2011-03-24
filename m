Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1CXM14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:27:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:36145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1CXM1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:27:55 -0400
Message-Id: <b7da2f$qre4te@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,236,1299484800"; 
   d="scan'208";a="901190574"
Date: Thu, 24 Mar 2011 12:27:52 +0000
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Subject: Re: regression: GM45 on Dell Latitude E6400 display from 1440x900 to 1024x768 somewhere between 2.6.38-git2 and -git7
Cc: linux-kernel@vger.kernel.org
References: <AANLkTimxnG56Q29CpKi7q0kiam2cDKHdB5OjV-vu4he9@mail.gmail.com> <1bdc18$jvuest@fmsmga002.fm.intel.com> <AANLkTinG5jvw7mYVxkhQ0RqpCyDmPTHHbiHxW8oHhwz0@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTinG5jvw7mYVxkhQ0RqpCyDmPTHHbiHxW8oHhwz0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 13:03:55 +0100, Alessandro Suardi <alessandro.suardi@gmail.com> wrote:
> OK - attaching in .tgz as they'd probably cross lkml size limits:

Ok, the clue to the bizarre sizing is:

[   376.501] (WW) intel(0): No outputs definitely connected, trying again...
[   376.501] (II) intel(0): Output LVDS1 connected
[   376.501] (II) intel(0): Output VGA1 disconnected
[   376.501] (II) intel(0): Output HDMI1 disconnected
[   376.501] (II) intel(0): Output DP1 disconnected
[   376.501] (II) intel(0): Output HDMI2 disconnected
[   376.501] (II) intel(0): Output DP2 disconnected
[   376.501] (II) intel(0): Output DP3 disconnected
[   376.501] (II) intel(0): Output TV1 connected
[   376.502] (II) intel(0): Using fuzzy aspect match for initial modes
[   376.502] (II) intel(0): Output LVDS1 using initial mode 1024x768 +0+0
[   376.502] (II) intel(0): Output TV1 using initial mode 1024x768 +0+0

Transient false TV detection rears its ugly head again. (It's detected
during the 'working' setup but then disappears upon reprobing.) So X
choose the intersection of the available modes, 1024x768. But that
doesn't explain why the LVDS exists (it prints the EDID for it) but it
thinks it is disconnected.

The difference in the dmesg is:

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
Hardware name: Latitude E6400
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit i2c_core video
Pid: 906, comm: modprobe Not tainted 2.6.38-git14 #1
Call Trace:
 [<ffffffff8103319b>] warn_slowpath_common+0x80/0x98
 [<ffffffff81033247>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff811253d0>] sysfs_add_one+0x92/0xa6
 [<ffffffff81125ad6>] sysfs_do_create_link+0xf3/0x186
 [<ffffffffa000175f>] acpi_video_bus_add+0x982/0xc87 [video]

which can be temporary fixed by reverting 9661e92c10a97752. But I don't
immediately see how that would cause the LVDS to be declared disconnected.
Can you add drm.debug=0xe to your grub kernel parameters and attach a
fresh dmesg?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
