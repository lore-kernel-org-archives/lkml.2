Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2IWGTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 02:19:00 -0400
Received: from mail.agmk.net ([91.192.224.71]:53921 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2IWGS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 02:18:57 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Sep 2012 02:18:57 EDT
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
        arekm@pld-linux.org, baggins@pld-linux.org
Subject: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs, autofs, vserver)
Date: Sun, 23 Sep 2012 08:09:48 +0200
Message-ID: <5092540.GORQ1kUuNX@localhost>
User-Agent: KMail/4.9.1 (Linux/3.5.3; KDE/4.9.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a long time ago i reported an ugly soft lock of heavy loaded opteron system without usable backtraces :(
recently, i've logged on 3.4.6 via serial console backtraces from all 16 cores which show some kind
of vfs lock (http://pluto.agmk.net/kernel/oops.txt). this lock occurs on heavy loaded system with
frequent autofs unmount (timeout=1s) in action with vserver patch applied.

i've isolated the vserver function that exposes problem: mnt_is_reachable()
http://vserver.13thfloor.at/Experimental/patch-3.4.6-vs2.3.3.6.diff:

static int mnt_is_reachable(struct vfsmount *vfsmnt)
{
	struct path root;
	struct dentry *point;
	struct mount *mnt = real_mount(vfsmnt);
	struct mount *root_mnt;
	int ret;

	if (mnt == mnt->mnt_ns->root)
		return 1;

	br_read_lock(vfsmount_lock);
	root = current->fs->root;
	root_mnt = real_mount(root.mnt);
	point = root.dentry;

	while ((mnt != mnt->mnt_parent) && (mnt != root_mnt)) {
		point = mnt->mnt_mountpoint;
		mnt = mnt->mnt_parent;
	}

	ret = (mnt == root_mnt) && is_subdir(point, root.dentry);

	br_read_unlock(vfsmount_lock);

	return ret;
}

the vserver developer (Herbert Poetzl) said that locking scheme used in this function looks correct,
so it might be a hidden vfs bug accidentaly exposed by vserver patch. i'm not a kernel developer,
so i'd like to ask you for help in solving this problem. afaics the problem starts with 2.6.38
release which introduced some major vfs changes.

please CC me on reply.

BR,
Paweł.

