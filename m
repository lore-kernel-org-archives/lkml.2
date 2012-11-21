Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2KUT7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:59:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45023 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2KUT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:59:45 -0500
Date: Wed, 21 Nov 2012 11:59:41 -0800
From: Joel Becker <jlbec@evilplan.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH RFC 09/12] userns: Convert ocfs2 to use kuid and kgid
 where appropriate
Message-ID: <20121121195940.GO2822@localhost>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel@vger.kernel.org,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
	Mark Fasheh <mfasheh@suse.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
 <1353415420-5457-9-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353415420-5457-9-git-send-email-ebiederm@xmission.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 04:43:37AM -0800, Eric W. Biederman wrote:
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index 260b162..8a40457 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -65,7 +65,20 @@ static struct posix_acl *ocfs2_acl_from_xattr(const void *value, size_t size)
>  
>  		acl->a_entries[n].e_tag  = le16_to_cpu(entry->e_tag);
>  		acl->a_entries[n].e_perm = le16_to_cpu(entry->e_perm);
> -		acl->a_entries[n].e_id   = le32_to_cpu(entry->e_id);
> +		switch(acl->a_entries[n].e_tag) {
> +		case ACL_USER:
> +			acl->a_entries[n].e_uid =
> +				make_kuid(&init_user_ns,
> +					  le32_to_cpu(entry->e_id));
> +			break;

Stupid question: do you consider disjoint namespaces on multiple
machines to be a problem?  Remember that ocfs2 is a cluster filesystem.
If I have uid 100 on machine A in the default namespace, and then I
mount the filesystem on machine B with uid 100 in a different namespace,
what happens?  I presume that both can access as the same nominal uid,
and configuring this correctly is left as an exercise to the namespace
administrator?

> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 4f7795f..f99af1c 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2045,8 +2045,8 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
>  	lvb->lvb_version   = OCFS2_LVB_VERSION;
>  	lvb->lvb_isize	   = cpu_to_be64(i_size_read(inode));
>  	lvb->lvb_iclusters = cpu_to_be32(oi->ip_clusters);
> -	lvb->lvb_iuid      = cpu_to_be32(inode->i_uid);
> -	lvb->lvb_igid      = cpu_to_be32(inode->i_gid);
> +	lvb->lvb_iuid      = cpu_to_be32(i_uid_read(inode));
> +	lvb->lvb_igid      = cpu_to_be32(i_gid_read(inode));

	I have the reverse question here.  Are we guaranteed that the
on-disk uid/gid will not change regardless of the namespace?  That is,
if I create a file on machine A in init_user_ns as uid 100, then access
it over on machine B in some other namespace with a user-visible uid of
100, will the wire be passing 100 in both directions?  This absolutely
must be true for the cluster communication to work.

Joel


-- 

Life's Little Instruction Book #80

	"Slow dance"

			http://www.jlbec.org/
			jlbec@evilplan.org
