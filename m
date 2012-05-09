Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab2EIF76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:59:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354Ab2EIFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:45 -0400
Message-Id: <20120509055042.631394070@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [ 093/167] [PATCH] x86, microcode: Fix sysfs warning during module unload on
 unsupported CPUs
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit a956bd6f8583326b18348ab1452b4686778f785d upstream.

Loading the microcode driver on an unsupported CPU and subsequently
unloading the driver causes

 WARNING: at fs/sysfs/group.c:138 mc_device_remove+0x5f/0x70 [microcode]()
 Hardware name: 01972NG
 sysfs group ffffffffa00013d0 not found for kobject 'cpu0'
 Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel btusb snd_hda_codec bluetooth thinkpad_acpi rfkill microcode(-) [last unloaded: cfg80211]
 Pid: 4560, comm: modprobe Not tainted 3.4.0-rc2-00002-g258f742 #5
 Call Trace:
  [<ffffffff8103113b>] ? warn_slowpath_common+0x7b/0xc0
  [<ffffffff81031235>] ? warn_slowpath_fmt+0x45/0x50
  [<ffffffff81120e74>] ? sysfs_remove_group+0x34/0x120
  [<ffffffffa00000ef>] ? mc_device_remove+0x5f/0x70 [microcode]
  [<ffffffff81331eb9>] ? subsys_interface_unregister+0x69/0xa0
  [<ffffffff81563526>] ? mutex_lock+0x16/0x40
  [<ffffffffa0000c3e>] ? microcode_exit+0x50/0x92 [microcode]
  [<ffffffff8107051d>] ? sys_delete_module+0x16d/0x260
  [<ffffffff810a0065>] ? wait_iff_congested+0x45/0x110
  [<ffffffff815656af>] ? page_fault+0x1f/0x30
  [<ffffffff81565ba2>] ? system_call_fastpath+0x16/0x1b

on recent kernels.

This is due to commit 8a25a2fd126c ("cpu: convert 'cpu' and
'machinecheck' sysdev_class to a regular subsystem") which renders
commit 6c53cbfced04 ("x86, microcode: Correct sysdev_add error path")
useless.

See http://marc.info/?l=linux-kernel&m=133416246406478

Avoid above warning by restoring the old driver behaviour before
6c53cbfced04 ("x86, microcode: Correct sysdev_add error path").

Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/20120411163849.GE4794@alberich.amd.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
[bwh: Backported to 3.2: deleted line uses sys_dev, not dev]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/microcode_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -419,10 +419,8 @@ static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+	if (microcode_init_cpu(cpu) == UCODE_ERROR)
 		return -EINVAL;
-	}
 
 	return err;
 }


