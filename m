Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0IGPKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:10:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0IGPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:10:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: BKL status?
Date: Tue, 7 Sep 2010 17:10:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jan Blunck <jblunck@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org
References: <20100824134931.GA30883@merkur.ravnborg.org> <201008241637.28279.arnd@arndb.de> <20100907132725.GB5375@nowhere>
In-Reply-To: <20100907132725.GB5375@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009071710.40669.arnd@arndb.de>
X-Provags-ID: V02:K0:3rd5QYAnEabNg/jQ/bDH3aNt5QeIlCGruElESalYB8x
 2OICXqg99gBrhw9c31xhtLi3BDWrS5qwElkyNe3o2BNhzEvc0H
 gq4YmpJsHxpROpbM/2zVtyre9p4izWFxSTEyTs3zOmub1mMmjr
 /dhKqZLFulptiYJJf6eeSnYI0/JqCQ6jFzAH7tS0Ov4PaPlmdV
 JVQoqbiTMR1sKdLvlmk1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010, Frederic Weisbecker wrote:
> On Tue, Aug 24, 2010 at 04:37:28PM +0200, Arnd Bergmann wrote:
> > We should probably plan how to proceed with that stuff now and get it
> > into -next as soon as possible.
> 
> (Adding Thomas and John in Cc)
> 
> Right. So there is:
> 
> - llseek
> - superblock:mount (Jan Blunck's patches to rebase and repost and apply)
> - v4l

v4l is actually two pieces: first the pushdown, then the removal.
Neither is hard, but both are a lot of work.

> - fs/locks, the hardest part

I talked to both Trond and Bruce (added to Cc) about fs/lockd, they said
it should be possible to split the locking such that lockd takes the 
file_lock_lock whenever it locks against fs/locks.c but keeps the BKL
for its internal locking. That should cut the gordian knot and let
us build a kernel (with both NFS and NFSD disabled) that does not use
the BKL. The next logical step is then to replace the BKL in lockd
with a private spinlock or mutex, but that will be much simpler than
it is now and we can do it at any time.

FWIW, the discussion from the last time I posted a patch is archived
at http://www.spinics.net/lists/linux-fsdevel/msg34346.html .
The patch itself is, as hch mentioned not acceptable for mainline, but
I would actually like to get it into -next and -rt as an intermediate
step, until Trond and Bruce find a better solution.

> - individual drivers

We have two categories here. There are a large number of trivial
drivers where we can prove that the BKL can get replaced with a
private mutex, as my 'trivial' branch in g.k.o:bkl.git does.

Then there are some modules that are actually hard to do, most
of them obsolete. Judging purely by the number of number of
lock_kernel() calls, which is somewhat misleading, the main
offenders are:

drivers/{media,staging,usb/gadget,char/raw}
fs/{autofs,coda,hpfs,isofs,ncpfs,nfs,smbfs,udf,ufs}
net/{appletalk,ipx,irda,ax25}

Out of these, we definitely need to fix v4l, isofs and nfs
to have a chance of disabling the BKL in a distro kernel.
But first things first, once fs/lockd is done, we are
at the point where all remaining BKL users are in modules.

> Now I should start to merge the llseek patches. I'm a bit scared by the
> automated conversions, I'm not sure Linus is going to pull that. But we
> can have a seperate branch for that and look at his reaction on an independant
> pull request.

Linus has merged tree-wide changes like this before, but we should ask
him his opinion first, not just on in the merge window. I don't think it's
much of a problem because hch specifically requested to do it this way.
The change is definitely useful, but we only require the trivial patch
that changes default_llseek to use i_mutex instead of the BKL, so if Linus
doesn't like the big change, he could override Christoph and just take
the small patch I initially proposed ;-)
 
> I can rebase my big v4l pushdown.

Mauro, do you agree with the approach of the pushdown? v4l is now by far
the biggest user of the BKL and we should do something about it by the
next merge window. The pushdown gets us one step in the right direction
(I hope), but there is more work to be done there. Do you have other patches
pending for this that would conflict with pushdown.


Finally, I'm not sure about my CONFIG_BKL patch. I will update it to
the latest series and then ask Linus and others for their opinion on it.
I see multiple options for it, which all have their advantages:

1. Don't apply this patch until we removed the BKL from all code that
is being actively used/maintained, then mark the remaining users as
BROKEN_ON_SMP and delete the BKL definition.

2. Turn the BKL into a module-only option on (SMP || PREEMPT), mark
all users as 'depends on BKL' and add a taint the kernel when loading
this module, printing the name of the module that uses it. This would
mainly serves to put the remaining users on the public shame list.

3. Introduce CONFIG_BKL as a bool option and make all users depend on
it. This is what my patch does today, though the list of users is
outdated and I need to update it.

4. Introduce CONFIG_BKL as a silent bool option and make all users
select it. This would be the least confusing for users (no options
to choose, everything keeps working), but provides little incentive
for the rest to be fixed.

5. A combination of the above.

	Arnd
