Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab2FDN0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:26:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56232 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760560Ab2FDN0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:26:31 -0400
Date: Mon, 4 Jun 2012 21:25:53 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <liwp@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] remove no longer use of pdflush interface
Message-ID: <20120604132532.GA6874@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1338813642-6476-1-git-send-email-liwp.linux@gmail.com>
 <20120604125356.GB7738@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604125356.GB7738@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 08:53:56PM +0800, Fengguang Wu wrote:
>Hi Wanpeng,
>
>On Mon, Jun 04, 2012 at 08:40:42PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> remove no longer use of pdflush interface nr_pdflush_threads.
>
>The patch looks good in itself: the nr_pdflush_threads takes no effect
>for many of the recent kernels. But what's the normal process of
>interface removal?  Shall we carry some warning printk for some time
>first or whatever?

Hi, Fengguang,

I also want to add an interface of nr_bdi_writeback_threads to statistic
how many flusher-x:y currently running, do you think it is a good idea?

Regards,
Wanpeng Li

>
>
>> Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> ---
>>  Documentation/sysctl/vm.txt |   11 -----------
>>  fs/fs-writeback.c           |    5 -----
>>  include/linux/writeback.h   |    5 -----
>>  kernel/sysctl.c             |    7 -------
>>  4 files changed, 28 deletions(-)
>> 
>> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
>> index 96f0ee8..71c17d2 100644
>> --- a/Documentation/sysctl/vm.txt
>> +++ b/Documentation/sysctl/vm.txt
>> @@ -42,7 +42,6 @@ Currently, these files are in /proc/sys/vm:
>>  - mmap_min_addr
>>  - nr_hugepages
>>  - nr_overcommit_hugepages
>> -- nr_pdflush_threads
>>  - nr_trim_pages         (only if CONFIG_MMU=n)
>>  - numa_zonelist_order
>>  - oom_dump_tasks
>> @@ -426,16 +425,6 @@ See Documentation/vm/hugetlbpage.txt
>>  
>>  ==============================================================
>>  
>> -nr_pdflush_threads
>> -
>> -The current number of pdflush threads.  This value is read-only.
>> -The value changes according to the number of dirty pages in the system.
>> -
>> -When necessary, additional pdflush threads are created, one per second, up to
>> -nr_pdflush_threads_max.
>> -
>> -==============================================================
>> -
>>  nr_trim_pages
>>  
>>  This is available only on NOMMU kernels.
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index 539f36c..30ddb8a 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -52,11 +52,6 @@ struct wb_writeback_work {
>>  	struct completion *done;	/* set if the caller waits */
>>  };
>>  
>> -/*
>> - * We don't actually have pdflush, but this one is exported though /proc...
>> - */
>> -int nr_pdflush_threads;
>> -
>>  /**
>>   * writeback_in_progress - determine whether there is writeback in progress
>>   * @bdi: the device's backing_dev_info structure.
>> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>> index a2b84f5..13b5df7 100644
>> --- a/include/linux/writeback.h
>> +++ b/include/linux/writeback.h
>> @@ -193,9 +193,4 @@ void tag_pages_for_writeback(struct address_space *mapping,
>>  
>>  void account_page_redirty(struct page *page);
>>  
>> -/* pdflush.c */
>> -extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
>> -				   read-only. */
>> -
>> -
>>  #endif		/* WRITEBACK_H */
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 4ab1187..e257b61 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -1095,13 +1095,6 @@ static struct ctl_table vm_table[] = {
>>  		.extra1		= &zero,
>>  	},
>>  	{
>> -		.procname	= "nr_pdflush_threads",
>> -		.data		= &nr_pdflush_threads,
>> -		.maxlen		= sizeof nr_pdflush_threads,
>> -		.mode		= 0444 /* read-only*/,
>> -		.proc_handler	= proc_dointvec,
>> -	},
>> -	{
>>  		.procname	= "swappiness",
>>  		.data		= &vm_swappiness,
>>  		.maxlen		= sizeof(vm_swappiness),
>> -- 
>> 1.7.9.5
