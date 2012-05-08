Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2EHPSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:18:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49264 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2EHPSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:18:45 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1205071024550.1060@router.home>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-6-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1205071024550.1060@router.home>
Date: Tue, 8 May 2012 18:18:44 +0300
Message-ID: <CAOtvUMeF6Xi-sOYZkJuAF0=jzqUHBNEMZU4BD=K3-yqQbdQxUw@mail.gmail.com>
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 6:29 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 3 May 2012, Gilad Ben-Yossef wrote:
>
>> vmstat_update runs every second from the work queue to update statistics
>> and drain per cpu pages back into the global page allocator.
>
> Looks good.

Thanks :-)

>
> - vmstat_off_cpus is a bit strange. Could we have a cpumask that has a bit
> set if vmstat is active? Rename to "vmstat_cpus"?

Sure.

> - Start out with vmstat_cpus cleared? Cpus only need vmstat if they do
> something and if a cpu is idle on boot then it will not need vmstat
> enabled until the cpu does something useful.

Ah cool. I haven't thought of that.

>
>> @@ -1204,8 +1265,14 @@ static int __init setup_vmstat(void)
>>
>>       register_cpu_notifier(&vmstat_notifier);
>>
>> +     INIT_DELAYED_WORK_DEFERRABLE(&vmstat_monitor_work,
>> +                             vmstat_update_monitor);
>> +     queue_delayed_work(system_unbound_wq,
>> +                             &vmstat_monitor_work,
>> +                             round_jiffies_relative(HZ));
>> +
>>       for_each_online_cpu(cpu)
>> -             start_cpu_timer(cpu);
>> +             setup_cpu_timer(cpu);
>>  #endif
>>  #ifdef CONFIG_PROC_FS
>>       proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
>
> So the monitoring thread just bounces around the system? Hope that the
> scheduler does the right thing to keep it on processors that do some other
> work.

My line of thought was that if we explicitly choose a scapegoat cpu we
and the user
need to manage this - such as worry about what happens if the
scapegoats is offlines and
let the user explicitly  designate the scapegoat cpu thus creating
another knob, and worrying
about what happens if the user designate such a cpu but then it goes offlines...

I figured the user needs to worry about other unbounded work items
anyway if he cares about
where such things are run in the general case, but using isolcpus for example.

The same should be doable with cpusets, except that right now we mark
unbounded workqueue
worker threads as pinned even though they aren't. If I understood the
discussion, the idea is
exactly to stop users from putting these threads in non root cpusets.
I am not 100% sure why..

Does that makes sense?

Thanks!
Gilad

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
