Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab2ILPS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:18:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34071 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759990Ab2ILPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:18:47 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] issues with NFS filesystems as lower layer
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
	<CAJfpegsCQKX==v-8NqO5tLDsEed7KhBFWpoeWLDjxT1vuMSokg@mail.gmail.com>
	<20120907193825.GA4633@fieldses.org>
	<87ipbkxoq3.fsf@tucsk.pomaz.szeredi.hu>
	<20120911214450.GB28418@fieldses.org>
Date: Wed, 12 Sep 2012 17:20:17 +0200
In-Reply-To: <20120911214450.GB28418@fieldses.org> (J. Bruce Fields's message
	of "Tue, 11 Sep 2012 17:44:50 -0400")
Message-ID: <87ehm7xo7i.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Tue, Sep 11, 2012 at 10:56:52PM +0200, Miklos Szeredi wrote:
>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>> 
>> >> > Secondly when using an NFSv3 R/O lower layer the filesystem permissions
>> >> > check refuses permission to write to the inode which prevents us from
>> >> > copying it up even though we have a writable upper layer.  (With an ext4
>> >> > lower layer the inode check will succeed if the inode  is writable even
>> >> > if the filesystem is not.)  It is not clear what the right solution is
>> >> > here.  One approach is to check the inode permissions only (avoiding the
>> >> > filesystem specific permissions op), but it is not clear we can rely on
>> >> > these for all underlying filesystems.  Perhaps this check should only be
>> >> > used for NFS.
>> >
>> > Then couldn't you for example end up circumventing ACLs on the
>> > underlying file to access data cached by reads from another user on the
>> > same system?
>> 
>> Ignoring ACL's should always give less access, isn't that right?
>
> Not necessarily.
>
> (It's up to the server--and if anything servers probably want to err on
> the side of returning mode bits that are an upper, not a lower, bound on
> the permissions.)

Okay, I looked at the POSIX ACL access check algorithm and now
understand things better.

Now i think that enforcing ACL's on the overlay is not possible if ACL's
are not copied up together with the data.

This is because during the copy-up the server checks for access, but it
checks access for only a single user/group pair.  Subsequent access
checks on the copied-up object by any other user/group may not reflect
the original ACL's on the lower filesystem.

So assuming that we can't copy up NFS ACL's, it is possible to
circumvent those ACL's by triggering a copy-up.  Of course this type of
"attack" is limited by the fact that copy-up is only triggerable by a
write type operation.

I'm not sure...  I believe that we should say that NFS ACL's on the
lower layer and overlayfs simply don't mix.  In that case current
behavior of erroring out seems to be the correct one.

Andy, I'm wondering: what is your use case for NFS with ACL's?

Because overlayfs can't completely ignore ACL's on the lower filesystem,
but it can't enforce them properly either.  So it's a rather weird
situation.


>
>> > Is it possible to arrange that the check for a readonly filesystem be
>> > done only by the vfs and not also by ->permission?
>> 
>> You'd need to modify NFS servers for that to work, no?  It's possible
>> but not practical.
>
> Oh, OK, I guess I assumed you were dealing with an NFS filesystem that
> had been mounted readonly on the NFS client.
>
> If it's a read-write mount of a filesystem that's read-only on the
> server side: well, there is at least an error for that case: the server
> should return NFSERR_ROFS, and you should see EROFS--could you do the
> copy-up only in the case you get that error?

If the server returns EROFS then all you know is that the filesystem is
read-only.  But that's not what we are interested in.  We are interested
in whether the access would be allowed *if* the filesystem *wasn't*
read-only.  The server doesn't tell us that.

Thanks,
Miklos
