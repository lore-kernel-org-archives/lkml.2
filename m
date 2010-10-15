Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0JPHjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:39:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42423 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0JPHjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dQqQvoUYG9XH1A6ZMrSAtRi0QhsPh9Cep62dwO5G9aAIpGV3pJfZwCyVQiXg7CXgZ+
         PMfKGDpsCzALH4C9R01zWExLjHxDs/SbG8Sgm5icWEkUkm9DeWXSwaANYiqek5zYVhOf
         +jISHJCn9ZwyNiji3E3uhO91vnUL7UAHUl5vg=
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/7] drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure
Date: Fri, 15 Oct 2010 17:49:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1287147610-8041-3-git-send-email-julia@diku.dk>
In-Reply-To: <1287147610-8041-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151749.07851.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 15:00:06 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In this code, 0 is returned on memory allocation failure, even though other
> failures return -ENOMEM or other similar values.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression ret;
> expression x,e1,e2,e3;
> @@
> 
> ret = 0
> ... when != ret = e1
> *x = \(kmalloc\|kcalloc\|kzalloc\)(...)
> ... when != ret = e2
> if (x == NULL) { ... when != ret = e3
>   return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: <stable@kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

> ---
>  drivers/net/wireless/p54/eeprom.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -u -p a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
> --- a/drivers/net/wireless/p54/eeprom.c
> +++ b/drivers/net/wireless/p54/eeprom.c
> @@ -261,8 +261,10 @@ static int p54_generate_channel_lists(st
>  	list->max_entries = max_channel_num;
>  	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
>  				 max_channel_num, GFP_KERNEL);
> -	if (!list->channels)
> +	if (!list->channels) {
> +		ret = -ENOMEM;
>  		goto free;
> +	}
>  
>  	for (i = 0; i < max_channel_num; i++) {
>  		if (i < priv->iq_autocal_len) {
> 
> 
