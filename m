Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0EUDf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 23:35:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab0EUDfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 23:35:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=G9z4uqS4jZKnkUJBdLfnd3ixQxUecG40VDW+hTcgxkXCQSR7jbxq6TACQaR6G3ZsD
	UX8XYVbCgedInZOVWFSMA==
MIME-Version: 1.0
In-Reply-To: <32068.1274275283@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-8-git-send-email-walken@google.com>
	 <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org>
	 <20100517231331.GA30847@google.com>
	 <20100517232052.GB30847@google.com> <32068.1274275283@redhat.com>
Date: Thu, 20 May 2010 20:35:43 -0700
Message-ID: <AANLkTiks8Wb95EC-cJsfdoboIif78vfxKJr-XjmBtOCv@mail.gmail.com>
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

I think it's not that bad - I mean, the unfairness does not come into
factor here. If you tried to do a regular down_read(), you could also
get preempted on your way to the blocking path. Being preempted on the
way to your critical section after a successful (if unfair) acquire
really is no worse.

The critical section prevents you from blocking on long-latency events
such as disk accesses; being preempted but still runnable is not
nearly as bad.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
