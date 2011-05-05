Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1EESa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:30:28 -0400
Received: from legolas.restena.lu ([158.64.1.34]:47354 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab1EESa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:30:26 -0400
Date: Thu, 5 May 2011 20:30:12 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: tim.gardner@canonical.com
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Subject: Re: [PATCH] fbcon -- fix race between open and removal of
 framebuffers
Message-ID: <20110505203012.7bc8127f@neptune.home>
In-Reply-To: <1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
	<1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 May 2011 tim.gardner@canonical.com wrote:
> From: Andy Whitcroft <apw@canonical.com>
> 
> Currently there is no locking for updates to the registered_fb list.
> This allows an open through /dev/fbN to pick up a registered framebuffer
> pointer in parallel with it being released, as happens when a conflicting
> framebuffer is ejected or on module unload.  There is also no reference
> counting on the framebuffer descriptor which is referenced from all open
> files, leading to references to released or reused memory to persist on
> these open files.
> 
> This patch adds a reference count to the framebuffer descriptor to prevent
> it from being released until after all pending opens are closed.  This
> allows the pending opens to detect the closed status and unmap themselves.
> It also adds locking to the framebuffer lookup path, locking it against
> the removal path such that it is possible to atomically lookup and take a
> reference to the descriptor.  It also adds locking to the read and write
> paths which currently could access the framebuffer descriptor after it
> has been freed.  Finally it moves the device to FBINFO_STATE_REMOVED to
> indicate that all access should be errored for this device.

Is there a good reason to not use kref for the refcounting? Except for
(un)registering framebuffers this would avoid the need for taking
registered_lock.

Unfortunately fbcon also accesses registered_fb (quite a lot!) but it
probably is save enough through use of the notifiers.

> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> Acked-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/video/fbmem.c |  132 ++++++++++++++++++++++++++++++++++++++-----------
>  include/linux/fb.h    |    2 +
>  2 files changed, 105 insertions(+), 29 deletions(-)
> 

...

> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index df728c1..60de3fa 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -834,6 +834,7 @@ struct fb_tile_ops {
>  struct fb_info {
>  	int node;
>  	int flags;
> +	int ref_count;
>  	struct mutex lock;		/* Lock for open/release/ioctl funcs */
>  	struct mutex mm_lock;		/* Lock for fb_mmap and smem_* fields */
>  	struct fb_var_screeninfo var;	/* Current var */
> @@ -873,6 +874,7 @@ struct fb_info {
>  	void *pseudo_palette;		/* Fake palette of 16 colors */ 
>  #define FBINFO_STATE_RUNNING	0
>  #define FBINFO_STATE_SUSPENDED	1
> +#define FBINFO_STATE_REMOVED	2
>  	u32 state;			/* Hardware state i.e suspend */
>  	void *fbcon_par;                /* fbcon use-only private area */
>  	/* From here on everything is device dependent */
