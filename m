Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1ISIjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:39:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1ISIjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:39:03 -0400
Message-ID: <4E76FF9F.4020505@canonical.com>
Date: Mon, 19 Sep 2011 16:38:55 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110809 Thunderbird/6.0
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 4/5] ideapad: add debugfs support
References: <1315247467-8812-1-git-send-email-ike.pan@canonical.com> <1315247572-9131-1-git-send-email-ike.pan@canonical.com>
In-Reply-To: <1315247572-9131-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some modification.

On 09/06/2011 02:32 AM, Ike Panhc wrote:
>  
>  static acpi_handle ideapad_handle;
> +static struct ideapad_private *ideapad_priv;

This is not necessary.

>  static bool no_bt_rfkill;
>  module_param(no_bt_rfkill, bool, 0444);
>  MODULE_PARM_DESC(no_bt_rfkill, "No rfkill for bluetooth.");
> @@ -188,6 +192,146 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
>  }
>  
>  /*
> + * debugfs
> + */
> +#define DEBUGFS_EVENT_LEN (4096)

No one use this.

> +static int debugfs_cfg_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, debugfs_cfg_show, NULL);

priv structure can be the third argument, so global variable is not necessary.

> +}
> +
> +static const struct file_operations debugfs_cfg_fops = {
> +	.owner = THIS_MODULE,
> +	.open = debugfs_cfg_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +
> +static int __devinit ideapad_debugfs_init(struct ideapad_private *priv)
> +{
> +	struct dentry *node;
> +
> +	priv->debug = debugfs_create_dir("ideapad", NULL);
> +	if (priv->debug == NULL) {

Use IS_ERR_OR_NULL instead.
When CONFIG_DEBUG_FS is not set, debugfs_create_dir will return ERR_PTR(-ENODEV)

> +		pr_err("failed to create debugfs directory");
> +		goto errout;
> +	}
> +
> +	node = debugfs_create_file("cfg", S_IRUGO, priv->debug, NULL,
> +				   &debugfs_cfg_fops);

priv structure can be the third argument.

> +	if (!node) {
> +		pr_err("failed to create cfg in debugfs");
> +		goto errout;
> +	}
> +
> +	node = debugfs_create_file("status", S_IRUGO, priv->debug, NULL,
> +				   &debugfs_status_fops);
> +	if (!node) {
> +		pr_err("failed to create event in debugfs");
> +		goto errout;
> +	}
> +
> +	return 0;
> +
> +errout:

call ideapad_debugfs_exit when failed.

> +	return -ENOMEM;
> +}
> +

> @@ -573,6 +717,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
>  	if (!priv)
>  		return -ENOMEM;
>  	dev_set_drvdata(&adevice->dev, priv);
> +	ideapad_priv = priv;

Removed

>  	ideapad_handle = adevice->handle;
>  	priv->cfg = cfg;
>  
> @@ -580,6 +725,10 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
>  	if (ret)
>  		goto platform_failed;
>  
> +	ret = ideapad_debugfs_init(priv);
> +	if (ret)
> +		goto debugfs_failed;
> +

Not to fail out when debugfs init failed. debugfs is for developers, not for users.

