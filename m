Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1E0Qbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:31:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56199 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1E0Qbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:31:43 -0400
MIME-Version: 1.0
Message-ID: <67cfb40f-e199-4676-8fe1-19f9768ac600@default>
Date: Fri, 27 May 2011 09:31:25 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>
Subject: RE: Cleancache and shared filesystems
References: <1306504300.2857.14.camel@menhir>
 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default
 1306513179.2857.38.camel@menhir>
In-Reply-To: <1306513179.2857.38.camel@menhir>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DDFD1ED.00EA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Forgive me but I am not a clustered FS expert (even for ocfs2):
> > If the UUID field in the sb is always 128-bits and is always
> > identical for all cluster nodes, and this fact is consistent
> > across all clustered FS's at mount time, I agree that there is
> > no need to pass the uuid as a parameter in
> > cleancache_init_shared_fs as it can be derived in the body of
> > cleancache_init_shared_fs and then passed to
> > __cleancache_init_shared_fs (which only cares that it gets
> > 128-bits and probably has no business digging through a
> > superblock).  OTOH, this call is made only once per mount
> > so there's no significant advantage in changing this... or am
> > I missing something?
> >
> The point was really just a question to see if I'd understood what was
> intended at this point of the code. It might be cleaner though to
> introduce a sb flag to say whether a particular fs is shared or not as
> a
> generic feature. Then the same init function could be used for both
> shared and non-shared filesystems presumably?

True.  I believe I had just one function long ago but an early reviewer
insisted that:

func_does_this()
func_does_this_and_also_X()

was more proper in the kernel than

func_does_this(parameter_selecting_X_or_notX)

> The way that GFS2 has worked in terms of unique filesystem IDs, is to
> have a filesystem "name" which is a combination of a cluster name and a
> filesystem specific part which are separated with a colon. This has
> been
> used as the identifier which gives the unique ID for any particular
> filesystem, and it is also the volume label for the filesystem.
> 
> In the early GFS2 code, we introduced, in addition a UUID as well. So
> that should also be a unique ID across the cluster. That does mean that
> it is possible (though very unlikely) that there will be GFS2
> filesystems with a zero UUID in existence. That is easily fixable
> though
> with tunegfs2.
> 
> So I think that the UUID is ok for this particular purpose, but if it
> was possible to use the filesystem "name" instead that would be more
> consistent with the rest of GFS2. I don't think its a big issue though.
> 
> I suspect that for GFS2 we'd need a patch looking something like this
> (untested) based on what I think is the case so far:
> 
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 8ac9ae1..e807850 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -18,6 +18,7 @@
>  #include <linux/mount.h>
>  #include <linux/gfs2_ondisk.h>
>  #include <linux/quotaops.h>
> +#include <linux/cleancache.h>
> 
>  #include "gfs2.h"
>  #include "incore.h"
> @@ -1187,6 +1188,12 @@ static int fill_super(struct super_block *sb,
> struct gfs2_args *args, int silent
> 
>  	gfs2_glock_dq_uninit(&mount_gh);
>  	gfs2_online_uevent(sdp);
> +	if (ls->ls_ops == &gfs2_dlm_ops) {
> +		if (gfs2_uuid_valid(sb->s_uuid))
> +			cleancache_init_shared_fs(sb->s_uuid, sb);

should this be &sb->s_uuid[0]? (or I guess it is the same
thing since it is an array).

> +	} else {
> +		cleancache_init_fs(sb);
> +	}
>  	return 0;
> 
>  fail_threads:
> 
> 
> I would also be interested to know if there are any plans for a KVM
> backend for cleancache,

I've had a couple of inquiries and have actually done some
work (not released yet) on a multiple-physical machine user
for cleancache (called RAMster) that extends tmem.c in
zcache to support multiple clients, which would make a
KVM implementation fairly easy.  But AFAIK, nobody has
started developing a KVM backend... are you interested?

Dan
