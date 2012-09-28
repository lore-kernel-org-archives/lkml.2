Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2I1QAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:00:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34114 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2I1QAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:00:49 -0400
Date: Fri, 28 Sep 2012 09:00:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv4 1/4] modem_shm: Add Modem Access Framework
Message-ID: <20120928160045.GD2625@kroah.com>
References: <1348819504-1303-1-git-send-email-arun.murthy@stericsson.com>
 <1348819504-1303-2-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348819504-1303-2-git-send-email-arun.murthy@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:35:01PM +0530, Arun Murthy wrote:
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/printk.h>
> +#include <linux/modem_shm/modem.h>
> +
> +static struct class *modem_class;

What's wrong with a bus_type instead?

> +static int __modem_is_requested(struct device *dev, void *data)
> +{
> +	struct modem_desc *mdesc = (struct modem_desc *)data;
> +
> +	if (!mdesc->mclients) {
> +		printk(KERN_ERR "modem_access: modem description is NULL\n");
> +		return 0;
> +	}
> +	return atomic_read(&mdesc->mclients->cnt);
> +}
> +
> +int modem_is_requested(struct modem_desc *mdesc)
> +{
> +	return class_for_each_device(modem_class, NULL, (void *)mdesc, __modem_is_requested);
> +}

Where is the documentation for your public api functions like this?

> +
> +int modem_release(struct modem_desc *mdesc)
> +{
> +	if (!mdesc->release)
> +		return -EFAULT;
> +
> +	if (modem_is_requested(mdesc)) {
> +		atomic_dec(&mdesc->mclients->cnt);
> +		if (atomic_read(&mdesc->use_cnt) == 1) {
> +			mdesc->release(mdesc);
> +			atomic_dec(&mdesc->use_cnt);
> +		}

Eeek, why aren't you using the built-in reference counting that the
struct device provided to you, and instead are rolling your own?  This
happens in many places, why?

greg k-h
