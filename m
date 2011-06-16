Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1FPKfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:35:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55613 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1FPKfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=SlC2+Li391ZKHzhC1O3PrTsSo6m8NQaI0o6ZslMmQjnbdWsw81nhZo7RbqKk/uj35I
         /o5dUAxo/E0JmAfrVMFVjHb/BeRqIdp8MxRW/7hFToC1J/jZSwn0dcdn84/efVEOquJO
         8IDMLSf8f3TVWjwO7NM/kVRnw1HGCCPK16GU4=
MIME-Version: 1.0
In-Reply-To: <18273.1308192226@jrobl>
References: <20110609125114.8dff08da.akpm@linux-foundation.org>
 <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk>
 <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl>
 <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl>
 <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com> <18273.1308192226@jrobl>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 16 Jun 2011 12:35:22 +0200
X-Google-Sender-Auth: 1ZtyV3zealnLyXDPHAQRhz9Q6e0
Message-ID: <BANLkTimhL5BG9gHOG0Fr9U5fLkE0NJvpng@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 04:43, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Michal Suchanek:
>> This is generally not possible in solutions that don't reserve any filename=
>> s.
>>
>> However, it should be possible to create whiteout of a non-existent
>> entry in a directory while it is locked without affecting userspace.
>
> Actually aufs generates a doubly whiteouted unique name dynamically for
> the target dir. For instance, when rmdir("dirA") aufs does,
> - lock i_mutex of the parent dir of dirA on the real fs
> - some verifycations for the parent-child relationship
> - some tests whether we can do rmdir
> - create whiteout for dirA
> - rename dirA to .wh..wh.XXXXXXXX (random value in hex), after making

Probably swap the two above, you can't make a whiteout in presence of
the directory, right?
Anyway, you could just mark dirA as whiteout and remove any whiteouts
contained in it asynchronously, and only jump through these hoops when
trying to create a new entry in place of non-empty whiteout, or sync
on emptying the old whiteout before making a new entry.

>  sure the name doesn't exist
> - unlock the parent dir
> - return to VFS
> And then the async workqueue removes the .wh..wh.XXXXXXXX dir with some
> whiteouts under it.
>
> It means the temporary whiteout name is,
> - always unique
> - always hidden (from users), even if it remains accidentally
> So even if an error happens in the async work, it doesn't matter.

Yes, it can only cause pollution with whiteouts unrelated to any files
that ever existed which is not too much of an issue unless people want
to add random stuff to the lower layer and see it in the union when
they reconstruct it again.

>
> Additionally there is a userspace script called "auchk" which is like
> fsck for real fs. auchk script checks the logical consistency on the
> (writable) real fs, and removes the illegal whiteouts, remained
> pseudo-links, and remained temp files.
>
>
>> As an alternative way to perform atomic renames I would suggest
>> "fallthrough symlinks". If you want to rename an entry which is
>
> Symlink?
> Is it a different thing from DCACHE_FALLTHRU in UnionMount?

Yes, the fallthru in unionmount only says "look below here", it cannot
point to a  different place in the filesystem.

> I am afraid a special symlink is fragile or dangerous.
> Its special meaning is valid in inner union world only, is it? If

It is only valid when in the upper layer of a union. However, so is
whiteout, and so are files that were visible in the union but are not
visible in the top layer if examined separately, outside of the union.

It must be accepted that the top layer is different from the union,
otherwise you want a copy, not a union.

> something in outer world gets changed, we may not follow the symlink
> anymore or follow something different unexpectedly. Is it acceptable?

That' the whole idea behind symlinks, and also unions which implicitly
link the lower layer into the upper to present the result as a single
directory tree.

Anyway, the motivation behind the "fallthru symlink" is that you need
not copy-up on seemingly trivial operations like rename, touch, etc.
which both makes them more efficient and easier to get atomic. As I
understand it copy-up is the operation that causes the most issues and
with "fallthru symlinks" you need it only for operations that are
expected to modify something non-trivially.

Obviously, this is not so nice for zero sized files but they should be
handled the same way for consistency I guess. Also metada that can be
conveniently recorded on the fallthru entry would make touch fast but
would hide possible later updates to the lower layer so it might be
not good solution for all use cases. For throwaway tmpfs, however, any
optimization counts.

Seriously, the overlayfs documents that it can have opaque directories
but I don't see what they would be used for. There is no way to turn a
directory opaque with normal userspace operation afaict.
It has no explicit fallthrus, at least not documented so to have any
level of consistency it should always check the lower layer because it
can grow some new directories when the union is deconstructed, offline
modified, and reconstructed (which is supported use case according to
the docs).

Thanks

Michal
