Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1KTCGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 21:06:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51078 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1KTCG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 21:06:29 -0500
Date: Sat, 19 Nov 2011 18:06:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH 1/2] NUMA emulation x86_64: numa=fake parameter for custom
 nodes distance
In-Reply-To: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
Message-ID: <alpine.DEB.2.00.1111191800030.25103@chino.kir.corp.google.com>
References: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, Petr Holasek wrote:

> As default, when numa emulation is turned on, node distance table
> uses physical distance, so for 4 nodes emulated on 1 physical table is
> 
> node   0   1   2   3
> 0:  10  10  10  10
> 1:  10  10  10  10
> 2:  10  10  10  10
> 3:  10  10  10  10
> 

That should only be true if you're booting on a system with one physical 
node and an SRAT, otherwise the distance between fake nodes should be 
representative of their physical distance.  For example, if you boot 
with numa=fake=4 on a two symmetrical two-node box, you should get 
something like

	10 10 20 20
	10 10 20 20
	20 20 10 10
	20 20 10 10

It's done like this intentionally so you can test NUMA without having many 
nodes.  What you're doing is changing the distance even though there is no 
actual difference in latency on the hardware so it's an incorrect 
representation.

> This patch adds new [distance] argument to
> 
> numa=fake=<number/size of nodes>[,distance]
> 
> When distance argument is used, it sets linear distance between nodes
> like that:
> 
>     __distance__
> ___|___     ____|___     ________     ________
> |       |   |        |   |        |   |        |
> | node1 |---| node 2 |---| node 3 |---| node 4 |
> |_______|   |________|   |________|   |________|
> |                        |             |
> |                        |             |
> |____distance * 2________|             |
> |                                      |
> |____________distance * 3______________|
> 
> This feature might be useful for testing some numa awareness features in
> both user and kernel spaces.
> 

I don't see any use case for this other than testing if code can actually 
order nodes correctly or not.  The distances that you're now adding are, 
by definition, incorrect since they aren't the same as exported by the 
true SLIT (which is what happens by default now) so nothing other than 
functional testing of node ordering is achieved with this patch.

So nack on this approach.

What you could do, however, and would be generally useful even outside of 
NUMA emulation, is to add fake SLIT functionality so that you can define 
it yourself on the command line.  You could use that either with or 
without NUMA emulation if you know the physical SLIT is incorrect in some 
way.  Then, you get the same functionality as your patch here by using it 
in combination with numa=fake and the added bonus is that you don't need 
any of the "distance * 2" or "distance * 3" limitations.
