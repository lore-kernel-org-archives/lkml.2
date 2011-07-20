Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1GTCDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 22:03:34 -0400
Received: from ozlabs.org ([203.10.76.45]:34804 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1GTCDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 22:03:33 -0400
Date: Wed, 20 Jul 2011 12:03:26 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110720120326.093d9045@kryten>
In-Reply-To: <1311070894.13765.180.camel@twins>
References: <20110707102107.GA16666@in.ibm.com>
	<1310036375.3282.509.camel@twins>
	<20110714103418.7ef25b68@kryten>
	<20110714143521.5fe4fab6@kryten>
	<1310649379.2586.273.camel@twins>
	<20110715104547.29c3c509@kryten>
	<1311024956.2309.22.camel@laptop>
	<20110719144451.79bc69ab@kryten>
	<1311070894.13765.180.camel@twins>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> That looks very strange indeed.. up to node 23 there is the normal
> symmetric matrix with all the trace elements on 10 (as we would expect
> for local access), and some 4x4 sub-matrix stacked around the trace
> with 20, suggesting a single hop distance, and the rest on 40 being
> out-there.
> 
> But row 24-27 and column 28-31 are way weird, how can that ever be?
> Aren't the inter-connects symmetric and thus mandating a fully
> symmetric matrix? That is, how can traffic from node 23 (row) to node
> 28 (column) have inf bandwidth (0) yet traffic from node 28 (row) to
> node 23 (column) have a multi-hop distance of 40.

Good point, it definitely makes no sense. It looks like a bug in
numactl, the raw data looks reasonable:

# cat /sys/devices/system/node/node?/distance node??/distance
10 20 20 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
20 10 20 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
20 20 10 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
20 20 20 10 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 10 20 20 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 20 10 20 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 20 20 10 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 20 20 20 10 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 10 20 20 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 20 10 20 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 20 20 10 20 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 20 20 20 10 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 10 20 20 20 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 20 10 20 20 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 20 20 10 20 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 20 20 20 10 40 40 40 40 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 10 20 20 20 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 10 20 20 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 20 10 20 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 20 20 10 40 40 40 40 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 10 20 20 20 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 10 20 20 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 20 10 20 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 20 20 10 40 40 40 40
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 10 20 20 20
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 10 20 20
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 20 10 20
40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 20 20 20 10

Yet another bug to track down :(

> So the idea I had to generate numa sched domains from the node
> distance ( http://marc.info/?l=linux-kernel&m=130218515520540 ),
> would that still work for you? [it does assume a symmetric matrix ]

It should work for us and it makes our NUMA memory and scheduler
domains more consistent. Nice!

Anton
