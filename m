Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2HFRDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:03:38 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26347 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2HFRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:03:37 -0400
Message-ID: <1344272614.2486.40.camel@lorien2>
Subject: Re: [PATCH RESEND] mm: Restructure kmem_cache_create() to move
 debug cache integrity checks into a new function
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: JoonSoo Kim <js1304@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, cl@linux.com, glommer@parallels.com,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, shuahkhan@gmail.com
Date: Mon, 06 Aug 2012 11:03:34 -0600
In-Reply-To: <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
References: <1342221125.17464.8.camel@lorien2>
	 <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com>
	 <1344224494.3053.5.camel@lorien2> <1344266096.2486.17.camel@lorien2>
	 <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 01:49 +0900, JoonSoo Kim wrote:
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 12637ce..08bc2a4 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -23,6 +23,41 @@ enum slab_state slab_state;
> >  LIST_HEAD(slab_caches);
> >  DEFINE_MUTEX(slab_mutex);
> >
> > +static int kmem_cache_sanity_check(const char *name, size_t size)
> > +{
> > +#ifdef CONFIG_DEBUG_VM
> > +       struct kmem_cache *s = NULL;
> > +
> > +       list_for_each_entry(s, &slab_caches, list) {
> > +               char tmp;
> > +               int res;
> > +
> > +               /*
> > +                * This happens when the module gets unloaded and doesn't
> > +                * destroy its slab cache and no-one else reuses the vmalloc
> > +                * area of the module.  Print a warning.
> > +                */
> > +               res = probe_kernel_address(s->name, tmp);
> > +               if (res) {
> > +                       pr_err("Slab cache with size %d has lost its name\n",
> > +                              s->object_size);
> > +                       continue;
> > +               }
> > +
> > +               if (!strcmp(s->name, name)) {
> > +                       pr_err("%s (%s): Cache name already exists.\n",
> > +                              __func__, name);
> > +                       dump_stack();
> > +                       s = NULL;
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +
> > +       WARN_ON(strchr(name, ' '));     /* It confuses parsers */
> > +#endif
> > +       return 0;
> > +}
> 
> As I know, following is more preferable than above.
> 
> #ifdef CONFIG_DEBUG_VM
> static int kmem_cache_sanity_check(const char *name, size_t size);
> #else
> static inline int kmem_cache_sanity_check(const char *name, size_t size)
> {
> return 0;
> }
> #endif
> 
> Is there any reason to do like that?
> Thanks.

No reason, just something I am used to doing :) inline is a good idea. I
can fix that easily and send v2 patch.

-- Shuah


