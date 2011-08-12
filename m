Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HLNvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:51:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1HLNvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:51:22 -0400
Subject: Re: [PATCH v2 2/4] Keep nr_dentry per super block
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>
In-Reply-To: <1312504544-1108-3-git-send-email-glommer@parallels.com>
References: <1312504544-1108-1-git-send-email-glommer@parallels.com>
	 <1312504544-1108-3-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 15:51:19 +0200
Message-ID: <1313157079.2354.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 août 2011 à 04:35 +0400, Glauber Costa a écrit :
> Now that we have per-sb shrinkers, it makes sense to have nr_dentries
> stored per sb as well. We turn them into per-cpu counters so we can
> keep acessing them without locking.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> ---
>  fs/dcache.c        |   12 +++++++++++-
>  fs/super.c         |   15 ++++++++++++++-
>  include/linux/fs.h |    2 ++
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index b05aac3..ac19d24 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -151,7 +151,13 @@ static void __d_free(struct rcu_head *head)
>  static void d_free(struct dentry *dentry)
>  {
>  	BUG_ON(dentry->d_count);
> +	/*
> +	 * It is cheaper to keep a global counter separate
> +	 * then to scan through all superblocks when needed

"then to scan" or "than scanning" ?

> +	 */
>  	this_cpu_dec(nr_dentry);
> +	this_cpu_dec(*dentry->d_sb->s_nr_dentry);
> +
>  	if (dentry->d_op && dentry->d_op->d_release)
>  		dentry->d_op->d_release(dentry);
>  
> @@ -1224,7 +1230,11 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
>  	INIT_LIST_HEAD(&dentry->d_alias);
>  	INIT_LIST_HEAD(&dentry->d_u.d_child);
>  	d_set_d_op(dentry, dentry->d_sb->s_d_op);
> -
> +	/*
> +	 * It is cheaper to keep a global counter separate
> +	 * then to scan through all superblocks when needed
> +	 */
> +	this_cpu_inc(*dentry->d_sb->s_nr_dentry);
>  	this_cpu_inc(nr_dentry);
>  
>  	return dentry;
> diff --git a/fs/super.c b/fs/super.c
> index 3f56a26..9345385 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -112,6 +112,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
>  {
>  	struct super_block *s = kzalloc(sizeof(struct super_block),  GFP_USER);
>  	static const struct super_operations default_op;
> +	int i;
>  
>  	if (s) {
>  		if (security_sb_alloc(s)) {
> @@ -119,15 +120,26 @@ static struct super_block *alloc_super(struct file_system_type *type)
>  			s = NULL;
>  			goto out;
>  		}
> +
> +		s->s_nr_dentry = alloc_percpu(int);
> +		if (!s->s_nr_dentry) {
> +			security_sb_free(s);
> +			kfree(s);
> +			s = NULL;
> +			goto out;
> +		}



> +		for_each_possible_cpu(i)
> +			*per_cpu_ptr(s->s_nr_dentry, i) = 0;

This loop is not needed, alloc_percpu() gives zeroed data

Why dont you use a percpu_counter ?


