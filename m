Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1BPWat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:30:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60135 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1BPWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:30:45 -0500
Message-ID: <4D5C4FD7.5070603@kernel.org>
Date: Wed, 16 Feb 2011 14:29:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: seperate alloc_numa_distance from numa_reset_distance.
References: <4D5C3A0F.3080107@kernel.org> <4D5C3A40.1060106@kernel.org> <4D5C4538.7060403@gmail.com>
In-Reply-To: <4D5C4538.7060403@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0202.4D5C4FFD.0059,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 01:44 PM, Cyrill Gorcunov wrote:
> On 02/16/2011 11:57 PM, Yinghai Lu wrote:
>>
>> alloc code is much bigger the setting self.
>>
> ...
>> +
>> +    numa_distance = __va(phys);
>> +    numa_distance_cnt = cnt;
>> +
>> +    /* fill with the default distances */
>> +    for (i = 0; i<  cnt; i++)
>> +        for (j = 0; j<  cnt; j++)
>> +            numa_distance[i * cnt + j] = i == j ?
>> +                LOCAL_DISTANCE : REMOTE_DISTANCE;
>> +    printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n",
>> cnt);
>> +}
>> +
> 
>   Hi Yinghai, btw would it be convenient to use node_distance() helper here
> (since this snippet is touched anyway and there is a big merging of numa
>  code), ie
> 
>     /* fill with the default distances */
>     for (i = 0; i < cnt; i++)
>         for (j = 0; j <  cnt; j++)
>             numa_distance[i * cnt + j] = node_distance(i, j);
>     
> though it should be patch on top of yours to not mix with plain code move

do you mean

int __node_distance(int from, int to)
{
        if (from >= numa_distance_cnt || to >= numa_distance_cnt)
                return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
        return numa_distance[from * numa_distance_cnt + to];
}
EXPORT_SYMBOL(__node_distance);

or node_distance()?

then you will have 

 numa_distance[i * cnt + j] =  numa_distance[i * cnt + j];

...
