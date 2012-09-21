Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab2IUJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:29:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63012 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2IUJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:29:21 -0400
MIME-Version: 1.0
In-Reply-To: <1347977530-29755-9-git-send-email-glommer@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-9-git-send-email-glommer@parallels.com>
Date: Fri, 21 Sep 2012 12:29:20 +0300
X-Google-Sender-Auth: 94m4xHrTHoLDfF0w8ND8AANvRHk
Message-ID: <CAOJsxLFeh5G1JBMmZPkwMBTEXSJB7Bmp1yvvbDz0suWE5sReYA@mail.gmail.com>
Subject: Re: [PATCH v3 08/16] slab: allow enable_cpu_cache to use preset
 values for its tunables
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:12 PM, Glauber Costa <glommer@parallels.com> wrote:
> diff --git a/mm/slab.c b/mm/slab.c
> index e2cf984..f2d760c 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4141,8 +4141,19 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
>  static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
>  {
>         int err;
> -       int limit, shared;
> -
> +       int limit = 0;
> +       int shared = 0;
> +       int batchcount = 0;
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +       if (cachep->memcg_params.parent) {
> +               limit = cachep->memcg_params.parent->limit;
> +               shared = cachep->memcg_params.parent->shared;
> +               batchcount = cachep->memcg_params.parent->batchcount;

Style nit: please introduce a variable for
"cachep->memcg_params.parent" to make this human-readable.
