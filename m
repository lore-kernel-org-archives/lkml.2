Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0IPVHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:07:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab0IPVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:07:14 -0400
Date: Thu, 16 Sep 2010 14:06:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: thomas@winischhofer.net, security@kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [Security] [PATCH] drivers/video/sis/sis_main.c: prevent
 reading uninitialized stack memory
Message-Id: <20100916140644.9788e677.akpm@linux-foundation.org>
In-Reply-To: <1284587033.6275.96.camel@dan>
References: <1284587033.6275.96.camel@dan>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 17:43:53 -0400
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16
> bytes of uninitialized stack memory, because the "reserved" member of
> the fb_vblank struct declared on the stack is not altered or zeroed
> before being copied back to the user.  This patch takes care of it.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 
> --- linux-2.6.35.4.orig/drivers/video/sis/sis_main.c	2010-08-26 19:47:12.000000000 -0400
> +++ linux-2.6.35.4/drivers/video/sis/sis_main.c	2010-09-15 11:52:41.437375730 -0400
> @@ -1701,6 +1701,9 @@ static int	sisfb_ioctl(struct fb_info *i
>  		break;
>  
>  	   case FBIOGET_VBLANK:
> +
> +		memset(&sisvbblank, 0, sizeof(struct fb_vblank));

grumble.  Every one of these patches I need to go in and check that the
types are correct.  In this case, that sisvbblank really does have the
type `struct fb_vblank'.

If the code had done

		memset(&sisvbblank, 0, sizeof(sisvbblank));

then I wouldn't need to do that.

