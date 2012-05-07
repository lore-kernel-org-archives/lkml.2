Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2EGP3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:29:23 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:31295 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754001Ab2EGP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:29:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HJL8OZcVM1ks1cFKCl40kw3_tDOdLuOnhrH0Wa6shu8itSE
 LdcKlWI9vClYULuZZYChAKbJKhUSFPrfkVB90Hm6nBjIB2rudQ_9XNdTRTdb
 _33X3qIog8ZGRHTtY8.wGYCSApG8NCjotM5FCfSeh9jxbfrRscdYYiUMo_y.
 KkTPCIffs2wIdTgsAKXvlkwiPOevZ2uqtZv41Fqf8uAsngmZ0IjmZ7_JgjJz
 DE5gq3H3_g1cchDDEshv6bNtOpn4D8b7wfG9gOAu4hnJo54gdzUk8qQMJG09
 AiOYQTxBy5EHveyIG0V7jvMmuh2eppymLpoJsCTCcAVKPCuaxlx4MKgM2Vjx
 gis5u6dRtfP.2fDL_IFy_c_lsA8gXqKAACp5HlgJJU9IxLitMnU8k.j7hg9o
 d
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 7 May 2012 10:29:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v1 5/6] mm: make vmstat_update periodic run conditional
In-Reply-To: <1336056962-10465-6-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1205071024550.1060@router.home>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-6-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, Gilad Ben-Yossef wrote:

> vmstat_update runs every second from the work queue to update statistics
> and drain per cpu pages back into the global page allocator.

Looks good.

- vmstat_off_cpus is a bit strange. Could we have a cpumask that has a bit
set if vmstat is active? Rename to "vmstat_cpus"?

- Start out with vmstat_cpus cleared? Cpus only need vmstat if they do
something and if a cpu is idle on boot then it will not need vmstat
enabled until the cpu does something useful.

> @@ -1204,8 +1265,14 @@ static int __init setup_vmstat(void)
>
>  	register_cpu_notifier(&vmstat_notifier);
>
> +	INIT_DELAYED_WORK_DEFERRABLE(&vmstat_monitor_work,
> +				vmstat_update_monitor);
> +	queue_delayed_work(system_unbound_wq,
> +				&vmstat_monitor_work,
> +				round_jiffies_relative(HZ));
> +
>  	for_each_online_cpu(cpu)
> -		start_cpu_timer(cpu);
> +		setup_cpu_timer(cpu);
>  #endif
>  #ifdef CONFIG_PROC_FS
>  	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);

So the monitoring thread just bounces around the system? Hope that the
scheduler does the right thing to keep it on processors that do some other
work.

