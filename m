Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab0E0I1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:27:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61938 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0E0I1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:27:12 -0400
Message-ID: <4BFE2D38.2010501@cn.fujitsu.com>
Date: Thu, 27 May 2010 16:28:40 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com
CC: Linux-Ext4 <linux-ext4@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext3: fix non-update ctime when changing the file's permission
 by setfacl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext3 didn't update the ctime of the file when its permission was changed.

Steps to reproduce:
 # touch aaa
 # stat -c %Z aaa
 1275289822
 # setfacl -m  'u::x,g::x,o::x' aaa
 # stat -c %Z aaa
 1275289822				<- unchanged

But, according to the spec of the ctime, ext3 must update it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/ext3/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 01552ab..8a11fe2 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -205,6 +205,7 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 					return error;
 				else {
 					inode->i_mode = mode;
+					inode->i_ctime = CURRENT_TIME_SEC;
 					ext3_mark_inode_dirty(handle, inode);
 					if (error == 0)
 						acl = NULL;
-- 
1.6.5.2


