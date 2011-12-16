Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1LPLWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:22:38 -0500
Received: from numidia.opendz.org ([98.142.220.152]:42727 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1LPLWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:22:32 -0500
Date: Fri, 16 Dec 2011 12:25:34 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: add missing mutex lock arround notify_change
Message-ID: <20111216112534.GA13147@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Calls to notify_change() must hold i_mutex.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 mm/filemap.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c106d3b..0670ec1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1994,10 +1994,16 @@ EXPORT_SYMBOL(should_remove_suid);
 
 static int __remove_suid(struct dentry *dentry, int kill)
 {
+	int ret;
 	struct iattr newattrs;
 
 	newattrs.ia_valid = ATTR_FORCE | kill;
-	return notify_change(dentry, &newattrs);
+
+	mutex_lock(&dentry->d_inode->i_mutex);
+	ret = notify_change(dentry, &newattrs);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	return ret;
 }
 
 int file_remove_suid(struct file *file)
-- 
1.7.1
