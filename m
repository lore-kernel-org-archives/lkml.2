Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3ABVl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:41:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26726 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3ABVl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:41:26 -0500
Date: Wed, 2 Jan 2013 16:41:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: Re: [PATCH 2/3] staging: ramster: move to new zcache2 codebase
Message-ID: <20130102214107.GB15833@phenom.dumpdata.com>
References: <1346877901-12543-1-git-send-email-dan.magenheimer@oracle.com>
 <1346877901-12543-3-git-send-email-dan.magenheimer@oracle.com>
 <CAMuHMdUQp3wX1V6cgUT7SG43_G=89z2+nPoeeL8WyoqYw5WcnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdUQp3wX1V6cgUT7SG43_G=89z2+nPoeeL8WyoqYw5WcnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 08:59:01PM +0100, Geert Uytterhoeven wrote:
> On Wed, Sep 5, 2012 at 10:45 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > + * These are all informative and exposed through debugfs... except for
> > + * the arrays... anyone know how to do that?  To avoid confusion for
> 
> debugfs_create_u32_array()?

Yes. I posted a patch that fixes a lot of these. Got some more work to
do on the patchset - and will CC you on them on the next posting.

> 
> > + * debugfs viewers, some of these should also be atomic_long_t, but
> > + * I don't know how to expose atomics via debugfs either...
> > + */
> > +static unsigned long zbud_eph_pageframes;
> > +static unsigned long zbud_pers_pageframes;
> > +static unsigned long zbud_eph_zpages;
> > +static unsigned long zbud_pers_zpages;
> > +static u64 zbud_eph_zbytes;
> > +static u64 zbud_pers_zbytes;
> > +static unsigned long zbud_eph_evicted_pageframes;
> > +static unsigned long zbud_pers_evicted_pageframes;
> > +static unsigned long zbud_eph_cumul_zpages;
> > +static unsigned long zbud_pers_cumul_zpages;
> > +static u64 zbud_eph_cumul_zbytes;
> > +static u64 zbud_pers_cumul_zbytes;
> > +static unsigned long zbud_eph_cumul_chunk_counts[NCHUNKS];
> > +static unsigned long zbud_pers_cumul_chunk_counts[NCHUNKS];
> > +static unsigned long zbud_eph_buddied_count;
> > +static unsigned long zbud_pers_buddied_count;
> > +static unsigned long zbud_eph_unbuddied_count;
> > +static unsigned long zbud_pers_unbuddied_count;
> > +static unsigned long zbud_eph_zombie_count;
> > +static unsigned long zbud_pers_zombie_count;
> > +static atomic_t zbud_eph_zombie_atomic;
> > +static atomic_t zbud_pers_zombie_atomic;
> > +
> > +#ifdef CONFIG_DEBUG_FS
> > +#include <linux/debugfs.h>
> > +#define        zdfs    debugfs_create_size_t
> > +#define        zdfs64  debugfs_create_u64
> > +static int zbud_debugfs_init(void)
> > +{
> > +       struct dentry *root = debugfs_create_dir("zbud", NULL);
> > +       if (root == NULL)
> > +               return -ENXIO;
> > +
> > +       /*
> > +        * would be nice to dump the sizes of the unbuddied
> > +        * arrays, like was done with sysfs, but it doesn't
> > +        * look like debugfs is flexible enough to do that
> > +        */
> > +       zdfs64("eph_zbytes", S_IRUGO, root, &zbud_eph_zbytes);
> > +       zdfs64("eph_cumul_zbytes", S_IRUGO, root, &zbud_eph_cumul_zbytes);
> > +       zdfs64("pers_zbytes", S_IRUGO, root, &zbud_pers_zbytes);
> > +       zdfs64("pers_cumul_zbytes", S_IRUGO, root, &zbud_pers_cumul_zbytes);
> > +       zdfs("eph_cumul_zpages", S_IRUGO, root, &zbud_eph_cumul_zpages);
> > +       zdfs("eph_evicted_pageframes", S_IRUGO, root,
> > +                               &zbud_eph_evicted_pageframes);
> > +       zdfs("eph_zpages", S_IRUGO, root, &zbud_eph_zpages);
> > +       zdfs("eph_pageframes", S_IRUGO, root, &zbud_eph_pageframes);
> > +       zdfs("eph_buddied_count", S_IRUGO, root, &zbud_eph_buddied_count);
> > +       zdfs("eph_unbuddied_count", S_IRUGO, root, &zbud_eph_unbuddied_count);
> > +       zdfs("pers_cumul_zpages", S_IRUGO, root, &zbud_pers_cumul_zpages);
> > +       zdfs("pers_evicted_pageframes", S_IRUGO, root,
> > +                               &zbud_pers_evicted_pageframes);
> > +       zdfs("pers_zpages", S_IRUGO, root, &zbud_pers_zpages);
> > +       zdfs("pers_pageframes", S_IRUGO, root, &zbud_pers_pageframes);
> > +       zdfs("pers_buddied_count", S_IRUGO, root, &zbud_pers_buddied_count);
> > +       zdfs("pers_unbuddied_count", S_IRUGO, root, &zbud_pers_unbuddied_count);
> > +       zdfs("pers_zombie_count", S_IRUGO, root, &zbud_pers_zombie_count);
> > +       return 0;
> > +}
> > +#undef zdfs
> > +#undef zdfs64
> > +#endif
> 
> On m68k (see e.g.
> http://kisskb.ellerman.id.au/kisskb/buildresult/7864856/), I'm getting
> lots of warnings for this:
> 
> drivers/staging/ramster/zbud.c: In function ‘zbud_debugfs_init’:
> drivers/staging/ramster/zbud.c:323: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:325: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:326: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:327: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:328: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:329: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:330: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:332: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:333: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:334: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:335: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:336: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zbud.c:337: warning: passing argument 4 of
> ‘debugfs_create_size_t’ from incompatible pointer type
> 
> as you're using debugfs_create_size_t() to refer to "unsigned long"
> instead of "size_t".
> 
> Some of the variables you can change from "unsigned long" to "size_t",
> as you just increment
> or decrement them.
> For others, that's not a good idea, as you assign them the return value of
> atomic_inc_return()/atomic_dec_return(), which is "int", i.e. always 32-bit,
> while "size_t" is 64-bit on 64-bit platforms.
> 
> zcache-main.c suffers from similar problems:
> 
> drivers/staging/ramster/zcache-main.c: In function ‘zcache_debugfs_init’:
> drivers/staging/ramster/zcache-main.c:195: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:196: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:197: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:198: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:199: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:200: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:201: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:202: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:203: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:204: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:206: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:207: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:208: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:209: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:210: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:211: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:212: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:213: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:214: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:215: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:217: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:218: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:219: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:220: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:221: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:222: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:223: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:224: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:225: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:227: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:229: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:231: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:233: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:235: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> drivers/staging/ramster/zcache-main.c:237: warning: passing argument 4
> of ‘debugfs_create_size_t’ from incompatible pointer type
> 
> But there is more work to do, as zcache_dump() formats many of them as "%lu",
> which should be "%zu" if you convert the counters to size_t.
> Note that you do not have to cast a "u64" to "unsigned long long" to format it
> using "%llu", so please remove the casts.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
