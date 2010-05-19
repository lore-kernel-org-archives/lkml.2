Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0ESXrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:47:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab0ESXrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:47:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ew2Wh2P4ZQ2JTT/lMTlBRfWMbWNkULw+nCeSOQCvxhS9vdEBC2coVnESLVGOTsseH
	L7+67O4bc3APYDRHKMJhg==
MIME-Version: 1.0
In-Reply-To: <32068.1274275283@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-8-git-send-email-walken@google.com>
	 <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org>
	 <20100517231331.GA30847@google.com>
	 <20100517232052.GB30847@google.com> <32068.1274275283@redhat.com>
Date: Wed, 19 May 2010 16:47:17 -0700
Message-ID: <AANLkTil9ev-q_uAK9vvA-GJ4LiPoDuKdeZJjAe4bh87K@mail.gmail.com>
Subject: Re: [PATCH 07/10] generic rwsem: implement down_read_critical() / 
	up_read_critical()
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 6:21 AM, David Howells <dhowells@redhat.com> wrote:
> Michel Lespinasse <walken@google.com> wrote:
>
>> +void __sched down_read_critical(struct rw_semaphore *sem)
>> +{
>> +     might_sleep();
>> +     rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
>> +
>> +     LOCK_CONTENDED(sem, __down_read_trylock, __down_read_unfair);
>> +
>> +     preempt_disable();
>
> Shouldn't preemption really be disabled before __down_read_unfair() is called?
> Otherwise you can get an unfair read on a sem and immediately get taken off
> the CPU.  Of course, this means __down_read_unfair() would have to deal with
> that in the slow path:-/

I've asked myself the same question; it is true that we don't fully
prevent ourselves getting preempted while holding the rwsem here.

My understanding is that Linus wants the preempt_disable() mainly to
prevent threads doing voluntary preemption (anything that might_sleep)
while holding the unfairly acquired rwsem;  and also to have people
think twice before adding more down_read_critical() calls.

It wouldn't be difficult to move the preempt_disable() ahead of the
lock acquire fast path. However I don't think I can do it for the
blocking path, where thread A tries to acquire the lock on behalf of
thread B and then wakes B if it succeeded - I don't think we have an
API for A to say 'I want to disable preemption in thread B', is there
?

> Oh, and something else that occurs to me:  Do unfair readers have to go at the
> front of the wakeup queue?  Can they be slightly less unfair and go either
> before the first reader in the queue or at the back of the queue instead?

Going before the first reader would be fine for our use, as we're
really only using this for mmap_sem and the write holders there don't
keep it very long. I'm not sure what this buys us though.

Going at the back of the queue would mean the critical readers would
still get occasionally blocked behind other readers doing disk
accesses - we'd like to avoid that.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
