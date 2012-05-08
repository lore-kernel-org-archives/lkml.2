Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2EHPZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:25:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61637 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab2EHPZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:25:08 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1205071438240.2215@router.home>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com>
	<1336056962-10465-6-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1205071024550.1060@router.home>
	<4FA823A7.9000801@gmail.com>
	<alpine.DEB.2.00.1205071438240.2215@router.home>
Date: Tue, 8 May 2012 18:25:07 +0300
Message-ID: <CAOtvUMf95gmZ4ZTSpTb+5NZdEiDTg_CPtp3L2_notdz+dZWG6A@mail.gmail.com>
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
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

On Mon, May 7, 2012 at 10:40 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 7 May 2012, KOSAKI Motohiro wrote:
>
>> > > @@ -1204,8 +1265,14 @@ static int __init setup_vmstat(void)
>> > >
>> > >           register_cpu_notifier(&vmstat_notifier);
>> > >
>> > > + INIT_DELAYED_WORK_DEFERRABLE(&vmstat_monitor_work,
>> > > +                         vmstat_update_monitor);
>> > > + queue_delayed_work(system_unbound_wq,
>> > > +                         &vmstat_monitor_work,
>> > > +                         round_jiffies_relative(HZ));
>> > > +
>> > >           for_each_online_cpu(cpu)
>> > > -         start_cpu_timer(cpu);
>> > > +         setup_cpu_timer(cpu);
>> > >   #endif
>> > >   #ifdef CONFIG_PROC_FS
>> > >           proc_create("buddyinfo", S_IRUGO,
>> > > NULL,&fragmentation_file_operations);
>> >
>> > So the monitoring thread just bounces around the system? Hope that the
>> > scheduler does the right thing to keep it on processors that do some other
>> > work.
>>
>> Good point. Usually, all cpus have update items and monitor worker only makes
>> new noise. I think this feature is only useful some hpc case.  So I wonder if
>> this vmstat improvemnt can integrate Frederic's Nohz cpusets activity. I.e.
>> vmstat-update integrate timer house keeping and automatically stop when
>> stopping
>> hz house keeping.
>
> Right. We could do the same processing in vmstat update and the
> thread could check if it is the last vmstat update thread. If so simply
> continue and do not terminate.
>
> But this would still mean that the vmstat update thread would run on an
> arbitrary cpu. If I have a sacrificial lamb processor for OS processing
> then I would expect the vmstat update thread to stick to that processor
> and avoid to run on the other processor that I would like to be as free
> from OS noise as possible.
>

OK, what about -

- We pick a scapegoat cpu (the first to come up gets the job).
- We add a knob to let user designate another cpu for the job.
- If scapegoat cpus goes offline, the cpu processing the off lining is
the new scapegoat.

Does this makes better sense?

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
