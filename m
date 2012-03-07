Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2CGXaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:30:15 -0500
Received: from bureau60.ns.utoronto.ca ([128.100.132.147]:56863 "EHLO
	bureau60.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2CGXaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:30:11 -0500
Message-ID: <4F57EF6F.2010408@utoronto.ca>
Date: Wed, 07 Mar 2012 18:29:51 -0500
From: Steven Truelove <steven.truelove@utoronto.ca>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: wli@holomorphy.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Correct alignment of huge page requests.
References: <1330830176-19449-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1330830176-19449-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 10:02 PM, Naoya Horiguchi wrote:
> On Thu, Mar 01, 2012 at 09:58:41PM -0500, Steven Truelove wrote:
>> When calling shmget() with SHM_HUGETLB, shmget aligns the request size to PAGE_SIZE, but this is not sufficient.  Modified hugetlb_file_setup() to align requests to the huge page size, and to accept an address argument so that all alignment checks can be performed in hugetlb_file_setup(), rather than in its callers.  Changed newseg and mmap_pgoff to match new prototype and eliminated a now redundant alignment check.
> I think only rounding up request size in shmget() is not sufficient,
> because later shmat() also have alignment check and fails to mmap()
> to unaligned address.
> Maybe file->f_op->get_unmapped_area() (or hugetlb_get_unmapped_area())
> should have round up code, I think.
> Could you try it?

Because the allocation is done in shmget() and the the address is not 
provided until shmat(), I don't see a way to make this work reasonably.  
I would argue that only allowing aligned addresses, or allowing the 
kernel to choose the address, is a reasonable restriction on SHM_HUGETLB 
usage.

Regarding your other comments, I will submit a revised patch.

Thanks,

Steven Truelove


> And a few comments below,
>
>> Signed-off-by: Steven Truelove<steven.truelove@utoronto.ca>
>> ---
>>   fs/hugetlbfs/inode.c    |   12 ++++++++----
>>   include/linux/hugetlb.h |    3 ++-
>>   ipc/shm.c               |    2 +-
>>   mm/mmap.c               |    6 +++---
>>   4 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 1e85a7a..a97b7cc 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -928,7 +928,7 @@ static int can_do_hugetlb_shm(void)
>>   	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
>>   }
>>
>> -struct file *hugetlb_file_setup(const char *name, size_t size,
>> +struct file *hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
> Just a nitpick, this line is over 80 characters.
> checkpatch.pl should warn.
>
>>   				vm_flags_t acctflag,
>>   				struct user_struct **user, int creat_flags)
>>   {
>> @@ -938,6 +938,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
>>   	struct path path;
>>   	struct dentry *root;
>>   	struct qstr quick_string;
>> +	struct hstate *hstate;
>> +	int num_pages;
> Is unsigned long better?
>
> Thanks,
> Naoya
>
