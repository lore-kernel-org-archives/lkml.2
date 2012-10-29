Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab2J2LYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:24:55 -0400
Received: from servizi.voixit.com ([78.46.247.94]:35028 "EHLO
	servizi.voixit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab2J2LYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:24:54 -0400
Message-ID: <508E6783.2080403@unimore.it>
Date: Mon, 29 Oct 2012 12:24:51 +0100
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: jhs@mojatatu.com, davem@davemloft.net, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH RFC] pkt_sched: enable QFQ to support TSO/GSO
References: <20121029085106.GA3733@paolo-ThinkPad-W520> <508E63AD.20803@gmail.com>
In-Reply-To: <508E63AD.20803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/10/2012 12:08, Cong Wang ha scritto:
> On 10/29/2012 04:51 PM, Paolo Valente wrote:
>> Hi,
>> if the max packet size for some class (configured through tc) is
>> violated by the actual size of the packets of that class, then QFQ
>> would not schedule classes correctly, and the data structures
>> implementing the bucket lists may get corrupted. This problem occurs
>> with TSO/GSO even if the max packet size is set to the MTU, and is,
>> e.g., the cause of the failure reported in [1]. Two patches have been
>> proposed to solve this problem in [2], one of them is a preliminary
>> version of this patch.
>>
>> This patch addresses the above issues by: 1) setting QFQ parameters to
>> proper values for supporting TSO/GSO (in particular, setting the
>> maximum possible packet size to 64KB), 2) automatically increasing the
>> max packet size for a class, lmax, when a packet with a larger size
>> than the current value of lmax arrives (a notification is also appended
>> to the log).
>>
>> The drawback of the first point is that the maximum weight for a class
>> is now limited to 4096, which is equal to 1/16 of the maximum weight
>> sum.
>>
>> Finally, this patch also forcibly caps the timestamps of a class if
>> they are too high to be stored in the bucket list. This capping, taken
>> from QFQ+ [3], handles the unfrequent case described in the comment to
>> the function slot_insert.
>>
>> [1] http://marc.info/?l=linux-netdev&m=134968777902077&w=2
>> [2] http://marc.info/?l=linux-netdev&m=135096573507936&w=2
>> [3] http://marc.info/?l=linux-netdev&m=134902691421670&w=2
>>
>> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
>
>
> Please respect people who helps you to test it:
>
> Tested-by: Cong Wang <amwang@redhat.com>
Oops, really sorry about that. I did not mean to hide your contribution. 
I am just not familiar with the process.
>
> I tested it again just in case...
Thanks again
>
> By the way, one nit below:
>
>
>> +    if (unlikely(cl->lmax < qdisc_pkt_len(skb))) {
>> +        pr_notice("qfq: increasing maxpkt from %u to %u for class %u",
>> +              cl->lmax, qdisc_pkt_len(skb), cl->common.classid);
>> +        qfq_update_reactivate_class(q, cl, cl->inv_w,
>> +                        qdisc_pkt_len(skb), 0);
>> +    }
>
>
> Seems the log level KERN_NOTICE is overkill, normal users don't care
> about these information, so s/pr_notice/pr_debug/.
>
Thanks, I will integrate this and possible other suggestions in a new 
version of the patch.
>
> Thanks!
>
>


-- 
-----------------------------------------------------------
| Paolo Valente              |                            |
| Algogroup                  |                            |
| Dip. Ing. Informazione     | tel:   +39 059 2056318     |
| Via Vignolese 905/b        | fax:   +39 059 2056129     |
| 41125 Modena - Italy       |                            |
|     home:  http://algo.ing.unimo.it/people/paolo/       |
-----------------------------------------------------------
