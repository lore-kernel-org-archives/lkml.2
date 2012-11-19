Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2KSSDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:03:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2KSSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:03:34 -0500
Date: Mon, 19 Nov 2012 12:03:23 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH review 12/16] userns: For /proc/self/{uid, gid}_map
 derive the lower userns from the struct file
Message-ID: <20121119180322.GC1883@serge-ThinkPad-X130e>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
 <1353337961-12962-12-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353337961-12962-12-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> To keep things sane in the context of file descriptor passing derive the
> user namespace that uids are mapped into from the opener of the file
> instead of from current.
> 
> When writing to the maps file the lower user namespace must always
> be the parent user namespace, or setting the mapping simply does
> not make sense.  Enforce that the opener of the file was in
> the parent user namespace or the user namespace whose mapping
> is being set.

Is there a reasonable use case for writing from the ns whose mapping
is being set?  Are you expecting cases where the child opens the file
and passes it back to the parent to set the mappings?

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index ce92f7e..89f6eae 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -391,7 +391,7 @@ static int uid_m_show(struct seq_file *seq, void *v)
>  	struct user_namespace *lower_ns;
>  	uid_t lower;
>  
> -	lower_ns = current_user_ns();
> +	lower_ns = seq_user_ns(seq);
>  	if ((lower_ns == ns) && lower_ns->parent)
>  		lower_ns = lower_ns->parent;
>  
> @@ -412,7 +412,7 @@ static int gid_m_show(struct seq_file *seq, void *v)
>  	struct user_namespace *lower_ns;
>  	gid_t lower;
>  
> -	lower_ns = current_user_ns();
> +	lower_ns = seq_user_ns(seq);
>  	if ((lower_ns == ns) && lower_ns->parent)
>  		lower_ns = lower_ns->parent;
>  
> @@ -688,10 +688,14 @@ ssize_t proc_uid_map_write(struct file *file, const char __user *buf, size_t siz
>  {
>  	struct seq_file *seq = file->private_data;
>  	struct user_namespace *ns = seq->private;
> +	struct user_namespace *seq_ns = seq_user_ns(seq);
>  
>  	if (!ns->parent)
>  		return -EPERM;
>  
> +	if ((seq_ns != ns) && (seq_ns != ns->parent))
> +		return -EPERM;
> +
>  	return map_write(file, buf, size, ppos, CAP_SETUID,
>  			 &ns->uid_map, &ns->parent->uid_map);
>  }
> @@ -700,10 +704,14 @@ ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t siz
>  {
>  	struct seq_file *seq = file->private_data;
>  	struct user_namespace *ns = seq->private;
> +	struct user_namespace *seq_ns = seq_user_ns(seq);
>  
>  	if (!ns->parent)
>  		return -EPERM;
>  
> +	if ((seq_ns != ns) && (seq_ns != ns->parent))
> +		return -EPERM;
> +
>  	return map_write(file, buf, size, ppos, CAP_SETGID,
>  			 &ns->gid_map, &ns->parent->gid_map);
>  }
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
