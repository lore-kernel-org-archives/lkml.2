Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2ARP1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:27:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39121 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab2ARP1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:27:10 -0500
Message-ID: <4F16E4BC.5080100@gmail.com>
Date: Wed, 18 Jan 2012 23:26:52 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Li Wang <liwang@nudt.edu.cn>
CC: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
In-Reply-To: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
Content-Type: multipart/mixed;
 boundary="------------000501060202090503000905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000501060202090503000905
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit

On 01/18/2012 03:30 PM, Li Wang wrote:
> Hi,
>    There is an infinite loop bug in eCryptfs, to make it present,
> just truncate to generate a huge file (>= 4G) on a 32-bit machine
> under the plain text foleder mounted with eCryptfs, a simple command
> 'truncate -s 4G dummy' is enough. Note: 4GB is smaller than 4G,
> therefore the following command 'truncate -s 4GB dummy' will not trigger this bug.
> The bug comes from a data overflow, the patch below fixes it.
>
>

Hi,

Your patch is not correctly generated, you need to make the diff on top 
of the source tree.

Also, after reviewing the code, I think there are more places need to 
fix. Can you try my patch below?

Thanks.

---->

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>



--------------000501060202090503000905
Content-Type: text/x-patch;
 name="ecryptfs-loff_t.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ecryptfs-loff_t.diff"

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index a9f29b1..9ca9c17 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -653,7 +653,7 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
 				      struct page *page_for_lower,
-				      size_t offset_in_page, size_t size);
+				      loff_t offset_in_page, size_t size);
 int ecryptfs_write(struct inode *inode, char *data, loff_t offset, size_t size);
 int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 			struct inode *ecryptfs_inode);
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 3745f7c..93d80c4 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -72,7 +72,7 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
  */
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
 				      struct page *page_for_lower,
-				      size_t offset_in_page, size_t size)
+				      loff_t offset_in_page, size_t size)
 {
 	char *virt;
 	loff_t offset;
@@ -128,15 +128,15 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char *data, loff_t offset,
 		pos = offset;
 	while (pos < (offset + size)) {
 		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
-		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
-		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
+		loff_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
+		loff_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
+		loff_t total_remaining_bytes = ((offset + size) - pos);
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
 			/* remaining zeros to write, up to destination offset */
-			size_t total_remaining_zeros = (offset - pos);
+			loff_t total_remaining_zeros = (offset - pos);
 
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;

--------------000501060202090503000905--
