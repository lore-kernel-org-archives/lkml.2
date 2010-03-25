Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0CYWlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:41:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0CYWla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:41:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 12/15] PM / Hibernate: split snapshot_read_next
Date: Thu, 25 Mar 2010 23:44:39 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-12-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-12-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252344.39415.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> When writing the snapshot, do the initialization and header write in
> a separate function. This makes the code more readable and lowers
> complexity of snapshot_read_next.

Good idea overall, but ->

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/power.h    |    1 +
>  kernel/power/snapshot.c |   63 +++++++++++++++++++++++++++++-----------------
>  kernel/power/swap.c     |   14 +++-------
>  3 files changed, 45 insertions(+), 33 deletions(-)
> 
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 50a888a..638a97c 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -130,6 +130,7 @@ struct sws_module_ops {
>  
>  extern unsigned int snapshot_additional_pages(struct zone *zone);
>  extern unsigned long snapshot_get_image_size(void);
> +extern int snapshot_write_init(struct snapshot_handle *handle);
>  extern int snapshot_read_next(struct snapshot_handle *handle);
>  extern int snapshot_write_next(struct snapshot_handle *handle);
>  extern void snapshot_write_finalize(struct snapshot_handle *handle);
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 7918351..c8864de 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -1597,10 +1597,44 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
>  }
>  
>  /**
> + *	snapshot_write_init - initialization before writing the snapshot to
> + *	a backing storage
> + *
> + *	This function *must* be called before snapshot_read_next to initialize
> + *	@handle and write a header.
> + *
> + *	@handle: snapshot handle to init
> + */
> +int snapshot_write_init(struct snapshot_handle *handle)
> +{
> +	int ret;
> +
> +	/* This makes the buffer be freed by swsusp_free() */
> +	buffer = get_image_page(GFP_ATOMIC, PG_ANY);
> +	if (!buffer)
> +		return -ENOMEM;
> +	init_header(buffer);
> +	ret = sws_rw_buffer_init(1);

-> That's hardly readable.  You could define something like
HIBERNATE_WRITING and HIBERNATE_READING and pass one of them instead of the '1'.
Or something.

Likewise in a few places below.

[Or even better IMO, define hibernate_write_buffer_init() and
hibernate_read_buffer_init() etc.]

> +	if (ret)
> +		return ret;
> +	ret = sws_rw_buffer(1, buffer, sizeof(struct swsusp_info));
> +	if (ret)
> +		goto finish;
> +	sws_rw_buffer_finish(1);
> +	memory_bm_position_reset(&orig_bm);
> +	memory_bm_position_reset(&copy_bm);
> +	handle->buffer = buffer;
> +	return 0;
> +finish:
> +	sws_rw_buffer_finish(1);
> +	return ret;
> +}
> +
> +/**
>   *	snapshot_read_next - used for reading the system memory snapshot.
>   *
> - *	On the first call to it @handle should point to a zeroed
> - *	snapshot_handle structure.  The structure gets updated and a pointer
> + *	Before calling this function, snapshot_write_init has to be called with
> + *	handle passed as @handle here. The structure gets updated and a pointer
>   *	to it should be passed to this function every next time.
>   *
>   *	On success the function returns a positive number.  Then, the caller

Rafael
