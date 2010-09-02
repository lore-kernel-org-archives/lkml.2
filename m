Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0IBJTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 05:19:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44744 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0IBJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:19:50 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
In-reply-to: <20100901214238.GC15849@shell> (message from Valerie Aurora on
	Wed, 1 Sep 2010 17:42:38 -0400)
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu> <20100826183507.402136609@szeredi.hu> <20100901214238.GC15849@shell>
Message-Id: <E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Sep 2010 11:19:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Valerie Aurora wrote:
> > +
> > +		err = vfs_create(upperdir, newdentry, attr->ia_mode, NULL);
> 
> Passing a NULL namiedata pointer to vfs_create() is a convenient
> temporary hack, but unfortunately NFS, ceph, etc. still use the
> nameidata passed to vfs_create() and other ops.
> 
> The way union mounts gets a valid nameidata is by doing the create in
> the VFS before calling file system ops that may trigger a copyup,
> while we still have the original nameidata.  This is one of the major
> reasons union mounts lives in the VFS.

Not a big deal, just set up nd as if this was a single component
lookup.  The previous version did it like this:

+       struct nameidata nd = {
+               .last_type = LAST_NORM,
+               .last = *name,
+       };
+
+       nd.path = pue->upperpath;
+       path_get(&nd.path);
+
+       newdentry = lookup_create(&nd, S_ISDIR(attr->ia_mode));

But that's not a solution to the NFS suckage, it's just a workaround.

"Fortunately" NFS isn't good for a writable layer of a union for other
reasons, so this isn't a big concern at the moment.

Thanks,
Miklos
