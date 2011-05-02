Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1EBWx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:53:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab1EBWx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TCpHvblPX9yL47aQVSCNu5+MNk4RwWFSqvjVJKd4lCeWbJHO34+DRLClXmdIBFLFdB
         KbM0+69ishooQ3RrymCw==
MIME-Version: 1.0
In-Reply-To: <1304366849.15370.27.camel@mulgrave.site>
References: <1304366849.15370.27.camel@mulgrave.site>
From: Paul Menage <menage@google.com>
Date: Mon, 2 May 2011 15:53:31 -0700
Message-ID: <BANLkTimhZAdL-HXftE86SyjRrDy9KB+qsg@mail.gmail.com>
Subject: Re: memcg: fix fatal livelock in kswapd
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Balbir Singh <balbir@in.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        nishimura@mxp.nes.nec.co.jp
Cc: Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding the memcg maintainers ]

On Mon, May 2, 2011 at 1:07 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> The fatal livelock in kswapd, reported in this thread:
>
> http://marc.info/?t=130392066000001
>
> Is mitigateable if we prevent the cgroups code being so aggressive in
> its zone shrinking (by reducing it's default shrink from 0 [everything]
> to DEF_PRIORITY [some things]).  This will have an obvious knock on
> effect to cgroup accounting, but it's better than hanging systems.
>
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
>
> ---
>
> From 74b62fc417f07e1411d98181631e4e097c8e3e68 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Mon, 2 May 2011 14:56:29 -0500
> Subject: [PATCH] vmscan: move containers scan back to default priority
>
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f6b435c..46cde92 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2173,8 +2173,12 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>         * if we don't reclaim here, the shrink_zone from balance_pgdat
>         * will pick up pages from other mem cgroup's as well. We hack
>         * the priority and make it zero.
> +        *
> +        * FIXME: jejb: zero here was causing a livelock in the
> +        * shrinker so changed to DEF_PRIORITY to fix this. Now need to
> +        * sort out cgroup accounting.
>         */
> -       shrink_zone(0, zone, &sc);
> +       shrink_zone(DEF_PRIORITY, zone, &sc);
>
>        trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
>
>
>
>
