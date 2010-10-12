Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab0JLHmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:42:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56330 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab0JLHmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:42:08 -0400
Date: Tue, 12 Oct 2010 00:41:59 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Szeredi Miklos <miklos@szeredi.hu>,
        mszeredi2@gmail.com, viro@zeniv.linux.org.uk, hch@infradead.org,
        agruen@suse.de, npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return
 error codes
Message-ID: <20101012074159.GB549@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
 <1284675145-4391-2-git-send-email-vaurora@redhat.com>
 <E1P1FnW-0001yC-Ts@pomaz-ex.szeredi.hu>
 <20100930214123.GA490@shell>
 <20100930214418.GB490@shell>
 <20101001003342.GI9247@ram-laptop>
 <20101001015857.GA5003@ram-laptop>
 <AANLkTin0k-Sz8Y6dwm9s6isKgDPgcqpg0NON5kuiOcJ3@mail.gmail.com>
 <20101001183243.GM9247@ram-laptop>
 <20101006182449.GC18479@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006182449.GC18479@shell>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 02:24:50PM -0400, Valerie Aurora wrote:
> On Fri, Oct 01, 2010 at 11:32:43AM -0700, Ram Pai wrote:
> > On Fri, Oct 01, 2010 at 11:12:48AM +0200, Szeredi Miklos wrote:
> > > On Fri, Oct 1, 2010 at 3:58 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> > > > > > > > @@ -1212,11 +1216,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> > > > > > > > ? ? ? ? struct path path;
> > > > > > > >
> > > > > > > > ? ? ? ? if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
> > > > > > > > - ? ? ? ? ? ? ? return NULL;
> > > > > > > > + ? ? ? ? ? ? ? return ERR_PTR(-EINVAL);
> > > > > >
> > > > > > Ram, do you remember how this worked?
> > > > >
> > > > > Oops. That should be a OR condition. there is one other check in that
> > > > > function that should also be a OR condition.
> > > >
> > > > I may be wrong here. Can't exactly recollect what CL_COPY_ALL flag means. Al Viro
> > > > might remember? ?If CL_COPY_ALL means, to clone everything irrespective of any other
> > > > flags, then the above code seems right.
> > > 
> > > CL_COPY_ALL means clone the mount despite MNT_UNBINDABLE.  It is used
> > > for cloning the whole namespace and for collect_mounts(), both of
> > > which ignore MNT_UNBINDABLE.
> > 
> > Ok. That reminds me  when the above piece of code in copy_tree() is triggered.
> > It triggered when a mount tree with a unbindable mount at its head
> > is moved on a shared mount with atleast one peer.
> > 
> > something like this should trigger the code.
> > 
> > # create a unbindable mount
> > mkdir -p /mnt2/m1
> > mount --bind /mnt2/m1 /mnt2/m1
> > mount --make-unbindable /mnt2/m1
> > 
> > #create a shared mount with one peer.
> > mkdir -p /mnt2/s1
> > mkdir -p /mnt2/s2
> > mount --bind /mnt2/s1 /mnt2/s1
> > mount --make-shared /mnt2/s1
> > mount --bind /mnt2/s1 /mnt2/s2
> > 
> > #move the unbindable mount to one of the shared peer
> > mkdir -p /mnt2/s1/movemount
> > mount --move /mnt2/m1 /mnt2/s1/movemount
> > 
> > the last step will fail and that is because of the above check in copy_tree()
> 
> Actually, it fails in do_move_mount(), as Miklos theorized.  I tested
> it with the above in an attempt to trigger it in practice in case the
> code review was wrong, but failed.

Well, yes there is a check in do_move_mount() for this case.
I was incorrect. 

> 
> > > Of the two remaining callers of copy_tree() do_loopback already checks
> > > MNT_UNBINDABLE on the root of the tree to be copied.
> > > 
> > > So that leaves the one in pnode.c.   That one will be called when
> > > attaching a new mount or mount tree.  If the root of that tree is
> > > unbindable then the propagation will fail with -ENOMEM which is wrong,
> > > it should simply skip the whole tree and not try to propagate.  
> > 
> > Yes.  the propagation_mnt() should fail if it is unable to create clones
> > of the source mount due to any reason. However -ENOMEM may not be
> > the right return code. 
> > 
> > 
> > > Calls
> > > which result in propagation are  do_loopback, do_move_mount and
> > > do_add_mount.  Of this do_loopback and do_move_mount already check for
> > > MNT_UNBINDABLE, do_add_mount doesn't check, but should probably just
> > > mask out MNT_UNBINDABLE.
> > > 
> > > So in the end that check in copy_tree() should never actually trigger
> > > and can be turned into a WARN_ON
> > 
> > You can do that. But then we have to catch for the cases where a unbindable
> > mount is moved on a shared mounts. I suppose we can put in a check in do_move_mount().

Since the check is already in there in do_move_mount(),  I now agree with Miklos.
The check in copy_tree() does nothing but chews up a few cycles unnecessarily.
However just to be safe we can make it a WARN_ON.

> > > 
> > > Additionally the propagation code should perhaps be more defensive and
> > > skip MNT_UNBINDABLE source mounts.

the code is already skipping unbindable source mounts in propagate_mnt(). 
Miklos: did you have something else in mind here?

> > 
> > No. If we do that, I am afraid, we will end up with inconsistent peer-mount trees 
> > which will not resemble each other.
> 
> Any chance you have the time to do a little documentation on where
> checks should be done and what flags each function expects?  Right now
> the distribution and location of the checks tend to send the reader
> off on false trails...

Yes. some additional documentation is needed, given that I myself trailed on wrong
paths after having not looked at this code for more than 4years.

RP
