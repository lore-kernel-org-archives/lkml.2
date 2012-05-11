Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672Ab2EKSN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:13:56 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33612 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2EKSNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:13:55 -0400
Message-ID: <4FAD566C.3000804@parallels.com>
Date: Fri, 11 May 2012 15:11:56 -0300
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
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
In-Reply-To: <alpine.DEB.2.00.1205111305570.386@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.105.248.83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 03:06 PM, Christoph Lameter wrote:
> On Fri, 11 May 2012, Glauber Costa wrote:
>
>>> Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
>>> always passed the correct slab cache.
>>
>> Well, problem is , it isn't always passed the "correct" slab cache.
>> At least not after this series, since we'll have child caches associated with
>> the main cache.
>>
>> So we'll pass, for instance, kmem_cache_free(dentry_cache...), but will in
>> fact free from the memcg copy of the dentry cache.
>
> Urg. But then please only do this for the MEMCG case and add a fat big
> warning in kmem_cache_free.

I can do that, of course.
Another option if you don't oppose, is to add another field in the 
kmem_cache structure (I tried to keep them at a minimum),
to record the parent cache we got created from.

Then, it gets trivial to do the following:

VM_BUG_ON(page->slab != s && page->slab != s->parent_cache);

