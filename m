Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1KOQA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:00:27 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:37821 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756466Ab1KOQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:00:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: E.1CmooVM1lPPxYNoVgRdLx7kasYKFm.UzjFNv2YD4lfiyH
 _O2EUVs96p7OLCVdm_0he.mpFiyULwGYo0Vec0JSlzRa0u3kBiKeW3AWh28Q
 dngEcHxDGOZ7DsG8kAs0IvBq0ENNE6yQCvkG3yb8ApCpkAXhuVO6v40WbWzN
 Q4ArvUtexfuyfzJJSKW0QHW0s6bNAkaxUnnS0WKpwstvahIZGzIAy_WYbkbj
 EG_jmWMRtOPP4QAALpWNcW06Je49_nuy6iF39wjCS4nQ4bj8x5rIr3ZJF8dN
 ctK4yfUjOlxOjPKz4_JZbClS4PKiKJHPPXmrP6.cfSfPyHtz4zcFKMmYe6RI
 YJVhkfNEk9htD4P_qNhfQMX6azgw8_T0SoGPrTVleKdyGxA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 15 Nov 2011 10:00:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 5/5] mm: Only IPI CPUs to drain local pages if they
 exist
In-Reply-To: <1321179449-6675-6-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1111150956410.22502@router.home>
References: <1321179449-6675-1-git-send-email-gilad@benyossef.com> <1321179449-6675-6-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Nov 2011, Gilad Ben-Yossef wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9dd443d..44dc6c5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1119,7 +1119,23 @@ void drain_local_pages(void *arg)
>   */
>  void drain_all_pages(void)
>  {
> -	on_each_cpu(drain_local_pages, NULL, 1);
> +	int cpu;
> +	struct zone *zone;
> +	cpumask_var_t cpus;
> +	struct per_cpu_pageset *pageset;

We usually name such pointers "pcp" in the page allocator.

> +
> +	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
> +		for_each_populated_zone(zone) {
> +			for_each_online_cpu(cpu) {
> +				pageset = per_cpu_ptr(zone->pageset, cpu);
> +				if (pageset->pcp.count)
> +					cpumask_set_cpu(cpu, cpus);
> +		}

The pagesets are allocated on bootup from the per cpu areas. You may get a
better access pattern by using for_each_online_cpu as the outer loop
because their is a likelyhood of linear increasing accesses as you loop
through the zones for a particular cpu.

Acked-by: Christoph Lameter <cl@linux.com>

