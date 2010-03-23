Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0CWMyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:54:14 -0400
Received: from poutre.nerim.net ([62.4.16.124]:62870 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab0CWMyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:54:13 -0400
Date: Tue, 23 Mar 2010 13:54:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]I2C device - release cleanup
Message-ID: <20100323135410.47276f58@hyperion.delvare>
In-Reply-To: <8cad0aa1003230301g44434763w13da24799f811faa@mail.gmail.com>
References: <8cad0aa1003230301g44434763w13da24799f811faa@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Michel,

On Tue, 23 Mar 2010 11:01:28 +0100, Jean-Michel Hautbois wrote:
> Hi there,
> 
> Here is a little patch which aims to cleanup the release function in i2c-dev.c.
> This is only a call to single_release, instead of kfree and several things.
> 
> Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
> ---
> drivers/i2c/i2c-dev.c
> 
> --- linux-2.6.34-rc2/drivers/i2c/i2c-dev.c.orig	2010-03-23
> 10:19:26.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/i2c/i2c-dev.c	2010-03-23 10:55:54.000000000 +0100
> @@ -36,6 +36,7 @@
>  #include <linux/i2c-dev.h>
>  #include <linux/jiffies.h>
>  #include <asm/uaccess.h>
> +#include <linux/seq_file.h>
> 
>  static struct i2c_driver i2cdev_driver;
> 
> @@ -477,12 +478,10 @@ static int i2cdev_open(struct inode *ino
>  static int i2cdev_release(struct inode *inode, struct file *file)
>  {
>  	struct i2c_client *client = file->private_data;
> -
> +	

This is adding trailing white-space. Obviously you did not review your
own patch before sending it. And you did not run it through
scripts/checkpatch.pl either.

>  	i2c_put_adapter(client->adapter);
> -	kfree(client);
> -	file->private_data = NULL;
> -
> -	return 0;
> +	
> +	return single_release(inode, file);
>  }
> 
>  static const struct file_operations i2cdev_fops = {

Did you test your patch? I am very skeptical that calling
single_release() out of the blue is the right thing to do. My instinct
tells me that single_release() is only meant for callers of
single_open().

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
