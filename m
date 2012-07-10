Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2GJOVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:21:01 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:49663 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2GJOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:21:00 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=qXqFsP3CSyuxK24Y70h+wgoOLv2N+XImbi1ieBnoVyIa6rbjeMAORlDNFtIa
	JRkN4Vu3Du3LtG/gz3T696To477PmG0t49ptbXIH8+lTjGZryqt5q3nGQ
	MeeHXZIOhndAYuSF9JjHn4B47OicVbjonyQZtuV/R3KLoBZOVV1k58=;
X-Spam-Processed: mail.digidescorp.com, Tue, 10 Jul 2012 09:20:58 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1538729052=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, steve@digidescorp.com
Subject: [PATCH v2 0/2] fat (exportfs): fix dentry reconnection
Date: Tue, 10 Jul 2012 09:20:51 -0500
Message-Id: <1341930053-10689-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under memory pressure, the system may evict dentries from cache.
When the FAT driver receives a NFS request involving an evicted dentry,
it is unable to reconnect it to the filesystem root. 
This causes the request to fail, often with ENOENT.

This is partially due to ineffectiveness of the current FAT NFS implementation,
and partially due to an unimplemented fh_to_parent method. The latter
can cause file accesses to fail on shares exported with subtree_check.

This patch set provides the FAT driver with the ability to reconnect dentries.
NFS file handle generation and lookups are simplified and made congruent with
ext2.

Testing has involved a memory-starved virtual machine running 3.5-rc5
that exports a ~2 GB vfat filesystem containing a kernel tree
(~770 MB, ~40000 files, 9 levels). Both 'cp -r' and 'ls -lR' operations
were performed from a client, some overlapping, some consecutive.
Exports with 'subtree_check' and 'no_subtree_check' have been tested.

Note that while this patch set improves FAT's NFS support, it does not
eliminate ESTALE errors completely.

The following should be considered for NFS clients who are sensitive to ESTALE:

* Mounting with lookupcache=none
  Unfortunately this can degrade performance severely, particularly for deep
  filesystems.

* Incorporating VFS patches to retry ESTALE failures on the client-side, 
  such as https://lkml.org/lkml/2012/6/29/381

* Handling ESTALE errors in client application code


This series depends on the following patches:
* fat: Fix non-atomic NFS i_pos read
* fat: Accessors for msdos_dir_entry 'start' fields
* fat: Refactor shortname parsing

Changes since v1:
* Dropped code to reconstitute evicted inodes. Too risky.
* Dropped FAT-specific get_name method. Not needed.
* Added index of directories by i_logstart (per. H. OGAWA)
  and "nfs" mount option to enable it


