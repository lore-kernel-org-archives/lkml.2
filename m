Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1I1MM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:12:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41711 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1I1MM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:12:26 -0400
Message-ID: <4E830EF1.5080704@parallels.com>
Date: Wed, 28 Sep 2011 09:11:29 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andrew Wagin <avagin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/7] per-cgroup tcp buffers control
References: <1316051175-17780-1-git-send-email-glommer@parallels.com> <1316051175-17780-5-git-send-email-glommer@parallels.com> <CANaxB-wy8VDv0Wjni6UzcfBzSgNn=bZBey5f+fXHebNuek=O1A@mail.gmail.com>
In-Reply-To: <CANaxB-wy8VDv0Wjni6UzcfBzSgNn=bZBey5f+fXHebNuek=O1A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.173.177]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 08:58 AM, Andrew Wagin wrote:
> * tcp_destroy_cgroup_fill() is executed for each cgroup and
> initializes some proto methods. proto_list is global and we can
> initialize each proto one time. Do we need this really?
>
> * And when a cgroup is destroyed, it cleans proto methods
> (tcp_destroy_cgroup_fill), how other cgroups will work after that?

I've already realized that, and removed destruction from my upcoming
series. Thanks

> * What about proto, which is registered when cgroup mounted?
>
> My opinion that we may initialize proto by the following way:
>
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM+       .enter_memory_pressure
> = tcp_enter_memory_pressure_nocg,
> +       .sockets_allocated      = sockets_allocated_tcp_nocg,
> +       .memory_allocated       = memory_allocated_tcp_nocg,
> +       .memory_pressure        = memory_pressure_tcp_nocg,
> +#else
>          .enter_memory_pressure  = tcp_enter_memory_pressure,
>          .sockets_allocated      = sockets_allocated_tcp,
>          .memory_allocated       = memory_allocated_tcp,
>          .memory_pressure        = memory_pressure_tcp,
> +#endif
>
> It should work, because the root memory cgroup always exists.
Yeah, I was still doing the initialization through cgroups, but I think
this works.

The reason I was keeping it cgroup's initialization method, was because 
we have a parameter that allowed kmem accounting to be disabled.
But Kame suggested we'd remove it, and so I did.

>
>> +int tcp_init_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
>> +                        struct cgroup_subsys *ss)
>> +{
>> +       prot->enter_memory_pressure     = tcp_enter_memory_pressure;
>> +       prot->memory_allocated          = memory_allocated_tcp;
>> +       prot->prot_mem                  = tcp_sysctl_mem;
>> +       prot->sockets_allocated         = sockets_allocated_tcp;
>> +       prot->memory_pressure           = memory_pressure_tcp;
>> +
>> +       return 0;
>> +}
>
>
>> +void tcp_destroy_cgroup_fill(struct proto *prot, struct cgroup *cgrp,
>> +                            struct cgroup_subsys *ss)
>> +{
>> +       prot->enter_memory_pressure     = tcp_enter_memory_pressure_nocg;
>> +       prot->memory_allocated          = memory_allocated_tcp_nocg;
>> +       prot->prot_mem                  = tcp_sysctl_mem_nocg;
>> +       prot->sockets_allocated         = sockets_allocated_tcp_nocg;
>> +       prot->memory_pressure           = memory_pressure_tcp_nocg;
>>
>
>> @@ -2220,12 +2220,16 @@ struct proto tcpv6_prot = {
>>        .hash                   = tcp_v6_hash,
>>        .unhash                 = inet_unhash,
>>        .get_port               = inet_csk_get_port
>> +       .enter_memory_pressure  = tcp_enter_memory_pressure_nocg,
>> +       .sockets_allocated      = sockets_allocated_tcp_nocg,
>> +       .memory_allocated       = memory_allocated_tcp_nocg,
>> +       .memory_pressure        = memory_pressure_tcp_nocg,

