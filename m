Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab1EEVAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:00:47 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44331 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab1EEVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:00:45 -0400
X-Sasl-enc: uvdjpp+5/0A/+pXCbP+wHRCNI3F80hNWePZno752+Wms 1304629244
Message-ID: <4DC30FFA.9030708@fastmail.fm>
Date: Thu, 05 May 2011 22:00:42 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: tim.gardner@canonical.com
CC: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>
Subject: Re: [PATCH] fbcon -- fix race between open and removal of framebuffers
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com> <1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1304617307-7389-2-git-send-email-tim.gardner@canonical.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 18:41, tim.gardner@canonical.com wrote:
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
> +
>  static int
>  fb_open(struct inode *inode, struct file *file)
>  __acquires(&info->lock)
> @@ -1363,13 +1421,17 @@ __releases(&info->lock)
>  
>  	if (fbidx >= FB_MAX)
>  		return -ENODEV;
> -	info = registered_fb[fbidx];
> +	info = get_framebuffer_info(fbidx);
>  	if (!info)
>  		request_module("fb%d", fbidx);
> -	info = registered_fb[fbidx];
> +	info = get_framebuffer_info(fbidx);
>  	if (!info)
>  		return -ENODEV;

If the first get_framebuffer_info succeeds don't you up the ref count
twice? Shouldn't this be:

info = get_framebuffer_info(fbidx);
if (!info) {
	request_module("fb%d", fbidx);
	info = get_framebuffer_info(fbidx);
}
if (!info)
	return -ENODEV;

Thanks,

Jack
