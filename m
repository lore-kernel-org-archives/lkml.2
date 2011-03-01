Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1CABDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 20:03:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1CABDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 20:03:37 -0500
Message-ID: <4D6C4652.6030804@cn.fujitsu.com>
Date: Tue, 01 Mar 2011 09:05:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] cpuset: Add a missing unlock in cpuset_write_resmask()
References: <4D6601B2.1090207@cn.fujitsu.com> <20110228155524.6d7563e0.akpm@linux-foundation.org>
In-Reply-To: <20110228155524.6d7563e0.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 09:02:28,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 09:02:28,
	Serialize complete at 2011-03-01 09:02:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1561,8 +1561,10 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
>>  		return -ENODEV;
>>  
>>  	trialcs = alloc_trial_cpuset(cs);
>> -	if (!trialcs)
>> +	if (!trialcs) {
>> +		cgroup_unlock();
>>  		return -ENOMEM;
>> +	}
>>  
>>  	switch (cft->private) {
>>  	case FILE_CPULIST:
> 
> It would be better to avoid multiple returns - it leads to more
> maintainable code and often shorter code:
> 

I have no strong opinion on this.

> --- a/kernel/cpuset.c~cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix
> +++ a/kernel/cpuset.c
> @@ -1562,8 +1562,8 @@ static int cpuset_write_resmask(struct c
>  
>  	trialcs = alloc_trial_cpuset(cs);
>  	if (!trialcs) {
> -		cgroup_unlock();
> -		return -ENOMEM;
> +		retval = -ENOMEM;
> +		goto out;
>  	}
>  
>  	switch (cft->private) {
> @@ -1579,6 +1579,7 @@ static int cpuset_write_resmask(struct c
>  	}
>  
>  	free_trial_cpuset(trialcs);
> +out:
>  	cgroup_unlock();
>  	return retval;
>  }
> _
> 
> also, alloc_trial_cpuset() is a fairly slow-looking function. 
> cpuset_write_resmask() could run alloc_trial_cpuset() before running
> cgroup_lock_live_group(), thereby reducing lock hold times.
> 

Nope. alloc_trial_cpuset() will read 'cs', so it must be protected by
the lock.
