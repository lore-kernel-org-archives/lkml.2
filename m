Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1IZHeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:34:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:33986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1IZHeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:34:15 -0400
Subject: Re: [PATCH 5/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Date: Mon, 26 Sep 2011 09:33:40 +0200
In-Reply-To: <1316940890-24138-6-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-6-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317022420.9084.57.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
> +       if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
> +               for_each_online_cpu(cpu) {
> +                       c = per_cpu_ptr(s->cpu_slab, cpu);
> +                       if (c && c->page)
> +                               cpumask_set_cpu(cpu, cpus);
> +               }
> +               on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
> +               free_cpumask_var(cpus); 

Right, having to do that for_each_oneline_cpu() loop only to then IPI
them can cause a massive cacheline bounce fest.. Ideally you'd want to
keep a cpumask per kmem_cache, although I bet the memory overhead of
that isn't attractive.

Also, what Pekka says, having that alloc here isn't good either.
