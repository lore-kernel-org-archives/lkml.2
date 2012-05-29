Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2E2QJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:09:05 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38964 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2E2QJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:09:02 -0400
Message-ID: <4FC4F415.30007@parallels.com>
Date: Tue, 29 May 2012 20:06:45 +0400
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
Subject: Re: [PATCH v3 18/28] slub: charge allocation to a memcg
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-19-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290948250.4666@router.home>
In-Reply-To: <alpine.DEB.2.00.1205290948250.4666@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 06:51 PM, Christoph Lameter wrote:
> On Fri, 25 May 2012, Glauber Costa wrote:
>
>> This patch charges allocation of a slab object to a particular
>> memcg.
>
> I am wondering why you need all the other patches. The simplest approach
> would just to hook into page allocation and freeing from the slab
> allocators as done here and charge to the currently active cgroup. This
> avoids all the duplication of slab caches and per node as well as per cpu
> structures. A certain degree of fuzziness cannot be avoided given that
> objects are cached and may be served to multiple cgroups. If that can be
> tolerated then the rest would be just like this patch which could be made
> more simple and non intrusive.
>
Just hooking into the page allocation only works for caches with very 
big objects. For all the others, we need to relay the process to the 
correct cache.

Some objects may be shared, yes, but in reality most won't.

Let me give you an example:

We track task_struct here. So as a nice side effect of this, a fork bomb 
will be killed because it will not be able to allocate any further.

But if we're accounting only at page allocation time, it is quite 
possible to come up with a pattern while I always let other cgroups
pay the price for the page, but I will be the one filling it.

Having an eventual dentry, for instance, shared among caches, is okay. 
But the main use case is for process in different cgroups dealing with 
totally different parts of the filesystem.

So we can't really afford to charge to the process touching the nth 
object where n is the number of objects per page. We need to relay it to 
the right one.
