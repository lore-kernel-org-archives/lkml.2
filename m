Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2GBMNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:13:24 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:37449 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2GBMNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:13:22 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Chinmay V S <cvs268@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Date: Mon, 02 Jul 2012 15:13:17 +0300
Message-ID: <6810708.ZQq4lbXqoi@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-26-generic; KDE/4.8.3; i686; ; )
In-Reply-To: <CAK-9PRBiqtyiQahunPex9FT2dtKA0k0gv9PR+=sNCXVvn5Bn9Q@mail.gmail.com>
References: <2325453.OX7ktP55U1@vlad> <1793005.iSx5GbFPJq@vlad> <CAK-9PRBiqtyiQahunPex9FT2dtKA0k0gv9PR+=sNCXVvn5Bn9Q@mail.gmail.com>
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

On Sunday 01 July 2012 17:24:34 Chinmay V S wrote:
> Played around with __read_mostly some time back in an attempt to optimise
> cache usage.
> thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.html

Nice article!

> 
> I concluded that in the current form, it is hard to limit the negative
> effects (bunching of write-mostly sections). IMHO, the potential
> costs/benefits of __read_mostly are closely related to the associativity of
> the cpu-cache. This differs vastly across different platforms. Hence (again
> IMHO), better to avoid usage of__read_mostly in cross-platform generic
> kernel code.

U see, if we assume that __read_mostly the way it's currently implemented is a 
bad thing (due to the fact that it implicitly causes the bunching of the 
write-mostly variables) than this means that "const" the way it's currently 
implemented is a bad thing too due to the same reasons. ;)

I'm not saying that your reasoning is completely wrong but it takes us to a 
completely different direction the current gcc tool chain is written today. If 
I extrapolate your idea it will bring us to the following:
 - no const data section. 
 - no read_mostly data section.
 - all const and non-const data resides at the same section and the linker 
tries to pack const and non-const variables together in order to minimize 
false cache line sharing. 

This is an interesting idea however there is (at least) one weakness in it - 
it assumes that linker's heuristics (those that will pack cons and non-const 
variables together in a single cache line) will do a better job than a person 
that writes a specific code section and knows the exact nature and the 
relationship between variables in his/her C code. 

I think that the current gcc tool chain implementation and kernel's linker 
scripts follows the second paradigm and leave a programmer a freedom to decide 
what is a nature of the variables and a packing strategy he/she prefers and 
then (linker) performs the most straight forward optimizations as possible on 
top of those decisions. 
By decisions I meant: 
 - defining variables as const.
 - defining variables as __read_mostly (which is quite similar to "const").
 - declaring per_cpu variables.
 - packing variables into structs and unions.
 - defining a proper alignment for the variables.
 - etc.

By linker optimizations I meant:
 - Packing all constants and __read_mostly variables into a separate data 
section.
 - Packing the per_cpu variables into a separate section.
 - Packing the variables according to the programmer's alignment definition.
 - etc.

Let's get back to the theoretical example of the code that was hammered by the 
usage of the __read_mostly variables that u are referring. 

First of all, let me note that saying that C code performance may benefit from 
NOT using the __read_mostly variables is a bit misleading because here u rely 
on something that is not deterministic: a linker decision to pack one (often 
written) variable together with another (read mostly) variable in a single 
cache line boundaries (thus improving the performance); and this decision may 
change due to a minor code change and u will not know about it. 

So, if there is a code which performance may be harmed by defining one of the 
variables as __read_only (thus taking it out from the data section where it 
was to the read_mostly data section) than the same code may be harmed by 
simply adding/removing a regular variable that will lead to the same 
phenomena.

After saying all that what should we conclude? Not to add/remove new/old 
variables because they can harm the performance of bad-formed code? How can we 
write new code then?

I think u would agree that the right solution for the problem above would be 
to fix the mentioned above code the way it won't depend on linker's decisions 
(probably by properly aligning the highly contended variables or by re-basing 
the variables into the appropriate groups spreading the contention pressure 
between these groups). And if we do so (surprise!!!) its performance won't be 
harmed by defining any read mostly variable as __read_mostly any more... ;)

I agree that there might be a few places in kernel that suffer from the 
weakness described above. That's why it's important to add __read_mostly in 
small portions (even one by one) in order to ease the bisect if and when the 
performance regression occurs.

Pls., comment.

thanks,
vlad



> 
> regards
> ChinmayVS
> 
> On Sun, Jul 1, 2012 at 5:04 PM, Vlad Zolotarov <vlad@scalemp.com> wrote:
> > On Sunday 10 June 2012 12:36:52 Vlad Zolotarov wrote:
> > > On Thursday 07 June 2012 17:07:21 Andrew Morton wrote:
> > > > On Mon, 28 May 2012 14:58:42 +0300
> > > > 
> > > > Vlad Zolotarov <vlad@scalemp.com> wrote:
> > > > > From: Shai Fultheim <shai@scalemp.com>
> > > > > 
> > > > > bh_cachep is only written to once on initialization, so move it to
> > 
> > the
> > 
> > > > > __read_mostly section.
> > > > > 
> > > > > Signed-off-by: Shai Fultheim <shai@scalemp.com>
> > > > > Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> > > > > ---
> > > > > 
> > > > >  fs/buffer.c |    2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/buffer.c b/fs/buffer.c
> > > > > index ad5938c..838a9cf 100644
> > > > > --- a/fs/buffer.c
> > > > > +++ b/fs/buffer.c
> > > > > @@ -3152,7 +3152,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long,
> > > > > data)
> > > > > 
> > > > >  /*
> > > > >  
> > > > >   * Buffer-head allocation
> > > > >   */
> > > > > 
> > > > > -static struct kmem_cache *bh_cachep;
> > > > > +static struct kmem_cache *bh_cachep __read_mostly;
> > > > 
> > > > hm, I thought I replied to this earlier, but I can't find that email.
> > > > 
> > > > Yes, bh_cachep is read-mostly.  In fact it's write-once.  But the same
> > > > is true of all kmem_cache*'s.  I don't see any particular reason for
> > > > singling out bh_cachep.
> > > > 
> > > > 
> > > > Alas, I don't see a smart way of addressing this.  It's either a
> > > > patchset which adds __read_mostly to all kmem_cache*'s, or a patchset
> > > > which converts all the definitions to use some nasty macro which
> > > > inserts the __read_mostly.
> > > 
> > > Well, it may be done. However my ability to properly check it is limited
> > 
> > as
> > 
> > > I have only a certain number of systems to check it on. I can create the
> > > patch, test it in our labs and post it on this mailing list with request
> > 
> > to
> > 
> > > test it on other platforms (like non-x86 platforms). However we may also
> > > hit the problem u describe below if do so...
> > > 
> > > > And I still have theoretical concerns with __read_mostly.  As we
> > > > further sort the storage into read-mostly and write-often sections,
> > > > the
> > > > density of writes in the write-mostly section increases.  IOW,
> > > > removing
> > > > the read-mostly padding *increase* cross-CPU traffic in the
> > > > write-often
> > > > scction.  IOW2, leaving the read-mostly stuff where it is provides
> > > > beneficial padding to the write-often fields.  I don't think it has
> > > > been shown that there will be net gains.
> > > 
> > > Great explanation! The above actually nicely concludes (maybe u haven't
> > > actually meant that ;)) why defining write-mostly section(s) is
> > 
> > pointless.
> > 
> > > ;)
> > > 
> > > This is a main topic of this (
> > 
> > http://markmail.org/thread/wl4lnjluroqxgabf)
> > 
> > > thread between me and Ingo.
> > > 
> > > However there is a clear motivation to define a read-mostly section(s)
> > 
> > just
> > 
> > > the same way there is a motivation to put constants separately from non-
> > > constant variables which I don't think anybody argues about. ;)
> > > 
> > > On the other hand, generally speaking, if we "complete the task" and put
> > 
> > ALL
> > 
> > > read-mostly variables into a separate section all the variables that
> > 
> > would
> > 
> > > be left will actually represent the write-mostly section, which we would
> > > prefer not to have (according to u). Yet we are still far from it
> > 
> > today...
> > 
> > > ;)
> > > 
> > > Unfortunately, we can't consider all types of bad C-code then we define
> > > something like "const" or "__read_mostly". We do our best. And if
> > > someone
> > > haven't defined a per-CPU write-mostly variable in order to prevent
> > > heavy
> > > cross-CPU traffic in his/her code (like in your example above) we can
> > 
> > only
> > 
> > > try to fix this code. But I don't think that the existence of such code
> > > shell imply that the whole idea of __read_mostly section is actually bad
> > 
> > or
> > 
> > > useless. It's this bad C-code that should be fixed and IMHO padding the
> > > variables with constants is not the proper way to fix it...
> > > 
> > > That's why I think it could be dangerous to go ahead and patch all
> > 
> > variables
> > 
> > > of a certain sort (like kmem_cache*'s) with __read_mostly as we may mess
> > > the things up in some places (like in your example above) where there
> > > should be done a deeper code analysis than just pattern matching.
> > > 
> > > So, getting back to the first section of my reply, do u still think we
> > 
> > want
> > 
> > > to patch all kmem_cache*'s with __read_mostly this time or we would
> > 
> > prefer
> > 
> > > this to be done incrementally in order to have better
> > > regression-ability?
> > > 
> > > Pls., comment.
> > 
> > Andrew, could u., pls., update what should be our next steps concerning
> > this
> > patch?
> > 
> > thanks,
> > vlad
> > 
> > > thanks in advance,
> > > vlad
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > 
> > in
> > 
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
