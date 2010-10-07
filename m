Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab0JGJn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:43:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54462 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760187Ab0JGJn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:43:27 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, linuxram@us.ibm.com, mszeredi2@gmail.com,
        viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-reply-to: <20101006183140.GD18479@shell> (message from Valerie Aurora on
	Wed, 6 Oct 2010 14:31:41 -0400)
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return error codes
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-2-git-send-email-vaurora@redhat.com> <E1P1FnW-0001yC-Ts@pomaz-ex.szeredi.hu> <20100930214123.GA490@shell> <20100930214418.GB490@shell> <20101001003342.GI9247@ram-laptop> <20101001015857.GA5003@ram-laptop> <AANLkTin0k-Sz8Y6dwm9s6isKgDPgcqpg0NON5kuiOcJ3@mail.gmail.com> <20101006183140.GD18479@shell>
Message-Id: <E1P3n00-0000rf-ID@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 07 Oct 2010 11:42:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Valerie Aurora wrote:
> On Fri, Oct 01, 2010 at 11:12:48AM +0200, Szeredi Miklos wrote:
> > On Fri, Oct 1, 2010 at 3:58 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> > > > > > > @@ -1212,11 +1216,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> > > > > > > ? ? ? ? struct path path;
> > > > > > >
> > > > > > > ? ? ? ? if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
> > > > > > > - ? ? ? ? ? ? ? return NULL;
> > > > > > > + ? ? ? ? ? ? ? return ERR_PTR(-EINVAL);
> > > > >
> > > > > Ram, do you remember how this worked?
> > > >
> > > > Oops. That should be a OR condition. there is one other check in that
> > > > function that should also be a OR condition.
> > >
> > > I may be wrong here. Can't exactly recollect what CL_COPY_ALL flag means. Al Viro
> > > might remember? ?If CL_COPY_ALL means, to clone everything irrespective of any other
> > > flags, then the above code seems right.
> > 
> > CL_COPY_ALL means clone the mount despite MNT_UNBINDABLE.  It is used
> > for cloning the whole namespace and for collect_mounts(), both of
> > which ignore MNT_UNBINDABLE.
> > 
> > Of the two remaining callers of copy_tree() do_loopback already checks
> > MNT_UNBINDABLE on the root of the tree to be copied.
> 
> I reviewed and tested and agree.
> 
> But I don't think this change should go into stable.  It doesn't fix
> any existing bug and I don't like perturbing the code in stable for a
> code cleanup.

Right.

> > So that leaves the one in pnode.c.   That one will be called when
> > attaching a new mount or mount tree.  If the root of that tree is
> > unbindable then the propagation will fail with -ENOMEM which is wrong,
> > it should simply skip the whole tree and not try to propagate.   Calls
> 
> Not try to propagate - and return an error?  Or succeed and ignore?

I thought succeed and ignore is the right answer, but I'm not sure
now.

> > which result in propagation are  do_loopback, do_move_mount and
> > do_add_mount.  Of this do_loopback and do_move_mount already check for
> > MNT_UNBINDABLE, do_add_mount doesn't check, but should probably just
> > mask out MNT_UNBINDABLE.
> 
> Hm, if we stop trusting callers of do_add_mount(), we should probably
> do a lot more than just mask this out.  Interestingly, most out-of-VFS
> callers just seem to add MNT_SHRINKABLE, maybe we should export
> do_add_shrinkable() instead or something like that?
> 
> > So in the end that check in copy_tree() should never actually trigger
> > and can be turned into a WARN_ON
> 
> WARN_ON() makes sense.
> 
> > Additionally the propagation code should perhaps be more defensive and
> > skip MNT_UNBINDABLE source mounts.
> 
> Maybe WARN_ON() here too?

Yes, I think so.

Thanks,
Miklos
