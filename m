Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1FORU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:20:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34798 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1FORU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iTar46bp7P8gCwnq9dE8uX/fbwpVzbRAkvTnwGANdwDEYJqBzY5nGl/ZRG4w+dGZNB
         UvLIbKMAHh1mqEbryrxmzoSH9eRzPu282/VE2OGoITv0sDZtSCt9SUAkqh9vwqgsKskQ
         8b0cTuOj3saRTKMBiSqWLKBOQIK0XhhDnmpy4=
MIME-Version: 1.0
In-Reply-To: <15402.1308154495@jrobl>
References: <20110609125114.8dff08da.akpm@linux-foundation.org>
 <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk>
 <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl>
 <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Wed, 15 Jun 2011 19:20:06 +0200
X-Google-Sender-Auth: Bw7eXVUUfz-Ssmc2GEX9p0WtRBI
Message-ID: <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com>
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

On 15 June 2011 18:14, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Miklos Szeredi:
>> Rollback on failure is an incomplete solution, rollback itself can fail.
>> And it doesn't protect against machine crashing in the middle of
>> operation.
>
> Maybe you are right.
> But do you think rollback is unnecessary since it is an incomplete
> solution?
>
> And you might not have read about the approach in aufs, which tries
> reducing the operations in rollback.
>
> (from '[RFC 2/8] Aufs2: structure' in 2009
>      <http://marc.info/?l=linux-kernel&m=123537453514896&w=2>)
> ----------------------------------------
> In aufs, rmdir(2) and rename(2) for dir uses whiteout alternatively.
> In order to make several functions in a single systemcall to be
> revertible, aufs adopts an approach to rename a directory to a temporary
> unique whiteouted name.
> For example, in rename(2) dir where the target dir already existed, aufs
> renames the target dir to a temporary unique whiteouted name before the

This is generally not possible in solutions that don't reserve any filenames.

However, it should be possible to create whiteout of a non-existent
entry in a directory while it is locked without affecting userspace.

> actual rename on a branch and then handles other actions (make it opaque,
> update the attributes, etc). If an error happens in these actions, aufs
> simply renames the whiteouted name back and returns an error. If all are
> succeeded, aufs registers a function to remove the whiteouted unique
> temporary name completely and asynchronously to the system global
> workqueue.

Removing the whiteout asynchronously does not seem like a good idea.
It should be gone before the directory containing the whiteout is
unlocked. Otherwise there might be an entry created which conflicts
with this whiteout that did not exist when the operation started. Also
if you unlock the directory while the artifical whiteout exists an
asynchronous process might replace the whiteout and the rollback would
fail.

As an alternative way to perform atomic renames I would suggest
"fallthrough symlinks". If you want to rename an entry which is
"fallthrough" (ie pointing to the entry with the same name in the
lower layer in the same directory) you can replace it with a
"fallthrough symlink" which points to the lower layer and does not
just implicitly say "here" but specifies a path relative to the
mountpoint instead. This can then be moved like any other entry. it is
in no way special anymore. Moving a directory tree which is partially
in the upper layer is still time-consuming but can be performed with
reasonable semantics imho. You perform a preparation step during which
nothing seems to change from the user's point of view and at the very
end you just move the directory.

Thanks

Michal
