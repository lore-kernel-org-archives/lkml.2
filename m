Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2KTPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:09:26 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:51636 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2KTPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:09:25 -0500
Message-ID: <50AB9D22.5030000@monom.org>
Date: Tue, 20 Nov 2012 16:09:22 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] netprio_cgroup: reimplement priomap expansion
References: <1353400211-5182-1-git-send-email-tj@kernel.org> <1353400211-5182-5-git-send-email-tj@kernel.org> <50AB435E.8060901@monom.org> <20121120143832.GO15971@htj.dyndns.org>
In-Reply-To: <20121120143832.GO15971@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.2012 15:38, Tejun Heo wrote:
> Hello, Daniel.
>
> On Tue, Nov 20, 2012 at 09:46:22AM +0100, Daniel Wagner wrote:
>> struct netprio_map {
>> 	struct rcu_head rcu;
>> 	struct netprio_aux *aux;	/* auxiliary config array */
>> 	u32 priomap_len;
>> 	u32 priomap[];
>> };
>>
>> Is there a specific reason why aux and priomap is handled
>> differently? Couldn't you just use same approach for both variables,
>> e.g. re/allocating only them here and leave the allocation struct
>> netprio_map in cgrp_css_alloc()?
>
> ->aux is no longer added, so the consistency issue doesn't exist
> anymore.

Right, I got confused looking at v1 and v2.

> The reason why they were handled differently before (or
> rather why I didn't change priomap[] to be allocated separately) was
> that pointer chasing tends to be more expensive than offsetting.  I
> don't know how much effect it would have in this case but things
> sitting in packet in/out paths can be very hot so didn't wanna disturb
> it.

I see.

>> Also the algorithm to figure out the size of the array might be a
>> bit too aggressive in my opinion. So you always start at
>> PRIOMAP_MIN_SIZE and then try to double the size until target_idx
>> fits. Wouldn't it make sense to start to look for the new size
>> beginning at old->priomap_len and then do the power-of-two increase?
>
> The only downside of always starting from PRIOMAP_MIN_SIZE is
> iterating several more times in the sizing loop which isn't really
> anything to worry about.  The loop is structured that way because I
> wanted to keep the size of the whole thing power-of-two.  Due to the
> fields before priomap[], if we size priomap_len power-of-two, we'll
> always end up with something slightly over power-of-two, which is
> usually the worst size to allocate.

Thanks for the explanation. I was pondering if the new size in power of 
two could be a bit too excessive and the allocation step could be 
linear, e.g. stick at 4096. target_id will increase linear, therefore 
linear increase might also be enough, no?

cheers,
daniel

