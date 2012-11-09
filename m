Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2KIP3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:29:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab2KIP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:29:00 -0500
Date: Fri, 9 Nov 2012 09:28:54 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: pid/status: show all supplementary groups
Message-ID: <20121109152854.GA6778@sergelap>
References: <1352467863-1371-1-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352467863-1371-1-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Artem Bityutskiy (dedekind1@gmail.com):
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> We display a list of supplementary group for each process in the
> /proc/<pid>/status. However, we show only the first 32 groups, not all of them.
> 
> Although this is rare, but sometimes processes do have more than 32
> supplementary groups, and this kernel limitation breaks user-space apps
> that rely on the group list in /proc/<pid>/status.
> 
> Number 32 comes from the internal NGROUPS_SMALL macro which defines the
> length for the internal kernel "small" groups buffer. There is no apparent
> reason to limit to this value.
> 
> This patch removes the 32 groups printing limit.
> 
> The Linux kernel limits the amount of supplementary groups by NGROUPS_MAX,
> which is currently set to 65536. And this is the maximum count of groups we
> may possibly print.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The 'min' is older than git history, but at that dawn of time the code
was just sprintf()ing into a large buffer.

I don't *really* see a problem with this, though if someone did have 1000
groups /proc/$$/status would be sort of annoying to read.  So on the one 
hand adding a '...' in /proc/self/status after 32, and adding a /proc/$$/creds
file seems more pleasant, but then you get into the whole adding files to
/proc kerfuffle, so...

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Cc: stable@vger.kernel.org
> ---
>  fs/proc/array.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> NOTE: I consider this to be a bug which breaks user-space, so I add -stable.
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index c1c207c..bd31e02 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -212,7 +212,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  	group_info = cred->group_info;
>  	task_unlock(p);
>  
> -	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
> +	for (g = 0; g < group_info->ngroups; g++)
>  		seq_printf(m, "%d ",
>  			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
>  	put_cred(cred);
> -- 
> 1.7.7.6
> 
