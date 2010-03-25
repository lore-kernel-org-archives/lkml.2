Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0CYWf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:35:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0CYWfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:35:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 11/15] PM / Hibernate: add chunk i/o support
Date: Thu, 25 Mar 2010 23:38:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-11-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-11-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252338.48513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> Chunk support is useful when not writing whole pages at once. It takes
> care of joining the buffers into the pages and writing at once when
> needed.
> 
> In the end when pages are compressed they use this interface as well
> (because they are indeed shorter than PAGE_SIZE).
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/block_io.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/power.h    |    6 +++
>  2 files changed, 87 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
> index 2b7898a..37412f7 100644
> --- a/kernel/power/block_io.c
> +++ b/kernel/power/block_io.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
>   * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
> + * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
>   *
>   * This file is released under the GPLv2.
>   */
> @@ -14,6 +15,9 @@
>  
>  #include "power.h"
>  
> +static char *sws_writer_buffer;
> +static unsigned long sws_writer_buffer_pos;
> +
>  /**
>   *	submit - submit BIO request.
>   *	@rw:	READ or WRITE.
> @@ -74,6 +78,83 @@ int sws_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
>  			virt_to_page(addr), bio_chain);
>  }
>  
> +int sws_rw_buffer_init(int writing)
> +{
> +	BUG_ON(sws_writer_buffer || sws_writer_buffer_pos);

Please don't do that.  Fail the operation instead.  You can also use WARN_ON
or WARN if you _really_ want the user to notice the failure.

BUG_ON's like this are annoying like hell for testers who trigger them.

> +	sws_writer_buffer = (void *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
> +	if (sws_writer_buffer && !writing)
> +		sws_writer_buffer_pos = PAGE_SIZE;
> +
> +	return sws_writer_buffer ? 0 : -ENOMEM;
> +}
> +
> +/**
> + * sws_rw_buffer - combine smaller buffers into PAGE_SIZE I/O
> + * @writing:		Bool - whether writing (or reading).
> + * @buffer:		The start of the buffer to write or fill.
> + * @buffer_size:	The size of the buffer to write or fill.
> + **/
> +int sws_rw_buffer(int writing, char *buffer, int buffer_size)
> +{
> +	int bytes_left = buffer_size, ret;
> +
> +	while (bytes_left) {
> +		char *source_start = buffer + buffer_size - bytes_left;
> +		char *dest_start = sws_writer_buffer + sws_writer_buffer_pos;
> +		int capacity = PAGE_SIZE - sws_writer_buffer_pos;
> +		char *to = writing ? dest_start : source_start;
> +		char *from = writing ? source_start : dest_start;
> +
> +		if (bytes_left <= capacity) {
> +			memcpy(to, from, bytes_left);
> +			sws_writer_buffer_pos += bytes_left;
> +			return 0;
> +		}
> +
> +		/* Complete this page and start a new one */
> +		memcpy(to, from, capacity);
> +		bytes_left -= capacity;
> +
> +		if (writing) {
> +			ret = sws_io_ops->write_page(sws_writer_buffer, NULL);
> +			clear_page(sws_writer_buffer);

Why do we need that clear_page()?

> +			if (ret)
> +				return ret;

Please move these two lines out of the if()/else.

> +		} else {
> +			ret = sws_io_ops->read_page(sws_writer_buffer, NULL);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		sws_writer_buffer_pos = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +int sws_rw_buffer_flush_page(int writing)
> +{
> +	int ret = 0;
> +	if (writing && sws_writer_buffer_pos)
> +		ret = sws_io_ops->write_page(sws_writer_buffer, NULL);
> +	sws_writer_buffer_pos = writing ? 0 : PAGE_SIZE;
> +	return ret;
> +}

I'd split the above into two functions, one for writing and the other for
reading.

Doing the same with sws_rw_buffer() (under a better name), for the sake of
clarity, also might make some sense, apparently.

> +
> +int sws_rw_buffer_finish(int writing)
> +{
> +	int ret = 0;
> +
> +	ret = sws_rw_buffer_flush_page(writing);
> +
> +	free_page((unsigned long)sws_writer_buffer);
> +	sws_writer_buffer = NULL;
> +	sws_writer_buffer_pos = 0;
> +
> +	return ret;
> +}
> +
>  int sws_wait_on_bio_chain(struct bio **bio_chain)
>  {
>  	struct bio *bio;
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 0f08de4..50a888a 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -3,6 +3,8 @@
>  #include <linux/utsname.h>
>  #include <linux/freezer.h>
>  
> +struct swap_map_handle;
> +
>  struct swsusp_info {
>  	struct new_utsname	uts;
>  	u32			version_code;
> @@ -161,6 +163,10 @@ extern int sws_bio_read_page(pgoff_t page_off, void *addr,
>  extern int sws_bio_write_page(pgoff_t page_off, void *addr,
>  		struct bio **bio_chain);
>  extern int sws_wait_on_bio_chain(struct bio **bio_chain);
> +extern int sws_rw_buffer_init(int writing);
> +extern int sws_rw_buffer_finish(int writing);
> +extern int sws_rw_buffer_flush_page(int writing);
> +extern int sws_rw_buffer(int writing, char *buffer, int buffer_size);
>  
>  struct timeval;
>  /* kernel/power/swsusp.c */
> 

