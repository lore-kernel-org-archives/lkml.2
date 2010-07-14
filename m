Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0GNWiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:38:10 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:38484 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083Ab0GNWiI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:38:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Fl67jaUMc8BnzdVo4dxdjEhSQLRHHMQDAjvfJk3EVSDvgUa/86yvirhImAy5468+;
  h=Received:Subject:Mime-Version:Content-Type:From:In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:To:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Subject: Re: Raise initial congestion window size / speedup slow start?
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Mitchell Erblich <erblichs@earthlink.net>
In-Reply-To: <20100714121040.4a674511@nehalam>
Date: Wed, 14 Jul 2010 14:47:51 -0700
Cc: Ed W <lists@wildgooses.com>, David Miller <davem@davemloft.net>,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8AD78D83-C54E-47DA-9D10-8C2CA59F91CF@earthlink.net>
References: <4C3D94E3.9080103@wildgooses.com> <4C3DD5EB.9070908@tmr.com> <20100714.111553.104052157.davem@davemloft.net> <4C3E0684.5060409@wildgooses.com> <20100714121040.4a674511@nehalam>
To: Stephen Hemminger <shemminger@vyatta.com>
X-Mailer: Apple Mail (2.1081)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79f293cc996e17eaaa3f2aadd0d42effc2350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 4.246.232.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 14, 2010, at 12:10 PM, Stephen Hemminger wrote:

> On Wed, 14 Jul 2010 19:48:36 +0100
> Ed W <lists@wildgooses.com> wrote:
> 
>> On 14/07/2010 19:15, David Miller wrote:
>>> From: Bill Davidsen<davidsen@tmr.com>
>>> Date: Wed, 14 Jul 2010 11:21:15 -0400
>>> 
>>> 
>>>> You may have to go into /proc/sys/net/core and crank up the
>>>> rmem_* settings, depending on your distribution.
>>>> 
>>> You should never, ever, have to touch the various networking sysctl
>>> values to get good performance in any normal setup.  If you do, it's a
>>> bug, report it so we can fix it.
>>> 
>> 
>> Just checking the basics here because I don't think this is a bug so 
>> much as a, less common installation that differs from the "normal" case.
>> 
>> - When we create a tcp connection we always start with tcp slow start
>> - This sets the congestion window to effectively 4 packets?
>> - This applies in both directions?
>> - Remote sender responds to my hypothetical http request with the first 
>> 4 packets of data
>> - We need to wait one RTT for the ack to come back and now we can send 
>> the next 8 packets,
>> - Wait for the next ack and at 16 packets we are now moving at a 
>> sensible fraction of the bandwidth delay product?
>> 
>> So just to be clear:
>> - We don't seem to have any user-space tuning knobs to influence this 
>> right now?
>> - In this age of short attention spans, a couple of extra seconds 
>> between clicking something and it responding is worth optimising (IMHO)
>> - I think I need to take this to netdev, but anyone else with any ideas 
>> happy to hear them?
>> 
>> Thanks
>> 
>> Ed W
> 
> TCP slow start is required by the RFC. It is there to prevent a TCP congestion
> collapse. The HTTP problem is exacerbated by things beyond the user's control:
>  1. stupid server software that dribbles out data and doesn't used the full
>    payload of the packets
>  2. web pages with data from multiple sources (ads especially), each of which
>    requires a new connection
>  3. pages with huge graphics.
> 
> Most of this is because of sites that haven't figured out that somebody on a phone
> across the globl might not have the same RTT and bandwidth that the developer on a
> local network that created them.  Changing the initial cwnd isn't going to fix it.
> --

IMO, in theory  one of the RFCs state a window with 4 ETH MTU (~6k window)
size packets/segment to allow a fast retransmit if a pkt is dropped.

I thought their is a fast-rexmit knob of 2 or 3 DUPACKs, for faster loss recovery.
Theorecticly it could be set to 1 DUPACK for lossey environments.

Now, the orig slow-start doubles the number of pkts per RTT assuming no loss,
which is a faster ramp up vs the orig congestion avoidance.

Now, with IPv4 with a default of 576 sized segments, without invalidating
the amount of data, 12 pkts could be sent. This would be helpful if your
app only generates smaller buffers,  gets more ACKs in return which sets
the ACK clocking at a faster rate. To compensate for the smaller pkt, the ABC
Experimental  RFC does byte counting to suggest fairness.

During a few round trips, the pkt size could be increased to the 1.5k ETH MTU
and hopefully to even a 9k Jumbo, probing with one increasing sized pkt.
(?to prevent rexmit of the too large pkt, overlap the increasing pkt with the next
one?)

Mitchell Erblich

> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

