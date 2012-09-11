Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2IKVo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:44:56 -0400
Received: from fieldses.org ([174.143.236.118]:60328 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2IKVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:44:53 -0400
Date: Tue, 11 Sep 2012 17:44:50 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] issues with NFS filesystems as lower layer
Message-ID: <20120911214450.GB28418@fieldses.org>
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
 <CAJfpegsCQKX==v-8NqO5tLDsEed7KhBFWpoeWLDjxT1vuMSokg@mail.gmail.com>
 <20120907193825.GA4633@fieldses.org>
 <87ipbkxoq3.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipbkxoq3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 10:56:52PM +0200, Miklos Szeredi wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> >> > Secondly when using an NFSv3 R/O lower layer the filesystem permissions
> >> > check refuses permission to write to the inode which prevents us from
> >> > copying it up even though we have a writable upper layer.  (With an ext4
> >> > lower layer the inode check will succeed if the inode  is writable even
> >> > if the filesystem is not.)  It is not clear what the right solution is
> >> > here.  One approach is to check the inode permissions only (avoiding the
> >> > filesystem specific permissions op), but it is not clear we can rely on
> >> > these for all underlying filesystems.  Perhaps this check should only be
> >> > used for NFS.
> >
> > Then couldn't you for example end up circumventing ACLs on the
> > underlying file to access data cached by reads from another user on the
> > same system?
> 
> Ignoring ACL's should always give less access, isn't that right?

Not necessarily.

(It's up to the server--and if anything servers probably want to err on
the side of returning mode bits that are an upper, not a lower, bound on
the permissions.)

> > Is it possible to arrange that the check for a readonly filesystem be
> > done only by the vfs and not also by ->permission?
> 
> You'd need to modify NFS servers for that to work, no?  It's possible
> but not practical.

Oh, OK, I guess I assumed you were dealing with an NFS filesystem that
had been mounted readonly on the NFS client.

If it's a read-write mount of a filesystem that's read-only on the
server side: well, there is at least an error for that case: the server
should return NFSERR_ROFS, and you should see EROFS--could you do the
copy-up only in the case you get that error?

--b.

> 
> Thanks,
> Miklos
> 
> 
> 
> >
> > --b.
> >
> >> > Perhaps it needs to be a mount option.  The second patch
> >> > (for discussion) following this email implements this, using the inode
> >> > permissions when the lowerlayer is read-only.  This seems to work as
> >> > expected in my limited testing.
> >> 
> >> I fear that will create an inconsistency between the read-only and the
> >> non-read-only case, even though both should behave the same.
> >> 
> >> I think the cleanest would be to create a mount option to always use
> >> generic_permission (on both the lower and the upper fs).  That would
> >> give us two, slightly different, operating modes but each would be
> >> self consistent.
> >> 
> >> Thanks,
> >> Miklos
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
