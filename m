Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1GSEo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:44:56 -0400
Received: from ozlabs.org ([203.10.76.45]:52354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1GSEoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:44:55 -0400
Date: Tue, 19 Jul 2011 14:44:51 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110719144451.79bc69ab@kryten>
In-Reply-To: <1311024956.2309.22.camel@laptop>
References: <20110707102107.GA16666@in.ibm.com>
	<1310036375.3282.509.camel@twins>
	<20110714103418.7ef25b68@kryten>
	<20110714143521.5fe4fab6@kryten>
	<1310649379.2586.273.camel@twins>
	<20110715104547.29c3c509@kryten>
	<1311024956.2309.22.camel@laptop>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 23:35:56 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Anton, could you test the below two patches on that machine?
> 
> It should make things boot again, while I don't have a machine nearly
> big enough to trigger any of this, I tested the new code paths by
> setting FORCE_SD_OVERLAP in /debug/sched_features. Although any review
> of the error paths would be much appreciated.

I get an oops in slub code:

NIP [c000000000197d30] .deactivate_slab+0x1b0/0x200
LR [c000000000199d94] .__slab_alloc+0xb4/0x5a0
[c000000000199d94] .__slab_alloc+0xb4/0x5a0
[c00000000019ac98] .kmem_cache_alloc_node_trace+0xa8/0x260
[c00000000007eb70] .build_sched_domains+0xa60/0xb90
[c000000000a16a98] .sched_init_smp+0xa8/0x228
[c000000000a00274] .kernel_init+0x10c/0x1fc
[c00000000002324c] .kernel_thread+0x54/0x70

I'm guessing it's a result of some nodes not having any local memory.
but a bit surprised I'm not seeing it elsewhere.

Investigating.

> Also, could you send me the node_distance table for that machine? I'm
> curious what the interconnects look like on that thing.

Our node distances are a bit arbitrary (I make them up based on
information given to us in the device tree). In terms of memory we have
a maximum of three levels. To give some gross estimates, on chip memory
might be 30GB/sec, on node memory 10-15GB/sec and off node memory
5GB/sec.

The only thing we tweak with node distances is to make sure we go into
node reclaim before going off node:

/*
 * Before going off node we want the VM to try and reclaim from the local
 * node. It does this if the remote distance is larger than RECLAIM_DISTANCE.
 * With the default REMOTE_DISTANCE of 20 and the default RECLAIM_DISTANCE of
 * 20, we never reclaim and go off node straight away.
 *
 * To fix this we choose a smaller value of RECLAIM_DISTANCE.
 */
#define RECLAIM_DISTANCE 10

Anton

node distances:
node   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31 
  0:  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  1:  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  2:  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  3:  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  4:  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  5:  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  6:  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  7:  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  8:  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
  9:  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 10:  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 11:  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 12:  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 13:  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 14:  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 15:  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40  40  40  40  40   0   0   0   0 
 16:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40  40  40  40  40   0   0   0   0 
 17:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40  40  40  40  40   0   0   0   0 
 18:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40  40  40  40  40   0   0   0   0 
 19:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40  40  40  40  40   0   0   0   0 
 20:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20  40  40  40  40   0   0   0   0 
 21:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20  40  40  40  40   0   0   0   0 
 22:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20  40  40  40  40   0   0   0   0 
 23:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10  40  40  40  40   0   0   0   0 
 24:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
 25:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
 26:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
 27:   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
 28:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  10  20  20  20   0   0   0   0 
 29:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  10  20  20   0   0   0   0 
 30:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  10  20   0   0   0   0 
 31:  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  40  20  20  20  10   0   0   0   0 

