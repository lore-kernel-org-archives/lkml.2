Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2HLV7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:59:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54867 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2HLV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:59:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Aug 2012 23:58:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] firewire: core: feed /dev/random with devices' GUIDs
Message-ID: <20120812235856.65e2c7d5@stein>
In-Reply-To: <5027CFA7.9000100@ladisch.de>
References: <5027CFA7.9000100@ladisch.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 12 Clemens Ladisch wrote:
> Send the GUIDs of newly registered controllers and devices
> to the /dev/random driver to help seed its pools.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

This looks good to me, almost.  Isn't the call in fw_card_add redundant?
The local node's fw_device instance initializer feeds the same GUID,
although a little bit later.

(Added CC: lkml and Theodore because I am not overly familiar with this
matter.)

> ---
>  drivers/firewire/core-card.c   |    3 +++
>  drivers/firewire/core-device.c |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> based on 3.6-rc1
> 
> --- a/drivers/firewire/core-card.c
> +++ b/drivers/firewire/core-card.c
> @@ -29,6 +29,7 @@
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/random.h>
>  #include <linux/spinlock.h>
>  #include <linux/workqueue.h>
> 
> @@ -570,6 +571,8 @@ int fw_card_add(struct fw_card *card,
>  	card->link_speed = link_speed;
>  	card->guid = guid;
> 
> +	add_device_randomness(&guid, sizeof(guid));
> +
>  	mutex_lock(&card_mutex);
> 
>  	generate_config_rom(card, tmp_config_rom);
> --- a/drivers/firewire/core-device.c
> +++ b/drivers/firewire/core-device.c
> @@ -32,6 +32,7 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/random.h>
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> @@ -1066,6 +1067,8 @@ static void fw_device_init(struct work_struct *work)
>  		device->config_rom_retries = 0;
> 
>  		set_broadcast_channel(device, device->generation);
> +
> +		add_device_randomness(&device->config_rom[3], 8);
>  	}
> 
>  	/*



-- 
Stefan Richter
-=====-===-- =--- -==--
http://arcgraph.de/sr/
