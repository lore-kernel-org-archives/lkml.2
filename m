Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab2DJUJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:09:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52289 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2DJUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:09:19 -0400
Message-ID: <4F84936A.1060708@openvz.org>
Date: Wed, 11 Apr 2012 00:09:14 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: correctly synchronize rss-counters at exit/exec
References: <20120409200336.8368.63793.stgit@zurg> <20120410170732.18750.64274.stgit@zurg> <20120410191059.GA5678@redhat.com>
In-Reply-To: <20120410191059.GA5678@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/10, Konstantin Khlebnikov wrote:
>>
>> This patch moves sync_mm_rss() into mm_release(), and moves mm_release() out of
>> do_exit() and calls it earlier. After mm_release() there should be no page-faults.
>
> Can't prove, but I feel there should be a simpler fix...
>
> Anyway, this patch is not exactly correct.
>
>> @@ -959,9 +959,10 @@ void do_exit(long code)
>>   				preempt_count());
>>
>>   	acct_update_integrals(tsk);
>> -	/* sync mm's RSS info before statistics gathering */
>> -	if (tsk->mm)
>> -		sync_mm_rss(tsk->mm);
>> +
>> +	/* Release mm and sync mm's RSS info before statistics gathering */
>> +	mm_release(tsk, tsk->mm);
>
> This breaks kthread_stop() at least.
>
> The exiting kthread shouldn't do complete_vfork_done() until it
> sets ->exit_code.

Ouch, I was afraid something like that.

>
> Oleg.
>

