Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab0JTEIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:08:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0JTEIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:08:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=AhWF4akB5a/t6ln9t6SkxAy9b5+xnSgE5Ask2i9Q7nnZyyDhqpTM/M+jtxNMcrju9
	sbzPMn10TbS79Dxfcmg/w==
From: Greg Thelen <gthelen@google.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 07/11] memcg: add dirty limits to mem_cgroup
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-8-git-send-email-gthelen@google.com>
	<20101020095056.48098b34.nishimura@mxp.nes.nec.co.jp>
Date: Tue, 19 Oct 2010 21:08:20 -0700
Message-ID: <xr93iq0x1p6z.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> writes:

>> +static unsigned long long
>> +memcg_hierarchical_free_pages(struct mem_cgroup *mem)
>> +{
>> +	struct cgroup *cgroup;
>> +	unsigned long long min_free, free;
>> +
>> +	min_free = res_counter_read_u64(&mem->res, RES_LIMIT) -
>> +		res_counter_read_u64(&mem->res, RES_USAGE);
>> +	cgroup = mem->css.cgroup;
>> +	if (!mem->use_hierarchy)
>> +		goto out;
>> +
>> +	while (cgroup->parent) {
>> +		cgroup = cgroup->parent;
>> +		mem = mem_cgroup_from_cont(cgroup);
>> +		if (!mem->use_hierarchy)
>> +			break;
>> +		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
>> +			res_counter_read_u64(&mem->res, RES_USAGE);
>> +		min_free = min(min_free, free);
>> +	}
>> +out:
>> +	/* Translate free memory in pages */
>> +	return min_free >> PAGE_SHIFT;
>> +}
>> +
> I think you can simplify this function using parent_mem_cgroup().
>
> 	unsigned long free, min_free = ULLONG_MAX;
>
> 	while (mem) {
> 		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
> 			res_counter_read_u64(&mem->res, RES_USAGE);
> 		min_free = min(min_free, free);
> 		mem = parent_mem_cgroup();
> 	}
>
> 	/* Translate free memory in pages */
> 	return min_free >> PAGE_SHIFT;
>
> And, IMHO, we should return min(global_page_state(NR_FREE_PAGES), min_free >> PAGE_SHIFT).
> Because we are allowed to set no-limit(or a very big limit) in memcg,
> so min_free can be very big if we don't set a limit against all the memcg's in hierarchy.
>
>
> Thanks,
> Dasiuke Nishimura.

Thank you.  This is a good suggestion.  I will update the page to include this.

--
Greg
