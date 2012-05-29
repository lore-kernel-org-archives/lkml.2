Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2E2UK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 16:10:58 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60752 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab2E2UK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 16:10:57 -0400
Message-ID: <4FC52CC6.7020109@parallels.com>
Date: Wed, 30 May 2012 00:08:38 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home> <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com> <alpine.DEB.2.00.1205291454030.2504@router.home>
In-Reply-To: <alpine.DEB.2.00.1205291454030.2504@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 11:55 PM, Christoph Lameter wrote:
>> NUMA just means what is the*best*  node to put my memory.
>> >  Now, if you actually say, through you syscalls "this is the node it should
>> >  live in", then you have a constraint, that to the best of my knowledge is
>> >  respected.
> Eith cpusets it means that memory needs to come from an assigned set of
> nodes.
>
>> >  Now isolation here, is done in the container boundary. (cgroups, to be
>> >  generic).
> Yes and with cpusets it is done at the cpuset boundary. Very much the
> same.

Well, I'd have to dive in the code a bit more, but that the impression 
that the documentation gives me, by saying:

"Cpusets constrain the CPU and Memory placement of tasks to only
the resources within a task's current cpuset."

is that you can't allocate from a node outside that set. Is this correct?

So extrapolating this to memcg, the situation is as follows:

* You can't use more memory than what you are assigned to.
* In order to do that, you need to account the memory you are using
* and to account the memory you are using, all objects in the page
   must belong to you.

Please note the following:

Having two cgroups touching the same object is something. It tells 
something about the relationship between them. This is shared memory.

Now having two cgroups putting objects in the same page, *does not mean 
_anything_*. It just mean that one had the luck to allocate just after 
the other.

With a predictable enough workload, this is a recipe for working around 
the very protection we need to establish: one can DoS a physical box 
full of containers, by always allocating in someone else's pages, and 
pinning kernel memory down. Never releasing it, so the shrinkers are 
useless.

So I still believe that if a page is allocated to a cgroup, all the 
objects in there belong to it  - unless of course the sharing actually 
means something - and identifying this is just too complicated.






