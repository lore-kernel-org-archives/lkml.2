Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab2HHQbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:31:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42989 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2HHQa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:30:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kernel-team@lists.ubuntu.com
Subject: Re: [overlayfs/bug] LXC ephemeral containers have "/rootfs" prefix in /proc/self/maps entries
References: <CAK5ve-LaEXC56iYAc+hCFen2x9Lfscy6Q-z1cCE21UypqpaK3g@mail.gmail.com>
Date: Wed, 08 Aug 2012 18:32:18 +0200
In-Reply-To: <CAK5ve-LaEXC56iYAc+hCFen2x9Lfscy6Q-z1cCE21UypqpaK3g@mail.gmail.com>
	(Bryan Wu's message of "Thu, 2 Aug 2012 21:14:46 +0800")
Message-ID: <87vcgtibu5.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu <bryan.wu@canonical.com> writes:

> Miklos,
>
> We met a LXC issue [1] with overlayfs in Ubuntu, but with aufs it is gone.
>
> I suspect it's related to the issue you mentioned in Documentation of overlayfs:
> --
> Symlinks in /proc/PID/ and /proc/PID/fd which point to a non-directory
> object in overlayfs will not contain vaid absolute paths, only
> relative paths leading up to the filesystem's root.  This will be
> fixed in the future.
> --
>
> Could you please help to take a look at this? or point me out some hints.
>
> [1], https://bugs.launchpad.net/ubuntu/+source/linux/+bug/959352

To explain this a little background is needed about how overlayfs works.

Unlike a "true" union filesystem like AUFS, the overlayfs filesystem
doesn't actually contain any non-directory files.  So when you open a
regular file, for example, what you get is actually the real file on the
upper or lower filesystems, not a file in the overlayfs.  This is the
most important difference between overlayfs and aufs.

Currently overlayfs creates private clones of the lower and upper mounts
and uses those internally when opening a file.  This results in
/proc/PID/fd showing not the expected path.

Instead of using private mount clones, overlayfs could add these mounts
to the same mountpoint as the overlayfs itself (under the overlayfs)
which would result in the correct path being printed.  But to make this
consistent new logic would need to be added to namespace.c so that these
auxillary mounts are properly cleaned up on umount, and they are
properly copied/moved during mount binding/moving or namespace cloning.

Thanks,
Miklos
