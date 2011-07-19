Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1GSKWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:22:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:44644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1GSKWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 06:22:13 -0400
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
In-Reply-To: <20110719144451.79bc69ab@kryten>
References: <20110707102107.GA16666@in.ibm.com>
	 <1310036375.3282.509.camel@twins> <20110714103418.7ef25b68@kryten>
	 <20110714143521.5fe4fab6@kryten> <1310649379.2586.273.camel@twins>
	 <20110715104547.29c3c509@kryten> <1311024956.2309.22.camel@laptop>
	 <20110719144451.79bc69ab@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Jul 2011 12:21:34 +0200
Message-ID: <1311070894.13765.180.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 14:44 +1000, Anton Blanchard wrote:
> 
> Our node distances are a bit arbitrary (I make them up based on
> information given to us in the device tree). In terms of memory we have
> a maximum of three levels. To give some gross estimates, on chip memory
> might be 30GB/sec, on node memory 10-15GB/sec and off node memory
> 5GB/sec.
> 
> The only thing we tweak with node distances is to make sure we go into
> node reclaim before going off node:
> 
> /*
>  * Before going off node we want the VM to try and reclaim from the local
>  * node. It does this if the remote distance is larger than RECLAIM_DISTANCE.
>  * With the default REMOTE_DISTANCE of 20 and the default RECLAIM_DISTANCE of
>  * 20, we never reclaim and go off node straight away.
>  *
>  * To fix this we choose a smaller value of RECLAIM_DISTANCE.
>  */
> #define RECLAIM_DISTANCE 10

> node distances:
> node   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31 
>   0:  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   1:  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   2:  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   3:  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   4:  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   5:  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   6:  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   7:  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   8:  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>   9:  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  10:  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  11:  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  12:  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  13:  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  14:  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  15:  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
>  16:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40   0   0   0   0 
>  17:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40   0   0   0   0 
>  18:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40   0   0   0   0 
>  19:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40   0   0   0   0 
>  20:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40   0   0   0   0 
>  21:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40   0   0   0   0 
>  22:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40   0   0   0   0 
>  23:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40   0   0   0   0 
>  24:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
>  25:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
>  26:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
>  27:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
>  28:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20   0   0   0   0 
>  29:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20   0   0   0   0 
>  30:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20   0   0   0   0 
>  31:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10   0   0   0   0 


That looks very strange indeed.. up to node 23 there is the normal
symmetric matrix with all the trace elements on 10 (as we would expect
for local access), and some 4x4 sub-matrix stacked around the trace with
20, suggesting a single hop distance, and the rest on 40 being
out-there.

But row 24-27 and column 28-31 are way weird, how can that ever be?
Aren't the inter-connects symmetric and thus mandating a fully symmetric
matrix? That is, how can traffic from node 23 (row) to node 28 (column)
have inf bandwidth (0) yet traffic from node 28 (row) to node 23
(column) have a multi-hop distance of 40.

So the idea I had to generate numa sched domains from the node distance
( http://marc.info/?l=linux-kernel&m=130218515520540 ), would that still
work for you? [it does assume a symmetric matrix ]
