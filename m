Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1LBRra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:47:30 -0500
Received: from mx2.parallels.com ([64.131.90.16]:58681 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab1LBRr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:47:27 -0500
Message-ID: <4ED90F06.102@parallels.com>
Date: Fri, 2 Dec 2011 15:46:46 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>, <devel@openvz.org>,
        <eric.dumazet@gmail.com>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] foundations of per-cgroup memory pressure controlling.
References: <1322611021-1730-1-git-send-email-glommer@parallels.com> <1322611021-1730-3-git-send-email-glommer@parallels.com> <20111130094305.9c69ecd8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111130094305.9c69ecd8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>   static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
>>   {
>> +	struct mem_cgroup *memcg = mem_cgroup_from_task(current);
>> +
>>   	seq_printf(seq, "%-9s %4u %6d  %6ld   %-3s %6u   %-3s  %-10s "
>>   			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
>>   		   proto->name,
>>   		   proto->obj_size,
>>   		   sock_prot_inuse_get(seq_file_net(seq), proto),
>> -		   proto->memory_allocated != NULL ? atomic_long_read(proto->memory_allocated) : -1L,
>> -		   proto->memory_pressure != NULL ? *proto->memory_pressure ? "yes" : "no" : "NI",
>> +		   sock_prot_memory_allocated(proto, memcg),
>> +		   sock_prot_memory_pressure(proto, memcg),
>
> I wonder I should say NO, here. (Networking guys are ok ??)
>
> IIUC, this means there is no way to see aggregated sockstat of all system.
> And the result depends on the cgroup which the caller is under control.
>
> I think you should show aggregated sockstat(global + per-memcg) here and
> show per-memcg ones via /cgroup interface or add private_sockstat to show
> per cgroup summary.
>

Hi Kame,

Yes, the statistics displayed depends on which cgroup you live.
Also, note that the parent cgroup here is always updated (even when 
use_hierarchy is set to 0). So it is always possible to grab global 
statistics, by being in the root cgroup.

For the others, I believe it to be a question of naturalization. Any 
tool that is fetching these values is likely interested in the amount of 
resources available/used. When you are on a cgroup, the amount of 
resources available/used changes, so that's what you should see.

Also brings the point of resource isolation: if you shouldn't interfere 
with other set of process' resources, there is no reason for you to see 
them in the first place.

So given all that, I believe that whenever we talk about resources in a 
cgroup, we should talk about cgroup-local ones.
