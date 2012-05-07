Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2EGTeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:34:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38747 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2EGTeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:34:03 -0400
Message-ID: <4FA823A7.9000801@gmail.com>
Date: Mon, 07 May 2012 15:33:59 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
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
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-6-git-send-email-gilad@benyossef.com> <alpine.DEB.2.00.1205071024550.1060@router.home>
In-Reply-To: <alpine.DEB.2.00.1205071024550.1060@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1204,8 +1265,14 @@ static int __init setup_vmstat(void)
>>
>>   	register_cpu_notifier(&vmstat_notifier);
>>
>> +	INIT_DELAYED_WORK_DEFERRABLE(&vmstat_monitor_work,
>> +				vmstat_update_monitor);
>> +	queue_delayed_work(system_unbound_wq,
>> +				&vmstat_monitor_work,
>> +				round_jiffies_relative(HZ));
>> +
>>   	for_each_online_cpu(cpu)
>> -		start_cpu_timer(cpu);
>> +		setup_cpu_timer(cpu);
>>   #endif
>>   #ifdef CONFIG_PROC_FS
>>   	proc_create("buddyinfo", S_IRUGO, NULL,&fragmentation_file_operations);
>
> So the monitoring thread just bounces around the system? Hope that the
> scheduler does the right thing to keep it on processors that do some other
> work.

Good point. Usually, all cpus have update items and monitor worker only makes
new noise. I think this feature is only useful some hpc case.  So I wonder if
this vmstat improvemnt can integrate Frederic's Nohz cpusets activity. I.e.
vmstat-update integrate timer house keeping and automatically stop when stopping
hz house keeping.

