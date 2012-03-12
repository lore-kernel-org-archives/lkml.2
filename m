Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2CLUl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:41:56 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43688 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2CLUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:41:54 -0400
Date: Mon, 12 Mar 2012 16:41:45 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix idle ticks in cpu summary line of /proc/stat
Message-ID: <20120312164145.5110ed5c@de.ibm.com>
In-Reply-To: <20120312153906.GE3994@tiehlicka.suse.cz>
References: <20120311182621.41674b39@de.ibm.com>
	<20120312121726.GA23608@tiehlicka.suse.cz>
	<20120312101739.26eb373e@de.ibm.com>
	<4F5E0CC1.6010102@linux.vnet.ibm.com>
	<20120312153906.GE3994@tiehlicka.suse.cz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12031220-1948-0000-0000-0000012D62A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 16:39:06 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Hmm, the semantic is that the function either returns the sleeptime or
> -1 if nohz is disabled. Bringing also online/offline into it seems
> rather confusing. 
> Maybe we shouldn't do the test layer up when we call the function
> instead. This should be much cleaner IMO (it also reduced cpu_online
> call from the governors call paths which might be a problem as well):
> 
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index 121f77c..d437258 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -24,7 +24,10 @@
> 
>  static u64 get_idle_time(int cpu)
>  {
> -	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
> +	u64 idle, idle_time = -1ULL;
> +	
> +	if (cpu_online(cpu))
> +		idle_time = get_cpu_idle_time_us(cpu, NULL);
> 
>  	if (idle_time == -1ULL) {
>  		/* !NO_HZ so we can rely on cpustat.idle */
> @@ -38,7 +41,10 @@ static u64 get_idle_time(int cpu)
> 
>  static u64 get_iowait_time(int cpu)
>  {
> -	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
> +	u64 iowait, iowait_time = -1ULL;
> +	
> +	if (cpu_online(cpu))
> +		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
> 
>  	if (iowait_time == -1ULL)
>  		/* !NO_HZ so we can rely on cpustat.iowait */
> 

That looks better and should be equivalent.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

