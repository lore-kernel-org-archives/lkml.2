Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab1AGJKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:10:07 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:46309 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1AGJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:10:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=eMBHRC0OYDA+XVwG1rGM2osOHVkS0NiTY7vKdSeQeMgWylokT9RKQ1PJ65YvQlORbb
         rJsp6FuPVn8YYf2rMvOs5R870blmQ179D9QdqLZ5I21HsxZKyPMeu9NgppPQxdnAGoVm
         mSJsPevGojrCD4v4VQ5mXoVKv/6rKNKpPYvZ8=
Message-ID: <4D26D866.40906@suse.cz>
Date: Fri, 07 Jan 2011 10:09:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 34/36] tty: add 'active' sysfs attribute to tty0 and console
 device
References: <20110106215404.GA30624@kroah.com> <1294352605-31906-34-git-send-email-gregkh@suse.de>
In-Reply-To: <1294352605-31906-34-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 11:23 PM, Greg Kroah-Hartman wrote:
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -3232,9 +3232,45 @@ static int __init tty_class_init(void)
>  postcore_initcall(tty_class_init);
>  
>  /* 3/2004 jmc: why do these devices exist? */
> -
>  static struct cdev tty_cdev, console_cdev;
>  
> +static ssize_t show_cons_active(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct console *cs[16];
> +	int i = 0;
> +	struct console *c;
> +	ssize_t count = 0;
> +
> +	acquire_console_sem();
> +	for (c = console_drivers; c; c = c->next) {

This should be:
for_each_console(c)
like somebody already suggested.

> +		if (!c->device)
> +			continue;

Why are consoles without devices ignored here?

Other than that there are 2 build warnings, see below.

> +		if (!c->write)
> +			continue;
> +		if ((c->flags & CON_ENABLED) == 0)
> +			continue;
> +		cs[i++] = c;
> +		if (i >= ARRAY_SIZE(cs))
> +			break;
> +	}
> +	while (i--)
> +		count += sprintf(buf + count, "%s%d%c",
> +				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
> +	release_console_sem();
> +
> +	return count;
> +}
> +static DEVICE_ATTR(active, S_IRUGO, show_cons_active, NULL);
> +
> +static struct device *consdev;
> +
> +void console_sysfs_notify(void)
> +{
> +	if (consdev)
> +		sysfs_notify(&consdev->kobj, NULL, "active");
> +}
> +
>  /*
>   * Ok, now we can initialize the rest of the tty devices and can count
>   * on memory allocations, interrupts etc..
> @@ -3245,15 +3281,18 @@ int __init tty_init(void)
>  	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
>  	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
>  		panic("Couldn't register /dev/tty driver\n");
> -	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL,
> -			      "tty");
> +	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");
>  
>  	cdev_init(&console_cdev, &console_fops);
>  	if (cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1) ||
>  	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 1), 1, "/dev/console") < 0)
>  		panic("Couldn't register /dev/console driver\n");
> -	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
> +	consdev = device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
>  			      "console");
> +	if (IS_ERR(consdev))
> +		consdev = NULL;
> +	else
> +		device_create_file(consdev, &dev_attr_active);

drivers/tty/tty_io.c: In function ‘tty_init’:
drivers/tty/tty_io.c:3309:21: warning: ignoring return value of
‘device_create_file’, declared with attribute warn_unused_result

> @@ -2967,13 +2977,24 @@ static const struct tty_operations con_ops = {
>  
>  static struct cdev vc0_cdev;
>  
> +static ssize_t show_tty_active(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "tty%d\n", fg_console + 1);
> +}
> +static DEVICE_ATTR(active, S_IRUGO, show_tty_active, NULL);
> +
>  int __init vty_init(const struct file_operations *console_fops)
>  {
>  	cdev_init(&vc0_cdev, console_fops);
>  	if (cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1) ||
>  	    register_chrdev_region(MKDEV(TTY_MAJOR, 0), 1, "/dev/vc/0") < 0)
>  		panic("Couldn't register /dev/tty0 driver\n");
> -	device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
> +	tty0dev = device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
> +	if (IS_ERR(tty0dev))
> +		tty0dev = NULL;
> +	else
> +		device_create_file(tty0dev, &dev_attr_active);

drivers/tty/vt/vt.c: In function ‘vty_init’:
drivers/tty/vt/vt.c:2997:21: warning: ignoring return value of
‘device_create_file’, declared with attribute warn_unused_result

>  
>  	vcs_init();
>  

regards,
-- 
js
suse labs
