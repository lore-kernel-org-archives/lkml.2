Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914Ab1J1EGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 00:06:36 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22435 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750715Ab1J1EGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 00:06:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: y35CKNIVM1nq9.zas3fGwJjMEpnDR7OkLhqUmDqEAlbICrx
 R99_iFBTY5isH4FNeBOnr8HTcFwFFmUECN69MUW90__ZB1y.TLXrbxGQUZbw
 AdcwuCSrzLg1FMJ3gA4RxVunXhQtKSezSp.KmkC.bOjhzC9V6byU7hQplP5v
 2hN1mtWHffUUpxjX5QfFhNiePt1QJvQz7ytjtvmi7_sR3988jgnPzTUTkgfd
 gclFPEq44GCuvVTlqC0CpUhOhR3c.ns.g90DW8aBa8.yfxCjhEho4IAeTIDR
 IMI6GMOqbXPgSLFbCn5Zk3_ZUlbxnKhEaFcmosqaI0dw9ejHBf9TxKmKgB_D
 d7kT2h1aeN4gLdxHjSWgVOx8Y2bE2pkjdRl56iooOOeOYjPQ-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 27 Oct 2011 23:06:31 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2 6/6] slub: only preallocate cpus_with_slabs if
 offstack
In-Reply-To: <1319385413-29665-7-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.DEB.2.00.1110272304020.14619@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com> <1319385413-29665-7-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Oct 2011, Gilad Ben-Yossef wrote:

> We need a cpumask to track cpus with per cpu cache pages
> to know which cpu to whack during flush_all. For
> CONFIG_CPUMASK_OFFSTACK=n we allocate the mask on stack.
> For CONFIG_CPUMASK_OFFSTACK=y we don't want to call kmalloc
> on the flush_all path, so we preallocate per kmem_cache
> on cache creation and use it in flush_all.

I think the on stack alloc should be the default because we can then avoid
the field in kmem_cache and the associated logic with managing the field.
Can we do a GFP_ATOMIC allocation in flush_all()? If the alloc
fails then you can still fallback to send an IPI to all cpus.

