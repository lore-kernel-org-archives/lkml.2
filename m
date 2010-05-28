Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0E1SLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:11:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0E1SL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:11:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aVHS2GmXFTpCl3VIuArCug8UZqiW2ZxqshrzKpZPgzpNyLdTGZePQscfduP9Lc1hQ
	wJwRPRDA8HpfV16vCv+fw==
MIME-Version: 1.0
In-Reply-To: <1275052414.1645.52.camel@laptop>
References: <4BF9EC69.5030709@example.com>
	<1274777422.5882.591.camel@twins>
	<20100526160252.325f8357.akpm@linux-foundation.org>
	<1274942798.27810.3584.camel@twins>
	<20100526235107.77e66ce0.akpm@linux-foundation.org>
	<1274945751.27810.3765.camel@twins>
	<20100527113340.d4afb8fc.akpm@linux-foundation.org>
	<1275052414.1645.52.camel@laptop>
Date: Fri, 28 May 2010 11:11:24 -0700
Message-ID: <AANLkTimbh3CsxAh9egF0etp0-uMDGb5Z9qkoltPZ6Nay@mail.gmail.com>
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve 
	documentation
From: Chad Talbott <ctalbott@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 6:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> + * local_clock()      -- is cpu_clock() on the current cpu.

Pretty sure this should read, "is cpu_clock() on *some* cpu," since
there is no guarantee in a preemptible kernel that local_clock()
returns on the same CPU that it was called from. The caller has to do
the preempt protection itself.

The function could be written as follows (thanks Salman Qazi):

u64 local_clock(unsigned int *where)
{
       u64 clock;
       unsigned long flags;

       local_irq_save(flags);
       *where = smp_processor_id();
       clock = sched_clock_cpu(*where);
       local_irq_restore(flags);

       return clock;
}

but I don't see the utility of the resulting routine.

Chad
