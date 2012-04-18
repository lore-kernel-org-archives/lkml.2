Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2DRTES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:04:18 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:33796 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2DRTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:04:16 -0400
Date: Wed, 18 Apr 2012 19:05:14 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 30/43] userns: Fail exec for suid and sgid binaries
 with ids outside our user namespace.
Message-ID: <20120418190514.GH5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-30-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-30-git-send-email-ebiederm@xmission.com>
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
>  fs/exec.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 00ae2ef..e001bdf 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1291,8 +1291,11 @@ int prepare_binprm(struct linux_binprm *bprm)
>  	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
>  		/* Set-uid? */
>  		if (mode & S_ISUID) {
> +			if (!kuid_has_mapping(bprm->cred->user_ns, inode->i_uid))
> +				return -EPERM;
>  			bprm->per_clear |= PER_CLEAR_ON_SETID;
>  			bprm->cred->euid = inode->i_uid;
> +
>  		}
>  
>  		/* Set-gid? */
> @@ -1302,6 +1305,8 @@ int prepare_binprm(struct linux_binprm *bprm)
>  		 * executable.
>  		 */
>  		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
> +			if (!kgid_has_mapping(bprm->cred->user_ns, inode->i_gid))
> +				return -EPERM;
>  			bprm->per_clear |= PER_CLEAR_ON_SETID;
>  			bprm->cred->egid = inode->i_gid;
>  		}
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
