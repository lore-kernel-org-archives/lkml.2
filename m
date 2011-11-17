Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1KQQ4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:56:09 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17175 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1KQQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:56:07 -0500
X-IronPort-AV: E=Sophos;i="4.69,528,1315180800"; 
   d="scan'208";a="8995430"
Subject: Re: [PATCH 1/3] xen/granttable: Introducing grant table V2 stucture
From: Ian Campbell <Ian.Campbell@citrix.com>
To: annie li <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Thu, 17 Nov 2011 16:55:59 +0000
In-Reply-To: <4EC53119.7060307@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
	 <1321451304-13559-1-git-send-email-annie.li@oracle.com>
	 <1321526148.3664.263.camel@zakaz.uk.xensource.com>
	 <4EC53119.7060307@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321548960.3664.283.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:06 +0000, annie li wrote:
> Thanks for your review, Ian.
> See following,
> > > -       } while ((nflags = sync_cmpxchg(&shared[ref].flags, flags, 0)) != flags);
> > > +       } while ((nflags = sync_cmpxchg(&gnttab_shared.v1[ref].flags, flags, 0))
> > > +                       != flags);
> > >     
> > 
> > I think this is one of those cases where strictly adhering to an
> > 80-column rule hurts the readability of the code.
> > 
> > If you had left the static global as "shared" rather than
> > "gnttab_shared" you wouldn't have this issue. If you want a more
> > descriptive name why not just call it "gnttab"?
> > 
> >   
> Actually, whether the name is "gnttab_shared" or "shared" or "gnttab",
> the code line still breaks the 80-column rule.

My point about strictly adhering to the 80-column limit still stands.

> > > return 1;
> > >  }
> > > +
> > > +int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
> > > +{
> > > +       return gnttab_interface.end_foreign_access_ref(ref, readonly);
> > > +}
> > >  EXPORT_SYMBOL_GPL(gnttab_end_foreign_access_ref);
> > > 
> > >  void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
> > > @@ -246,37 +309,45 @@ EXPORT_SYMBOL_GPL(gnttab_grant_foreign_transfer);
> > >  void gnttab_grant_foreign_transfer_ref(grant_ref_t ref, domid_t domid,
> > >                                        unsigned long pfn)
> > >  {
> > > -       update_grant_entry(ref, domid, pfn, GTF_accept_transfer);
> > > +       gnttab_interface.update_entry(ref, domid, pfn, GTF_accept_transfer);
> > >  }
> > >  EXPORT_SYMBOL_GPL(gnttab_grant_foreign_transfer_ref);
> > > 
> > > -unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
> > > +static unsigned long gnttab_end_foreign_transfer_ref_v1(grant_ref_t ref)
> > >  {
> > >         unsigned long frame;
> > >         u16           flags;
> > > +       u16          *pflags;
> > > +
> > > +       pflags = &gnttab_shared.v1[ref].flags;
> > >     
> > 
> > It would be nice if these refactoring bits could be separated out from
> > the more mechanical renaming and abstracting to fn pointer aspects of
> > the patch.
> >   
> I am not so sure about your meaning, do you mean change gnttab_shared
> back to shared?

I mean that this patch combines a bunch of renaming, an abstraction to
function pointers and other refactoring such as this which actually
change behaviour (or might). It's easier to review if the purely
mechanical stuff (like renaming or adding a layer of function pointers)
is split out from changes like this one.

> > > /*
> > >          * If a transfer is not even yet started, try to reclaim the grant
> > >          * reference and return failure (== 0).
> > >          */
> > > -       while (!((flags = shared[ref].flags) & GTF_transfer_committed)) {
> > > -               if (sync_cmpxchg(&shared[ref].flags, flags, 0) == flags)
> > > +       while (!((flags = *pflags) & GTF_transfer_committed)) {
> > > +               if (sync_cmpxchg(pflags, flags, 0) == flags)
> > >                         return 0;
> > >                 cpu_relax();
> > >         }
> > > 
> > >         /* If a transfer is in progress then wait until it is completed. */
> > >         while (!(flags & GTF_transfer_completed)) {
> > > -               flags = shared[ref].flags;
> > > +               flags = *pflags;
> > >                 cpu_relax();
> > >         }
> > > 
> > >         rmb();  /* Read the frame number /after/ reading completion status. */
> > > -       frame = shared[ref].frame;
> > > +       frame = gnttab_shared.v1[ref].frame;
> > >         BUG_ON(frame == 0);
> > > 
> > >         return frame;
> > >  }
> > > +
> > > +unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
> > > +{
> > > +       return gnttab_interface.end_foreign_transfer_ref(ref);
> > > +}
> > >  EXPORT_SYMBOL_GPL(gnttab_end_foreign_transfer_ref);
> > > 
> > >  unsigned long gnttab_end_foreign_transfer(grant_ref_t ref)
> > > @@ -520,6 +591,23 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> > >  }
> > >  EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
> > > 
> > > +static int gnttab_map_frames_v1(unsigned long *frames, unsigned int nr_gframes)
> > > +{
> > > +       int rc;
> > > +
> > > +       rc = arch_gnttab_map_shared(frames, nr_gframes,
> > > +                                   gnttab_max_grant_frames(),
> > > +                                   &gnttab_shared.addr);
> > > +       BUG_ON(rc);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static void gnttab_unmap_frames_v1(void)
> > > +{
> > > +       arch_gnttab_unmap_shared(gnttab_shared.addr, nr_grant_frames);
> > > +}
> > > +
> > >  static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
> > >  {
> > >         struct gnttab_setup_table setup;
> > > @@ -567,19 +655,33 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
> > > 
> > >         BUG_ON(rc || setup.status);
> > > 
> > > -       rc = arch_gnttab_map_shared(frames, nr_gframes, gnttab_max_grant_frames(),
> > > -                                   &shared);
> > > -       BUG_ON(rc);
> > > +       rc = gnttab_interface.map_frames(frames, nr_gframes);
> > >     
> > 
> > Nothing checks rc here now?
> > 
> > In fact the gnttab_map_frames_v1 function has its own BUG_ON(rc) and
> > always returns 0 if it returns at all so perhaps that hook should be
> > returning void?
> >   
> Yes, it should be that if there is only v1 function existing.
> However, I added returns 0 here in order to keep consistence with v2
> function of next patch. The function pointer type is: int
> (*map_frames)(....), and v2 function returning value is meaningful.
> The returning value directly decides returning value of gnttab_map.
> See following code in function gnttab_map of v2 patch:
> 
>         if (rc < 0)
>                 return rc;
>         return 0;

Can rc ever be +ve? Doesn't look like it, in which case this is the same
as "return rc".

> If gnttab_map_frames_v1 returns void here, it is necessary to change
> it back(including "void (*map_frames)"  --> "int (*map_frames)") in
> next v2 implementation patch. So I only added return 0 here.

OK.

> 
> .....
> > > +/*
> > >   * Bitfield values for update_pin_status.flags.
> > >   */
> > >   /* Map the grant entry for access by I/O devices. */
> > > diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> > > index 6a6e914..710afe0 100644
> > > --- a/include/xen/interface/xen.h
> > > +++ b/include/xen/interface/xen.h
> > > @@ -523,6 +523,8 @@ struct tmem_op {
> > >         } u;
> > >  };
> > > 
> > > +DEFINE_GUEST_HANDLE(uint64_t);
> > >     
> > 
> > The kernel uses uN style types rather than the uintN_t style ones,
> > although include/xen/interface/grant_table.h seems not to adhere to that
> > at the moment. It might be worth cleaning that up as you go passed.
> >   
> Thanks, I'd like to change it.
> 
> Thanks
> Annie
> > > +
> > >  #else /* __ASSEMBLY__ */
> > > 
> > >  /* In assembly code we cannot use C numeric constant suffixes. */
> > > --
> > > 1.7.6.4
> > > 
> > >     
> > 
> > 
> >   


