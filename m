Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab2ILQHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:07:54 -0400
Received: from fieldses.org ([174.143.236.118]:36747 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab2ILQHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:07:50 -0400
Date: Wed, 12 Sep 2012 12:07:48 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] issues with NFS filesystems as lower layer
Message-ID: <20120912160748.GF3009@fieldses.org>
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
 <CAJfpegsCQKX==v-8NqO5tLDsEed7KhBFWpoeWLDjxT1vuMSokg@mail.gmail.com>
 <20120907193825.GA4633@fieldses.org>
 <87ipbkxoq3.fsf@tucsk.pomaz.szeredi.hu>
 <20120911214450.GB28418@fieldses.org>
 <87ehm7xo7i.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehm7xo7i.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 05:20:17PM +0200, Miklos Szeredi wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Tue, Sep 11, 2012 at 10:56:52PM +0200, Miklos Szeredi wrote:
> >> "J. Bruce Fields" <bfields@fieldses.org> writes:
> >> 
> >> >> > Secondly when using an NFSv3 R/O lower layer the filesystem permissions
> >> >> > check refuses permission to write to the inode which prevents us from
> >> >> > copying it up even though we have a writable upper layer.  (With an ext4
> >> >> > lower layer the inode check will succeed if the inode  is writable even
> >> >> > if the filesystem is not.)  It is not clear what the right solution is
> >> >> > here.  One approach is to check the inode permissions only (avoiding the
> >> >> > filesystem specific permissions op), but it is not clear we can rely on
> >> >> > these for all underlying filesystems.  Perhaps this check should only be
> >> >> > used for NFS.
> >> >
> >> > Then couldn't you for example end up circumventing ACLs on the
> >> > underlying file to access data cached by reads from another user on the
> >> > same system?
> >> 
> >> Ignoring ACL's should always give less access, isn't that right?
> >
> > Not necessarily.
> >
> > (It's up to the server--and if anything servers probably want to err on
> > the side of returning mode bits that are an upper, not a lower, bound on
> > the permissions.)
> 
> Okay, I looked at the POSIX ACL access check algorithm and now
> understand things better.
> 
> Now i think that enforcing ACL's on the overlay is not possible if ACL's
> are not copied up together with the data.

And the NFSv4 case is different (it doesn't use "posix" acls), etc.,
etc.

But forget all that, even mode bits aren't much use since you don't
understand how the server might be mapping your uid, so you don't know
whether you're the owner, or a member of the group.

On the other hand, for some cases maybe what you want is to just forget
all that and trust the file owners and mode bits, so maybe that's useful
at least as an option.

> > Oh, OK, I guess I assumed you were dealing with an NFS filesystem that
> > had been mounted readonly on the NFS client.
> >
> > If it's a read-write mount of a filesystem that's read-only on the
> > server side: well, there is at least an error for that case: the server
> > should return NFSERR_ROFS, and you should see EROFS--could you do the
> > copy-up only in the case you get that error?
> 
> If the server returns EROFS then all you know is that the filesystem is
> read-only.  But that's not what we are interested in.  We are interested
> in whether the access would be allowed *if* the filesystem *wasn't*
> read-only.  The server doesn't tell us that.

Yeah.  I wonder if it would be reasonable in the future to let servers
tell us that.

--b.
