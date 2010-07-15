Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab0GORgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:36:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45790 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab0GORgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:36:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=wJUsFxU2ahhSypeYPhB7SOYjvLFFg3lrXm3LBX1MxXsDHvBqdIo2RBNw7VmbKGm76
	E5iaZw0mHw6DunN8FtBVA==
MIME-Version: 1.0
In-Reply-To: <4C3EBD51.80406@wildgooses.com>
References: <4C3D94E3.9080103@wildgooses.com>
	<4C3DD5EB.9070908@tmr.com>
	<20100714.111553.104052157.davem@davemloft.net>
	<4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
	<AANLkTikTyZGQWWIBzYSQWpUK30xxbMXLbJXeHahWnlIi@mail.gmail.com>
	<4C3EBD51.80406@wildgooses.com>
Date: Thu, 15 Jul 2010 10:36:01 -0700
Message-ID: <AANLkTikF0RVNAhJTyA1PJThAbqY7U5Pei13umU6qWfsZ@mail.gmail.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
From: Jerry Chu <hkchu@google.com>
To: Ed W <lists@wildgooses.com>
Cc: Tom Herbert <therbert@google.com>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Rick Jones <rick.jones2@hp.com>, David Miller <davem@davemloft.net>,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Nandita Dukkipati <nanditad@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 12:48 AM, Ed W <lists@wildgooses.com> wrote:
>
> On 15/07/2010 05:12, Tom Herbert wrote:
>>
>> There is an Internet draft
>> (http://datatracker.ietf.org/doc/draft-hkchu-tcpm-initcwnd/) on
>> raising the default Initial Congestion window to 10 segments, as well
>> as a SIGCOMM paper (http://ccr.sigcomm.org/online/?q=node/621).
>>
>
> You guys have obviously done a lot of work on this, however, it seems that there is a case for introducing some heuristics into the choice of init cwnd as well as offering the option to go larger?  An initial size of 10 packets is just another magic number that obviously works with the median bandwidth delay product on today's networks - can we not do better still?
>
> Seems like a bunch of clever folks have already suggested tweaks to the steady stage congestion avoidance, but so far everyone is afraid to touch the early stage heuristics?

This is because there is not enough info for deriving any heuristic.
For initcwnd one is constrained to
only info from 3WHS. This includes a rough estimate of RTT plus all
the bits in the SYN/SYN-ACK
headers. I'm assuming a stateless approach. We've tried a stateful
solution (i.e., seeding initcwnd from
past history) but found its complexity outweigh the gain.
(See http://www.ietf.org/proceedings/77/slides/tcpm-4.pdf)

>
> Also would you guys not benefit from wider deployment of ECN?  Can you not help find some ways that deployment could be increased?  At present there are big warnings all over the option that it causes some problems, but there is no quantification of how much and really whether this warning is still appropriate?

That will add yet another hoop for us to jump over. Also I'm not sure
a couple of bits are sufficient for a
guesstimate of what initcwnd ought to be.

Our reasoning is simple - there has been tremendous b/w growth since
rfc2414 was published. Even the
lowest common denominator (i.e., dialup links) has moved from 9.6Kbps
to 56Kbps. That's a six fold
increase. If you believe initcwnd should grow proportionally to the
buffer sizes in access links, and the
buffer sizes grows proportionally to b/w, then the initcwnd outght to
be 3*6 = 18 today.

We chose a modest increase (10) with the hope to expedite the
standardization process (and would
certainly appreciate helps from folks on this list). 10 is very
conservative considering many deployment
has gone beyond 3, including Linux stack, which allows one additional
pkt if it's the last data pkt.

Longer term it will be nice to find a way to get rid of this fixed,
somewhat arbitrary initcwnd. Mark
Allman's JumpStart is one idea, but it'd be a much longer route.

Jerry

>
> Ed W
>
