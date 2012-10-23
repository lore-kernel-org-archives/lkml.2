Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab2JWUdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:33:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:49498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898Ab2JWUdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:33:41 -0400
Message-ID: <1351024368.13456.39.camel@twins>
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 23 Oct 2012 22:32:48 +0200
In-Reply-To: <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com>
	 <20121015191018.GA4816@redhat.com>
	 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
	 <20121017165902.GB9872@redhat.com>
	 <20121017224430.GC2518@linux.vnet.ibm.com>
	 <20121018162409.GA28504@redhat.com>
	 <20121018163833.GK2518@linux.vnet.ibm.com>
	 <20121018175747.GA30691@redhat.com>
	 <20121019192838.GM2518@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
	 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-22 at 19:37 -0400, Mikulas Patocka wrote:
> -       /*
> -        * On X86, write operation in this_cpu_dec serves as a memory unlock
> -        * barrier (i.e. memory accesses may be moved before the write, but
> -        * no memory accesses are moved past the write).
> -        * On other architectures this may not be the case, so we need smp_mb()
> -        * there.
> -        */
> -#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
> -       barrier();
> -#else
> -       smp_mb();
> -#endif
> +       light_mb(); /* B, between read of the data and write to p->counter, paired with C */ 

If we're going to invent new primitives for this, shouldn't we call
this: smp_unlock_barrier() or something? That at least has well defined
semantics.


