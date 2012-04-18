Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2DRTCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:02:52 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:48710 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2DRTCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:02:49 -0400
Date: Wed, 18 Apr 2012 19:03:47 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 28/43] userns: Convert user specfied uids and gids in
 chown into kuids and kgid
Message-ID: <20120418190347.GF5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-28-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-28-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/open.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 92335f6..e166801 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -506,15 +506,24 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
>  	struct inode *inode = path->dentry->d_inode;
>  	int error;
>  	struct iattr newattrs;
> +	kuid_t uid;
> +	kgid_t gid;
> +
> +	uid = make_kuid(current_user_ns(), user);
> +	gid = make_kgid(current_user_ns(), group);
>  
>  	newattrs.ia_valid =  ATTR_CTIME;
>  	if (user != (uid_t) -1) {
> +		if (!uid_valid(uid))
> +			return -EINVAL;
>  		newattrs.ia_valid |= ATTR_UID;
> -		newattrs.ia_uid = user;
> +		newattrs.ia_uid = uid;
>  	}
>  	if (group != (gid_t) -1) {
> +		if (!gid_valid(gid))
> +			return -EINVAL;
>  		newattrs.ia_valid |= ATTR_GID;
> -		newattrs.ia_gid = group;
> +		newattrs.ia_gid = gid;
>  	}
>  	if (!S_ISDIR(inode->i_mode))
>  		newattrs.ia_valid |=
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
