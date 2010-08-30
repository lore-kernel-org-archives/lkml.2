Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0H3Lki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:40:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:32981 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab0H3Lkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:40:37 -0400
Date: Mon, 30 Aug 2010 21:40:27 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100830214027.77e197f5@notabene>
In-Reply-To: <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	<20100829144207.4fbf2713@notabene>
	<E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 12:18:11 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Sun, 29 Aug 2010, Neil Brown wrote:
> > On Fri, 27 Aug 2010 18:53:45 +0200
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > On Fri, 27 Aug 2010, Neil Brown wrote:
> > > > I was wondering why you even bothered to fiddle st_ino.  Given
> > > > that lots of other things come from one fs or the other, having
> > > > the merged directories appear to be from the upper filesystem
> > > > doesn't seem like a problem.  I don't really care either way
> > > > though.
> > > 
> > > "rm -rf" complains if st_ino of a directory changes spontaneously.
> > 
> > I see...
> > Doesn't that mean that you must always present a merged-directory if the
> > lower directory exists.
> 
> Directory opens are never "forwarded" to the lower filesystem like
> other opens.  One reason is that lookups continuing from the file's
> path need to be on the union filesystem instead on one of the
> underlying filesystems.

You're right - I misread the code there.

> > > I think it's best to leave that stuff until someone actually cares.
> > > The "people might find it useful" argument is not strong enough to put
> > > nontrivial effort into thinking about all the weird corner cases.
> > 
> > My thought on this is that in order to describe the behaviour of the
> > filesystem accurately you need to think about all the weird corner cases.
> > 
> > Then it becomes a question of: is it easier to document the weird behaviour,
> > or change the code so the documentation will be easier to understand?
> > Some cases will go one way, some the other.
> > 
> > But as you suggest this isn't urgent.
> 
> You didn't mention one possibility: add limitations that prevent the
> weird corner cases arising.  I believe this is the simplest option.

Val has been following that approach and asking if it is possible to make an
NFS filesystem really-truly read-only. i.e. no changes.
I don't believe it is.

But I won't pursue this further without patches.


> > My comment about set-theory unions being commutative set me thinking.  I
> > really don't think "union" is the right name for this thing.  There is
> > nothing about it which really fits that proper definition of a union.
> > whiteouts mean that even the list of names in a directory is not the union of
> > the lists of names in the upper and lower directories.
> > "overlay" is a much more accurate name.  But union seems to be the name
> > that is most used.  I wonder if it is too late to change that.
> 
> We could call it overlayfs.  People learn new names quickly :)

+1

> 
> > Also, dnotify (and presumably inotifiy) doesn't work reliably in the current
> > implementation.
> > It works for opaque directories and those which don't have a namesake in the
> > lower filesystem, but for others it never notifies of changes to any files in
> > the directory.
> > This is because dnotify will set an fsnotifier on the merged-directory in the
> > union-fs, but the change happens to the file in the upper fs, so
> > fsnotify_parent will only call notifiers on the parent in the upper fs.
> 
> I think *notify will work correctly, every modificaton will be
> notified on both the union fs and the upper fs.  But I haven't tested
> this yet.

I tried.  It doesn't.
To be precise:  directory changes like file creation (even creation of a file
that already exists) get notified, but purely file-based event like modifying
the contents of the file don't generate events back to the overlayfs
directory.
Because an open (for write) of a file is passed through to the upper
filesystem, the notifications of modification through that open only go to the
upper filesystem.

Thanks,
NeilBrown
