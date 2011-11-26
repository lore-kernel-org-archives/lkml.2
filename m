Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1KZUEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:04:46 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34225 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab1KZUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:04:34 -0500
X-Sasl-enc: PqayptxlF2vL8yJ6DNydZMDDEyl6k9paophVVEnqHJ5m 1322337873
Date: Sat, 26 Nov 2011 12:02:16 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 2/7] include/linux: add headers for drivers/zio
Message-ID: <20111126200216.GC11421@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com>
 <09c2b3834c06fc45d8cca26d980482c8dad7af5a.1322328075.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09c2b3834c06fc45d8cca26d980482c8dad7af5a.1322328075.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 06:30:31PM +0100, Alessandro Rubini wrote:
> +/*
> + * We use the same functions to deal with attributes, but the structures
> + * we act on may be different (dev, cset, channel). Thus, all structures
> + * begin with the type identifier, and zio_obj_head is used in container_of
> + */

Because you are using container_of, you don't have to have the structure
at the beginning of the structure it is included in, right?

> +enum zio_object_type {
> +	ZNONE = 0,	/* reserved for non zio object */
> +	ZDEV, ZCSET, ZCHAN,
> +	ZTRIG, ZTI,	/* trigger and trigger instance */
> +	ZBUF, ZBI,	/* buffer and buffer instance */
> +};
> +
> +/* zio_obj_head is for internal use only, as explained above */
> +struct zio_obj_head {
> +	struct kobject		kobj;
> +	enum zio_object_type	zobj_type;
> +	char			name[ZIO_NAME_LEN];
> +};
> +#define to_zio_head(_kobj) container_of(_kobj, struct zio_obj_head, kobj)
> +#define to_zio_dev(_kobj) container_of(_kobj, struct zio_device, head.kobj)
> +#define to_zio_cset(_kobj) container_of(_kobj, struct zio_cset, head.kobj)
> +#define to_zio_chan(_kobj) container_of(_kobj, struct zio_channel, head.kobj)

Why are you using a "raw" kobject and not 'struct device' instead?  If
you use a kobject, you loose all of the device tree information that a
real struct device provides to userspace, and can only cause confusion
in the long run.

This also will provide you the "type" and name that you are needing
here, as well as lots of other good things (properly formatted logging
messages, uevents, etc.)

Please consider moving to that instead.

thanks,

greg k-h
