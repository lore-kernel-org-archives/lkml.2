Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993429Ab2KOENR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:13:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56036 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993396Ab2KOENL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:11 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A46BB6.6070902@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 13:12:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz> <1352820639-13521-3-git-send-email-mhocko@suse.cz> <50A2E3B3.6080007@jp.fujitsu.com> <20121114101052.GD17111@dhcp22.suse.cz>
In-Reply-To: <20121114101052.GD17111@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/14 19:10), Michal Hocko wrote:
> On Wed 14-11-12 09:20:03, KAMEZAWA Hiroyuki wrote:
>> (2012/11/14 0:30), Michal Hocko wrote:
> [...]
>>> @@ -1096,30 +1096,64 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>>    			mz = mem_cgroup_zoneinfo(root, nid, zid);
>>>    			iter = &mz->reclaim_iter[reclaim->priority];
>>>    			spin_lock(&iter->iter_lock);
>>> +			last_visited = iter->last_visited;
>>>    			if (prev && reclaim->generation != iter->generation) {
>>> +				if (last_visited) {
>>> +					mem_cgroup_put(last_visited);
>>> +					iter->last_visited = NULL;
>>> +				}
>>>    				spin_unlock(&iter->iter_lock);
>>>    				return NULL;
>>>    			}
>>> -			id = iter->position;
>>>    		}
>>>
>>>    		rcu_read_lock();
>>> -		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
>>> -		if (css) {
>>> -			if (css == &root->css || css_tryget(css))
>>> -				memcg = mem_cgroup_from_css(css);
>>> -		} else
>>> -			id = 0;
>>> -		rcu_read_unlock();
>>> +		/*
>>> +		 * Root is not visited by cgroup iterators so it needs a special
>>> +		 * treatment.
>>> +		 */
>>> +		if (!last_visited) {
>>> +			css = &root->css;
>>> +		} else {
>>> +			struct cgroup *next_cgroup;
>>> +
>>> +			next_cgroup = cgroup_next_descendant_pre(
>>> +					last_visited->css.cgroup,
>>> +					root->css.cgroup);
>>
>> Maybe I miss something but.... last_visited is holded by memcg's refcnt.
>> The cgroup pointed by css.cgroup is by cgroup's refcnt which can be freed
>> before memcg is freed and last_visited->css.cgroup is out of RCU cycle.
>> Is this safe ?
>
> Good spotted. You are right. What I need to do is to check that the
> last_visited is alive and restart from the root if not. Something like
> the bellow (incremental patch on top of this one) should help, right?
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 30efd7e..c0a91a3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1105,6 +1105,16 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>   				spin_unlock(&iter->iter_lock);
>   				return NULL;
>   			}
> +			/*
> +			 * memcg is still valid because we hold a reference but
> +			 * its cgroup might have vanished in the meantime so
> +			 * we have to double check it is alive and restart the
> +			 * tree walk otherwise.
> +			 */
> +			if (last_visited && !css_tryget(&last_visited->css)) {
> +				mem_cgroup_put(last_visited);
> +				last_visited = NULL;
> +			}
>   		}
>
>   		rcu_read_lock();
> @@ -1136,8 +1146,10 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>   		if (reclaim) {
>   			struct mem_cgroup *curr = memcg;
>
> -			if (last_visited)
> +			if (last_visited) {
> +				css_put(&last_visited->css);
>   				mem_cgroup_put(last_visited);
> +			}
>
>   			if (css && !memcg)
>   				curr = mem_cgroup_from_css(css);
>

I think this will work.

Thanks,
-Kame


