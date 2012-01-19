Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab2ASUUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:20:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2ASUUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:20:07 -0500
Date: Thu, 19 Jan 2012 20:20:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mike Marciniszyn <infinipath@qlogic.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: races in ipathfs
Message-ID: <20120119202003.GZ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Use of qib_super is seriously racy.  qibfs_add() (and worse,
qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().

	1) CPU1: qib_init_one().  The sucker is allocated and placed
on the list.  CPU2: ipathfs is mounted, directory created.  CPU1: finally
gets around to qibfs_add(); by now qib_super is non-NULL and off we go,
trying to create it again.  The worst part is, that code doesn't even
notice that dentry is there and positive; you silently leak the old inode.

	2) CPU1: qib_init_one().  Allocated the sucker.  CPU2: ipathfs
is getting mounted.  Picked the first device off the list, creating
directory for it.  CPU1: inserted new device into the head of the list,
continued working.  Got around to qibfs_add(); qib_super is NULL, so
we do nothing.  CPU2: walked the rest of the list, creating directories
for all devices.  Our device is missed, since we are past that point in
the list.  Worse, shift the timing a bit and it doesn't matter whether
you add to the head or to the tail of the list - if qibfs_add() happens
just before we set qib_super, we are screwed again.

	3) CPU1: qib_remove_one().  CPU2: mount ipathfs is walking that
list and decides to try and create a directory for the device that is
being freed.  Oops...

	4) CPU1: qib_init_one() or qib_remove_one(), doesn't matter which.
CPU2: final umount of ipathfs already got through setting sb->s_root to
NULL but still hadn't set qib_super to the same.  Oops...  And no,
moving that qib_super = NULL; up prior to kill_litter_super() won't
fix the race either, of course.

AFAICS, the older driver (in hw/ipath) has the same problems.
