Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744Ab2EDUoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:44:16 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab2EDUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:44:12 -0400
Message-Id: <20120504204224.883145095@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [ 06/75] x86, microcode: Fix sysfs warning during module unload on unsupported CPUs
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -418,10 +418,8 @@ static int mc_device_add(struct device *
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
-		sysfs_remove_group(&dev->kobj, &mc_attr_group);
+	if (microcode_init_cpu(cpu) == UCODE_ERROR)
 		return -EINVAL;
-	}
 
 	return err;
 }


