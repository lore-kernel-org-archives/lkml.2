Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2GALee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 07:34:34 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:48168 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2GALea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 07:34:30 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Date: Sun, 01 Jul 2012 14:34:22 +0300
Message-ID: <1793005.iSx5GbFPJq@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-26-generic; KDE/4.8.3; i686; ; )
In-Reply-To: <55807110.YgdjxJAxpX@vlad>
References: <2325453.OX7ktP55U1@vlad> <20120607170721.474bd8d8.akpm@linux-foundation.org> <55807110.YgdjxJAxpX@vlad>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2012 12:36:52 Vlad Zolotarov wrote:
> On Thursday 07 June 2012 17:07:21 Andrew Morton wrote:
> > On Mon, 28 May 2012 14:58:42 +0300
> > 
> > Vlad Zolotarov <vlad@scalemp.com> wrote:
> > > From: Shai Fultheim <shai@scalemp.com>
> > > 
> > > bh_cachep is only written to once on initialization, so move it to the
> > > __read_mostly section.
> > > 
> > > Signed-off-by: Shai Fultheim <shai@scalemp.com>
> > > Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> > > ---
> > > 
> > >  fs/buffer.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/buffer.c b/fs/buffer.c
> > > index ad5938c..838a9cf 100644
> > > --- a/fs/buffer.c
> > > +++ b/fs/buffer.c
> > > @@ -3152,7 +3152,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long, data)
> > > 
> > >  /*
> > >  
> > >   * Buffer-head allocation
> > >   */
> > > 
> > > -static struct kmem_cache *bh_cachep;
> > > +static struct kmem_cache *bh_cachep __read_mostly;
> > 
> > hm, I thought I replied to this earlier, but I can't find that email.
> > 
> > Yes, bh_cachep is read-mostly.  In fact it's write-once.  But the same
> > is true of all kmem_cache*'s.  I don't see any particular reason for
> > singling out bh_cachep.
> > 
> > 
> > Alas, I don't see a smart way of addressing this.  It's either a
> > patchset which adds __read_mostly to all kmem_cache*'s, or a patchset
> > which converts all the definitions to use some nasty macro which
> > inserts the __read_mostly.
> 
> Well, it may be done. However my ability to properly check it is limited as
> I have only a certain number of systems to check it on. I can create the
> patch, test it in our labs and post it on this mailing list with request to
> test it on other platforms (like non-x86 platforms). However we may also
> hit the problem u describe below if do so...
> 
> > And I still have theoretical concerns with __read_mostly.  As we
> > further sort the storage into read-mostly and write-often sections, the
> > density of writes in the write-mostly section increases.  IOW, removing
> > the read-mostly padding *increase* cross-CPU traffic in the write-often
> > scction.  IOW2, leaving the read-mostly stuff where it is provides
> > beneficial padding to the write-often fields.  I don't think it has
> > been shown that there will be net gains.
> 
> Great explanation! The above actually nicely concludes (maybe u haven't
> actually meant that ;)) why defining write-mostly section(s) is pointless.
> ;)
> 
> This is a main topic of this (http://markmail.org/thread/wl4lnjluroqxgabf)
> thread between me and Ingo.
> 
> However there is a clear motivation to define a read-mostly section(s) just
> the same way there is a motivation to put constants separately from non-
> constant variables which I don't think anybody argues about. ;)
> 
> On the other hand, generally speaking, if we "complete the task" and put ALL
> read-mostly variables into a separate section all the variables that would
> be left will actually represent the write-mostly section, which we would
> prefer not to have (according to u). Yet we are still far from it today...
> ;)
> 
> Unfortunately, we can't consider all types of bad C-code then we define
> something like "const" or "__read_mostly". We do our best. And if someone
> haven't defined a per-CPU write-mostly variable in order to prevent heavy
> cross-CPU traffic in his/her code (like in your example above) we can only
> try to fix this code. But I don't think that the existence of such code
> shell imply that the whole idea of __read_mostly section is actually bad or
> useless. It's this bad C-code that should be fixed and IMHO padding the
> variables with constants is not the proper way to fix it...
> 
> That's why I think it could be dangerous to go ahead and patch all variables
> of a certain sort (like kmem_cache*'s) with __read_mostly as we may mess
> the things up in some places (like in your example above) where there
> should be done a deeper code analysis than just pattern matching.
> 
> So, getting back to the first section of my reply, do u still think we want
> to patch all kmem_cache*'s with __read_mostly this time or we would prefer
> this to be done incrementally in order to have better regression-ability?
> 
> Pls., comment.

Andrew, could u., pls., update what should be our next steps concerning this 
patch?

thanks,
vlad

> 
> thanks in advance,
> vlad
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
