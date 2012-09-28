Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2I1Hq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:46:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab2I1Hq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:46:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5933191"
Message-ID: <50654F6E.7090000@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 15:19:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph <cl@linux.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/3] slub, hotplug: ignore unrelated node's hot-adding
 and hot-removing
References: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com> <1348728470-5580-3-git-send-email-laijs@cn.fujitsu.com> <5064CD7F.1040507@gmail.com> <0000013a09dec004-497e7afa-8c0f-46ff-bf8e-056f7df1ed0b-000000@email.amazonses.com>
In-Reply-To: <0000013a09dec004-497e7afa-8c0f-46ff-bf8e-056f7df1ed0b-000000@email.amazonses.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 15:17:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 15:17:09,
	Serialize complete at 2012/09/28 15:17:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, Christoph, KOSAKI

SLAB always allocates kmem_list3 for all nodes(N_HIGH_MEMORY), also node bug/bad things happens.
SLUB always requires kmem_cache_node on the correct node, so these fix is needed.

SLAB uses for_each_online_node() to travel nodes and do maintain,
and it tolerates kmem_list3 on alien nodes.
SLUB uses for_each_node_state(node, N_NORMAL_MEMORY) to travel nodes and do maintain,
and it does not tolerate kmem_cache_node on alien nodes.

Maybe we need to change SLAB future and let it use
for_each_node_state(node, N_NORMAL_MEMORY), But I don't want to change SLAB
until I find something bad in SLAB.

Thanks,
Lai

On 09/28/2012 06:35 AM, Christoph wrote:
> While you are at it: Could you move the code into slab_common.c so that there is only one version to maintain?
> 
> On Sep 27, 2012, at 17:04, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> 
>> (9/27/12 2:47 AM), Lai Jiangshan wrote:
>>> SLUB only fucus on the nodes which has normal memory, so ignore the other
>>> node's hot-adding and hot-removing.
>>>
>>> Aka: if some memroy of a node(which has no onlined memory) is online,
>>> but this new memory onlined is not normal memory(HIGH memory example),
>>> we should not allocate kmem_cache_node for SLUB.
>>>
>>> And if the last normal memory is offlined, but the node still has memroy,
>>> we should remove kmem_cache_node for that node.(current code delay it when
>>> all of the memory is offlined)
>>>
>>> so we only do something when marg->status_change_nid_normal > 0.
>>> marg->status_change_nid is not suitable here.
>>>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> ---
>>> mm/slub.c |    4 ++--
>>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index 2fdd96f..2d78639 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -3577,7 +3577,7 @@ static void slab_mem_offline_callback(void *arg)
>>>    struct memory_notify *marg = arg;
>>>    int offline_node;
>>>
>>> -    offline_node = marg->status_change_nid;
>>> +    offline_node = marg->status_change_nid_normal;
>>>
>>>    /*
>>>     * If the node still has available memory. we need kmem_cache_node
>>> @@ -3610,7 +3610,7 @@ static int slab_mem_going_online_callback(void *arg)
>>>    struct kmem_cache_node *n;
>>>    struct kmem_cache *s;
>>>    struct memory_notify *marg = arg;
>>> -    int nid = marg->status_change_nid;
>>> +    int nid = marg->status_change_nid_normal;
>>>    int ret = 0;
>>
>> Looks reasonable. I think slab need similar fix too.
>>
>>
>>
> 

