Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0HTISm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:18:42 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HTISk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:18:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aetEpS0bMbV5sJzZTd2N8IfycYeXLrvjqxy1Dw0zO0aZvG07dZphspx3ykgNa3U99
	Mm8ILlt47qssyQBy59Ctg==
MIME-Version: 1.0
In-Reply-To: <20100820031647.GC5502@localhost>
References: <1282251447-16937-1-git-send-email-mrubin@google.com>
 <1282251447-16937-4-git-send-email-mrubin@google.com> <20100820031647.GC5502@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Fri, 20 Aug 2010 01:18:15 -0700
Message-ID: <AANLkTik1=FRc53o9L8z6PGeA4wcLBaeBv_eLVzCUpypg@mail.gmail.com>
Subject: Re: [PATCH 3/3] writeback: Reporting dirty thresholds in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your quick reply and comments.

On Thu, Aug 19, 2010 at 8:16 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Thu, Aug 19, 2010 at 01:57:27PM -0700, Michael Rubin wrote:
>> The kernel already exposes the desired thresholds in /proc/sys/vm with
>> dirty_background_ratio and background_ratio. Instead the kernel may
>> alter the number requested without giving the user any indication that
>> is the case.
>
> You mean the 5% lower bound in global_dirty_limits()? Let's rip it :)
>
>> Knowing the actual ratios the kernel is honoring can help app developers
>> understand how their buffered IO will be sent to the disk.
>>
>>       $ grep threshold /proc/vmstat
>>       nr_pages_dirty_threshold 409111
>>       nr_pages_dirty_background_threshold 818223
>
> It's redundant to have _pages in the names. /proc/vmstat has the
> tradition to use nr_dirty instead of nr_pages_dirty.
>
> They do look like useful counters to export, especially when we do
> dynamic dirty limits in future.
>
>> Signed-off-by: Michael Rubin <mrubin@google.com>
>> ---
>>  include/linux/mmzone.h |    2 ++
>>  mm/vmstat.c            |    8 ++++++++
>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index f160481..7c4a3bf 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -114,6 +114,8 @@ enum zone_stat_item {
>>  #endif
>>       NR_PAGES_ENTERED_WRITEBACK, /* number of times pages enter writeback */
>>       NR_FILE_PAGES_DIRTIED,      /* number of times pages get dirtied */
>> +     NR_PAGES_DIRTY_THRESHOLD,   /* writeback threshold */
>> +     NR_PAGES_DIRTY_BG_THRESHOLD,/* bg writeback threshold */
>
> s/_PAGES//

Cool. Thanks.

>
>>       NR_VM_ZONE_STAT_ITEMS };
>>
>>  /*
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index e177a40..8b5bc78 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/vmstat.h>
>>  #include <linux/sched.h>
>>  #include <linux/math64.h>
>> +#include <linux/writeback.h>
>>
>>  #ifdef CONFIG_VM_EVENT_COUNTERS
>>  DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
>> @@ -742,6 +743,8 @@ static const char * const vmstat_text[] = {
>>  #endif
>>       "nr_pages_entered_writeback",
>>       "nr_file_pages_dirtied",
>> +     "nr_pages_dirty_threshold",
>> +     "nr_pages_dirty_background_threshold",
>
> s/_pages//

Got it.

>
>>  #ifdef CONFIG_VM_EVENT_COUNTERS
>>       "pgpgin",
>> @@ -901,6 +904,7 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
>>  #ifdef CONFIG_VM_EVENT_COUNTERS
>>       unsigned long *e;
>>  #endif
>> +     unsigned long dirty_thresh, dirty_bg_thresh;
>>       int i;
>>
>>       if (*pos >= ARRAY_SIZE(vmstat_text))
>> @@ -918,6 +922,10 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
>>               return ERR_PTR(-ENOMEM);
>>       for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
>>               v[i] = global_page_state(i);
>> +
>> +     get_dirty_limits(&dirty_thresh, &dirty_bg_thresh, NULL, NULL);
>
> 2.6.36-rc1 will need this:
>
>        global_dirty_limits(v + NR_DIRTY_THRESHOLD, v + NR_DIRTY_BG_THRESHOLD);

Yeah I noticed when I rebased. Thanks.

mrubin
