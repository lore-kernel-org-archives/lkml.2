Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0IBVdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IBVdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:33:38 -0400
Date: Thu, 2 Sep 2010 17:33:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
Message-ID: <20100902213315.GA16004@shell>
References: <20100826183340.027591901@szeredi.hu> <20100826183507.402136609@szeredi.hu> <20100901214238.GC15849@shell> <E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:19:41AM +0200, Miklos Szeredi wrote:
> On Wed, 1 Sep 2010, Valerie Aurora wrote:
> > > +
> > > +		err = vfs_create(upperdir, newdentry, attr->ia_mode, NULL);
> > 
> > Passing a NULL namiedata pointer to vfs_create() is a convenient
> > temporary hack, but unfortunately NFS, ceph, etc. still use the
> > nameidata passed to vfs_create() and other ops.
> > 
> > The way union mounts gets a valid nameidata is by doing the create in
> > the VFS before calling file system ops that may trigger a copyup,
> > while we still have the original nameidata.  This is one of the major
> > reasons union mounts lives in the VFS.
> 
> Not a big deal, just set up nd as if this was a single component
> lookup.  The previous version did it like this:
> 
> +       struct nameidata nd = {
> +               .last_type = LAST_NORM,
> +               .last = *name,
> +       };
> +
> +       nd.path = pue->upperpath;
> +       path_get(&nd.path);
> +
> +       newdentry = lookup_create(&nd, S_ISDIR(attr->ia_mode));
> 
> But that's not a solution to the NFS suckage, it's just a workaround.

Hm, I suspect it's more complicated than this.  I looked at how
unionfs does it in init_lower_nd() and it requires poking around in
VFS internal details in the file system implementation.  So unioning
code is not in the VFS, but VFS code is in the union fs.  Progress?  I
dunno.

> "Fortunately" NFS isn't good for a writable layer of a union for other
> reasons, so this isn't a big concern at the moment.

It's the long-term effect on the code structure that concerns me more.

-VAL
