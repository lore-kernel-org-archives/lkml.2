Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0KJB23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:28:29 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0KJB22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:28:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=illHNCvRXzH8QmwRfEiCNCXQkz4JolzXGcCvprweliO+AxhxLALJEbbQxnnoVXM6s
	2o/WEfMNgozgCfgPTk0Kg==
From: Greg Thelen <gthelen@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mem_cgroup_get_limit() return type, was [patch] memcg: fix unit mismatch in memcg oom limit calculation
References: <20101109110521.GS23393@cmpxchg.org>
	<xr93iq068dyd.fsf@ninji.mtv.corp.google.com>
	<alpine.DEB.2.00.1011091327420.7730@chino.kir.corp.google.com>
	<xr9362w66tss.fsf@ninji.mtv.corp.google.com>
	<alpine.DEB.2.00.1011091519420.26837@chino.kir.corp.google.com>
Date: Tue, 09 Nov 2010 17:26:34 -0800
In-Reply-To: <alpine.DEB.2.00.1011091519420.26837@chino.kir.corp.google.com>
	(David Rientjes's message of "Tue, 9 Nov 2010 15:21:50 -0800 (PST)")
Message-ID: <xr93vd4655px.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> On Tue, 9 Nov 2010, Greg Thelen wrote:
>
>> >> > Adding the number of swap pages to the byte limit of a memory control
>> >> > group makes no sense.  Convert the pages to bytes before adding them.
>> >> >
>> >> > The only user of this code is the OOM killer, and the way it is used
>> >> > means that the error results in a higher OOM badness value.  Since the
>> >> > cgroup limit is the same for all tasks in the cgroup, the error should
>> >> > have no practical impact at the moment.
>> >> >
>> >> > But let's not wait for future or changing users to trip over it.
>> >> 
>> >> Thanks for the fix.
>> >> 
>> >
>> > Nice catch, but it's done in the opposite way: the oom killer doesn't use 
>> > byte limits but page limits.  So this needs to be
>> >
>> > 	(res_counter_read_u64(&memcg->res, RES_LIMIT) >> PAGE_SHIFT) +
>> > 			total_swap_pages;
>> 
>> In -mm, the oom killer queries memcg for a byte limit using
>> mem_cgroup_get_limit(). The following is from
>> mem_cgroup_out_of_memory():
>> 
>> 	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
>> 
>
> Oops, I missed that.  I think Johannes' patch is better because 
> mem_cgroup_get_limit() may eventually be used elsewhere and the subsystem 
> has byte granularity.

I have no problem with mem_cgroup_get_limit() returning a byte count as
you prefer.  I think this approach does have an issue.
"mem_cgroup_get_limit() >> PAGE_SHIFT" may not fit within unsigned long
on 32-bit machines.  Does this cause a problem for the 'limit' local
variable in mem_cgroup_out_of_memory():
 	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;

Do we need something like the following in mem_cgroup_out_of_memory() to
guard against this overflow?
 	limit = min(mem_cgroup_get_limit(mem) >> PAGE_SHIFT, ULONG_MAX);
