Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2I0Wor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:44:47 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:34184 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab2I0Woo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:44:44 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 18:44:44 EDT
References: <1348728470-5580-1-git-send-email-laijs@cn.fujitsu.com> <1348728470-5580-3-git-send-email-laijs@cn.fujitsu.com> <5064CD7F.1040507@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5064CD7F.1040507@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <0000013a09dec004-497e7afa-8c0f-46ff-bf8e-056f7df1ed0b-000000@email.amazonses.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kosaki.motohiro@gmail.com" <kosaki.motohiro@gmail.com>
X-Mailer: iPad Mail (10A403)
From: Christoph <cl@linux.com>
Subject: Re: [PATCH 2/3] slub, hotplug: ignore unrelated node's hot-adding and hot-removing
Date: Thu, 27 Sep 2012 22:35:25 +0000
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While you are at it: Could you move the code into slab_common.c so that there is only one version to maintain?

On Sep 27, 2012, at 17:04, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> (9/27/12 2:47 AM), Lai Jiangshan wrote:
>> SLUB only fucus on the nodes which has normal memory, so ignore the other
>> node's hot-adding and hot-removing.
>> 
>> Aka: if some memroy of a node(which has no onlined memory) is online,
>> but this new memory onlined is not normal memory(HIGH memory example),
>> we should not allocate kmem_cache_node for SLUB.
>> 
>> And if the last normal memory is offlined, but the node still has memroy,
>> we should remove kmem_cache_node for that node.(current code delay it when
>> all of the memory is offlined)
>> 
>> so we only do something when marg->status_change_nid_normal > 0.
>> marg->status_change_nid is not suitable here.
>> 
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> mm/slub.c |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 2fdd96f..2d78639 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3577,7 +3577,7 @@ static void slab_mem_offline_callback(void *arg)
>>    struct memory_notify *marg = arg;
>>    int offline_node;
>> 
>> -    offline_node = marg->status_change_nid;
>> +    offline_node = marg->status_change_nid_normal;
>> 
>>    /*
>>     * If the node still has available memory. we need kmem_cache_node
>> @@ -3610,7 +3610,7 @@ static int slab_mem_going_online_callback(void *arg)
>>    struct kmem_cache_node *n;
>>    struct kmem_cache *s;
>>    struct memory_notify *marg = arg;
>> -    int nid = marg->status_change_nid;
>> +    int nid = marg->status_change_nid_normal;
>>    int ret = 0;
> 
> Looks reasonable. I think slab need similar fix too.
> 
> 
> 
