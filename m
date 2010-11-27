Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0K0IJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:09:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65164 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0K0IJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qc2KS51Yeh53VTxQqww4p70TOt63OCRweMHLte7slCQqmuee8rvHwwwssSt49LhPbv
         5iHmODfTVUymIMLprctw93V6z+XJhqY7QGD+MStU3x/05HaSvzrq5Wdj3faMsJ/e9VDf
         Y8tYpmg1GPxhXXmTUrmv1CaK6PoV/FPJnF1xA=
MIME-Version: 1.0
In-Reply-To: <20101126210952.446650993@linux.com>
References: <20101126210937.383047168@linux.com>
	<20101126210952.446650993@linux.com>
Date: Sat, 27 Nov 2010 10:09:35 +0200
X-Google-Sender-Auth: eXNz2M4bH1n2YSKbMM-0vfnI0AY
Message-ID: <AANLkTi=6wVzEQwuMZTgL8WWhFMnNoYgsYv9hZk1jB4jw@mail.gmail.com>
Subject: Re: [thisops uV2 06/10] vmstat: Use this_cpu_inc_return for vm statistics
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> this_cpu_inc_return() saves us a memory access there. Code
> size does not change.
>
> V1->V2:
>        - Fixed the location of the __per_cpu pointer attributes
>        - Sparse checked
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> ---
>  mm/vmstat.c |   20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>
> Index: linux-2.6/mm/vmstat.c
> ===================================================================
> --- linux-2.6.orig/mm/vmstat.c  2010-11-26 10:35:45.000000000 -0600
> +++ linux-2.6/mm/vmstat.c       2010-11-26 10:45:49.000000000 -0600
> @@ -167,8 +167,8 @@ static void refresh_zone_stat_thresholds
>  void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
>                                int delta)
>  {
> -       struct per_cpu_pageset * __percpu pcp = zone->pageset;
> -       s8 * __percpu p = pcp->vm_stat_diff + item;
> +       struct per_cpu_pageset __percpu *pcp = zone->pageset;
> +       s8 __percpu *p = pcp->vm_stat_diff + item;
>        long x;
>        long t;
>

Shouldn't this hunk be in the other vmstat patch?

> @@ -223,13 +223,11 @@ EXPORT_SYMBOL(mod_zone_page_state);
>  */
>  void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
>  {
> -       struct per_cpu_pageset * __percpu pcp = zone->pageset;
> -       s8 * __percpu p = pcp->vm_stat_diff + item;
> +       struct per_cpu_pageset __percpu *pcp = zone->pageset;
> +       s8 __percpu *p = pcp->vm_stat_diff + item;
>        s8 v, t;
>
> -       __this_cpu_inc(*p);
> -
> -       v = __this_cpu_read(*p);
> +       v = __this_cpu_inc_return(*p);
>        t = __this_cpu_read(pcp->stat_threshold);
>        if (unlikely(v > t)) {
>                s8 overstep = t >> 1;
> @@ -247,13 +245,11 @@ EXPORT_SYMBOL(__inc_zone_page_state);
>
>  void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
>  {
> -       struct per_cpu_pageset * __percpu pcp = zone->pageset;
> -       s8 * __percpu p = pcp->vm_stat_diff + item;
> +       struct per_cpu_pageset __percpu *pcp = zone->pageset;
> +       s8 __percpu *p = pcp->vm_stat_diff + item;
>        s8 v, t;
>
> -       __this_cpu_dec(*p);
> -
> -       v = __this_cpu_read(*p);
> +       v = __this_cpu_dec_return(*p);
>        t = __this_cpu_read(pcp->stat_threshold);
>        if (unlikely(v < - t)) {
>                s8 overstep = t >> 1;

For the rest of this patch:

Reviewed-by: Pekka Enberg <penberg@kernel.org>
