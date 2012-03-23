Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031650Ab2CWAUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:20:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33920 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031616Ab2CWAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:20:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6BC166.80407@jp.fujitsu.com>
Date: Fri, 23 Mar 2012 09:18:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
References: <4F69A4C4.4080602@jp.fujitsu.com> <20120322143610.e4df49c9.akpm@linux-foundation.org>
In-Reply-To: <20120322143610.e4df49c9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/23 6:36), Andrew Morton wrote:

> On Wed, 21 Mar 2012 18:52:04 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>>  static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>>  			unsigned long addr, pte_t ptent, swp_entry_t *entry)
>>  {
>> -	int usage_count;
>>  	struct page *page = NULL;
>>  	swp_entry_t ent = pte_to_swp_entry(ptent);
>>  
>>  	if (!move_anon() || non_swap_entry(ent))
>>  		return NULL;
>> -	usage_count = mem_cgroup_count_swap_user(ent, &page);
>> -	if (usage_count > 1) { /* we don't move shared anon */
>> -		if (page)
>> -			put_page(page);
>> -		return NULL;
>> -	}
>> +#ifdef CONFIG_SWAP
>> +	/*
>> +	 * Avoid lookup_swap_cache() not to update statistics.
>> +	 */
> 
> I don't understand this comment - what is it trying to tell us?
> 


High Dickins advised me to use find_get_page() rather than lookup_swap_cache()
because lookup_swap_cache() has some statistics with swap.

>> +	page = find_get_page(&swapper_space, ent.val);
> 
> The code won't even compile if CONFIG_SWAP=n?
> 

mm/built-in.o: In function `mc_handle_swap_pte':
/home/kamezawa/Kernel/next/linux/mm/memcontrol.c:5172: undefined reference to `swapper_space'
make: *** [.tmp_vmlinux1] Error 1

Ah...but I think this function (mc_handle_swap_pte) itself should be under CONFIG_SWAP.
I'll post v2.

Thank you for review!
-Kame

