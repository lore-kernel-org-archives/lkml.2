Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1IQXDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 19:03:06 -0400
Received: from shawmail.shawcable.com ([64.59.128.220]:52265 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab1IQXDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 19:03:04 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=W1EbViUdRLrB3xZls61b9cpNy9JNgdRUyrcMJe3sx/g= c=1 sm=1
 a=EbUuBWHc38EA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=yPCof4ZbAAAA:8 a=OLL_FvSJAAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=RiPh2G5sJ1vWErPw-DQA:9
 a=9xxq7yMXEqzbMmPOr8sA:7 a=CjuIK1q_8ugA:10 a=mfTLZt5StWkA:10
 a=x8gzFH9gYPwA:10 a=7DSvI1NPTFQA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.68,399,1312178400"; 
   d="scan'208";a="378694673"
X-reinject: true
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com>
In-Reply-To: <4E7439EB.7080100@oracle.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
X-Mailer: iPhone Mail (8L1)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Sat, 17 Sep 2011 17:03:48 -0600
To: "jeff.liu@oracle.com" <jeff.liu@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-17, at 12:10 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
> I once posted a similar patch for this issue which can be found at:
> http://www.spinics.net/lists/linux-btrfs/msg12169.html
> 
> with an additional improvement if the offset is larger or equal to the
> file size, return -ENXIO in directly:
> 
>                if (offset >= inode->i_size) {
>                        mutex_unlock(&inode->i_mutex);
>                        return -ENXIO;
>                }

Except that is wrong, because it would then be impossible to write sparse files. 

> Thanks,
> -Jeff
> On 09/16/2011 11:48 PM, Christoph Hellwig wrote:
> 
>> On Thu, Sep 15, 2011 at 04:06:47PM -0700, Andi Kleen wrote:
>>> From: Andi Kleen <ak@linux.intel.com>
>>> 
>>> Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c
>> 
>> I think this should go to Chris/Linus ASAP.  But a slightly better
>> patch description wouldn't hurt either.
>> 
>> Also any reason you captialize BTRFS?
>> 
>>> 
>>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>> ---
>>> fs/btrfs/file.c |   13 +++++++------
>>> 1 files changed, 7 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 3c3abff..7ec0a24 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>> @@ -1818,19 +1818,17 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
>>>    case SEEK_DATA:
>>>    case SEEK_HOLE:
>>>        ret = find_desired_extent(inode, &offset, origin);
>>> -        if (ret) {
>>> -            mutex_unlock(&inode->i_mutex);
>>> -            return ret;
>>> -        }
>>> +        if (ret)
>>> +            goto error;
>>>    }
>>> 
>>>    if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
>>>        ret = -EINVAL;
>>> -        goto out;
>>> +        goto error;
>>>    }
>>>    if (offset > inode->i_sb->s_maxbytes) {
>>>        ret = -EINVAL;
>>> -        goto out;
>>> +        goto error;
>>>    }
>>> 
>>>    /* Special lock needed here? */
>>> @@ -1841,6 +1839,9 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
>>> out:
>>>    mutex_unlock(&inode->i_mutex);
>>>    return offset;
>>> +error:
>>> +    mutex_unlock(&inode->i_mutex);
>>> +    return ret;
>>> }
>>> 
>>> const struct file_operations btrfs_file_operations = {
>>> -- 
>>> 1.7.4.4
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> ---end quoted text---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
