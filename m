Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1EJVIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:08:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57456 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163Ab1EJVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:08:09 -0400
X-Sasl-enc: I/cHzjSXwAfaI0SagEBlVWRxYjJFACvOjlHUu7hVJ/WR 1305061688
Message-ID: <4DC9A933.5030706@fastmail.fm>
Date: Tue, 10 May 2011 22:08:03 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Subject: Re: [PATCH V2] fbcon -- fix race between open and removal of framebuffers
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com> <1304617307-7389-2-git-send-email-tim.gardner@canonical.com> <4DC30FFA.9030708@fastmail.fm> <4DC933EE.70409@canonical.com> <4DC9A8C0.9070502@fastmail.fm>
In-Reply-To: <4DC9A8C0.9070502@fastmail.fm>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 22:06, Jack Stone wrote:
> Hi Tim,
> 
> One more quick question:
> 
> On 10/05/2011 13:47, Tim Gardner wrote:
> +static struct fb_info *get_framebuffer_info(int idx)
> +__acquires(&registered_lock)
> +__releases(&registered_lock)
> +{
> +	struct fb_info *fb_info;
> +
> +	spin_lock(&registered_lock);
> +	fb_info = registered_fb[idx];
> +	fb_info->ref_count++;
> +	spin_unlock(&registered_lock);
> +
> +	return fb_info;
> +}
> 
> [snip]
> 
>  static int
>  fb_open(struct inode *inode, struct file *file)
>  __acquires(&info->lock)
> @@ -1363,13 +1421,18 @@ __releases(&info->lock)
> 
>  	if (fbidx >= FB_MAX)
>  		return -ENODEV;
> -	info = registered_fb[fbidx];
> -	if (!info)
> +	info = get_framebuffer_info(fbidx);
> +	if (!info) {
>  		request_module("fb%d", fbidx);
> -	info = registered_fb[fbidx];
> +		info = get_framebuffer_info(fbidx);
> +	}
>  	if (!info)
>  		return -ENODEV;
> 
> This section of code implies that get_framebuffer_info can return NULL
> but in that case wouldn't the fb_info->ref_count++ have oopsed?
> 
> You could add the simple case of
> 
> if(fb_info)
> 	fb_info->ref_count++
> 
> to get_framebuffer_info. That should cover it.
> 

Just read your later patch. Sorry for the extra email.

Thanks,

Jack
