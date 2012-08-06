Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab2HFAAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 20:00:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61806 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2HFAAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 20:00:38 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-fd-501f09231b88
Date: Mon, 6 Aug 2012 09:01:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Tejun Heo <tj@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page_alloc.c:4514 free_area_init_node+0x4f/0x37b()
Message-ID: <20120806000157.GA10971@bbox>
References: <20120801173837.GI8082@aftab.osrc.amd.com>
 <20120801233335.GA4673@barrios>
 <20120802110641.GA16328@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802110641.GA16328@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Thu, Aug 02, 2012 at 01:06:41PM +0200, Borislav Petkov wrote:
> On Thu, Aug 02, 2012 at 08:33:35AM +0900, Minchan Kim wrote:
> > Hello Borislav,
> > 
> > On Wed, Aug 01, 2012 at 07:38:37PM +0200, Borislav Petkov wrote:
> > > Hi,
> > > 
> > > I'm hitting the WARN_ON in $Subject with latest linus:
> > > v3.5-8833-g2d534926205d on a 4-node AMD system. As it looks from
> > > dmesg, it is happening on node 0, 1 and 2 but not on 3. Probably the
> > > pgdat->nr_zones thing but I'll have to add more dbg code to be sure.
> > 
> > As I look the code quickly, free_area_init_node initializes node_id and
> > node_start_pfn doublely. They were initialized by setup_node_data.
> > 
> > Could you test below patch? It's not a totally right way to fix it but
> > I want to confirm why it happens.
> > 
> > (I'm on vacation now so please understand that it hard to reach me)
> 
> I sincerely hope you're not going to interrupt your vacation because of
> this.
> 
> :-).
> 
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 889532b..009ac28 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4511,7 +4511,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
> >         pg_data_t *pgdat = NODE_DATA(nid);
> >  
> >         /* pg_data_t should be reset to zero when it's allocated */
> > -       WARN_ON(pgdat->nr_zones || pgdat->node_start_pfn || pgdat->classzone_idx);
> > +       WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
> >  
> >         pgdat->node_id = nid;
> >         pgdat->node_start_pfn = node_start_pfn;
> 
> Yep, you were right: ->node_start_pfn is set. I added additional debug
> output for more info:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 889532b8e6c1..c249abe4fee2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4511,7 +4511,17 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
>         pg_data_t *pgdat = NODE_DATA(nid);
>  
>         /* pg_data_t should be reset to zero when it's allocated */
> -       WARN_ON(pgdat->nr_zones || pgdat->node_start_pfn || pgdat->classzone_idx);
> +       WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
> +
> +       if (pgdat->node_start_pfn)
> +               pr_warn("%s: pgdat->node_start_pfn: %lu\n", __func__, pgdat->node_start_pfn);
> +
> +       if (pgdat->nr_zones)
> +               pr_warn("%s: pgdat->nr_zones: %d\n", __func__, pgdat->nr_zones);
> +
> +       if (pgdat->classzone_idx)
> +               pr_warn("%s: pgdat->classzone_idx: %d\n", __func__, pgdat->classzone_idx);
> +
>  
>         pgdat->node_id = nid;
>         pgdat->node_start_pfn = node_start_pfn;
> 
> 
> 
> Here's what it says:
> 
> [    0.000000] On node 0 totalpages: 4193848
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3890 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 798464 pages, LIFO batch:31
> [    0.000000]   Normal zone: 52736 pages used for memmap
> [    0.000000]   Normal zone: 3322368 pages, LIFO batch:31
> [    0.000000] free_area_init_node: pgdat->node_start_pfn: 4423680	<----
> [    0.000000] On node 1 totalpages: 4194304
> [    0.000000]   Normal zone: 65536 pages used for memmap
> [    0.000000]   Normal zone: 4128768 pages, LIFO batch:31
> [    0.000000] free_area_init_node: pgdat->node_start_pfn: 8617984	<----
> [    0.000000] On node 2 totalpages: 4194304
> [    0.000000]   Normal zone: 65536 pages used for memmap
> [    0.000000]   Normal zone: 4128768 pages, LIFO batch:31
> [    0.000000] free_area_init_node: pgdat->node_start_pfn: 12812288	<----
> [    0.000000] On node 3 totalpages: 4194304
> [    0.000000]   Normal zone: 65536 pages used for memmap
> [    0.000000]   Normal zone: 4128768 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x2008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> 
> Thanks.

Thanks for looking at this!

As soon as I come back from vacation, I see this BUG carefully and think patch I sent
is good. The patch's goal is to detect for uninitialized pgdat structure
when it was allocated. So it checks some variables randomly but unfortunately,
pgdat's members like node_start_pfn are closely related to boot arch code
so some members could be used by arch code before reaching generic mm code.
It was a Tejun's concern and he was correct.

I think nr_zones and classzone_idx should be initialized by only generic MM code
during boot sequence, not memory hotplug so that patch would be okay.

Linus already applied the patch in rc-1 but he might need better changelog.
I am not sure I send this patch to whom, Linus or Andrew?
Anyway, Please use below if really need it.

Thanks!

>From b575b78a1ba7daf7a9adc3b49dadfbd573be398d Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 6 Aug 2012 08:57:57 +0900
Subject: [PATCH] mm: fix wrong warning check for detect pgdat's garbage

[1] added some check for pgdat garbage but Borislav reported
the warning happens in 4-node AMD system.

The problem is that node_start_pfn is initialized doublely
in arch code and generic mm code. Normally, pgdat's members
are closely related to arch boot code so it's not good idea
to check such members in generic mm code.

So this patch removes node_start_pfn check and leave other
variable check as it is because nr_zone and classzone_idx
should be initialized by generic mm code, NOT arch code so
it would never happen problem.

[1] 88fdf75d, mm: warn if pg_data_t isn't initialized with zero

Reporeted-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 889532b..009ac28 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4511,7 +4511,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	pg_data_t *pgdat = NODE_DATA(nid);
 
 	/* pg_data_t should be reset to zero when it's allocated */
-	WARN_ON(pgdat->nr_zones || pgdat->node_start_pfn || pgdat->classzone_idx);
+	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-- 
1.7.9.5


> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> GM: Alberto Bozzo
> Reg: Dornach, Landkreis Muenchen
> HRB Nr. 43632 WEEE Registernr: 129 19551
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
