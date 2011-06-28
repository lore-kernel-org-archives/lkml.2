Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab1F1U65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:58:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:22205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1F1U6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,439,1304319600"; 
   d="scan'208";a="19406408"
Message-ID: <4E0A4086.7080600@linux.intel.com>
Date: Tue, 28 Jun 2011 13:58:46 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH v3] futex: Fix regression with read only mappings
References: <4E08F893.10103@linux.intel.com> <1309213375-31471-1-git-send-email-sbohrer@rgmadvisors.com> <1309258475.6701.200.camel@twins> <4E09EA96.5080005@linux.intel.com> <20110628173841.GA2089@BohrerMBP.rgmadvisors.com>
In-Reply-To: <20110628173841.GA2089@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/28/2011 10:38 AM, Shawn Bohrer wrote:
> On Tue, Jun 28, 2011 at 07:52:06AM -0700, Darren Hart wrote:
>>
>>
>> On 06/28/2011 03:54 AM, Peter Zijlstra wrote:
>>> On Mon, 2011-06-27 at 17:22 -0500, Shawn Bohrer wrote:
>>>> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
>>>> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
>>>> regression in that it additionally prevented futex operations on a
>>>> region within a read only memory mapped file.  For example this breaks
>>>> workloads that have one or more reader processes doing a FUTEX_WAIT on a
>>>> futex within a read only shared mapping, and a writer processes that has
>>>> a writable mapping issuing the FUTEX_WAKE.
>>>>
>>>> This fixes the regression for futex operations that should be valid on
>>>> RO mappings by trying a RO get_user_pages_fast() when the RW
>>>> get_user_pages_fast() fails so as not to slow down the common path of
>>>> writable anonymous maps and bailing when we used the RO path on
>>>> anonymous memory.
>>>>
>>>> While fixing the regression this patch opens up two possible bad
>>>> scenarios as identified by KOSAKI Motohiro:
>>>>
>>>> 1) This patch also allows FUTEX_WAIT on RO private mappings which have
>>>> the following corner case.
>>>>
>>>>   Thread-A: call futex(FUTEX_WAIT, memory-region-A).
>>>>             get_futex_key() return inode based key.
>>>>             sleep on the key
>>>>   Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
>>>>   Thread-B: write memory-region-A.
>>>>             COW happen. This process's memory-region-A become related
>>>>             to new COWed private (ie PageAnon=1) page.
>>>>   Thread-B: call futex(FUETX_WAKE, memory-region-A).
>>>>             get_futex_key() return mm based key.
>>>>             IOW, we fail to wake up Thread-A.
>>>>
>>>> 2) Current futex code doesn't handle zero page properly.
>>>>
>>>>   Read mode get_user_pages() can return zero page, but current futex
>>>>   code doesn't handle it at all. Then, zero page makes infinite loop
>>>>   internally.
>>>>
>>>> This Patch is based on Peter Zijlstra's initial patch with modifications to
>>>> only allow RO mappings for futex operations that need VERIFY_READ access.
>>>>
>>>> Reported-by: David Oliver <david@rgmadvisors.com>
>>>> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
>>>
>>> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> I think we need to address #2 above first.
> 
> I believe the following contrived case triggers the zero page problem:
> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdint.h>
> #include <linux/futex.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <unistd.h>
> #include <stdio.h>
> 
> 
> int main(int argc, char *argv[])
> {
>         int fd, *futex, rc, val = 42;
>         struct timespec ts = {.tv_sec = 2, .tv_nsec = 0 };
> 
>         fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
>         write(fd, &val, 4);
>         futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
>         rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
>         printf("rc=%d errno=%d\n", rc, errno);
> }
> 
> Running the program above with my patch applied will spin in the
> kernel at 100% CPU usage.
> 
>> 1) Is the loop killable?
> 
> Yes, SIGINT causes the program to return.
> 


Confirmed.


>> 2) If not, and we try to catch zero_page scenario, we need to ensure RO
>>    sparse file mapping work. Peter notes that these are probably fine,
>>    filemap.c doesn't seem to use the zero page - but we need to test.

I felt it was worth testing sparse files anyway. The following works with a
sparse mapped file created as:

$ dd if=/dev/null of=/tmp/futex_test_sparse bs=1k seek=5120

$ ls -l /tmp/futex_test_sparse 
-rw-r--r-- 1 dvhart dvhart 5242880 2011-06-28 13:44 /tmp/futex_test_sparse

$ du -B1 /tmp/futex_test_sparse 
4096	/tmp/futex_test_sparse

$ ./futex-zero-page-sparse 
fd=3, errno=0
futex=0x7f6b86248000, offset=40960, errno=0
rc=-1 errno=110

Successful ETIMEDOUT return.


#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <linux/futex.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>


int main(int argc, char *argv[])
{
        struct timespec ts = {.tv_sec = 2, .tv_nsec = 0 };
        int fd, *futex, rc;
	off_t offset;

	offset = sysconf(_SC_PAGESIZE) * 10;

        fd = open("/tmp/futex_test_sparse", O_RDONLY, 0644);
	printf("fd=%d, errno=%d\n", fd, errno);
        futex = (int *)mmap(NULL, sizeof(int), PROT_READ, MAP_SHARED, fd, offset);
	printf("futex=%p, offset=%d, errno=%d\n", futex, offset, errno);
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, 0, &ts, 0, 0);
        printf("rc=%d errno=%d\n", rc, errno);
}



>> It's agreed, I believe, between myself, Peter, and Shawn that we will
>> document Private RW mappings as unsupported.
>>
>> -- 
>> Darren Hart
>> Intel Open Source Technology Center
>> Yocto Project - Linux Kernel
> 
> 
> ---------------------------------------------------------------
> This email, along with any attachments, is confidential. If you 
> believe you received this message in error, please contact the 
> sender immediately and delete all copies of the message.  
> Thank you.
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
