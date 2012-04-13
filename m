Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2DMGnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 02:43:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34306 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755018Ab2DMGnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 02:43:16 -0400
Message-ID: <4F87CAFF.2010407@openvz.org>
Date: Fri, 13 Apr 2012 10:43:11 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] mm: call complete_vfork_done() after clearing child_tid
 and flushing rss-counters
References: <20120409200336.8368.63793.stgit@zurg> <20120412080952.26401.2025.stgit@zurg> <20120412163953.4cd2314d.akpm@linux-foundation.org>
In-Reply-To: <20120412163953.4cd2314d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 12 Apr 2012 12:09:53 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> Child should wake ups parent from vfork() only after finishing all operations with
>> shared mm. There is no sense to use CLONE_CHILD_CLEARTID together with CLONE_VFORK,
>> but it looks more accurate now.
>>
>> ...
>>
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -728,9 +728,6 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>>   	/* Get rid of any cached register state */
>>   	deactivate_mm(tsk, mm);
>>
>> -	if (tsk->vfork_done)
>> -		complete_vfork_done(tsk);
>> -
>>   	/*
>>   	 * If we're exiting normally, clear a user-space tid field if
>>   	 * requested.  We leave this alone when dying by signal, to leave
>> @@ -759,6 +756,13 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>>   	 */
>>   	if (mm)
>>   		sync_mm_rss(mm);
>> +
>> +	/*
>> +	 * All done, finally we can wake up parent and return this mm to him.
>> +	 * Also kthread_stop() uses this completion for synchronization.
>> +	 */
>> +	if (tsk->vfork_done)
>> +		complete_vfork_done(tsk);
>>   }
>
> That does look a bit racy.
>
> But are we really sure that the patch really does fix something?
> Because it does increase vfork() latency a tiny bit.
>
> I'm going to call this a patch against the fork subsystem, not the mm
> subsystem.
>
> I believe that this patch is unrelated to "mm: set task exit code
> before complete_vfork_done()", yes?

Yes, unrelated.
