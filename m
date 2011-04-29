Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1D2IVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:21:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40135 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1D2IV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:21:28 -0400
Date: Fri, 29 Apr 2011 10:21:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: rob@curates-egg.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: Linux 2.6.39-rc4: modprobe lm85 provokes WARNING
Message-ID: <20110429102115.4e4d7fe3@endymion.delvare>
In-Reply-To: <4DB5B530.8010900@curates-egg.org>
References: <4DB5B530.8010900@curates-egg.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Mon, 25 Apr 2011 18:53:52 +0100, rob wrote:
> 
> Following the report format suggested in REPORTING-BUGS;
> 
> [2.] Full description of the problem/report:
> 
> Attempts to modprobe lm85 provokes WARNING: at fs/sysfs/dir.c:455
> sysfs_add_one+0x73/0x88().  Subsequent attempts provoke kernel oops.
>
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version):
> 
> $ cat /proc/version
> Linux version 2.6.39-rc4-1 () (gcc version 4.4.5 (Gentoo 4.4.5 p1.2,
> pie-0.4.5) ) #3 SMP PREEMPT Mon Apr 25 17:09:06 BST 2011

I can't reproduce the problem on 2.6.39-rc5 (x86-64 / gcc 4.5.0).

> (...)
> [5.] Most recent kernel version which did not have the bug:
> 
> The last known (to me) version in which this was trouble-free was Linux
> 2.6.33.7-rt29-1 #1 SMP PREEMPT RT Thu Aug 5 12:51:07 BST 2010 i686
> Intel(R) Pentium(R) D CPU 3.40GHz GenuineIntel GNU/Linux
>
> [6.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> 
> [   32.766181] ------------[ cut here ]------------
> [   32.766192] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x73/0x88()
> [   32.766196] Hardware name:         
> [   32.766198] sysfs: cannot create duplicate filename
> '/devices/pci0000:00/0000:00:1f.3/i2c-8/8-002e/temp1_auto_temp_off'

OK, this is the useful info. Please provide a dump of the device which
triggers this. First install i2c-tools, and then:
# rmmod lm85
# modprobe i2c-dev
# i2cdump -y 8 0x2e b > /tmp/i2c-8-002e.dump

With the dump I may be able to reproduce the bug.

> [   32.766201] Modules linked in: lm85(+) hwmon_vid fuse bnep rfcomm
> snd_seq_midi sata_sil snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
> snd_cs8427 snd_ac97_codec ac97_bus snd_i2c i2c_i801 snd_mpu401_uart
> snd_rawmidi sata_sil24 uvcvideo videodev btusb bluetooth
> [   32.766225] Pid: 5183, comm: modprobe Not tainted 2.6.39-rc4-1 #3
> [   32.766228] Call Trace:
> [   32.766236]  [<c102fec9>] warn_slowpath_common+0x65/0x7a
> [   32.766240]  [<c10fae8b>] ? sysfs_add_one+0x73/0x88
> [   32.766245]  [<c102ff42>] warn_slowpath_fmt+0x26/0x2a
> [   32.766250]  [<c10fae8b>] sysfs_add_one+0x73/0x88
> [   32.766254]  [<c10fa91c>] sysfs_add_file_mode+0x45/0x6d
> [   32.766259]  [<c10fc5cf>] internal_create_group+0xd1/0x12a
> [   32.766264]  [<c10fc645>] sysfs_create_group+0xc/0xf
> [   32.766272]  [<f8e5a63d>] lm85_probe+0x123/0x1ae [lm85]
> [   32.766278]  [<c133c507>] i2c_device_probe+0x6f/0x99
> [   32.766285]  [<f8e5a51a>] ? set_fan_min+0x86/0x86 [lm85]
> [   32.766290]  [<c12ae4e1>] driver_probe_device+0x81/0xfd
> [   32.766295]  [<c12ae5e6>] __device_attach+0x2a/0x2e
> [   32.766299]  [<c12adada>] bus_for_each_drv+0x3d/0x67
> [   32.766304]  [<c12ae650>] device_attach+0x47/0x5b
> [   32.766308]  [<c12ae5bc>] ? __driver_attach+0x5f/0x5f
> [   32.766312]  [<c12ad965>] bus_probe_device+0x18/0x2d
> [   32.766316]  [<c12ace3c>] device_add+0x37a/0x4b8
> [   32.766322]  [<c12b2495>] ? device_pm_init+0x26/0x39
> [   32.766326]  [<c12acf8c>] device_register+0x12/0x15
> [   32.766331]  [<c133d61b>] i2c_new_device+0xe0/0x129
> [   32.766335]  [<c133dc1b>] i2c_do_add_adapter+0xf1/0x1a5
> [   32.766341]  [<c133dcec>] __process_new_driver+0x1d/0x20
> [   32.766346]  [<c12add05>] bus_for_each_dev+0x3d/0x67
> [   32.766350]  [<c133dccf>] ? i2c_do_add_adapter+0x1a5/0x1a5
> [   32.766354]  [<c133c7b5>] i2c_for_each_dev+0x22/0x37
> [   32.766358]  [<c133dccf>] ? i2c_do_add_adapter+0x1a5/0x1a5
> [   32.766363]  [<c133c862>] i2c_register_driver+0x7d/0x86
> [   32.766369]  [<f8e5e012>] sm_lm85_init+0x12/0x14 [lm85]
> [   32.766374]  [<c1001159>] do_one_initcall+0x71/0x113
> [   32.766378]  [<f8e5e000>] ? 0xf8e5dfff
> [   32.766383]  [<c105ad21>] sys_init_module+0x77/0x19a
> [   32.766389]  [<c14f118c>] sysenter_do_call+0x12/0x22
> [   32.766394] ---[ end trace 968cdc4911c9d3b1 ]---
> [   32.766415] lm85: probe of 8-002e failed with error -17
> 
> A subsequent attempt yields;
> 
> [ 1041.893548] BUG: unable to handle kernel NULL pointer dereference at
> 00000010
> [ 1041.893615] IP: [<c14ebb5c>] mutex_lock+0x9/0x21
> [ 1041.893656] *pde = 00000000
> [ 1041.893680] Oops: 0002 [#1] PREEMPT SMP
> [ 1041.893715] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.3/i2c-8/8-002e/temp1_input
> [ 1041.893768] Modules linked in: sbs power_supply sbshc lm85 hwmon_vid
> fuse bnep rfcomm snd_seq_midi sata_sil snd_ice1712 snd_ice17xx_ak4xxx
> snd_ak4xxx_adda snd_cs8427 snd_ac97_codec ac97_bus snd_i2c i2c_i801
> snd_mpu401_uart snd_rawmidi sata_sil24 uvcvideo videodev btusb bluetooth
> [last unloaded: i2c_dev]
> [ 1041.894000]
> [ 1041.894016] Pid: 6891, comm: cat Tainted: G        W   2.6.39-rc4-1
> #3                  /D945GNT
> [ 1041.894016] EIP: 0060:[<c14ebb5c>] EFLAGS: 00010286 CPU: 1
> [ 1041.894016] EIP is at mutex_lock+0x9/0x21
> [ 1041.894016] EAX: 00000010 EBX: 00000010 ECX: f477f000 EDX: f8e5b36c
> [ 1041.894016] ESI: f4b0dd00 EDI: f8e5a1cf EBP: f475def8 ESP: f475def0
> [ 1041.894016]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 1041.894016] Process cat (pid: 6891, ti=f475c000 task=f5448f00
> task.ti=f475c000)
> [ 1041.894016] Stack:
> [ 1041.894016]  c1724104 00000000 f475df20 f8e59211 f5448f00 00000010
> 00000000 007fffff
> [ 1041.894016]  00000000 f477f000 00000000 f8e5a1cf f475df30 f8e5a1de
> f8e5b36c fffffffb
> [ 1041.894016]  f475df44 c12abfba f46f5680 f4fd85d0 c1548118 f475df70
> c10fa55d f475df70
> [ 1041.894016] Call Trace:
> [ 1041.894016]  [<f8e59211>] lm85_update_device+0x1e/0x435 [lm85]
> [ 1041.894016]  [<f8e5a1cf>] ? show_temp_min+0x2d/0x2d [lm85]
> [ 1041.894016]  [<f8e5a1de>] show_temp+0xf/0x43 [lm85]
> [ 1041.894016]  [<c12abfba>] dev_attr_show+0x19/0x36
> [ 1041.894016]  [<c10fa55d>] sysfs_read_file+0x89/0xef
> [ 1041.894016]  [<c10fa4d4>] ? sysfs_write_file+0xe7/0xe7
> [ 1041.894016]  [<c10bb14c>] vfs_read+0x7d/0xdb
> [ 1041.894016]  [<c10bb241>] sys_read+0x3b/0x60
> [ 1041.894016]  [<c14f118c>] sysenter_do_call+0x12/0x22
> [ 1041.894016] Code: 45 ec 89 45 ec 89 45 f0 8b 45 d4 89 75 d8 c7 45 e8
> e2 60 04 c1 e8 0d ff ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 c3 83
> ec 04 <f0> ff 08 79 05 e8 53 02 00 00 89 e0 25 00 e0 ff ff 89 43 10 58
> [ 1041.894016] EIP: [<c14ebb5c>] mutex_lock+0x9/0x21 SS:ESP 0068:f475def0
> [ 1041.894016] CR2: 0000000000000010
> [ 1041.914645] ---[ end trace 968cdc4911c9d3b2 ]---

Probably caused by faulty error paths in the lm85 driver: on certain
probe failures, it won't remove the sysfs attribute files it created.

D'oh, I see the bug now. Big one, I wonder how the driver can possibly
work for me... And I can't believed I reviewed and acked this broken
patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=06923f84422371a6fb10b3efcd05b80ab48715c0

Here's the combined fix, I'll send proper patches to the lm-sensors
list for review:

--- linux-2.6.39-rc5.orig/drivers/hwmon/lm85.c	2011-04-12 11:05:32.000000000 +0200
+++ linux-2.6.39-rc5/drivers/hwmon/lm85.c	2011-04-29 10:12:56.000000000 +0200
@@ -1094,6 +1094,7 @@ static struct attribute *lm85_attributes
 	&sensor_dev_attr_pwm1_auto_pwm_minctl.dev_attr.attr,
 	&sensor_dev_attr_pwm2_auto_pwm_minctl.dev_attr.attr,
 	&sensor_dev_attr_pwm3_auto_pwm_minctl.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group lm85_group_minctl = {
@@ -1104,6 +1105,7 @@ static struct attribute *lm85_attributes
 	&sensor_dev_attr_temp1_auto_temp_off.dev_attr.attr,
 	&sensor_dev_attr_temp2_auto_temp_off.dev_attr.attr,
 	&sensor_dev_attr_temp3_auto_temp_off.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group lm85_group_temp_off = {
@@ -1329,11 +1331,11 @@ static int lm85_probe(struct i2c_client
 	if (data->type != emc6d103s) {
 		err = sysfs_create_group(&client->dev.kobj, &lm85_group_minctl);
 		if (err)
-			goto err_kfree;
+			goto err_remove_files;
 		err = sysfs_create_group(&client->dev.kobj,
 					 &lm85_group_temp_off);
 		if (err)
-			goto err_kfree;
+			goto err_remove_files;
 	}
 
 	/* The ADT7463/68 have an optional VRM 10 mode where pin 21 is used


-- 
Jean Delvare
