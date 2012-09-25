Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2IYKcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:32:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53611 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2IYKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:32:10 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-c3-50618828dbab
Message-id: <5061882D.2080804@samsung.com>
Date: Tue, 25 Sep 2012 19:32:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH] extcon: Fix return value in extcon_register_interest()
References: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jAV2NjsQAg9n7OC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG6gOvmAoe8FY0XZnJ2MA4h7uLkZNDQsBE4trUFewQtpjEhXvr
	2boYuTiEBBYxSlycdZ8dwulikpi4dSEbSBWvgJbE1y/drCA2i4CqROOSf2A2G1B8/4sbQDUc
	HKICERK/+jkgygUlfky+xwJiiwCVvOxezgRSwizgJzFxbxCIKSzgLbHpky9IhZCAu8S0++vB
	BnIKeEgcaZvIDGIzC+hI7G+dxgZhy0tsXvOWeQKjwCwkC2YhKZuFpGwBI/MqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjODgeya1g3Flg8UhRgEORiUeXo4NCQFCrIllxZW5hxglOJiVRHh3
	yyQGCPGmJFZWpRblxxeV5qQWH2KU5mBREucV/hQYICSQnliSmp2aWpBaBJNl4uCUamCMbnHS
	Ff7eOavoSqjPpJZ5uw9NMQqQLWQQ+mPzf6rslIa3h4KjFitOsei+JftNWlgp+PLH5NSZLI1G
	Fc+mh7JmMlTI2JraV2V1POqN2HJqDmtm3WT1HtfI2C9378mqHrns+HGi8e4jx3iqYs2PZtg9
	XLjZ7vXsK1drKrcavGQyM9Rl3+3z6rQSS3FGoqEWc1FxIgA5Jc9OOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 03:58 PM, Sachin Kamat wrote:

> Return the value obtained from extcon_find_cable_index()
> instead of -ENODEV.
> 
> Fixes the following smatch info:
> drivers/extcon/extcon-class.c:478 extcon_register_interest() info:
> why not propagate 'obj->cable_index' from extcon_find_cable_index()
> instead of -19?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/extcon/extcon-class.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 946a318..e996800 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -475,7 +475,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
>  
>  	obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
>  	if (obj->cable_index < 0)
> -		return -ENODEV;
> +		return obj->cable_index;
>  
>  	obj->user_nb = nb;
>  


I agree.
But, if extcon_register_interest() return directly 'obj-cable_index' value
when extcon_find_cable_index() return -EINVAL, it would spoil readability
of extcon_register_interest() function. So, I think we can make it as
following
patch  a little better.

---
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 936580b..078e6a5 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -468,7 +468,7 @@ int extcon_register_interest(struct
extcon_specific_cable_nb *obj,

        obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
        if (obj->cable_index < 0)
-               return -ENODEV;
+               return -EINVAL;

        obj->user_nb = nb;



Thanks,
Chanwoo Choi
