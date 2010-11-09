Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0KIXWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:22:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:3436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0KIXWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gHqrzlAUj96bq+ms7EQMZWnhWnknGD1pnCj75BTD5G1jzerlnS3yY9jA0ZlAJESSj6
         TTiYRCcv/ZV0fKXNzvNA==
Date: Tue, 9 Nov 2010 15:21:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Thelen <gthelen@google.com>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mem_cgroup_get_limit() return type, was [patch] memcg: fix unit
 mismatch in memcg oom limit calculation
In-Reply-To: <xr9362w66tss.fsf@ninji.mtv.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011091519420.26837@chino.kir.corp.google.com>
References: <20101109110521.GS23393@cmpxchg.org> <xr93iq068dyd.fsf@ninji.mtv.corp.google.com> <alpine.DEB.2.00.1011091327420.7730@chino.kir.corp.google.com> <xr9362w66tss.fsf@ninji.mtv.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Greg Thelen wrote:

> >> > Adding the number of swap pages to the byte limit of a memory control
> >> > group makes no sense.  Convert the pages to bytes before adding them.
> >> >
> >> > The only user of this code is the OOM killer, and the way it is used
> >> > means that the error results in a higher OOM badness value.  Since the
> >> > cgroup limit is the same for all tasks in the cgroup, the error should
> >> > have no practical impact at the moment.
> >> >
> >> > But let's not wait for future or changing users to trip over it.
> >> 
> >> Thanks for the fix.
> >> 
> >
> > Nice catch, but it's done in the opposite way: the oom killer doesn't use 
> > byte limits but page limits.  So this needs to be
> >
> > 	(res_counter_read_u64(&memcg->res, RES_LIMIT) >> PAGE_SHIFT) +
> > 			total_swap_pages;
> 
> In -mm, the oom killer queries memcg for a byte limit using
> mem_cgroup_get_limit(). The following is from
> mem_cgroup_out_of_memory():
> 
> 	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
> 

Oops, I missed that.  I think Johannes' patch is better because 
mem_cgroup_get_limit() may eventually be used elsewhere and the subsystem 
has byte granularity.

Thanks!
