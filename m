Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab1DNPld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:41:33 -0400
Received: from mail4.comsite.net ([205.238.176.238]:26590 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704Ab1DNPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:41:31 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>, "Ted Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "John Stoffel" <john@stoffel.org>, Ric Wheeler <ricwheeler@gmail.com>
Message-Id: <ext4-masq@mdm.bga.com>
Subject: [PATCH] ext4: register ext2 and ext3 alias after ext4
In-Reply-To: <20110413223005.GB6821@noexit>
X-send-attempt: 2
References: <4DA48AF4.5080803@teksavvy.com>
	<20110413004938.GE3682@thunk.org>
	<4DA5ADA6.5060301@teksavvy.com>
	<5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
Date: Thu, 14 Apr 2011 10:41:23 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of CONFIG_EXT4_USE_FOR_EXT23 is to provide an alias so
that the ext4 module is sufficient even if user space calls out ext2.
However, it currently registers the alias names before registering ext4.
This means they show up first in /proc/filesystems and ext3 and ext4
formatted file systems show up in the mount list as ext4.

Register the filesystem aliases after ext4 so they show as ext4 until the
filesystems is filtered.  This will avoid users or tools configuring a
kernel with just ext2 and wondering why there system broke.  Also register
in the same order as listed in fs/Makefile.

Signed-off-by: Milton Miller <miltonm@bga.com>
---

Untested but simple code movement.  Mark will you please test?

Is it safe to initialize ext4_li_info and ext4_li_mtx after we register
the filesystem?  What keeps the init after the first call to mount
a filesystem?

I checked unregister_filesystem and it is safe when the file system
type is and is not registered.

Index: work.git/fs/ext4/super.c
===================================================================
--- work.git.orig/fs/ext4/super.c	2011-04-14 09:26:43.250066794 -0500
+++ work.git/fs/ext4/super.c	2011-04-14 09:29:53.220061521 -0500
@@ -4898,11 +4898,11 @@ static int __init ext4_init_fs(void)
 	err = init_inodecache();
 	if (err)
 		goto out1;
-	register_as_ext2();
-	register_as_ext3();
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
+	register_as_ext3();
+	register_as_ext2();
 
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
