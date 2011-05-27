Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1E0QSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1E0QSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:18:03 -0400
Subject: RE: Cleancache and shared filesystems
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, sunil.mushran@oracle.com
In-Reply-To: <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
References: <1306504300.2857.14.camel@menhir>
	 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 27 May 2011 17:19:39 +0100
Message-ID: <1306513179.2857.38.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2011-05-27 at 08:31 -0700, Dan Magenheimer wrote:
> > From: Steven Whitehouse [mailto:swhiteho@redhat.com]
> > Sent: Friday, May 27, 2011 7:52 AM
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Cleancache and shared filesystems
> > 
> > Hi,
> > 
> > I'm trying to figure out what I would need to do in order to get GFS2
> > to
> > work with cleancache. Looking at the OCFS2 implementation leaves me
> > with
> > some questions about how this is supposed to work. The docs say that
> > the
> > cleancache_init_shared_fs() function is supposed to take a 128 bit UUID
> > plus the sb.
> > 
> > In OCFS2 it is passed a pointer to a 32 bit little endian quantity as
> > the UUID:
> > 
> > __le32 uuid_net_key;
> > 
> > ...
> > 
> > memcpy(&uuid_net_key, di->id2.i_super.s_uuid, sizeof(uuid_net_key));
> > 
> > ...
> > 
> > cleancache_init_shared_fs((char *)&uuid_net_key, sb);
> > 
> > and in the Xen backend driver this then appears to be dereferenced as
> > if
> > its two 64 bit values, which doesn't look right to me.
> 
> Hi Steve --
> 
> Thanks for looking at cleancache!
> 
> Hmmm... yes... it looks like you are right and the cleancache
> interface code for ocfs2 has bit-rotted over time and a bad value
> is being used for the uuid.  This would result in pages not being
> shared between clustered VMs on the same physical machine, but
> would only result in a lower performance advantage, not any
> other visible effects, which would explain why it has gone
> undiscovered for so long.
> 
> Thanks for pointing this out as it is definitely a bug!
> 
Ok, thanks for confirming.

> > Also, since the sb has a UUID field in it anyway, is there some reason
> > why that cannot be used directly rather than passing the uuid as a
> > separate variable?
> 
> Forgive me but I am not a clustered FS expert (even for ocfs2):
> If the UUID field in the sb is always 128-bits and is always
> identical for all cluster nodes, and this fact is consistent
> across all clustered FS's at mount time, I agree that there is
> no need to pass the uuid as a parameter in
> cleancache_init_shared_fs as it can be derived in the body of
> cleancache_init_shared_fs and then passed to
> __cleancache_init_shared_fs (which only cares that it gets
> 128-bits and probably has no business digging through a
> superblock).  OTOH, this call is made only once per mount
> so there's no significant advantage in changing this... or am
> I missing something?
> 
> Thanks,
> Dan
> 
The point was really just a question to see if I'd understood what was
intended at this point of the code. It might be cleaner though to
introduce a sb flag to say whether a particular fs is shared or not as a
generic feature. Then the same init function could be used for both
shared and non-shared filesystems presumably?

The way that GFS2 has worked in terms of unique filesystem IDs, is to
have a filesystem "name" which is a combination of a cluster name and a
filesystem specific part which are separated with a colon. This has been
used as the identifier which gives the unique ID for any particular
filesystem, and it is also the volume label for the filesystem.

In the early GFS2 code, we introduced, in addition a UUID as well. So
that should also be a unique ID across the cluster. That does mean that
it is possible (though very unlikely) that there will be GFS2
filesystems with a zero UUID in existence. That is easily fixable though
with tunegfs2.

So I think that the UUID is ok for this particular purpose, but if it
was possible to use the filesystem "name" instead that would be more
consistent with the rest of GFS2. I don't think its a big issue though.

I suspect that for GFS2 we'd need a patch looking something like this
(untested) based on what I think is the case so far:

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 8ac9ae1..e807850 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -18,6 +18,7 @@
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/quotaops.h>
+#include <linux/cleancache.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -1187,6 +1188,12 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 
 	gfs2_glock_dq_uninit(&mount_gh);
 	gfs2_online_uevent(sdp);
+	if (ls->ls_ops == &gfs2_dlm_ops) {
+		if (gfs2_uuid_valid(sb->s_uuid))
+			cleancache_init_shared_fs(sb->s_uuid, sb);
+	} else {
+		cleancache_init_fs(sb);
+	}
 	return 0;
 
 fail_threads:


I would also be interested to know if there are any plans for a KVM
backend for cleancache,

Steve.


