Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2GBItc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:49:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59595 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2GBIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:49:30 -0400
Date: Mon, 2 Jul 2012 01:49:17 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 1/2] fs: configfs: add check_rmdir operation
Message-ID: <20120702084914.GB13247@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <1340276129-20023-2-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340276129-20023-2-git-send-email-andrzej.p@samsung.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.  You should be using configfs_(un)depend_item() if you require the
item to stay alive.

Joel

On Thu, Jun 21, 2012 at 12:55:28PM +0200, Andrzej Pietrasiewicz wrote:
> The logic behind a subsystem which uses configfs might be that it is not
> desired to allow removing the pseudo directories (items or groups) in a
> mounted configfs while some criterion is not met, e.g. while some
> actions are in progress. This patch adds a check_rmdir operation to
> configfs_item_operations and to configfs_group_operations. The operation,
> if provided, is called before actual remove takes place and if the result
> is nonzero, the remove is not done and the error it returns is reported.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  fs/configfs/dir.c        |   20 ++++++++++++++++++++
>  include/linux/configfs.h |    2 ++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 7e6c52d..de2680f 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -1408,12 +1408,32 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
>  		dead_item_owner = item->ci_type->ct_owner;
>  
>  	if (sd->s_type & CONFIGFS_USET_DIR) {
> +		if (item->ci_type && item->ci_type->ct_group_ops &&
> +		    item->ci_type->ct_group_ops->check_rmdir) {
> +		    	ret = item->ci_type->ct_group_ops->check_rmdir(
> +				to_config_group(parent_item), item);
> +			if (ret) {
> +				config_item_put(item);
> +				configfs_detach_rollback(dentry);
> +				return ret;
> +			}
> +		}
>  		configfs_detach_group(item);
>  
>  		mutex_lock(&subsys->su_mutex);
>  		client_disconnect_notify(parent_item, item);
>  		unlink_group(to_config_group(item));
>  	} else {
> +		if (item->ci_type && item->ci_type->ct_item_ops &&
> +		    item->ci_type->ct_item_ops->check_rmdir) {
> +		    	ret = item->ci_type->ct_item_ops->check_rmdir(
> +				to_config_group(parent_item), item);
> +			if (ret) {
> +				config_item_put(item);
> +				configfs_detach_rollback(dentry);
> +				return ret;
> +			}
> +		}
>  		configfs_detach_item(item);
>  
>  		mutex_lock(&subsys->su_mutex);
> diff --git a/include/linux/configfs.h b/include/linux/configfs.h
> index 34025df..f356a55 100644
> --- a/include/linux/configfs.h
> +++ b/include/linux/configfs.h
> @@ -225,6 +225,7 @@ struct configfs_item_operations {
>  	void (*release)(struct config_item *);
>  	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
>  	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
> +	int (*check_rmdir)(struct config_group *group, struct config_item *item);
>  	int (*allow_link)(struct config_item *src, struct config_item *target);
>  	int (*drop_link)(struct config_item *src, struct config_item *target);
>  };
> @@ -233,6 +234,7 @@ struct configfs_group_operations {
>  	struct config_item *(*make_item)(struct config_group *group, const char *name);
>  	struct config_group *(*make_group)(struct config_group *group, const char *name);
>  	int (*commit_item)(struct config_item *item);
> +	int (*check_rmdir)(struct config_group *group, struct config_item *item);
>  	void (*disconnect_notify)(struct config_group *group, struct config_item *item);
>  	void (*drop_item)(struct config_group *group, struct config_item *item);
>  };
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

Dort wo man Bücher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

			http://www.jlbec.org/
			jlbec@evilplan.org
