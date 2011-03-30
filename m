Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1C3LRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:17:22 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:35187 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab1C3LRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:17:21 -0400
X-ASG-Debug-ID: 1301483840-01de284cf8daf00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D93113E.2070805@fusionio.com>
Date: Wed, 30 Mar 2011 13:17:18 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-nilfs <linux-nilfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
References: <20110330.132555.158630340.ryusuke@osrg.net> <4D930F02.4070409@fusionio.com>
X-ASG-Orig-Subj: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
In-Reply-To: <4D930F02.4070409@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301483840
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59400
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 13:07, Jens Axboe wrote:
> On 2011-03-30 06:25, Ryusuke Konishi wrote:
>> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
>> index 4d2a1ee..9d2dc6b 100644
>> --- a/fs/nilfs2/page.c
>> +++ b/fs/nilfs2/page.c
>> @@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
>>  void nilfs_mapping_init(struct address_space *mapping,
>>  			struct backing_dev_info *bdi)
>>  {
>> +	static const struct address_space_operations empty_aops;
>> +
>>  	mapping->host = NULL;
>>  	mapping->flags = 0;
>>  	mapping_set_gfp_mask(mapping, GFP_NOFS);
>>  	mapping->assoc_mapping = NULL;
>>  	mapping->backing_dev_info = bdi;
>> -	mapping->a_ops = NULL;
>> +	mapping->a_ops = &empty_aops;
>>  }
> 
> Hmm wait, inode init should set the mapping aops to an empty type
> already. Does the OOPS go away if you just remove the mapping->a_ops =
> NULL assignment?

In any case, I think this is a better fix.

diff --git a/fs/inode.c b/fs/inode.c
index 5f4e11a..b818730 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -125,6 +125,13 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 static DECLARE_RWSEM(iprune_sem);
 
 /*
+ * Empty aops. Can be used for the cases where the user does not
+ * define any of the address_space operations.
+ */
+const struct address_space_operations empty_aops = {
+};
+
+/*
  * Statistics gathering..
  */
 struct inodes_stat_t inodes_stat;
@@ -176,7 +183,6 @@ int proc_nr_inodes(ctl_table *table, int write,
  */
 int inode_init_always(struct super_block *sb, struct inode *inode)
 {
-	static const struct address_space_operations empty_aops;
 	static const struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;
 	struct address_space *const mapping = &inode->i_data;
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 4d2a1ee..1168059 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -500,7 +500,7 @@ void nilfs_mapping_init(struct address_space *mapping,
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	mapping->assoc_mapping = NULL;
 	mapping->backing_dev_info = bdi;
-	mapping->a_ops = NULL;
+	mapping->a_ops = &empty_aops;
 }
 
 /*
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index c74400f..403c192 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -80,7 +80,6 @@ enum {
 };
 
 static const struct inode_operations none_inode_operations;
-static const struct address_space_operations none_address_operations;
 static const struct file_operations none_file_operations;
 
 /**
@@ -130,7 +129,7 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 	}
 
 	/* Re-define all operations to be "nothing" */
-	inode->i_mapping->a_ops = &none_address_operations;
+	inode->i_mapping->a_ops = &empty_aops;
 	inode->i_op = &none_inode_operations;
 	inode->i_fop = &none_file_operations;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 52f283c..1b95af3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -613,6 +613,8 @@ struct address_space_operations {
 	int (*error_remove_page)(struct address_space *, struct page *);
 };
 
+extern const struct address_space_operations empty_aops;
+
 /*
  * pagecache_write_begin/pagecache_write_end must be used by general code
  * to write into the pagecache.

-- 
Jens Axboe

