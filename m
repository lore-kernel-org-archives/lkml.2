Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1FHV5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:57:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:43740 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1FHV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:57:18 -0400
Date: Wed, 8 Jun 2011 23:57:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
In-Reply-To: <1307569758.2497.1012.camel@laptop>
Message-ID: <alpine.LFD.2.02.1106082347050.11814@ionos>
References: <20110606160810.GA16636@elte.hu>  <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>  <4DED0292.1040605@die-jansens.de> <4DED0423.4050904@die-jansens.de>  <20110606170725.GD2391@elte.hu> <1307380311.2322.223.camel@twins> 
 <1307548218.3941.6.camel@twins> <20110608191758.GA12457@elte.hu>  <1307562329.3941.21.camel@twins>  <20110608205253.GA10669@elte.hu> <1307569758.2497.1012.camel@laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Peter Zijlstra wrote:

> On Wed, 2011-06-08 at 22:52 +0200, Ingo Molnar wrote:
> > Hm, i thought it would be possible to only express it via the 
> > slowpath: if mutex_trylock() succeeds then *all* execution goes into 
> > the slowpath so we don't have to take all the fastpaths into account.
> 
> Right, but you first have to take wait_lock, then do the trylock, but
> that's complicated for asm/mutex-null.h because trylock will then also
> try to obtain the wait_lock.
> 
> You can do it by creating ___mutex_trylock_slowpath() which contains the
> meat of __mutex_trylock_slowpath() and then implement
> atomic_mutex_trylock{_irq,_irqsave,} using that, not releasing wait_lock
> on success.
> 
> Shouldn't be too bad, but it ain't too pretty either.
> 
> Furthermore, like I said in my initial patch, I share Thomas' worry
> about 'creative' usage of these primitives.

We are way better off with the semaphore abuse confined to printk.c.

A mutex would give us lockdep coverage, but due to the strict owner
semantics - which we have already proven in -rt by converting it to a
mutex - we can annotate console_sem lockdep wise and still keep the
nifty semaphore abuse.

Further I don't have any worries about -rt either as a RT task using
printf is doomed anyway and we should not encourage that by making it
somehow more deterministic.

Thanks,

	tglx
