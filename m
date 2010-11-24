Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab0KXHQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:16:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46664 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0KXHQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZMnzqgdlzBDq+3Tp95JqELNnQWO043JbzJNC4MfjszGiIGHT1pc2RJqyFDdlgmhCx0
         OyPrR2leJDKXKQZhS9z8jFsoJNkEDt+/7kgN7k1CQTCbuNIV/tqS7wCPmmDYmge/cPH9
         HQGGmUn5bztgKasRaNiSf30EHvK7fTKOgYHRU=
MIME-Version: 1.0
In-Reply-To: <20101123235201.758191189@linux.com>
References: <20101123235139.908255844@linux.com>
	<20101123235201.758191189@linux.com>
Date: Wed, 24 Nov 2010 09:16:18 +0200
X-Google-Sender-Auth: OuUXzSRlwm9LU8u4-rrceQ_dWWI
Message-ID: <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 1:51 AM, Christoph Lameter <cl@linux.com> wrote:
> @@ -1737,23 +1770,53 @@ static __always_inline void *slab_alloc(
>  {
>        void **object;
>        struct kmem_cache_cpu *c;
> -       unsigned long flags;
> +       unsigned long tid;
>
>        if (slab_pre_alloc_hook(s, gfpflags))
>                return NULL;
>
> -       local_irq_save(flags);
> +redo:
> +       /*
> +        * Must read kmem_cache cpu data via this cpu ptr. Preemption is
> +        * enabled. We may switch back and forth between cpus while
> +        * reading from one cpu area. That does not matter as long
> +        * as we end up on the original cpu again when doing the cmpxchg.
> +        */
>        c = __this_cpu_ptr(s->cpu_slab);
> +
> +       /*
> +        * The transaction ids are globally unique per cpu and per operation on
> +        * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
> +        * occurs on the right processor and that there was no operation on the
> +        * linked list in between.
> +        */
> +       tid = c->tid;
> +       barrier();

You're using a compiler barrier after every load from c->tid. Why?
