Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1IWHEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 03:04:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33705 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1IWHEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 03:04:21 -0400
Subject: Re: [patch] agp: potential info leak in compat_agpioc_info_wrap()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20110923061945.GC4387@elgon.mountain>
References: <20110923061945.GC4387@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 09:04:15 +0200
Message-ID: <1316761455.2560.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 23 septembre 2011 à 09:19 +0300, Dan Carpenter a écrit :
> Smatch has a new check for Rosenberg type information leaks where
> structs are copied to the user with uninitialized stack data in them.
> 

Hmm, automatic tools should not send patches without human check.

> The agp_info32 struct has a 4 byte hole in it so we need to clear
> that before copying it to userspace.
> 
> struct agp_info32 {
>         struct agp_version         version;              /*     0     0 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 

This makes no sense :

Why should we have a 32bit hole before an u32 field ?

Which arch mandates this ?

>         u32                        bridge_id;            /*     4     4 */
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/char/agp/compat_ioctl.c b/drivers/char/agp/compat_ioctl.c
> index a48e05b..0509497 100644
> --- a/drivers/char/agp/compat_ioctl.c
> +++ b/drivers/char/agp/compat_ioctl.c
> @@ -42,6 +42,8 @@ static int compat_agpioc_info_wrap(struct agp_file_private *priv, void __user *a
>  
>  	agp_copy_info(agp_bridge, &kerninfo);
>  
> +	memset(&userinfo, 0, sizeof(userinfo));
> +
>  	userinfo.version.major = kerninfo.version.major;
>  	userinfo.version.minor = kerninfo.version.minor;
>  	userinfo.bridge_id = kerninfo.device->vendor |


