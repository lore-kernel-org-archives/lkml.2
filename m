Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0ESNWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ESNWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:22:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100517232052.GB30847@google.com>
References: <20100517232052.GB30847@google.com> <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-8-git-send-email-walken@google.com> <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org> <20100517231331.GA30847@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 07/10] generic rwsem: implement down_read_critical() / up_read_critical()
Date: Wed, 19 May 2010 14:21:23 +0100
Message-ID: <32068.1274275283@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> +void __sched down_read_critical(struct rw_semaphore *sem)
> +{
> +	might_sleep();
> +	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
> +
> +	LOCK_CONTENDED(sem, __down_read_trylock, __down_read_unfair);
> +
> +	preempt_disable();

Shouldn't preemption really be disabled before __down_read_unfair() is called?
Otherwise you can get an unfair read on a sem and immediately get taken off
the CPU.  Of course, this means __down_read_unfair() would have to deal with
that in the slow path:-/

Oh, and something else that occurs to me:  Do unfair readers have to go at the
front of the wakeup queue?  Can they be slightly less unfair and go either
before the first reader in the queue or at the back of the queue instead?

David
