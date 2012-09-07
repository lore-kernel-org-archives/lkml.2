Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2IGMsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:48:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60537 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2IGMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:48:20 -0400
Date: Fri, 7 Sep 2012 08:48:14 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: don't need a PATH_MAX allocation to hold a
 string representation of an int
Message-ID: <20120907084814.07a59c98@corrin.poochiereds.net>
In-Reply-To: <1347021293-19052-1-git-send-email-jlayton@redhat.com>
References: <1347021293-19052-1-git-send-email-jlayton@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Sep 2012 08:34:53 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/proc/base.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 1b6c84c..58e801b 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2758,7 +2758,8 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
>  	pid_t tgid = task_tgid_nr_ns(current, ns);
>  	char *name = ERR_PTR(-ENOENT);
>  	if (tgid) {
> -		name = __getname();
> +		/* 10 for max length of an int in decimal + NULL terminator */
> +		name = kmalloc(11, GFP_KERNEL);

		^^^^^
Bah...my mistake. This should be "12", since it's possible (though
unlikely) that this value could be negative. Is there a better way to
express "strlen of max representation of an int in decimal" ?

>  		if (!name)
>  			name = ERR_PTR(-ENOMEM);
>  		else
> @@ -2773,7 +2774,7 @@ static void proc_self_put_link(struct dentry *dentry, struct nameidata *nd,
>  {
>  	char *s = nd_get_link(nd);
>  	if (!IS_ERR(s))
> -		__putname(s);
> +		kfree(s);
>  }
>  
>  static const struct inode_operations proc_self_inode_operations = {


-- 
Jeff Layton <jlayton@poochiereds.net>
