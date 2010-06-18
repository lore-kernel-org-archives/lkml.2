Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0FRVML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:12:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471Ab0FRVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:12:08 -0400
Date: Fri, 18 Jun 2010 14:10:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: fix 88pm860x_bl macro collision
Message-Id: <20100618141058.9044b83d.akpm@linux-foundation.org>
In-Reply-To: <20100614170122.b44df729.randy.dunlap@oracle.com>
References: <20100614170122.b44df729.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 17:01:22 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix collision with kernel-supplied #define:
> 
> drivers/video/backlight/88pm860x_bl.c:24:1: warning: "CURRENT_MASK" redefined
> arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> ---
>  drivers/video/backlight/88pm860x_bl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- lnx-2634-rc5.orig/drivers/video/backlight/88pm860x_bl.c
> +++ lnx-2634-rc5/drivers/video/backlight/88pm860x_bl.c
> @@ -21,7 +21,7 @@
>  #define MAX_BRIGHTNESS		(0xFF)
>  #define MIN_BRIGHTNESS		(0)
>  
> -#define CURRENT_MASK		(0x1F << 1)
> +#define CURRENT_BITMASK		(0x1F << 1)
>  
>  struct pm860x_backlight_data {
>  	struct pm860x_chip *chip;
> @@ -85,7 +85,7 @@ static int pm860x_backlight_set(struct b
>  	if ((data->current_brightness == 0) && brightness) {
>  		if (data->iset) {
>  			ret = pm860x_set_bits(data->i2c, wled_idc(data->port),
> -					      CURRENT_MASK, data->iset);
> +					      CURRENT_BITMASK, data->iset);
>  			if (ret < 0)
>  				goto out;
>  		}

mutter.  "CURRENT_BITMASK" isn't a lot better.  And look at
"MAX_BRIGHTNESS" and "MIN_BRIGHTNESS" up there (five instances of
MAX_BRIGHTNESS in the tree).

Just because a definition resides in a .c file doesn't mena that it's
"private"!  We should be more defensive about these things.  And
picking better identifiers gets you more ctags-friendliness for free.


