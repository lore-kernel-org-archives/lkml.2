Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab1DXVse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:48:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47919 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab1DXVsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ocfZjvdFmqRzY9fbNyIJ5Ba1xtigeXvpxkswGBSy3NVInWX+q+IDfZUg1ycl5gYvKx
         fPzd+Sy7Zdyu4SfsmDHXOKDfxlUr077UwEyy9Dw7HQ4iiMONZUVqg3gfohXEDHn3Nn7X
         bmTXTXxr0mQ4YEFMyWXpII/RDrOygP5K7l7Qg=
MIME-Version: 1.0
In-Reply-To: <8873.1303391374@redhat.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
	<1264.1301495438@redhat.com>
	<AANLkTi==rGJLQfDXohFZwqCT3m27XWUB4sASzomHWCor@mail.gmail.com>
	<8873.1303391374@redhat.com>
Date: Sun, 24 Apr 2011 14:48:31 -0700
Message-ID: <BANLkTinS2XXD4atoGdun7kp=_XVE2RFgrg@mail.gmail.com>
Subject: Re: [PATCH 00/74] Union mounts version something or other
From: Valerie Aurora <valerie.aurora@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 6:09 AM, David Howells <dhowells@redhat.com> wrote:
> Valerie Aurora <valerie.aurora@gmail.com> wrote:
>
>> That's never up to date, but I just fixed it.  The branch you want is
>> "ext2_cleanup".  Any branch with "+" at the front is a mistake from
>> trying to do a git push of a rebased branch.  I deleted it.
>
> Okay, I've got that pulled up to Linus's head branch.  I've mostly got the RCU
> pathwalk and managed dentry stuff correctly entangled.

Awesome, thanks!

> However, I have a few questions:
>
>  (1) Is it meant to be possible to unionmount over a mount tree rather than
>     just a single mount?  I ask because do_lookup_union() calls
>     __follow_mount().

It's meant to allow mounting over a mount tree, as long as all the
mounts are read-only.   I don't recall the difference between
__follow_mount() and follow_mount() at this moment, but that code may
be left over from the time that we could only union mount a single
mount.

Think about it carefully though, and check my comments, and run the
union mounts test suite - I got this wrong a few times and added a
number of tests to make sure the mount point case is right.

>  (2) When you open a file that exists in the lower layer but not the top
>     layer, am I right in thinking that f_path points to the lower layer file?

If the file is opened read-write, then it is copied up and the f_path
points to the upper layer file.  If the file is opened read-only, then
it is not copied up and the f_path points to the lower layer file.
So, yes, f_path points to the lower layer file.

>  (3) If I'm correct in (2), I presume something must intercept fchown() and
>     suchlike?

There's a thread somewhere on this, hang on...

http://kerneltrap.org/mailarchive/linux-fsdevel/2010/3/29/6897953/thread

Basically, if you open the file read-write and do an fchown() on it,
it works fine because the file is copied up on open.  If you open the
file read-only and fchown() it (yes, that's permitted) then in union
mounts you will get EPERM or EBADF (don't recall which).  Actually
implementing this requires copy-up after open, which requires atomic
update of the struct file pointer, which is ugly and painful and what
we were trying to avoid in the first place.

I discussed this with Al and Christoph and the consensus was along the
lines of, "What?  You can do that?  POSIX is so stupid.  Yes, we don't
care if union mounts returns EPERM in this case that no one thinks
should work anyway."

If you can find a way to do this cleanly, hurray.  Otherwise the
current code works for fchown/fchmod/utimensat already in the open
read-write case.

>  (4) I presume IS_DIR_UNIONED() only gives true on the upper layer (the one
>     that was mounted -o union)?

Yes.  It maybe should be renamed...

Thanks,

-VAL
