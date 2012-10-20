Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2JTChW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 22:37:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50409 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab2JTChV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 22:37:21 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-c9-50820e6078c8
Message-id: <50820E5F.2010000@samsung.com>
Date: Sat, 20 Oct 2012 11:37:19 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: anish kumar <anish198519851985@gmail.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] extcon: driver model release call not needed
References: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
 <508204FC.4030802@samsung.com> <1350700237.3764.156.camel@anish-Inspiron-N5050>
In-reply-to: <1350700237.3764.156.camel@anish-Inspiron-N5050>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAd0EvqYAgwN3eCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG63tPWAsuC1R8/DaXpYFxM28XIyeHhICJxK1t65ggbDGJC/fW
	s3UxcnEICSxilFj4YBGU08UkMX3OFDaQKl4BLYld0zaB2SwCqhIzPq9mBLHZgOL7X9wAinNw
	iApESPzq54AoF5T4MfkeC0hYREBXYtPCFJAwM1DFpFeLWUBsYQFPiT2XjrNDrJrDKHF7E8Qq
	TgFbiT0dO5khGtQlJs1bBGXLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4AB8Jr2DcVWDxSFGAQ5GJR5eib7GACHWxLLiytxDjBIczEoivEsXAYV4
	UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJpCeWpGanphakFsFkmTg4pRoYZ3t7MBzsdPSO
	6bI+pZ9RLezzcd3BH9NO9UnONey+N1/A4s6ksvKcGH5ZCa6McpVpHw5N15+2TmVjTk5sfv0Z
	+yP7ue4dEgh95MYpP9+31V+C78OiXPEHkj+3+Zr9rFK3/Jl/r2KFX8kZzW1NvXZ5ynYT29pj
	Za9d4n5WFiO2QUvSvsv2EYcSS3FGoqEWc1FxIgAJ8CQvPAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 11:30 AM, anish kumar wrote:
> On Sat, 2012-10-20 at 10:57 +0900, Chanwoo Choi wrote:
>> On 10/19/2012 02:12 AM, anish kumar wrote:
>>> From: anish kumar <anish198519851985@gmail.com>
>>>
>>> We don't need a release call in this file as we are doing
>>> everything needed in unregister call and we don't have any
>>> more pointer to free up.
>>>
>>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>>> ---
>>>  drivers/extcon/extcon-class.c |    4 +---
>>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>>> index 946a318..cf30eb1 100644
>>> --- a/drivers/extcon/extcon-class.c
>>> +++ b/drivers/extcon/extcon-class.c
>>> @@ -585,9 +585,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
>>>  
>>>  static void extcon_dev_release(struct device *dev)
>>>  {
>>> -	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
>>> -
>>> -	extcon_cleanup(edev, true);
>>> +	/* We don't have any thing to free here */
>>>  }
>>>  
>>>  static const char *muex_name = "mutually_exclusive";
>>
>> I can't agree this patch. The extcon_dev_release() function is used
>> for dev->release. If some case without calling extcon_dev_unregister(),
>> I think dev->release function is needed to free memory of edev->dev.
> Is it not being released by extcon_dev_unregister?
> I think it is released by that and we will do two times free and
> list_del(&edev->entry) as it is called by extcon_dev_release also.

I think that this patch should modify it as below patch to remove
two call of kfree().  How about you?

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index e717bbc..efca0b4 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -597,9 +597,8 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 #endif
                device_unregister(edev->dev);
                put_device(edev->dev);
-       }
-
-       kfree(edev->dev);
+       } else {
+               kfree(edev->dev);

