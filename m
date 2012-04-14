Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2DNSYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:24:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab2DNSXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:23:49 -0400
Date: Sat, 14 Apr 2012 11:23:32 -0700
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-a956bd6f8583326b18348ab1452b4686778f785d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        mingo@kernel.org, andreas.herrmann3@amd.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <20120411163849.GE4794@alberich.amd.com>
References: <20120411163849.GE4794@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode:
  Fix sysfs warning during module unload on unsupported CPUs
Git-Commit-ID: a956bd6f8583326b18348ab1452b4686778f785d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 14 Apr 2012 11:23:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a956bd6f8583326b18348ab1452b4686778f785d
Gitweb:     http://git.kernel.org/tip/a956bd6f8583326b18348ab1452b4686778f785d
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 12 Apr 2012 16:48:01 +0200
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Fri, 13 Apr 2012 11:49:06 +0200

x86, microcode: Fix sysfs warning during module unload on unsupported CPUs

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

Cc: stable@vger.kernel.org
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/20120411163849.GE4794@alberich.amd.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 87a0f86..d389e74 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -419,10 +419,8 @@ static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR) {
-		sysfs_remove_group(&dev->kobj, &mc_attr_group);
+	if (microcode_init_cpu(cpu) == UCODE_ERROR)
 		return -EINVAL;
-	}
 
 	return err;
 }
