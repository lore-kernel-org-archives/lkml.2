Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0JAJMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:12:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39164 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0JAJMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vEhoInjKDsPXau4s2mCbhDnqP6UnD5YMksRjiw5tRVS9ZfTFHmwjfO7/N5xU3bU0Ej
         fWzLWvK1/AUQctk0huI1c8bZ2DguP/UUh60IopaABjpSH7C6i45NQd80yGi6sTP/QX0I
         gxhUHKyK4GLFGtu3Uea+BQv1Jo3dGaf0ZGfqo=
MIME-Version: 1.0
In-Reply-To: <20101001015857.GA5003@ram-laptop>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
	<1284675145-4391-2-git-send-email-vaurora@redhat.com>
	<E1P1FnW-0001yC-Ts@pomaz-ex.szeredi.hu>
	<20100930214123.GA490@shell>
	<20100930214418.GB490@shell>
	<20101001003342.GI9247@ram-laptop>
	<20101001015857.GA5003@ram-laptop>
Date: Fri, 1 Oct 2010 11:12:48 +0200
X-Google-Sender-Auth: NjDZZ_UdSQ2-OkJS_JdSxkF_erY
Message-ID: <AANLkTin0k-Sz8Y6dwm9s6isKgDPgcqpg0NON5kuiOcJ3@mail.gmail.com>
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return error codes
From: Szeredi Miklos <miklos@szeredi.hu>
To: Ram Pai <linuxram@us.ibm.com>
Cc: mszeredi2@gmail.com, Valerie Aurora <vaurora@redhat.com>,
        viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 3:58 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> > > > > @@ -1212,11 +1216,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> > > > >         struct path path;
> > > > >
> > > > >         if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
> > > > > -               return NULL;
> > > > > +               return ERR_PTR(-EINVAL);
> > >
> > > Ram, do you remember how this worked?
> >
> > Oops. That should be a OR condition. there is one other check in that
> > function that should also be a OR condition.
>
> I may be wrong here. Can't exactly recollect what CL_COPY_ALL flag means. Al Viro
> might remember?  If CL_COPY_ALL means, to clone everything irrespective of any other
> flags, then the above code seems right.

CL_COPY_ALL means clone the mount despite MNT_UNBINDABLE.  It is used
for cloning the whole namespace and for collect_mounts(), both of
which ignore MNT_UNBINDABLE.

Of the two remaining callers of copy_tree() do_loopback already checks
MNT_UNBINDABLE on the root of the tree to be copied.

So that leaves the one in pnode.c.   That one will be called when
attaching a new mount or mount tree.  If the root of that tree is
unbindable then the propagation will fail with -ENOMEM which is wrong,
it should simply skip the whole tree and not try to propagate.   Calls
which result in propagation are  do_loopback, do_move_mount and
do_add_mount.  Of this do_loopback and do_move_mount already check for
MNT_UNBINDABLE, do_add_mount doesn't check, but should probably just
mask out MNT_UNBINDABLE.

So in the end that check in copy_tree() should never actually trigger
and can be turned into a WARN_ON

Additionally the propagation code should perhaps be more defensive and
skip MNT_UNBINDABLE source mounts.

Thanks,
Miklos
