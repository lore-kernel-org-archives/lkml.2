Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0CXJ3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:29:46 -0400
Received: from poutre.nerim.net ([62.4.16.124]:62839 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab0CXJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:29:45 -0400
Date: Wed, 24 Mar 2010 10:29:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: properly acquire I/O regions while
 probing
Message-ID: <20100324102942.215ee413@hyperion.delvare>
In-Reply-To: <1269353535-23134-1-git-send-email-me@mortis.eu>
References: <1269353535-23134-1-git-send-email-me@mortis.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 15:12:15 +0100, Giel van Schijndel wrote:
> Acquire the I/O region for the Super I/O chip while we're working on it.
> 
> Further alter the way multiple Super I/O addresses are probed for chips
> such that errors in the probing process are passed on from the module
> initialisation function.
> 
> Some code cleanup: properly using, previously defined, functions rather
> than duplicating their code.
> (...)

On top of Hans' comments, to which I agree:

>  static u16 f71882fg_read_temp(struct f71882fg_data *data, int nr)
> @@ -2184,6 +2178,13 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>  	int err = -ENODEV;
>  	u16 devid;
>  
> +	/* Don't step on other driver's I/O space by accident */
> +	if (!request_region(sioaddr, 2, DRVNAME)) {
> +		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
> +				(int)sioaddr);
> +		return -EIO;

This is the wrong error code. This isn't an I/O error. You want -EBUSY.

> +	}
> +
>  	superio_enter(sioaddr);
>  
>  	devid = superio_inw(sioaddr, SIO_REG_MANID);

-- 
Jean Delvare
