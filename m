Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1GAHCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:02:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40922 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1GAHCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:02:52 -0400
Message-ID: <4E0D7108.5070802@oracle.com>
Date: Fri, 01 Jul 2011 00:02:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-30-15-59 uploaded (mm/memcontrol.c)
References: <201106302259.p5UMxh5i019162@imap1.linux-foundation.org>	<20110630172054.49287627.randy.dunlap@oracle.com>	<20110701091525.bd8095f1.kamezawa.hiroyu@jp.fujitsu.com> <20110701095433.71c2aa18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110701095433.71c2aa18.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E0D7116.0072:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/11 17:54, KAMEZAWA Hiroyuki wrote:
> On Fri, 1 Jul 2011 09:15:25 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> On Thu, 30 Jun 2011 17:20:54 -0700
>> Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>>> On Thu, 30 Jun 2011 15:59:43 -0700 akpm@linux-foundation.org wrote:
>>>
>>>> The mm-of-the-moment snapshot 2011-06-30-15-59 has been uploaded to
>>>>
>>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>>
>>>> and will soon be available at
>>>>    git://zen-kernel.org/kernel/mmotm.git
>>>> or
>>>>    git://git.cmpxchg.org/linux-mmotm.git
>>>>
>>>> It contains the following patches against 3.0-rc5:
>>>
>>> I see several of these build errors:
>>>
>>> mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
>>> mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
>>>
>>
>> Thanks...maybe !CONFIG_NUMA again. will post a fix soon.
>>
> 
> fix here. compiled and booted on !CONFIG_NUMA on my host.
> I think I should do total cleanup of functions in mm/memcontrol.c 
> in the next week..several functions implements similar logics....
> ==
> From 8773fc8b596dc56adf52fd0780c1b034291185ee Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 1 Jul 2011 09:49:54 +0900
> Subject: [PATCH]memcg-fix-reclaimable-lru-check-in-memcg-fix2.patch
> 
> 
>  memcg-fix-reclaimable-lru-check-in-memcg.patch
>  causes following error with !CONFIG_NUMA.
> 
>> mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
>> mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
>>
> 
> This patch fixes it by moving functions out of #ifdef.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  mm/memcontrol.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index db70176..fb7338f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1134,7 +1134,6 @@ unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
>  	return MEM_CGROUP_ZSTAT(mz, lru);
>  }
>  
> -#ifdef CONFIG_NUMA
>  static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
>  							int nid)
>  {
> @@ -1146,6 +1145,17 @@ static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
>  	return ret;
>  }
>  
> +static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
> +							int nid)
> +{
> +	unsigned long ret;
> +
> +	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
> +		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
> +	return ret;
> +}
> +
> +#if MAX_NUMNODES > 1
>  static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
>  {
>  	u64 total = 0;
> @@ -1157,17 +1167,6 @@ static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
>  	return total;
>  }
>  
> -static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
> -							int nid)
> -{
> -	unsigned long ret;
> -
> -	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
> -		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
> -
> -	return ret;
> -}
> -
>  static unsigned long mem_cgroup_nr_anon_lru_pages(struct mem_cgroup *memcg)
>  {
>  	u64 total = 0;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
