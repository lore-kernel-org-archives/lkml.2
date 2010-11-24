Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0KXAWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:22:32 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38279 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0KXAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:22:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WdL0rjxNcprlzsKexYNqNsGxpBraI/TW21+ODTf1t4oP7RxpTXlDOgb4Kb7zMFh1Nc
         B96IwHQKweW+sIxaF7uKtA6FavD1EbY859S8P3/ducxd71vJuUm8AIWQGVo/T8e1ryRN
         mFBXC48EltafC168COccjrMqQynxIpykhTOa4=
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless)
 fastpaths for slub
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20101123235201.758191189@linux.com>
References: <20101123235139.908255844@linux.com>
	 <20101123235201.758191189@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 01:22:24 +0100
Message-ID: <1290558144.2866.122.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 17:51 -0600, Christoph Lameter a écrit :
> pièce jointe document texte brut (slub_generation)
> Use the this_cpu_cmpxchg_double functionality to implement a lockless
> allocation algorith.
> 
> Each of the per cpu pointers is paired with a transaction id that ensures
> that updates of the per cpu information can only occur in sequence on
> a certain cpu.
> 
> A transaction id is a "long" integer that is comprised of an event number
> and the cpu number. The event number is incremented for every change to the
> per cpu state. This means that the cmpxchg instruction can verify for an
> update that nothing interfered and that we are updating the percpu structure
> for the processor where we picked up the information and that we are also
> currently on that processor when we update the information.
> 
> This results in a significant decrease of the overhead in the fastpaths. It
> also makes it easy to adopt the fast path for realtime kernels since this
> is lockless and does not require that the use of the current per cpu area
> over the critical section. It is only important that the per cpu area is
> current at the beginning of the critical section and at that end.
> 
> So there is no need even to disable preemption which will make the allocations
> scale well in a RT environment.
> 
> [Beware: There have been previous attempts at lockless fastpaths that
> did not succeed. We hope to have learned from these experiences but
> review certainly is necessary.]
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---

>  
>  /*
> + * Calculate the next globally unique transaction for disambiguiation
> + * during cmpxchg. The transactions start with the cpu number and are then
> + * incremented by CONFIG_NR_CPUS.
> + */
> +static inline unsigned long next_tid(unsigned long tid)
> +{
> +	return tid + CONFIG_NR_CPUS;
> +}


Hmm, this only works for power of two NR_CPUS, or else one cpu 'tid'
could wrap on another cpu tid.

I suggest using 4096  (or roundup_pow_of_two(CONFIG_NR_CPUS))



