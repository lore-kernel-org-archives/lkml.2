Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1FOSMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:12:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1FOSMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ZIlEbFCXzqGUda4sCOpUoF57hwBOZs1FTi1yx9z1j6LBw+k/1jDBmuyImw+7ggtzLq
         +gVYpws+q5BXPgH+DECgJdT3oBzGcvJHOS0s3Mr61AVitX3iG8sLPD0J33P3By3UL4//
         uZ5O2/08BVO5P3r9jDYJ0uo/ejc6N4hoebJ2E=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <20110609125114.8dff08da.akpm@linux-foundation.org>
	<BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com>
	<20110610100143.28037551@lxorguk.ukuu.org.uk>
	<8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl>
	<87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl>
	<BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com>
Date: Wed, 15 Jun 2011 20:12:49 +0200
In-Reply-To: <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com> (Michal
	Suchanek's message of "Wed, 15 Jun 2011 19:20:06 +0200")
Message-ID: <87r56vhske.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Suchanek <hramrach@centrum.cz> writes:

> On 15 June 2011 18:14, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>> For example, in rename(2) dir where the target dir already existed, aufs
>> renames the target dir to a temporary unique whiteouted name before the
>
> This is generally not possible in solutions that don't reserve any filenames.
>
> However, it should be possible to create whiteout of a non-existent
> entry in a directory while it is locked without affecting userspace.

Yes, creation of whiteout and renaming it to target or vice versa works
if target is non-directory.

Cases where this trick could make operations atomic:

 - create/mknod/symlink/link over whiteout
 - rename non-directory to whiteout
 - remove of non-directory with whiteout creation
 - copy up

Cases where atomicity is not possible with this:

 - mkdir over whiteout
 - rename directory to whiteout
 - rename where source needs whiteout
 - rmdir with whiteout creation


>> actual rename on a branch and then handles other actions (make it opaque,
>> update the attributes, etc). If an error happens in these actions, aufs
>> simply renames the whiteouted name back and returns an error. If all are
>> succeeded, aufs registers a function to remove the whiteouted unique
>> temporary name completely and asynchronously to the system global
>> workqueue.
>
> Removing the whiteout asynchronously does not seem like a good idea.
> It should be gone before the directory containing the whiteout is
> unlocked. Otherwise there might be an entry created which conflicts
> with this whiteout that did not exist when the operation started. Also
> if you unlock the directory while the artifical whiteout exists an
> asynchronous process might replace the whiteout and the rollback would
> fail.
>
> As an alternative way to perform atomic renames I would suggest
> "fallthrough symlinks". If you want to rename an entry which is
> "fallthrough" (ie pointing to the entry with the same name in the
> lower layer in the same directory) you can replace it with a
> "fallthrough symlink" which points to the lower layer and does not
> just implicitly say "here" but specifies a path relative to the
> mountpoint instead. This can then be moved like any other entry. it is
> in no way special anymore.

This is a nice idea, but doesn't have a lot to do with atomicity.  It
allows rename of non-pure upper directory (they return EXDEV currently).

> Moving a directory tree which is partially
> in the upper layer is still time-consuming but can be performed with
> reasonable semantics imho.

Shouldn't be time consuming, really.  The upper, mixed directory is
renamed and given a "trusted.overlay.redirect" attribute to show where
its lower directory resides.

Thanks,
Miklos
