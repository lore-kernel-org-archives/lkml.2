Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab2KAKHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:07:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44140 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab2KAKHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:07:12 -0400
Message-ID: <509249C7.3080000@gmail.com>
Date: Thu, 01 Nov 2012 18:07:03 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
References: <50910A04.5000003@gmail.com> <0000013ab7e86f8a-4adb8b81-19be-4264-96f1-924aaf3819f2-000000@email.amazonses.com>
In-Reply-To: <0000013ab7e86f8a-4adb8b81-19be-4264-96f1-924aaf3819f2-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter said, at 2012/11/1 1:39:
> On Wed, 31 Oct 2012, Shan Wei wrote:
> 
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -208,7 +208,7 @@ void ovs_dp_process_received_packet(struct vport *p, struct sk_buff *skb)
>>  	int error;
>>  	int key_len;
>>
>> -	stats = per_cpu_ptr(dp->stats_percpu, smp_processor_id());
>> +	stats = this_cpu_ptr(dp->stats_percpu);
> 
> Well this is an improvement and may be ok if the preemption is disabled at
> this point. There is another possibility here to use this_cpu_read/add/inc
> instead of determining the pointer to the local cpu first and then
> performing operations on the fields. The pointer relocation with
> this_cpu_xxx ops is implicit in the instructions and safe against changing
> of processors. It would also save us the determination of a pointer to the
> current cpus stats structure.

yes, this_cpu_ptr just locate the point to current cpu per-cpu data domain.
and then operating [read/write/inc/sub] fields of this per-cpu variable
maybe on other cpu because task is rescheduled for preemption, interrupt.

But for different field in same per-cpu variable, how to guarantee n_missed
and n_hit are from same cpu? 
this_cpu_read(dp->stats_percpu->n_missed);
[processor changed]
this_cpu_read(dp->stats_percpu->n_hit);


In addition, following usage of per_cpu_ptr can be replaced by this_cpu_read.

cpu=get_cpu()
....
*per_cpu_ptr(p,cpu)
....
....
put_cpu()

