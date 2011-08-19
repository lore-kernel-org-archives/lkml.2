Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1HSAA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:00:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1HSAAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:00:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=naTVt1mD+9GuAq6/9QhWXaC5dfnvaqV7Jy6X2wOj5/aDbggu6Cp55OsG1KCu3DpWG
	ETzMe4oR/Fl5aqJF3YT9g==
MIME-Version: 1.0
In-Reply-To: <20110818144025.8e122a67.akpm@linux-foundation.org>
References: <1313650253-21794-1-git-send-email-gthelen@google.com> <20110818144025.8e122a67.akpm@linux-foundation.org>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 18 Aug 2011 17:00:30 -0700
Message-ID: <CAHH2K0b_jNHfAnSpDqBMKh4NbZCu8JrEcfjb+rputWKXgv5FLA@mail.gmail.com>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-arch@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        jweiner@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 2:40 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> (cc linux-arch)
>
> On Wed, 17 Aug 2011 23:50:53 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> Both mem_cgroup_charge_statistics() and mem_cgroup_move_account() were
>> unnecessarily disabling preemption when adjusting per-cpu counters:
>>     preempt_disable()
>>     __this_cpu_xxx()
>>     __this_cpu_yyy()
>>     preempt_enable()
>>
>> This change does not disable preemption and thus CPU switch is possible
>> within these routines.  This does not cause a problem because the total
>> of all cpu counters is summed when reporting stats.  Now both
>> mem_cgroup_charge_statistics() and mem_cgroup_move_account() look like:
>>     this_cpu_xxx()
>>     this_cpu_yyy()
>>
>> ...
>>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -664,24 +664,20 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *mem,
>>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>>                                        bool file, int nr_pages)
>>  {
>> -     preempt_disable();
>> -
>>       if (file)
>> -             __this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
>> +             this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_CACHE], nr_pages);
>>       else
>> -             __this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
>> +             this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], nr_pages);
>>
>>       /* pagein of a big page is an event. So, ignore page size */
>>       if (nr_pages > 0)
>> -             __this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
>> +             this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
>>       else {
>> -             __this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
>> +             this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
>>               nr_pages = -nr_pages; /* for event */
>>       }
>>
>> -     __this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
>> -
>> -     preempt_enable();
>> +     this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
>>  }
>
> On non-x86 architectures this_cpu_add() internally does
> preempt_disable() and preempt_enable().  So the patch is a small
> optimisation for x86 and a larger deoptimisation for non-x86.
>
> I think I'll apply it, as the call frequency is low (correct?) and the
> problem will correct itself as other architectures implement their
> atomic this_cpu_foo() operations.

mem_cgroup_charge_statistics() is a common operation, which is called
on each memcg page charge and uncharge.

The per arch/config effects of this patch:
* non-preemptible kernels: there's no difference before/after this patch.
* preemptible x86: this patch helps by removing an unnecessary
preempt_disable/enable.
* preemptible non-x86: this patch hurts by adding implicit
preempt_disable/enable around each operation.

So I am uncomfortable this patch's unmeasured impact on archs that do
not have atomic this_cpu_foo() operations.  Please drop the patch from
mmotm.  Sorry for the noise.
