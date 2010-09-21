Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0IUAEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0IUAEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:04:05 -0400
Date: Mon, 20 Sep 2010 20:03:44 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Ram Pai <ram.n.pai@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/34] VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
Message-ID: <20100921000344.GB9032@shell>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-4-git-send-email-vaurora@redhat.com> <AANLkTim1bbGrrPcFHThx3XOm8GmudQFSmFUs3NAXT5yC@mail.gmail.com> <20100917043401.GD8926@ram-laptop> <20100917171514.GA32258@shell> <20100920052553.GM8926@ram-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920052553.GM8926@ram-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 10:25:53PM -0700, Ram Pai wrote:
> 
> I understand your intentions, but I think you are making a wrong assumption.
> You seem to be thinking that if a slave-mount is cloned, the new cloned
> mount will also be a slave-mount and will hence receive propagations. As
> per shared subtree semantics, a slave-mount when cloned will create a private
> mount. Since your intention is to avoid generating any new mounts that 
> recieve propagations, you should be checking for shared-mounts and 
> slave-shared-mounts because these are the two kind of mounts that when
> cloned create new mounts that receive propagation.

No.  This isn't about the semantics of the clone mount operation.  It
is about the administrator creating a slave mount, unioning it, and
then being surprised when the unioned file system does not receive
mount propagation events.

Think of the source vfsmount tree as a set of command line arguments
for the union mount.

> > One of the reasons I had to do it this way is that you can't hold
> > vfsmount_lock while calling copy_tree(), so the mount flags can change
> > between the first check in #2 and the copy_tree() in #3.  Also
> > sb->s_flag can change.  
> 
> Isn't this whole operation done under the protection of namespace_sem? 
> I know that shared/slave flags can't change if the namespace_sem is held. 
> The same may also be true for sb->s_flag. 

namespace_sem only covers the shared/slave mount flags.  We also care
about MNT_READONLY, which is protected by vfsmount_lock.  sb->s_flags
is protected by sb->s_umount and not namespace_sem.

We could do the shared/slave check outside of clone_mnt(), but it
would require two passes over the source vfsmount tree.

> > One of the problems with the current code is
> > that it can't deal with cloning existing union mounts, which we need
> > if we are to make bind mounts work (see do_loopback()).
> 
> if I understand your union mount semantics correctly, you dont' allow the
> same filesystem to be union mounted rw in two different locations. correct?
> If yes, then bind mount of a union-mount has to be disallowed.

A bind mount of part of a union file system (which is itself unioned
and includes the lower layers) doesn't have the same problems as an
independent mount of the rw layer.  Mainly, the union stack will be
the same for both.  I'm not sure it will work but it won't fail for
the same reasons as a separate mount of the rw layer alone.

-VAL
