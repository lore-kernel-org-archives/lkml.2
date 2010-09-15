Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0IOJbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:31:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49520 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0IOJbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IBzT1H0MfrPfYLUqQvXMCzkAxa9OiwlNRQ3ITXMmms/lyFb0AOWtPj1bPqsclJ9JFU
         V9y8MkNe0u4NnnVEABOl6bPoX4RChhKyx1DXf4JEWFcEctQSrJP7MtLgRWa3rIhgDMGu
         wwNBGzvlOdomvFO+Ce/l5O6gWLq5vXRE5HeME=
MIME-Version: 1.0
In-Reply-To: <1284493213-7263-5-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
	<1284493213-7263-5-git-send-email-arnd@arndb.de>
Date: Wed, 15 Sep 2010 10:31:34 +0100
Message-ID: <AANLkTik44U-8vTbw5XvVxRJp-7v1wDg35vqPT-BTJQ70@mail.gmail.com>
Subject: Re: [PATCH 04/18] isapnp: BKL removal
From: Will Newton <will.newton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 8:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
> index 3f94eda..4249999 100644
> --- a/drivers/pnp/isapnp/proc.c
> +++ b/drivers/pnp/isapnp/proc.c
> @@ -31,8 +31,9 @@ static struct proc_dir_entry *isapnp_proc_bus_dir = NULL;
>  static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
>  {
>        loff_t new = -1;
> +       struct inode *inode = file->f_path.dentry->d_inode;
>
> -       lock_kernel();
> +       mutex_lock(&inode->i_mutex);
>        switch (whence) {
>        case 0:
>                new = off;
> @@ -45,11 +46,11 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
>                break;
>        }
>        if (new < 0 || new > 256) {

Mismatched brackets here?

> -               unlock_kernel();
> -               return -EINVAL;
> -       }
> -       unlock_kernel();
> -       return (file->f_pos = new);
> +               new = -EINVAL;
> +       else
> +               file->f_pos = new;
> +       mutex_unlock(&inode->i_mutex);
> +       return new;
>  }
>
