Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1LCOqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 09:46:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49363 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1LCOqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 09:46:37 -0500
Subject: Re: [PATCH] w1: add fast search for single slave bus
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
In-Reply-To: <1322510807-3247-1-git-send-email-h.feurstein@gmail.com>
Date: Sat, 3 Dec 2011 09:46:29 -0500
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <258EF057-8FF6-4432-A9E5-77F87607C45F@gmail.com>
References: <1322510807-3247-1-git-send-email-h.feurstein@gmail.com>
To: Hubert Feurstein <h.feurstein@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2011-11-28, at 15:06, Hubert Feurstein wrote:

> This enables a much more efficient way of device searching. It uses the
> 1-wire read-rom operation which allows the direct reading of the slave
> address. BUT this works only with exactly one slave on the bus.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---
> drivers/w1/Kconfig |    8 ++++++++
> drivers/w1/w1.c    |   11 +++++++++++
> 2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
> index fd2c7bd..e5006bc 100644
> --- a/drivers/w1/Kconfig
> +++ b/drivers/w1/Kconfig
> @@ -25,6 +25,14 @@ config W1_CON
> 	  2. Userspace commands. Includes read/write and search/alarm search commands.
> 	  3. Replies to userspace commands.
> 
> +config W1_FAST_SEARCH
> +	bool "Fast search (single slave bus only!)"
> +	---help---
> +	  This enables a much more efficient way of device searching. It uses the
> +	  1-wire read-rom operation which allows the direct reading of the slave
> +	  address. BUT this works only with exactly one slave on the bus.
> +	  If unsure, say 'N'.
> +
Not needed I think, see below...
> source drivers/w1/masters/Kconfig
> source drivers/w1/slaves/Kconfig
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index c374978..7c648ec 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -892,6 +892,17 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
> 			break;
> 		}
> 
> +#ifdef CONFIG_W1_FAST_SEARCH
> +		if (dev->max_slave_count == 1) {
> +			w1_write_8(dev, W1_READ_ROM);
> +
> +			if (w1_read_block(dev, (u8 *)&rn, 8) == 8 && rn)
> +				cb(dev, rn);
> +
> +			break;
> +		}
> +#endif
> +
I would drop the CONFIG item and just add this "if" block to the search function
unconditionnaly. Unless I am missing something, it wouldn't hurt multi-slave setups...
> 		/* Start the search */
> 		w1_write_8(dev, search_type);
> 		for (i = 0; i < 64; ++i) {
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

