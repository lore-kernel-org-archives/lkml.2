Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2K0Wnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:43:45 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51412 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab2K0Wno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:43:44 -0500
Date: Tue, 27 Nov 2012 23:43:41 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Message-ID: <20121127224341.GA2605@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211271348.14603.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:48:14PM +0200, Vitalii Demianets wrote:
> Fix warning: 'ret' might be used uninitialized
> 
> Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
> ---
>  drivers/uio/uio.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 5110f36..c33fd18 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -280,12 +280,16 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>  			map_found = 1;
>  			idev->map_dir = kobject_create_and_add("maps",
>  							&idev->dev->kobj);
> -			if (!idev->map_dir)
> +			if (!idev->map_dir) {
> +				ret = -ENOMEM;
>  				goto err_map;
> +			}
>  		}
>  		map = kzalloc(sizeof(*map), GFP_KERNEL);
> -		if (!map)
> +		if (!map) {
> +			ret = -ENOMEM;
>  			goto err_map;
> +		}
>  		kobject_init(&map->kobj, &map_attr_type);
>  		map->mem = mem;
>  		mem->map = map;
> @@ -305,12 +309,16 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>  			portio_found = 1;
>  			idev->portio_dir = kobject_create_and_add("portio",
>  							&idev->dev->kobj);
> -			if (!idev->portio_dir)
> +			if (!idev->portio_dir) {
> +				ret = -ENOMEM;
>  				goto err_portio;
> +			}
>  		}
>  		portio = kzalloc(sizeof(*portio), GFP_KERNEL);
> -		if (!portio)
> +		if (!portio) {
> +			ret = -ENOMEM;
>  			goto err_portio;
> +		}
>  		kobject_init(&portio->kobj, &portio_attr_type);
>  		portio->port = port;
>  		port->portio = portio;
> -- 
> 1.7.8.6
> 

Thanks, good catch, but why don't you simply do this:


>From 228445996bb75a44d16b6237eca6a0916d9b2d7e Mon Sep 17 00:00:00 2001
From: "Hans J. Koch" <hjk@hansjkoch.de>
Date: Tue, 27 Nov 2012 23:38:00 +0100
Subject: [PATCH] uio: Fix warning: 'ret' might be used uninitialized

In two cases, the return value variable "ret" can be undefined.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
---
 drivers/uio/uio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..fc60e35 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -263,7 +263,7 @@ static struct class uio_class = {
  */
 static int uio_dev_add_attributes(struct uio_device *idev)
 {
-	int ret;
+	int ret = -ENOMEM;
 	int mi, pi;
 	int map_found = 0;
 	int portio_found = 0;
-- 
1.7.9

