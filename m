Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2HDQeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:34:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58458 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2HDQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:34:48 -0400
Subject: Re: TCP Delayed ACK in FIN/ACK
From: Eric Dumazet <eric.dumazet@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: =?UTF-8?Q?S=C5=82awek?= Janecki <janecki@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <CAFLxGvxqj+-rf5twsMPk-pRQqzqsK8-MSsKaez9cwarPmyEqzw@mail.gmail.com>
References: <CACS4u_zUF9T0rSsndhyVzgaauOBFJ4LTUeb432B1zg_oLHvTsg@mail.gmail.com>
	 <CAFLxGvxqj+-rf5twsMPk-pRQqzqsK8-MSsKaez9cwarPmyEqzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Aug 2012 18:34:43 +0200
Message-ID: <1344098083.9299.1503.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-04 at 16:51 +0200, richard -rw- weinberger wrote:
> On Sat, Aug 4, 2012 at 4:45 PM, Sławek Janecki <janecki@gmail.com> wrote:
> > I have a node.js client (10.177.62.7) requesting some data from http
> > rest service from server (10.177.0.1).
> > Client is simply using nodejs http.request() method (agent=false).
> > Client is on Ubuntu 11.10 box.
> > Why client sends FIN ACK after 475ms? Why so slow? He should send FIN
> > ACK immediately.
> > I have many situations like this. About 1% of whole traffic is request
> > with delayed FIN ACK.
> > Cpu idle on the client is about 99%, so nothing is draining CPU.
> > How to debug this? What could it be? Is there any sysctl option I need to tune?
> > I think this behaviour is the Delayed ACK feature of RFC1122 TCP stack.
> >
> > Link to tcpdump picture (done on a client machine) :
> > http://i48.tinypic.com/35cpogx.png
> >
> > Can you tell why kernel delayed that FIN/ACK.
> > In tcpflow data there is exacly one ACK per packet comming from server.
> > Why kernel delayed client FIN/ACK.
> > It could avoid sending ACK every 'data' packet.
> > But it choose to delay FIN/ACK?
> > Is this possible? Is this a bug?
> >
> > I've also posted question on stackexchange:
> > http://stackoverflow.com/questions/11711218/client-sends-delayed-fin-ack-500ms-to-server
> >
> > Please help.
> 
> CC'ing netdev.
> 

I see nothing wrong in this tcpdump. You should strace the application
instead.

FIN/ACK is sent when client closes its socket (or calls shutdown()), and
not in reply of FIN sent by the server.

Kernel has no additional delay. I suspect your client is slow processing
the server answer, then close() its socket _after_ data processing.

Its possible tcp_send_fin() has to loop while allocating one skb under
very high memory pressure, and it seems we have no counters for this
case. But if it _was_ ever happening, you would have lot of messages in
kernel log (dmesg) about alloc_skb_clone() failures.



