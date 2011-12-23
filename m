Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1LWI6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 03:58:40 -0500
Received: from mx2.parallels.com ([64.131.90.16]:44265 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab1LWI6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 03:58:31 -0500
Message-ID: <4EF4428D.6010103@parallels.com>
Date: Fri, 23 Dec 2011 12:57:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <ebiederm@xmission.com>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>, <devel@openvz.org>,
        <eric.dumazet@gmail.com>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v9 3/9] socket: initial cgroup code.
References: <1323676029-5890-1-git-send-email-glommer@parallels.com> <1323676029-5890-4-git-send-email-glommer@parallels.com> <20111222211028.GB3916@redhat.com>
In-Reply-To: <20111222211028.GB3916@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 01:10 AM, Jason Baron wrote:
> On Mon, Dec 12, 2011 at 11:47:03AM +0400, Glauber Costa wrote:
>> +
>> +static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
>> +void sock_update_memcg(struct sock *sk)
>> +{
>> +	/* A socket spends its whole life in the same cgroup */
>> +	if (sk->sk_cgrp) {
>> +		WARN_ON(1);
>> +		return;
>> +	}
>> +	if (static_branch(&memcg_socket_limit_enabled)) {
>> +		struct mem_cgroup *memcg;
>> +
>> +		BUG_ON(!sk->sk_prot->proto_cgroup);
>> +
>> +		rcu_read_lock();
>> +		memcg = mem_cgroup_from_task(current);
>> +		if (!mem_cgroup_is_root(memcg)) {
>> +			mem_cgroup_get(memcg);
>> +			sk->sk_cgrp = sk->sk_prot->proto_cgroup(memcg);
>> +		}
>> +		rcu_read_unlock();
>> +	}
>> +}
>> +EXPORT_SYMBOL(sock_update_memcg);
>> +
>> +void sock_release_memcg(struct sock *sk)
>> +{
>> +	if (static_branch(&memcg_socket_limit_enabled)&&  sk->sk_cgrp) {
>> +		struct mem_cgroup *memcg;
>> +		WARN_ON(!sk->sk_cgrp->memcg);
>> +		memcg = sk->sk_cgrp->memcg;
>> +		mem_cgroup_put(memcg);
>> +	}
>> +}
>
> Hi Glauber,
>
> I think for 'sock_release_memcg()', you want:
>
> static inline sock_release_memcg(sk)
> {
> 	if (static_branch())
> 		__sock_release_memcg();
> }
>
> And then re-define the current sock_release_memcg ->  __sock_release_memcg().
> In that way the straight line path is a single no-op. As currently
> written, there is function call and then an immediate return.
>

Hello Jason,

Thanks for the tip. I may be wrong here, but I don't think that the 
release performance matters to that level. But your suggestion seems 
good nevertheless. Since this is already sitting on a tree, would you 
like to send a patch for that?

