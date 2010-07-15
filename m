Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab0GOMza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 08:55:30 -0400
Received: from mail-i4.nets.RWTH-Aachen.DE ([137.226.12.21]:44298 "EHLO
	MAIL-i4.nets.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933120Ab0GOMz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 08:55:29 -0400
Message-ID: <4C3F053F.7090704@nets.rwth-aachen.de>
Date: Thu, 15 Jul 2010 14:55:27 +0200
From: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: =?UTF-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
References: <4C358AAA.9080400@kernel.org> <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi> <4C3EF7EA.2040900@nets.rwth-aachen.de> <1279195528.2496.2.camel@edumazet-laptop>
In-Reply-To: <1279195528.2496.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since tcp_xmit_retransmit_queue also gets skb == NULL I'm pretty sure it 
is the same bug.
Up to now I only experienced the problem with ACK loss (without ACK loss 
the test ran about 30min without problems, with ACK loss it had paniced 
within 10min).
The data sender only has a HTB queue for traffic shaping (set to 20 
Mbit/s). The ACK loss is done by another router.
The setup looks like this. This way it seems to be the most realistic.

o sender with HTB
|
|
o netem queue for forward path delay
|
o netem queue for a queue limit
|
o netem queue for backward path delay
|
o netem queue for ACK loss
|
|
o receiver with HTB

Perhaps now it is a little big clearer.


On 15.07.2010 14:05, Eric Dumazet wrote:
> Le jeudi 15 juillet 2010 à 13:58 +0200, Lennart Schulte a écrit :
>    
>> I'm testing new reordering algorithms in a virtual testbed, that is the
>> nodes are emulated with xen and all the network parameters can be tuned
>> with queues.
>> With one of the algorithms I also got tracebacks which include
>> tcp_xmit_retransmit_queue. It only happens with ACK loss. The kernel
>> version however is 2.6.31.
>> When I read this thread I tried the debug patch and got the following:
>>
>> [ 2754.413150] NULL head, pkts 0
>> [ 2754.413156] Errors caught so far 1
>>
>> Hope that is of any help.
>>      
> Not sure I understand.
>
> Are you saying you reproduce same tcp_xmit_retransmit_queue()  bug, with
> a special tc qdisc/class droppping some ACK frames ?
>
> Could it be some sched problem and incorrect return codes in case of
> congestion ?
>    
