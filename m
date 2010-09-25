Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0IYWOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:14:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IYWOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:14:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 13/22] Hibernation: Extent save/load routines.
Date: Sun, 26 Sep 2010 00:12:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> <1285388224-10012-14-git-send-email-nigel@tuxonice.net>
In-Reply-To: <1285388224-10012-14-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009260012.42059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 25, 2010, Nigel Cunningham wrote:
> Add routines for saving and reloading a chain of extents. This will
> be used to store the block extents in the image header, rather than
> in swap map pages.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>

Well, I guess it would be better to move these functions to the patch where
they are used for the first time.

Thanks,
Rafael


> ---
>  kernel/power/extents.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/extents.h |    5 +++
>  2 files changed, 80 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/extents.c b/kernel/power/extents.c
> index 172322d..75d2fb4 100644
> --- a/kernel/power/extents.c
> +++ b/kernel/power/extents.c
> @@ -14,6 +14,7 @@
>  
>  #include <linux/slab.h>
>  #include "extents.h"
> +#include "block_io.h"
>  
>  int hib_extents_empty(struct hib_extent_state *pos)
>  {
> @@ -123,3 +124,77 @@ void hib_extents_clear(struct hib_extent_state *pos)
>  		kfree(ext);
>  	}
>  }
> +
> +int hib_extents_storage_needed(struct hib_extent_state *pos)
> +{
> +	return sizeof(int) + pos->num_extents * 2 * sizeof(unsigned long);
> +}
> +
> +int hib_extents_store(struct hib_extent_state *pos)
> +{
> +	struct rb_node *node;
> +	struct hib_extent *ext;
> +	int ret = hib_write_buffer((char *) &pos->num_extents, sizeof(int));
> +
> +	if (hib_extents_empty(pos))
> +		return 0;
> +
> +	node = rb_first(&pos->root);
> +	while (node) {
> +		ext = container_of(node, struct hib_extent, node);
> +		ret = hib_write_buffer((char *) &ext->start,
> +				2 * sizeof(unsigned long));
> +		if (ret)
> +			return ret;
> +		node = rb_next(node);
> +	}
> +
> +	return 0;
> +}
> +
> +int hib_extents_load(struct hib_extent_state *pos, int bootstrap)
> +{
> +	struct rb_node **new = &(pos->root.rb_node);
> +	struct rb_node *parent = NULL;
> +	struct hib_extent *existing, *adding;
> +	int i;
> +	int ret = hib_read_buffer((char *) &pos->num_extents, sizeof(int));
> +
> +	if (!pos->num_extents)
> +		return 0;
> +
> +	for (i = 0; i < pos->num_extents; i++) {
> +		adding = kzalloc(sizeof(struct hib_extent), GFP_KERNEL);
> +		if (!adding)
> +			return -ENOMEM;
> +
> +		ret = hib_read_buffer((char *) &adding->start,
> +				2 * sizeof(unsigned long));
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * No need for some of the checks from inserting above -
> +		 * they were done when preparing the image.
> +		 */
> +		while (*new) {
> +			existing = container_of(*new, struct hib_extent, node);
> +			parent = *new;
> +			if (adding->end < existing->start)
> +				new = &((*new)->rb_left);
> +			else
> +				new = &((*new)->rb_right);
> +		}
> +		rb_link_node(&adding->node, parent, new);
> +		rb_insert_color(&adding->node, &pos->root);
> +
> +		if (bootstrap && !i) {
> +			hib_reset_extent_pos(&sector_extents);
> +
> +			/* We have already read the first page */
> +			hib_extent_next(&sector_extents);
> +		}
> +	}
> +
> +	return 0;
> +}
> diff --git a/kernel/power/extents.h b/kernel/power/extents.h
> index 0b69b8e..4288f9e 100644
> --- a/kernel/power/extents.h
> +++ b/kernel/power/extents.h
> @@ -33,3 +33,8 @@ unsigned long hib_extent_next(struct hib_extent_state *pos);
>  int hib_extents_insert(struct hib_extent_state *pos, unsigned long value);
>  void hib_extents_clear(struct hib_extent_state *pos);
>  int hib_extents_empty(struct hib_extent_state *pos);
> +
> +/* Serialisation support */
> +int hib_extents_storage_needed(struct hib_extent_state *pos);
> +int hib_extents_store(struct hib_extent_state *pos);
> +int hib_extents_load(struct hib_extent_state *pos, int bootstrap);
> 

