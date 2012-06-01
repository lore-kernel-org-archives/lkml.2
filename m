Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2FAJxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:53:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46242 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790Ab2FAJxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:53:34 -0400
Date: Fri, 1 Jun 2012 11:53:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Moser <john.r.moser@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: Is this code right in zram?
Message-ID: <20120601095330.GC3969@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	John Moser <john.r.moser@gmail.com>, linux-kernel@vger.kernel.org,
	Nitin Gupta <ngupta@vflare.org>
References: <4FC7E610.5060207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC7E610.5060207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 05:43:44PM -0400, John Moser wrote:
> before I go stomping all over other peoples' work and sending
> idiotic patches, I think I'll ask.  Since I have no clue what I'm
> doing.
> 
> in drivers/staging/zram.c out of 3.4

There's no such file in 3.4 - I get

tree v3.4:drivers/staging/zram/

Kconfig
Makefile
zram.txt
zram_drv.c
zram_drv.h
zram_sysfs.c

I'm guessing you mean zram_drv.c - there's code like that below?

> (I just grabbed the source
> hours ago), I see this on lines 810-822:
> 
>        /* Allocate the device array and initialize each one */
>         pr_info("Creating %u devices ...\n", num_devices);
>         zram_devices = kzalloc(num_devices * sizeof(struct zram),
> GFP_KERNEL);
>         if (!zram_devices) {
>                 ret = -ENOMEM;
>                 goto unregister;
>         }
> 
>         for (dev_id = 0; dev_id < num_devices; dev_id++) {
>                 ret = create_device(&zram_devices[dev_id], dev_id);
>                 if (ret)
>                         goto free_devices;
>         }
> 
> Curiosity got me to here:
> 
> http://lwn.net/Articles/147014/
> 
> So assuming this, what I see here is:
> 
>  - kmalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
>  - memset() that to 0
>  - immediately fill in this RAM without reading it
> 
> I'm wondering what the immediate need is to fill the area with
> zeros?

You don't want to use unitialized memory in those zram_devices thingies,
i.e. touch something in there which you haven't initialized before thus
the convention to zero out the whole struct.

Right, create_device() does that init later but what do you do if
create_device changes and forgets one variable, for example? There's
your bug (and a very subtle one, for that matter).

That's why you can't risk it and have to init the memory to a known good
value just in case.

> Also curious as to whether the kzalloc() thing should better be
> kcalloc(num_devices, sizeof(struct zram), GFP_KERNEL) as a matter of
> convention.

That makes sense, let's ask.

-- 
Regards/Gruss,
    Boris.
