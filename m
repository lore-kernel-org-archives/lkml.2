Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2KSRuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:50:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46997 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2KSRuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:50:02 -0500
Date: Mon, 19 Nov 2012 11:49:52 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH review 03/16] userns: Allow chown and setgid preservation
Message-ID: <20121119174951.GA1883@serge-ThinkPad-X130e>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
 <1353337961-12962-3-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353337961-12962-3-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Allow chown if CAP_CHOWN is present in the current user namespace
>   and the uid of the inode maps into the current user namespace, and
>   the destination uid or gid maps into the current user namespace.
> 
> - Allow perserving setgid when changing an inode if CAP_FSETID is
>   present in the current user namespace and the owner of the file has
>   a mapping into the current user namespace.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/attr.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index cce7df5..1449adb 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -49,14 +49,15 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
>  	/* Make sure a caller can chown. */
>  	if ((ia_valid & ATTR_UID) &&
>  	    (!uid_eq(current_fsuid(), inode->i_uid) ||
> -	     !uid_eq(attr->ia_uid, inode->i_uid)) && !capable(CAP_CHOWN))
> +	     !uid_eq(attr->ia_uid, inode->i_uid)) &&
> +	    !inode_capable(inode, CAP_CHOWN))
>  		return -EPERM;
>  
>  	/* Make sure caller can chgrp. */
>  	if ((ia_valid & ATTR_GID) &&
>  	    (!uid_eq(current_fsuid(), inode->i_uid) ||
>  	    (!in_group_p(attr->ia_gid) && !gid_eq(attr->ia_gid, inode->i_gid))) &&
> -	    !capable(CAP_CHOWN))
> +	    !inode_capable(inode, CAP_CHOWN))
>  		return -EPERM;
>  
>  	/* Make sure a caller can chmod. */
> @@ -65,7 +66,8 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
>  			return -EPERM;
>  		/* Also check the setgid bit! */
>  		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
> -				inode->i_gid) && !capable(CAP_FSETID))
> +				inode->i_gid) &&
> +		    !inode_capable(inode, CAP_FSETID))
>  			attr->ia_mode &= ~S_ISGID;
>  	}
>  
> @@ -157,7 +159,8 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
>  	if (ia_valid & ATTR_MODE) {
>  		umode_t mode = attr->ia_mode;
>  
> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> +		if (!in_group_p(inode->i_gid) &&
> +		    !inode_capable(inode, CAP_FSETID))
>  			mode &= ~S_ISGID;
>  		inode->i_mode = mode;
>  	}
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
