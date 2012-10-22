Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2JVAzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:55:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53171 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2JVAzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:55:54 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-22-50849998c34c
Message-id: <50849998.2010201@samsung.com>
Date: Mon, 22 Oct 2012 09:55:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: anish kumar <anish198519851985@gmail.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: driver model release call not needed
References: <1350794811-12388-1-git-send-email-anish198519851985@gmail.com>
In-reply-to: <1350794811-12388-1-git-send-email-anish198519851985@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd0ZM1sCDPa+FLe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZy38vZSs4yl/xesFxtgbGezxdjJwcEgImEj13tjJB2GISF+6t
	Z+ti5OIQEpjOKDH/62d2CKeLSWLfulssIFW8AloSnw/MYgOxWQRUJe49ecMOYrMBxfe/uAEU
	5+AQFYiQ+NXPAVEuKPFj8j0WkLCIgK7EpoUpIGFmoIpJrxaDTRQWcJRYvPkz2EQhAW+J801r
	GEHKOQV8JA62s0KU60jsb53GBmHLS2xe85Z5AqPALCQLZiEpm4WkbAEj8ypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4OB7JrWDcWWDxSFGAQ5GJR5eJuvmACHWxLLiytxDjBIczEoivKfi
	WwKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQICaQnlqRmp6YWpBbBZJk4OKUaGEMEk05a
	+eyR5P87lfXOlTzPG394jH6ZRfPFhW3pO/8r7oNf2b39XXNmid24w36kdPqWf06buZy3vWW1
	vvHAy7oxUCPccrP0P88PSx99jsgtk93xT8Bt33qW4rkM6z5Gl9w84OrdvPXast8GqXI887md
	pC+feXhHxXw+r+z5usRTDMZv5/65k6rEUpyRaKjFXFScCACVQa9lOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 01:46 PM, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> There was a case where free and list_del can be called twice
> on the same pointer.So fixed it by re-arranging the code and
> removing a function which was not needed.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/extcon/extcon-class.c |   71 ++++++++++++++++++-----------------------
>  1 files changed, 31 insertions(+), 40 deletions(-)
> 
Applied, thanks,

But, There were some minor issue, so I fix and applied it.

[...]

>  static void extcon_dev_release(struct device *dev)
>  {
> -	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
> -
> -	extcon_cleanup(edev, true);
> +	struct extcon_dev *edev = dev_get_drvdata(dev);
> +	kfree(edev->dev);
It is not necessary to get extcon_dev instance through dev_get_drvdata()
and only call kfree(dev) by using extcon_dev_release()'s parameter.

	kfree(dev);

>  }
>  
>  static const char *muex_name = "mutually_exclusive";
> @@ -810,7 +773,35 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
>   */
>  void extcon_dev_unregister(struct extcon_dev *edev)
>  {
> -	extcon_cleanup(edev, false);
> +	mutex_lock(&extcon_dev_list_lock);
> +	list_del(&edev->entry);
> +	mutex_unlock(&extcon_dev_list_lock);
> +
> +	if (get_device(edev->dev) != NULL) {

I prefer minimal indentation, so I will modify as below code.

	int index;

	mutex_lock(&extcon_dev_list_lock);
	list_del(&edev->entry);
	mutex_unlock(&extcon_dev_list_lock);

	if (IS_ERR_OR_NULL(get_device(edev->dev))) {
		dev_err(edev->dev, "Failed to unregister extcon_dev (%s)\n",
				dev_name(edev->dev));
		return;
	}

	if (edev->mutually_exclusive && edev->max_supported) {
		for (index = 0; edev->mutually_exclusive[index];
				index++)
			kfree(edev->d_attrs_muex[index].attr.name);
		kfree(edev->d_attrs_muex);
		kfree(edev->attrs_muex);
	}

[...]

Cheers,
Chanwoo Choi
