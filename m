Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1HHRWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:22:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1HHRWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:22:15 -0400
Date: Mon, 8 Aug 2011 10:20:40 -0700
From: Greg KH <gregkh@suse.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Paul Clements <Paul.Clements@steeleye.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] nbd: some trivial improvements
Message-ID: <20110808172040.GA3191@suse.de>
References: <1312794004-22047-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312794004-22047-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 05:00:04PM +0800, Amerigo Wang wrote:
> This patch 1) uses task_pid_nr(current) to get the pid of current process,
>  2) replaces sysfs_create_file() with device_create_file(), 3) lower
> the loglevel of an error message.

As you are doing 3 different things, please make this 3 different
patches (remember, one patch per logical thing being done.)

> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index f533f33..07cad4b 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -405,10 +405,10 @@ static int nbd_do_it(struct nbd_device *lo)
>  
>  	BUG_ON(lo->magic != LO_MAGIC);
>  
> -	lo->pid = current->pid;
> -	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
> +	lo->pid = task_pid_nr(current);
> +	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
>  	if (ret) {
> -		printk(KERN_ERR "nbd: sysfs_create_file failed!");
> +		printk(KERN_ERR "nbd: device_create_file failed!");

Use dev_err() instead please.

>  		lo->pid = 0;
>  		return ret;
>  	}
> @@ -416,7 +416,7 @@ static int nbd_do_it(struct nbd_device *lo)
>  	while ((req = nbd_read_stat(lo)) != NULL)
>  		nbd_end_request(req);
>  
> -	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
> +	device_remove_file(disk_to_dev(lo->disk), &pid_attr);
>  	lo->pid = 0;
>  	return 0;
>  }
> @@ -745,7 +745,7 @@ static int __init nbd_init(void)
>  	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
>  
>  	if (max_part < 0) {
> -		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
> +		printk(KERN_ERR "nbd: max_part must be >= 0\n");

Again, dev_err() please.  That properly identifies exactly which device
had problems.

thanks,

greg k-h
