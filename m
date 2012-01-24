Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2AXOJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:09:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38780 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597Ab2AXOJo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:09:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAC=NXX3jdCAjmwTjQ-d43DWb-617a33nMcWb_UvBUyB_q7VZTQ@mail.gmail.com>
References: <CAC=NXX3jdCAjmwTjQ-d43DWb-617a33nMcWb_UvBUyB_q7VZTQ@mail.gmail.com>
Date: Tue, 24 Jan 2012 22:09:43 +0800
Message-ID: <CAC=NXX2NLsChhuY5_Bv3HJ4fvnq7XpM7UksPS80uaZgGsJnfVw@mail.gmail.com>
Subject: Re: How to accelerate tcp retransmition
From: leno soff <lnxuff@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 4:58 PM, leno soff <lnxuff@gmail.com> wrote:
> Hello everyone,
>   I have a lot of client, say C1, C2, .. Cn, which route packets to
> my servers through router R. But R will drop 70% - 90% _ non-SYN _
> packets from clients to Server.
>
>  The clients and server work like http client and server, sending a
> request, wating for the response.
>
>  When router R drop the request-like packets(without SYN flag, of
> cause), the clients retransmit with icsk_backoff++;  They usually
> should wait 15 seconds+ (1+2+4+8), and sometimes more or just timeout.
>
>   So, my question is:
>
>        Is there any way in _server_ side, to accelerate the
> retransmition like accelerating slow-start. I tried SO_KEEPALIVE in
> server, interval == 1 second or less,  I assume the keepalive ack will
>  accelerate the retransmition, ,  but it does not work:
>
>       Flags [P.], seq 1:314, ack 1.  ----------------client request,
> which is lost
>       Flags [.], ack 1, win 905, length 0  --- server keepalive ack
>       Flags [.], ack 1, win 115, length 0  --- client responds ack
>       .... A lot keepalive and response.
>
>    The client timeout because of RTO, why doesn't retransmit the
> request packet but just an ack without data when it sees keepalive ack
> ?
>
>
> Thanks.


After 3-way shakehands,  Client sends 9 bytes(I make sure it is
DROPPED by router),
I modify the server-side kernel, set keepalive timer interval = 100ms
to accelerate retransmiting 3+ DUP ACKS which makes sure the client
will not timeout.
I run 'ss -en|grep 8888' in client side, it shows the retransmition
timer exp-increasing which is not expected for me. I assume it will
retransimit after receiving 3+ DUP ACKS.
And below is the packets flow.
I think it is not the right way to solve this Bad-Router problem, but
it is the only method I know which failed.

In one word, I don't want the client timeout.

Any  suggestion is helpful
Thanks


21:41:17.586310 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[.], ack 1, win 115, options [nop,nop,TS val 38962812 ecr 12647162],
length 0
21:41:17.680113 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[P.], seq 1:9, ack 1, win 115, options [nop,nop,TS val 38962906 ecr
12647162], length 8
21:41:17.687612 IP 199.192.156.23.8888 > 192.168.10.22.49538: Flags
[.], ack 1, win 905, options [nop,nop,TS val 12673575 ecr 38962367],
length 0
21:41:17.687635 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[.], ack 1, win 115, options [nop,nop,TS val 38962913 ecr 12647162],
length 0
 --------- a lot keepalive here interval=100ms ------
21:41:18.418845 IP 199.192.156.23.8888 > 192.168.10.22.49538: Flags
[.], ack 1, win 905, options [nop,nop,TS val 12674313 ecr 38962367],
length 0
21:41:18.418862 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[.], ack 1, win 115, options [nop,nop,TS val 38963644 ecr 12647162],
length 0
21:41:18.427900 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[P.], seq 1:9, ack 1, win 115, options [nop,nop,TS val 38963654 ecr
12647162], length 8
21:41:18.520310 IP 199.192.156.23.8888 > 192.168.10.22.49538: Flags
[.], ack 1, win 905, options [nop,nop,TS val 12674413 ecr 38962367],
length 0
21:41:18.520332 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[.], ack 1, win 115, options [nop,nop,TS val 38963746 ecr 12647162],
length 0
-----------  a lot keepalive here too ----------
21:41:19.877055 IP 199.192.156.23.8888 > 192.168.10.22.49538: Flags
[.], ack 1, win 905, options [nop,nop,TS val 12675771 ecr 38962367],
length 0
21:41:19.877082 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[.], ack 1, win 115, options [nop,nop,TS val 38965103 ecr 12647162],
length 0
21:41:19.925886 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[P.], seq 1:9, ack 1, win 115, options [nop,nop,TS val 38965152 ecr
12647162], length 8
21:41:19.975419 IP 199.192.156.23.8888 > 192.168.10.22.49538: Flags
[.], ack 1, win 905, options [nop,nop,TS val 12675871 ecr 38962367],
length 0
21:41:19.975446 IP 192.168.10.22.49538 > 199.192.156.23.8888: Flags
[.], ack 1, win 115, options [nop,nop,TS val 38965201 ecr 12647162],
length 0
