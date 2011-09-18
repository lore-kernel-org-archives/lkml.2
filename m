Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1IRHaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 03:30:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23481 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1IRHaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 03:30:13 -0400
Message-ID: <4E759DE5.3020907@oracle.com>
Date: Sun, 18 Sep 2011 15:29:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
Organization: Oracle
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Andreas Dilger <adilger@dilger.ca>
CC: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com>
In-Reply-To: <20110918014608.GA16198@alboin.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E759DFB.0045,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas and Andi,

Thanks for your comments.

On 09/18/2011 09:46 AM, Andi Kleen wrote:

>>> with an additional improvement if the offset is larger or equal to the
>>> file size, return -ENXIO in directly:
>>>
>>>                if (offset >= inode->i_size) {
>>>                        mutex_unlock(&inode->i_mutex);
>>>                        return -ENXIO;
>>>                }
>>
>> Except that is wrong, because it would then be impossible to write sparse files. 

Per my tryout, except that, if the offset >= source file size, call
lseek(fd, offset, SEEK_DATA/SEEK_HOLE) against Btrfs will always return
the total file size rather than -ENXIO.  however, our desired result it
-ENXIO in this case, Am I right?

> 
> And also i_size must be always read with i_size_read()

Thanks for pointing this out!
Would you please kindly review the revised as below?

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/btrfs/file.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..40c1ef3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1813,6 +1813,11 @@ static loff_t btrfs_file_llseek(struct file
*file, loff_t offset, int origin)
 		goto out;
 	case SEEK_DATA:
 	case SEEK_HOLE:
+		if (offset >= i_size_read(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+
 		ret = find_desired_extent(inode, &offset, origin);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
@@ -1821,11 +1826,11 @@ static loff_t btrfs_file_llseek(struct file
*file, loff_t offset, int origin)
 	}

 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-		ret = -EINVAL;
+		offset = -EINVAL;
 		goto out;
 	}
 	if (offset > inode->i_sb->s_maxbytes) {
-		ret = -EINVAL;
+		offset = -EINVAL;
 		goto out;
 	}

-- 
1.7.4.1
