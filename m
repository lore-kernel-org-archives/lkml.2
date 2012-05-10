Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab2EJXW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:22:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2EJXW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:22:28 -0400
Date: Thu, 10 May 2012 16:22:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Greg KH <greg@kroah.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-Id: <20120510162227.5cf2294b.akpm@linux-foundation.org>
In-Reply-To: <4FAC47F6.6080903@hrz.tu-chemnitz.de>
References: <20120503180056.GB13988@ioremap.net>
	<4FAAD584.70102@hrz.tu-chemnitz.de>
	<20120509220636.GA27659@kroah.com>
	<4FAAECB7.8070904@hrz.tu-chemnitz.de>
	<20120509222411.GA24302@kroah.com>
	<4FAAF1C4.2050500@hrz.tu-chemnitz.de>
	<20120509235723.GA7404@ioremap.net>
	<20120510000126.GA2357@kroah.com>
	<20120510004350.GA8362@ioremap.net>
	<4FAB4A4D.8080901@hrz.tu-chemnitz.de>
	<20120510151639.GE17472@kroah.com>
	<4FAC47F6.6080903@hrz.tu-chemnitz.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 00:57:58 +0200
Markus Franke <markus.franke@s2002.tu-chemnitz.de> wrote:

> +static int w1_f1C_add_slave(struct w1_slave *sl)
> +{
> +	int err = 0;
> +	int i;
> +	struct w1_f1C_data *data = NULL;
> +
> +	if (w1_enable_crccheck) {
> +		data = kzalloc(sizeof(struct w1_f1C_data), GFP_KERNEL);
> +		if (!data)
> +			return -ENOMEM;
> +		sl->family_data = data;
> +	}
> +
> +	/* create binary sysfs attributes */
> +	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
> +		err = sysfs_create_bin_file(
> +			&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
> +
> +	if (err)
> +		goto out;

If this goto is taken, we will leak 0..i sysfs files.

> +	/* create device attributes */
> +	err = device_create_file(&sl->dev, &dev_attr_crccheck);
> +
> +	if (err) {
> +		/* remove binary sysfs attributes */
> +		for (i = 0; i < NB_SYSFS_BIN_FILES; ++i)
> +			sysfs_remove_bin_file(
> +				&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
> +	}
> +
> +out:
> +	if (err) {
> +		if (w1_enable_crccheck)
> +			kfree(data);

kfree(NULL) is legal - the w1_enable_crccheck test can be removed.

> +	}
> +
> +	return err;
> +}
