Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2HONvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:51:52 -0400
Received: from mx2.parallels.com ([64.131.90.16]:57926 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab2HONvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:51:51 -0400
Message-ID: <502BA96C.8070602@parallels.com>
Date: Wed, 15 Aug 2012 17:51:40 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 07/11] mm: Allocate kernel pages to the right memcg
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-8-git-send-email-glommer@parallels.com> <20120814151616.GO4177@suse.de> <502B66F8.30909@parallels.com> <20120815132244.GQ4177@suse.de>
In-Reply-To: <20120815132244.GQ4177@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 05:22 PM, Mel Gorman wrote:
>> I believe it
>> > to be a better and less complicated approach then letting a page appear
>> > and then charging it. Besides being consistent with the rest of memcg,
>> > it won't create unnecessary disturbance in the page allocator
>> > when the allocation is to fail.
>> > 
> I still don't get why you did not just return a mem_cgroup instead of a
> handle.
> 

Forgot this one, sorry:

The reason is to keep the semantics simple.

What should we return if the code is not compiled in? If we return NULL
for failure, the test becomes

memcg = memcg_kmem_charge_page(gfp, order);
if (!memcg)
  exit;

If we're not compiled in, we'd either return positive garbage or we need
to wrap it inside an ifdef

I personally believe to be a lot more clear to standardize on true
to mean "allocation can proceed".

the compiled out case becomes:

if (!true)
   exit;

which is easily compiled away altogether. Now of course, using struct
mem_cgroup makes sense, and I have already changed that here.

