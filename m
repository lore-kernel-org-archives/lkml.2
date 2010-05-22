Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0EVGcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 02:32:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42085 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0EVGcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 02:32:20 -0400
Date: Sat, 22 May 2010 15:50:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>,
       Eric Sandeen <sandeen@redhat.com>
Subject: linux-next: manual merge of the ext4 tree with Linus' tree
Message-Id: <20100522155033.8616811d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

Today's linux-next merge of the ext4 tree got a conflict in
include/linux/quotaops.h between commit
12755627bdcddcdb30a1bfb9a09395a52b1d6838 ("quota: unify quota init
condition in setattr") from Linus' tree and commits
2b03a9dee57f0a567b17571774d6a6ee8e0135b6 ("quota: use flags interface for
dquot alloc/free space") and facd5e10d2eca8b0eb85eba94494d9302c3740ad
("quota: add the option to not fail with EDQUOT in block") from the ext4
tree.

Juts overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/quotaops.h
index 0c77cd8,8f858ce..0000000
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@@ -14,14 -14,10 +14,18 @@@ static inline struct quota_info *sb_dqo
  	return &sb->s_dquot;
  }
  
 +/* i_mutex must being held */
 +static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
 +{
 +	return (ia->ia_valid & ATTR_SIZE && ia->ia_size != inode->i_size) ||
 +		(ia->ia_valid & ATTR_UID && ia->ia_uid != inode->i_uid) ||
 +		(ia->ia_valid & ATTR_GID && ia->ia_gid != inode->i_gid);
 +}
 +
+ #define DQUOT_SPACE_WARN	0x1
+ #define DQUOT_SPACE_RESERVE	0x2
+ #define DQUOT_SPACE_NOFAIL	0x4
+ 
  #if defined(CONFIG_QUOTA)
  
  /*
