Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2EHPWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:22:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65115 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab2EHPWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:22:54 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4FA823A7.9000801@gmail.com>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-6-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1205071024550.1060@router.home>
	<4FA823A7.9000801@gmail.com>
Date: Tue, 8 May 2012 18:22:45 +0300
Message-ID: <CAOtvUMekh0PdVTsdgL=NuVwPW=Yrmum=WWecmfB6wbgwLQzVGw@mail.gmail.com>
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
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

On Mon, May 7, 2012 at 10:33 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>>> @@ -1204,8 +1265,14 @@ static int __init setup_vmstat(void)
>>>
>>>        register_cpu_notifier(&vmstat_notifier);
>>>
>>> +       INIT_DELAYED_WORK_DEFERRABLE(&vmstat_monitor_work,
>>> +                               vmstat_update_monitor);
>>> +       queue_delayed_work(system_unbound_wq,
>>> +                               &vmstat_monitor_work,
>>> +                               round_jiffies_relative(HZ));
>>> +
>>>        for_each_online_cpu(cpu)
>>> -               start_cpu_timer(cpu);
>>> +               setup_cpu_timer(cpu);
>>>  #endif
>>>  #ifdef CONFIG_PROC_FS
>>>        proc_create("buddyinfo", S_IRUGO,
>>> NULL,&fragmentation_file_operations);
>>
>>
>> So the monitoring thread just bounces around the system? Hope that the
>> scheduler does the right thing to keep it on processors that do some other
>> work.
>
>
> Good point. Usually, all cpus have update items and monitor worker only
> makes
> new noise. I think this feature is only useful some hpc case.  So I wonder
> if
> this vmstat improvemnt can integrate Frederic's Nohz cpusets activity. I.e.
> vmstat-update integrate timer house keeping and automatically stop when
> stopping
> hz house keeping.

I wrote this and the previous IPI patch set explicitly to use with
Frederic's  Nohz stuff
for CPU isolation. It just seemed at the time to be wrong to tie them
together - I mean
people that do CPU isolation can enjoy this even if they don't want to
kill the tick (that
comes with its own overhead for doing system calls, for example).

Thanks!
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
