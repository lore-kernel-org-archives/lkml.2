Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1ESJ62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:58:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65215 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1ESJ61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=NGNbqGKcsRS2y/RswUFQA4UkgD9ZkSSAFIJjzedrKYWF0Vr9IngAKRYBh2YfSI1NaT
         NCbwaEe/yRJ3Ba0yE9FD9o8GoMzhJ/7PVq7QAslUIh+9JrkcfKbXaJ1YUZgxbISOXRHS
         EbNQo6s4I/m5X5FKqVjFNK3s9F69cPx83u7AQ=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <BANLkTimU7FyuTuVw1ezOo381a798Ec+uCw@mail.gmail.com>
References: <1305723718.6172.6.camel@phoenix> <20110518163205.GC16414@opensource.wolfsonmicro.com>
 <BANLkTimU7FyuTuVw1ezOo381a798Ec+uCw@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 19 May 2011 17:58:06 +0800
Message-ID: <BANLkTinx-OPhDBVZFrz2V_o8-p4yfTt9Kg@mail.gmail.com>
Subject: Re: [RFC][PATCH] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Axel Lin <axel.lin@gmail.com>:
> 2011/5/19 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> On Wed, May 18, 2011 at 09:01:58PM +0800, Axel Lin wrote:
>>
>>> @@ -1886,13 +1886,15 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
>>>               if (sel < 0)
>>>                       return sel;
>>>               ret = rdev->desc->ops->list_voltage(rdev, sel);
>>> +             goto out;
>>>       }
>>
>> Why are you adding this goto?  It's not going to change anything...
>>
> no matter what ret value returns from rdev->desc->ops->list_voltage(rdev, sel);
>
> In the case of rdev->desc->ops->get_voltage is NULL,
> current implementation will always return -EINVAL;
>
hi Mark,
I'm thinking maybe you prefer changes like below:
How do you think?

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9493f61..2a2e927 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1887,12 +1887,12 @@ static int _regulator_get_voltage(struct
regulator_dev *rdev)
                        return sel;
                ret = rdev->desc->ops->list_voltage(rdev, sel);
        }
-       if (rdev->desc->ops->get_voltage)
+       else if (rdev->desc->ops->get_voltage)
                ret = rdev->desc->ops->get_voltage(rdev);
        else
                return -EINVAL;

-       return ret - rdev->constraints->uV_offset;
+       return ret < 0 ? ret : ret - rdev->constraints->uV_offset;
 }

 /**


Regards,
Axel
