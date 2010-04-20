Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0DTQal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:30:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34313 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0DTQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:30:17 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, vaurora@redhat.com
In-reply-to: <1271372682-21225-17-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Thu, 15 Apr 2010 16:04:23 -0700)
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com>
Message-Id: <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Apr 2010 18:30:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Valerie Aurora wrote:
> +VFS implementation
> +==================
> +
> +Writable overlays are implemented as an integral part of the VFS,
> +rather than as a VFS client file system (i.e., a stacked file system
> +like unionfs or ecryptfs).  Implementing writable overlays inside the
> +VFS eliminates the need for duplicate copies of VFS data structures,
> +unnecessary indirection, and code duplication, but requires very
> +maintainable, low-to-zero overhead code.  Writable overlays require no
> +change to file systems serving as the read-only layer, and requires
> +some minor support from file systems serving as the read-write layer.
> +File systems that want to be the writable layer must implement the new
> +->whiteout() and ->fallthru() inode operations, which create special
> +dummy directory entries.

Maybe this should have been discussed earlier, but looking at all the
places where copyup and whiteout logic needs to be added (and the
current code is still unfinished, as you state) makes me wonder, does
all that really belong in the VFS?

What exactly are the areas where a VFS implementation eliminates
duplication and unnecessary indirection?  Well, it turns out that in
the current implementation there's only one place, and that's
non-directory nodes.

Which begs the question: why do all the other things (union lookup,
directory merging and copyup, file copyup) need to be in the VFS?
Especially since I can imagine other union implementations wanting to
do these differently (e.g. not copying up directories in readdir).

What really needs to be in the VFS is the ability to:

- allow a filesystem to "redirect" a lookup to a different fs,

- if the operation happens to modify the file, then *not* redirect the
  lookup

And there is already one example for the above: LAST_BIND lookups in
/proc.  So basically it's mostly there and just needs to be
implemented in a filesystem.

Have I missed something fundamental?  Are there other reasons why a
filesystem based implementation would be inferior?

Thanks,
Miklos
