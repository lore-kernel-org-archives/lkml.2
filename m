Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab1ELRk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:40:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57047 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab1ELRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:40:56 -0400
Date: Thu, 12 May 2011 18:40:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [GIT PULL] fuse fix for 2.6.39
Message-ID: <20110512174029.GB19987@ZenIV.linux.org.uk>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu>
 <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
 <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com>
 <1305217732.15566.31.camel@lade.trondhjem.org>
 <BANLkTikBVAJSmBZrAvJ6fRQD32TFNeO4zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikBVAJSmBZrAvJ6fRQD32TFNeO4zQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:21:21AM -0700, Linus Torvalds wrote:
> On Thu, May 12, 2011 at 9:28 AM, Trond Myklebust
> <Trond.Myklebust@netapp.com> wrote:
> >
> > NFS also requires look up using the full 'struct path' if/when we happen
> > upon an automount point (i.e. if we cross into a submounted filesystem
> > on the server or if we encounter an NFSv4 referral). Again, this is
> > something that lookup_one_len() can't do.
> 
> Sure. But we might not want to oops. Would you be willing to try
> ecryptfs over NFS to at least make it limp along?

IMO that's crap; not the part about not wanting an oops, but lookup_one_len()
one.  We do *NOT* want to pass nameidata all over the place; that had been
a mistake in the first place.  Proper solution will have to wait one more
cycle, but it's going to be along the lines of "pass struct file * explicitly
on the last component handling; screw nameidata for everything else for old
methods".  We already have the call sites (almost) separated in namei.c and
I'm going to finish that come the next cycle.  Again, the long-term solution
will have ->d_revalidate() and ->lookup() *lose* struct nameidata * argument,
with new method used in place of ->open() for the last component.  Defaulting
to the current sequence, yes, but NFS will be a lot more comfortable using
it instead of the Cthulhu-scaring kludges it relies upon now.  At the same
point ecryptfs will have one more method to pass through to the underlying
fs.  And nameidata will be passed only to ->follow_link(), where it's
inevitable.  I hoped to do (and debug) that during the last cycle, but
do_last() got mutilated by Nick's patchset and during this cycle I was
MIA completely.  Sorry, but that'll have to wait until .40 ;-/

Again, lookup_one_len() (and not having nameidata anywhere in sight) is
right and proper.
