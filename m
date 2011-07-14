Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1GNAeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:34:21 -0400
Received: from ozlabs.org ([203.10.76.45]:57641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1GNAeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:34:20 -0400
Date: Thu, 14 Jul 2011 10:34:18 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110714103418.7ef25b68@kryten>
In-Reply-To: <1310036375.3282.509.camel@twins>
References: <20110707102107.GA16666@in.ibm.com>
	<1310036375.3282.509.camel@twins>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

> Surely this isn't the first multi-node P7 to boot a kernel with this
> patch? If my git foo is any good it hit -next on 23rd of May.
> 
> I guess I'm asking is, do smaller P7 machines boot? And if so, is
> there any difference except size?
> 
> How many nodes does the thing have anyway, 28? Hmm, that could mean
> its the first machine with >16 nodes to boot this, which would make it
> trigger the magic ALL_NODES crap.

We haven't tested a box with more than 16 nodes in quite a while, so it
may be this.

I took a quick look and we are stuck in update_group_power:

        do {
                power += group->cpu_power;
                group = group->next;
        } while (group != child->groups);

I looked at the linked list:

child->groups = c000007b2f74ff00

and dumping group as we go:

c000007b2f74ff00 c000007b2f760000 c000007b2fb60000 c000007b2ff60000

at this point we end up in a cycle and never make it back to
child->groups:

c000008b2e68ff00 c000008b2e6a0000 c000008b2eaa0000 c000008b2eea0000
c000009aee77ff00 c000009aee790000 c000009aeeb90000 c000009aeef90000
c00000bafde91800 c00000dafdf81800 c00000fafce81800 c000011afdf71800
c00001226e70ff00 c00001226e720000 c00001226eb20000 c00001226ef20000
c000008b2e68ff00

Still investigating

Anton

