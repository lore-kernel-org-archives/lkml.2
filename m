Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1GHPWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:22:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61240 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GHPWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:22:08 -0400
MIME-Version: 1.0
X-Originating-IP: [88.102.100.37]
In-Reply-To: <8739ig3k93.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
 <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu>
 <21324.1307677721@jrobl> <871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu> <8739ig3k93.fsf@tucsk.pomaz.szeredi.hu>
From: Tomas M <tomas@slax.org>
Date: Fri, 8 Jul 2011 17:21:20 +0200
Message-ID: <CAL1oBhrt38rSQHC03AZP5b3R=2PfguJ-VLQhPXX3aqtes3iUXw@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a patch to document these limitations.

Why would we need to 'document limitations' if we can use code which
DOESN'T IMPOSE the limitations? (read: aufs)

Believe me or not, OverlayFS will be pointless if there are any
limitations which make the final 'filesystem' work inconsistently from
the behavior expected by crazy applications, like KDE suite, for
example.

Inode number change (as mentioned in the 'non-standard' behavior
documentation) is a NO NO option, really, applications rely on that
more than you would expect!


Tomas M



On Fri, Jul 8, 2011 at 4:44 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
>> "J. R. Okajima" <hooanon05@yahoo.co.jp> writes:
>>> If I remember correctly, Miklos has mentioned about it like this.
>>> - overlayfs provides the same feature set as UnionMount.
>>> - but its implementation is much smaller and simpler than UnionMount.
>>>
>>> I agree with this argument (Oh, I have to confess that I don't test
>>> overlayfs by myself). But it means that overlayfs doesn't provide some
>>> features which UnionMount doesn't provide. I have posted about such
>>> features before, but I list them up again here.
>>> - the inode number may change silently.
>>> - hardlinks may corrupt by copy-up.
>>> - read(2) may get obsolete filedata (fstat(2) for metadata too).
>>> - fcntl(F_SETLK) may be broken by copy-up.
>>> - unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
>>>   open(O_RDWR).
>
> Here's a patch to document these limitations.
>
> Thanks,
> Miklos
> ----
>
> Subject: ovl: add limitation to documentation
>
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> J. R. Okajima noted some examples where overlayfs behaves differently
> from a standard filesystem.  Describe these cases in the documentation.
>
> Reported-by: "J. R. Okajima" <hooanon05@yahoo.co.jp>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  Documentation/filesystems/overlayfs.txt |   29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/Documentation/filesystems/overlayfs.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/filesystems/overlayfs.txt      2011-07-07 16:01:47.000000000 +0200
> +++ linux-2.6/Documentation/filesystems/overlayfs.txt   2011-07-08 14:16:44.000000000 +0200
> @@ -143,6 +143,9 @@ to the upper filesystem (copy_up).  Note
>  also requires copy_up, though of course creation of a symlink does
>  not.
>
> +The copy_up may turn out to be unnecessary, for example if the file is
> +opened for read-write but the data is not modified.
> +
>  The copy_up process first makes sure that the containing directory
>  exists in the upper filesystem - creating it and any parents as
>  necessary.  It then creates the object with the same metadata (owner,
> @@ -156,6 +159,27 @@ filesystem - future operations on the fi
>  overlay filesystem (though an operation on the name of the file such as
>  rename or unlink will of course be noticed and handled).
>
> +
> +Non-standard behavior at copy_up
> +--------------------------------
> +
> +The copy_up operation essentially creates a new, identical file and
> +moves it over to the old name.  The new file may be on a different
> +filesystem, so both st_dev and st_ino of the file may change.
> +
> +Any open files referring to this inode will access the old data and
> +metadata.  Similarly any file locks obtained before copy_up will not
> +apply to the copied up file.
> +
> +If a file with multiple hard links is copied up, then this will
> +"break" the link.  Changes will not be propagated to other names
> +referring to the same inode.
> +
> +Symlinks in /proc/PID/ and /proc/PID/fd which point to a non-directory
> +object in overlayfs will not contain vaid absolute paths, only
> +relative paths leading up to the filesystem's root.  This will be
> +fixed in the future.
> +
>  Changes to underlying filesystems
>  ---------------------------------
>
> @@ -163,5 +187,6 @@ Offline changes, when the overlay is not
>  the upper or the lower trees.
>
>  Changes to the underlying filesystems while part of a mounted overlay
> -filesystem are not allowed.  This is not yet enforced, but will be in
> -the future.
> +filesystem are not allowed.  If the underlying filesystem is changed,
> +the behavior of the overlay is undefined, though it will not result in
> +a crash or deadlock.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
