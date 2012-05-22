Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab2EVP0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:26:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:38670 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2EVP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:26:41 -0400
Date: Tue, 22 May 2012 17:26:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
In-Reply-To: <1337090625.14207.304.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1205221553400.3231@ionos>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Steven Rostedt wrote:
> +struct rw_semaphore {
> +	int			initialized;
> +	struct __rw_semaphore	lock[NR_CPUS];

So that will blow up every rw_semaphore user by

   NR_CPUS * sizeof(struct __rw_semaphore)

With lockdep off thats: NR_CPUS * 48

With lockdep on thats:  NR_CPUS * 128 + NR_CPUS * 8 (__key)

So for NR_CPUS=64 that's 3072 or 8704 Bytes.

That'll make e.g. XFS happy. xfs_inode has two rw_sems.

sizeof(xfs_inode) in mainline is:  856 bytes

sizeof(xfs_inode) on RT is:       1028 bytes

But with your change it would goto (NR_CPUS = 64):

    1028 - 96 + 2 * 3072 =        7076 bytes

That's almost an order of magnitude!

NFS has an rwsem in the inode as well, and ext4 has two.

So we trade massive memory waste for how much performance? 

We really need numbers for various scenarios. There are applications
which are pretty mmap heavy and it would really surprise me when
taking NR_CPUS locks in one go is not going to cause a massive
overhead.

Thanks,

	tglx
