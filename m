Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab1IXNcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 09:32:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51112 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1IXNb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 09:31:59 -0400
Message-ID: <4E7DDB82.3030802@parallels.com>
Date: Sat, 24 Sep 2011 10:30:42 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-7-git-send-email-glommer@parallels.com> <CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
In-Reply-To: <CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.134.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 03:01 AM, Greg Thelen wrote:
> On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa<glommer@parallels.com>  wrote:
>> +static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
>> +{
>> +       return (mem == root_mem_cgroup);
>> +}
>> +
>
> Why are you adding a copy of mem_cgroup_is_root().  I see one already
> in v3.0.  Was it deleted in a previous patch?

Already answered by another good samaritan.

>> +static int tcp_write_maxmem(struct cgroup *cgrp, struct cftype *cft, u64 val)
>> +{
>> +       struct mem_cgroup *sg = mem_cgroup_from_cont(cgrp);
>> +       struct mem_cgroup *parent = parent_mem_cgroup(sg);
>> +       struct net *net = current->nsproxy->net_ns;
>> +       int i;
>> +
>> +       if (!cgroup_lock_live_group(cgrp))
>> +               return -ENODEV;
>
> Why is cgroup_lock_live_cgroup() needed here?  Does it protect updates
> to sg->tcp_prot_mem[*]?
>
>> +static u64 tcp_read_maxmem(struct cgroup *cgrp, struct cftype *cft)
>> +{
>> +       struct mem_cgroup *sg = mem_cgroup_from_cont(cgrp);
>> +       u64 ret;
>> +
>> +       if (!cgroup_lock_live_group(cgrp))
>> +               return -ENODEV;
>
> Why is cgroup_lock_live_cgroup() needed here?  Does it protect updates
> to sg->tcp_max_memory?

No, that is not my understanding. My understanding is this lock is 
needed to protect against the cgroup just disappearing under our nose.

The task reading/writing it is not necessarily inside the cgroup 
(usually it is not...), so the mere fact of opening the file does not 
guarantee the cgroup will be kept alive. So we can grab a pointer - 
cgroup exists - and write to it - cgroup does not exist.

Or am I missing something ?
