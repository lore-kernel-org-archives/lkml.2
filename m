Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab1JDUWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:22:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33699 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933631Ab1JDUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:22:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/aSiALBlTaRhRDbqvr6uPzMIQNdYBj9jJxz/idLs
	Gk5nFwtR+Z7Ptt
Message-ID: <4E8B6AEA.2060608@gmx.de>
Date: Tue, 04 Oct 2011 20:22:02 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Michael Thalmeier <michael.thalmeier@hale.at>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mx3fb: fix NULL pointer dereference in screen blanking.
References: <1316779775-12730-1-git-send-email-michael.thalmeier@hale.at>
In-Reply-To: <1316779775-12730-1-git-send-email-michael.thalmeier@hale.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 12:09 PM, Michael Thalmeier wrote:
> From: Wolfram Stering <wolfram.stering@hale.at>
> 
> When blanking an already blanked framebuffer, a kernel NULL pointer
> dereference occurred, because mx3fb driver handles all kinds of screen
> blanking (normal, vsync suspend, powerdown) in the same way.
> Certain programs (Xorg X11 server) first do a normal blank, followed by
> a powerdown blank, which triggered the bug.
> 
> Add an additional safeguard and make sdc_disable_channel() safe against
> multiple calls independent of other logic.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/mx3fb.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index 7e3a490..286be99 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -382,6 +382,9 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
>  	uint32_t enabled;
>  	unsigned long flags;
>  
> +	if (mx3_fbi->txd == NULL)
> +		return;
> +
>  	spin_lock_irqsave(&mx3fb->lock, flags);
>  
>  	enabled = sdc_fb_uninit(mx3_fbi);
> @@ -986,9 +989,19 @@ static void __blank(int blank, struct fb_info *fbi)
>  {
>  	struct mx3fb_info *mx3_fbi = fbi->par;
>  	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
> +	int was_blank = mx3_fbi->blank;
>  
>  	mx3_fbi->blank = blank;
>  
> +	/* Attention!
> +	 * Do not call sdc_disable_channel() for a channel that is disabled
> +	 * already! This will result in a kernel NULL pointer dereference
> +	 * (mx3_fbi->txd is NULL). Hide the fact, that all blank modes are
> +	 * handled equally by this driver.
> +	 */
> +	if (blank > FB_BLANK_UNBLANK && was_blank > FB_BLANK_UNBLANK)
> +		return;
> +
>  	switch (blank) {
>  	case FB_BLANK_POWERDOWN:
>  	case FB_BLANK_VSYNC_SUSPEND:

