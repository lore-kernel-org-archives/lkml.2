Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0HUIaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 04:30:35 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16783 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab0HUIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 04:30:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO4qb0x5Ld90/2dsb2JhbACgP3K3IYJtgkoE
Date: Sat, 21 Aug 2010 18:30:24 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, adilger@sun.com,
        corbet@lwn.net, npiggin@kernel.dk, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100821083024.GB3448@amd>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100820083057.GA10039@infradead.org>
 <20100820195303.20b17210@notabene>
 <20100820115135.GQ31363@ZenIV.linux.org.uk>
 <20100821100900.4b15fe08@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821100900.4b15fe08@notabene>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I had both of the same concerns as Christoph with API
change and exposing symlink fds last time I looked at the patces,
actually.

But they can probably be worked around or avoided. I think the more
important thing is whether it is worth supporting. This is
all restricted to root (or CAP_DAC_READ_SEARCH) only, right, and
what exact semantics they want. I would like to see more discussion
of what this enables and some results.

For the case of avoiding expensive network revalidations in path name
lookup, do we even need to open symlinks? Could the security issues be
avoided by always having handle attached to an open fd?

On Sat, Aug 21, 2010 at 10:09:00AM +1000, Neil Brown wrote:
> [[email address for Nick Piggin changed to npiggin@kernel.dk]]
> 
> On Fri, 20 Aug 2010 12:51:35 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Fri, Aug 20, 2010 at 07:53:03PM +1000, Neil Brown wrote:
> > > On Fri, 20 Aug 2010 04:30:57 -0400
> > > Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > > Suddenly getting an file pointer for a symlink which could never happen
> > > > before is a really bad idea.  Just add a proper readlink_by_handle
> > > > system call, similar to what's done in the XFS interface.
> > > 
> > > Why is that?
> > > With futexes we suddenly get a file descriptor for something we could never
> > > get a file descriptor on before and that doesn't seem to be a problem.
> > > 
> > > Why should symlinks be special as the only thing that you cannot have a file
> > > descriptor for?  Uniformity of interface is a very valuable property.
> > 
> > You are welcome to review the codepaths around pathname resolution for
> > assumptions of presense of ->follow_link() and friends; there _are_
> > subtle cases and dumping your "opened symlinks" in there is far from
> > a trivial change.  Note that it affects more than just the starting
> > points of lookups; /proc/*/fd/* stuff is also involved.
> 
> So as I understand it you aren't rejecting the concept in principle, but you
> believe non-trivial code review is required before it can be considered an
> acceptable change?
> That's quite reasonable.  I hope to find time to have a look at the code.
> 
> > 
> > BTW, speaking of NULL pathname, linkat() variant that allows creating a link
> > to an opened file is also a very dubious thing; at the very least, you get
> > non-trivial security implications, since now a process that got an opened
> > descriptor passed to it by somebody else may create hardlinks to the sucker.
> 
> Fair comment, and while one could imagine ways around this (such as requiring
> some Capability to link an fd) they wouldn't be very elegant.
> But then nor is inventing a pile of new syscalls for doing different things
> with handles such as the list Aneesh posted.
> 
> Maybe a different approach is needed.
> 
> How about a new AT flag:  AT_FILE_HANDLE
> 
> Meaning is that the 'dirfd' is used only to identify a filesystem (vfsmnt) and
> the 'name' pointer actually points to a filehandle fragment interpreted in
> that filesystem.
> 
> One problem is that there is no way to pass the length...
> Options:
>    fragment is at most 64 bytes nul padded at the end
>    fragment is hex encoded and nul terminated
>    ??
> 
> I think I prefer the hex encoding, but I'm hoping someone else has a better
> idea.
> 
> NeilBrown
