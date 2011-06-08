Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1FHVpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:45:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1FHVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:45:44 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110608205253.GA10669@elte.hu>
References: <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>
	 <4DED0292.1040605@die-jansens.de> <4DED0423.4050904@die-jansens.de>
	 <20110606170725.GD2391@elte.hu> <1307380311.2322.223.camel@twins>
	 <1307548218.3941.6.camel@twins> <20110608191758.GA12457@elte.hu>
	 <1307562329.3941.21.camel@twins>  <20110608205253.GA10669@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 23:49:18 +0200
Message-ID: <1307569758.2497.1012.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 22:52 +0200, Ingo Molnar wrote:
> Hm, i thought it would be possible to only express it via the 
> slowpath: if mutex_trylock() succeeds then *all* execution goes into 
> the slowpath so we don't have to take all the fastpaths into account.

Right, but you first have to take wait_lock, then do the trylock, but
that's complicated for asm/mutex-null.h because trylock will then also
try to obtain the wait_lock.

You can do it by creating ___mutex_trylock_slowpath() which contains the
meat of __mutex_trylock_slowpath() and then implement
atomic_mutex_trylock{_irq,_irqsave,} using that, not releasing wait_lock
on success.

Shouldn't be too bad, but it ain't too pretty either.

Furthermore, like I said in my initial patch, I share Thomas' worry
about 'creative' usage of these primitives.

