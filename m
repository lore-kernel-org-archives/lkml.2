Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab1JERC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:02:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3420 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab1JERCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:02:55 -0400
Date: Wed, 5 Oct 2011 13:02:49 -0400
From: Thomas Tuttle <ttuttle@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Johan Myreen <jem@iki.fi>
Subject: [PATCH] misc/serio_raw: Avoid circular locking.
Message-ID: <20111005170249.GA27129@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging an unrelated bug in cdc-acm, PROVE_LOCKING found a
circular locking dependency between the misc and serio_raw:

<5>[    4.311231] =======================================================
<5>[    4.311242] [ INFO: possible circular locking dependency detected ]
<5>[    4.311251] 3.0.3 #1
<5>[    4.311257] -------------------------------------------------------
<5>[    4.311264] X/394 is trying to acquire lock:
<5>[    4.311273]  (serio_raw_mutex){+.+.+.}, at: [<812be42c>] serio_raw_open+0x1b/0xb3
<5>[    4.311301]
<5>[    4.311303] but task is already holding lock:
<5>[    4.311311]  (misc_mtx){+.+.+.}, at: [<8120913d>] misc_open+0x25/0x137
<5>[    4.311331]
<5>[    4.311333] which lock already depends on the new lock.
<5>[    4.311337]
<5>[    4.311343]
<5>[    4.311345] the existing dependency chain (in reverse order) is:
<5>[    4.311353]
<5>[    4.311355] -> #1 (misc_mtx){+.+.+.}:
<5>[    4.311369]        [<8105f177>] lock_acquire+0x8e/0xad
<5>[    4.311383]        [<8138b82d>] __mutex_lock_common+0x33/0x2a6
<5>[    4.311399]        [<8138bb92>] mutex_lock_nested+0x37/0x40
<5>[    4.311412]        [<812093af>] misc_register+0x21/0xee
<5>[    4.311426]        [<812be5cb>] serio_raw_connect+0x107/0x1a0
<5>[    4.311440]        [<812bbb46>] serio_connect_driver+0x25/0x35
<5>[    4.311454]        [<812bc6dc>] serio_rebind_driver+0x15a/0x1dd
<5>[    4.311466]        [<8125b1a0>] dev_attr_store+0x20/0x28
<5>[    4.311479]        [<810ffb7b>] sysfs_write_file+0xc5/0xf0
<5>[    4.311491]        [<810bd048>] vfs_write+0x8f/0x101
<5>[    4.311501]        [<810bd15b>] sys_write+0x40/0x65
<5>[    4.311510]        [<8138d697>] sysenter_do_call+0x12/0x36
<5>[    4.311520]
<5>[    4.311522] -> #0 (serio_raw_mutex){+.+.+.}:
<5>[    4.311534]        [<8105eb42>] __lock_acquire+0x92d/0xb92
<5>[    4.311546]        [<8105f177>] lock_acquire+0x8e/0xad
<5>[    4.311558]        [<8138b82d>] __mutex_lock_common+0x33/0x2a6
<5>[    4.311572]        [<8138bad7>] mutex_lock_interruptible_nested+0x37/0x3e
<5>[    4.311586]        [<812be42c>] serio_raw_open+0x1b/0xb3
<5>[    4.311598]        [<812091fb>] misc_open+0xe3/0x137
<5>[    4.311612]        [<810bf952>] chrdev_open+0x171/0x192
<5>[    4.311625]        [<810bb1fc>] __dentry_open+0x162/0x243
<5>[    4.311635]        [<810bb37b>] nameidata_to_filp+0x4a/0x58
<5>[    4.311644]        [<810c6d32>] do_last+0x3ea/0x4b6
<5>[    4.311653]        [<810c8053>] path_openat+0x9a/0x2cf
<5>[    4.311662]        [<810c833c>] do_filp_open+0x26/0x62
<5>[    4.311671]        [<810baf0f>] do_sys_open+0x61/0x10a
<5>[    4.311682]        [<810bb004>] sys_open+0x23/0x2b
<5>[    4.311695]        [<8138d697>] sysenter_do_call+0x12/0x36
<5>[    4.311709]
<5>[    4.311711] other info that might help us debug this:
<5>[    4.311714]
<5>[    4.311721]  Possible unsafe locking scenario:
<5>[    4.311724]
<5>[    4.311730]        CPU0                    CPU1
<5>[    4.311736]        ----                    ----
<5>[    4.311741]   lock(misc_mtx);
<5>[    4.311752]                                lock(serio_raw_mutex);
<5>[    4.311764]                                lock(misc_mtx);
<5>[    4.311776]   lock(serio_raw_mutex);
<5>[    4.311786]
<5>[    4.311788]  *** DEADLOCK ***
<5>[    4.311791]
<5>[    4.311799] 1 lock held by X/394:
<5>[    4.311805]  #0:  (misc_mtx){+.+.+.}, at: [<8120913d>] misc_open+0x25/0x137
<5>[    4.311827]
<5>[    4.311830] stack backtrace:
<5>[    4.311839] Pid: 394, comm: X Not tainted 3.0.3 #1
<5>[    4.311846] Call Trace:
<5>[    4.311862]  [<8105e17a>] print_circular_bug+0x18d/0x19a
<5>[    4.311877]  [<8105eb42>] __lock_acquire+0x92d/0xb92
<5>[    4.311892]  [<8105f177>] lock_acquire+0x8e/0xad
<5>[    4.311906]  [<812be42c>] ? serio_raw_open+0x1b/0xb3
<5>[    4.311920]  [<8138b82d>] __mutex_lock_common+0x33/0x2a6
<5>[    4.311935]  [<812be42c>] ? serio_raw_open+0x1b/0xb3
<5>[    4.311949]  [<8138bad7>] mutex_lock_interruptible_nested+0x37/0x3e
<5>[    4.311962]  [<812be42c>] ? serio_raw_open+0x1b/0xb3
<5>[    4.311975]  [<812be42c>] serio_raw_open+0x1b/0xb3
<5>[    4.311989]  [<812091fb>] misc_open+0xe3/0x137
<5>[    4.312004]  [<810bf952>] chrdev_open+0x171/0x192
<5>[    4.312017]  [<810bb1fc>] __dentry_open+0x162/0x243
<5>[    4.312019]  [<810bb37b>] nameidata_to_filp+0x4a/0x58
<5>[    4.312019]  [<810bf7e1>] ? cdev_put+0x1f/0x1f
<5>[    4.312019]  [<810c6d32>] do_last+0x3ea/0x4b6
<5>[    4.312019]  [<810c8053>] path_openat+0x9a/0x2cf
<5>[    4.312019]  [<8105ee2d>] ? lock_release_non_nested+0x86/0x1d8
<5>[    4.312019]  [<810c833c>] do_filp_open+0x26/0x62
<5>[    4.312019]  [<8138cc4f>] ? _raw_spin_unlock+0x22/0x25
<5>[    4.312019]  [<810d149d>] ? alloc_fd+0xc2/0xcf
<5>[    4.312019]  [<810baf0f>] do_sys_open+0x61/0x10a
<5>[    4.312019]  [<810bd0a6>] ? vfs_write+0xed/0x101
<5>[    4.312019]  [<810bb004>] sys_open+0x23/0x2b
<5>[    4.312019]  [<8138d697>] sysenter_do_call+0x12/0x36

This patch rearranges serio_raw_connect so that it takes the mutex once
to allocate a device number and open the serio device, drops it to call
misc_register, then takes it again to add the serio_raw device to the
list.

BUG=chromium-os:21113
TEST=Adhoc: PROVE_LOCKING no longer finds circular locking dependency

Change-Id: I414c5a3d606c28c81e42dcf989e5c55918eb4ea3
Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
---
I think this works, but I'm not familiar enough with the misc and serio
subsystems to know if this is completely correct, nor if it is the best
way to break the circular dependency.  Feedback would be appreciated.

 drivers/input/serio/serio_raw.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index b7ba459..d5757e8 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -294,13 +294,13 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	if (err)
 		goto out_free;
 
-	list_add_tail(&serio_raw->node, &serio_raw_list);
-
 	serio_raw->dev.minor = PSMOUSE_MINOR;
 	serio_raw->dev.name = serio_raw->name;
 	serio_raw->dev.parent = &serio->dev;
 	serio_raw->dev.fops = &serio_raw_fops;
 
+	mutex_unlock(&serio_raw_mutex);
+
 	err = misc_register(&serio_raw->dev);
 	if (err) {
 		serio_raw->dev.minor = MISC_DYNAMIC_MINOR;
@@ -313,18 +313,22 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 		goto out_close;
 	}
 
+	mutex_lock(&serio_raw_mutex);
+	list_add_tail(&serio_raw->node, &serio_raw_list);
+	mutex_unlock(&serio_raw_mutex);
+
 	printk(KERN_INFO "serio_raw: raw access enabled on %s (%s, minor %d)\n",
 		serio->phys, serio_raw->name, serio_raw->dev.minor);
-	goto out;
+	return 0;
 
 out_close:
+	mutex_lock(&serio_raw_mutex);
 	serio_close(serio);
-	list_del_init(&serio_raw->node);
 out_free:
 	serio_set_drvdata(serio, NULL);
+	mutex_unlock(&serio_raw_mutex);
 	kfree(serio_raw);
 out:
-	mutex_unlock(&serio_raw_mutex);
 	return err;
 }
 
-- 
1.7.3.1

