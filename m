Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1EaDNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 23:13:49 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51524 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1EaDNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 23:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WWnzLgNXL3PBZp3AzRlDVc2tTQjqsROXEXy98ujTgooT79cv+zBOOAP++tYGSH9dVJ
         XgTdq5oh5Ot/SWLQOvdumyS4qwsIL7Dv7GgH15dlBcq83tRjiRlraXbJHq3SxUj6q+D/
         STlPQIwu7K/7tGRMaVnBvr1mOGc9a0Sa+CHW4=
MIME-Version: 1.0
In-Reply-To: <20110531083859.98e4ff43.kamezawa.hiroyu@jp.fujitsu.com>
References: <1306774744.4061.5.camel@localhost.localdomain>
	<20110531083859.98e4ff43.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 31 May 2011 09:13:47 +0600
Message-ID: <BANLkTinTqijGxCpZ_nRwWZHYsR-u2zojZA@mail.gmail.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
From: Rakib Mullick <rakib.mullick@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 5:38 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 30 May 2011 22:59:04 +0600
> Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>> commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>
> Hmm, what benefit do we get by adding this extra #ifdef in the code directly ?
> Other cond_resched() callers are not guilty in !CONFIG_PREEMPT ?
>
Well, in preemptible kernel this context will get preempted if
requires, so we don't need cond_resched(). If you checkout the git log
of the mentioned commit, you'll find the explanation. It says:
        "Adding a cond_resched() to allow other threads to run in the
non-preemptive
    case."

So, let cond_resched() be in non-preemptive case.

Thanks,
Rakib

> Thanks,
> -Kame
>
>> ---
>>
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 20c18b7..72cf857 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -461,7 +461,11 @@ void refresh_cpu_vm_stats(int cpu)
>>                               p->expire = 3;
>>  #endif
>>                       }
>> +
>> +#ifndef CONFIG_PREEMPT
>>               cond_resched();
>> +#endif
>> +
>>  #ifdef CONFIG_NUMA
>>               /*
>>                * Deal with draining the remote pageset of this
>>
>>
>
>
