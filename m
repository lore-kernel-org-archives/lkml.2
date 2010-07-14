Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0GNIS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:18:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61485 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0GNISz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NZ+PwrKQyFTc8wfddbSTZTEj7tXs/rYFy6DzOskiwb8Gw/fuuT0h3+ffYoibADiR6K
         v+M4ez4+pcx1DBhTxzTKBedq4XHMJ5GBycRoQxW/ofVMNdWA91c4/+TymjIqhno3I79D
         gyi5A8ICWXMwYggecqdSwvZL5HVT9Qy5+OsYE=
Date: Wed, 14 Jul 2010 01:18:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100714081848.GC2712@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274289757-2723-5-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 07:22:37PM +0200, Daniel Mack wrote:
>  
>  /**
> + * input_alloc_absinfo - allocates an input_absinfo struct
> + * @dev: the input device
> + * @axis: the ABS axis
> + *
> + * If the absinfo struct the caller asked for is already allocated, this
> + * functions will not do anything but return it.
> + */
> +struct input_absinfo *input_alloc_absinfo(struct input_dev *dev, int axis)
> +{
> +	if (!dev->absinfo[axis])
> +		dev->absinfo[axis] =
> +			kzalloc(sizeof(struct input_absinfo), GFP_KERNEL);
> +
> +	WARN(!dev->absinfo[axis], "%s(): kzalloc() failed?\n", __func__);
> +	return dev->absinfo[axis];

This causes us to allocate every absinfo structure separately and use
64 additional pointers (256 bytes on 32 bit boxes and even more on 64 bit
boxes). If device uses enough axis we end up eating up most savings.

I think we should simply alloctate ABS_CNT worth of absinfo first time
we try to set up abs parameters and be done with it so we'll be saving
space for devices not reporting absolute events.

Another optionw woudl be to allow drivers specify size of absinfo array
but I am not sure if it worth it.

Thanks.

-- 
Dmitry
