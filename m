Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2DCGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:17:38 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:43325 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2DCGRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:17:37 -0400
Date: Tue, 3 Apr 2012 08:17:35 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Prevent crash on missing sysfs attribute group
Message-ID: <20120403081735.78ca3bb3@pluto.restena.lu>
In-Reply-To: <20120403060252.GA27084@gmail.com>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
	<20120402165036.2bc987ad@pluto.restena.lu>
	<m17gxyklfm.fsf@fess.ebiederm.org>
	<20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop>
	<1333403193.2960.80.camel@laptop>
	<20120403060252.GA27084@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent kernel from crashing when a device is being registered with sysfs
but has no (aka NULL) group attributes, but warn about it so calling path
can get fixed.

This would warn instead of trying NULL pointer deref like:
 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<ffffffff81152673>] internal_create_group+0x83/0x1a0
 PGD 0 
 Oops: 0000 [#1] SMP 
 CPU 0 
 Modules linked in:

 Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
 RIP: 0010:[<ffffffff81152673>]  [<ffffffff81152673>] internal_create_group+0x83/0x1a0
 RSP: 0018:ffff88019485fd70  EFLAGS: 00010202
 RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000001
 RDX: ffff880192e99908 RSI: ffff880192e99630 RDI: ffffffff81a26c60
 RBP: ffff88019485fdc0 R08: 0000000000000000 R09: 0000000000000000
 R10: ffff880192e99908 R11: 0000000000000000 R12: ffffffff81a16a00
 R13: ffff880192e99908 R14: ffffffff81a16900 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88019bc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000001a0c000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process swapper/0 (pid: 1, threadinfo ffff88019485e000, task ffff880194878000)
 Stack:
  ffff88019485fdd0 ffff880192da9d60 0000000000000000 ffff880192e99908
  ffff880192e995d8 0000000000000001 ffffffff81a16a00 ffff880192da9d60
  0000000000000000 0000000000000000 ffff88019485fdd0 ffffffff811527be
 Call Trace:
  [<ffffffff811527be>] sysfs_create_group+0xe/0x10
  [<ffffffff81376ca6>] device_add_groups+0x46/0x80
  [<ffffffff81377d3d>] device_add+0x46d/0x6a0
  ...

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
On Tue, 3 Apr 2012 08:02:52 +0200 Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2012-04-02 at 23:24 +0200, Peter Zijlstra wrote:
> > > On Mon, 2012-04-02 at 21:34 +0200, Bruno Prémont wrote:
> > > > > >> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
> > > 
> > > Is this a netburst based space heater?
> > 
> > In particular, does: https://lkml.org/lkml/2012/3/27/182 , sort it?
> > 
> > Ingo, could you pick that one up and route it Linus wards?
> 
> Will do - but the underlying generic bug should be fixed as 
> well: we must not crash just because some attributes are missing 
> in a rarely used sub-driver ...
> 
> We should WARN_ON(), etc. - but not crash.

Greg, is this ok for you or should the check be moved out to calling
internal_create_group()?

---
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index dd1701c..0040ff2 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -32,7 +32,8 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 	struct attribute *const* attr;
 	int error = 0, i;
 
-	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
+	WARN_ON(!grp->attrs);
+	for (i = 0, attr = grp->attrs; attr && *attr && !error; i++, attr++) {
 		umode_t mode = 0;
 
 		/* in update mode, we're changing the permissions or
