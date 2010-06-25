Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0FYNq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:46:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49191 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0FYNq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:46:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 5/9] PM / Hibernate: add chunk i/o support
Date: Fri, 25 Jun 2010 15:44:44 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <1275468768-28229-5-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-5-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251544.45121.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 02, 2010, Jiri Slaby wrote:
> Chunk support is useful when not writing whole pages at once. It takes
> care of joining the buffers into the pages and writing at once when
> needed.
> 
> This adds functions for both reads and writes.
> 
> In the end when pages are compressed they use this interface as well
> (because they are indeed shorter than PAGE_SIZE).

This one looks good up to a couple of minor things below.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/block_io.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/power.h    |   16 ++++++
>  2 files changed, 142 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
> index 97024fd..5b6413d 100644
> --- a/kernel/power/block_io.c
> +++ b/kernel/power/block_io.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
>   * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
> + * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)

Please use the e-mail address.

>   *
>   * This file is released under the GPLv2.
>   */
> @@ -74,6 +75,131 @@ int hib_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
>  			virt_to_page(addr), bio_chain);
>  }
>  
> +static int hib_buffer_init_rw(struct hibernate_io_handle *io_handle,
> +		int writing)
> +{
> +	/* should never happen - it means we didn't finish properly last time */
> +	BUG_ON(io_handle->chunk_buffer || io_handle->chunk_buffer_pos);

Please use if (WARN_ON(...)) retuirn -EINVAL; instead.  The BUG_ON() will kill
an otherwise perfectly useable system just because we happen to have a bug in
the hibernation code.

Generally, please don't use BUG_ON() unless you _have_ _to_ (ie. the system
would crash anyway causing data loss and possibly other damage to happen if
we didn't do it).

Rafael
