Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0GEHKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:10:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57043 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab0GEHKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iPgBGTsN0BEOiUpJ4BQP0HQDgqlhfVxW1EFV2gMmY4FXpKnX2TxsaBqZmOmNCSl9/O
         L/68VHKdrN8v+agKPJjVZpkJ0PgCjFMYlcNZhh7nEqZpY1iNt1Qu9orKY5gVX39cWdkT
         YAvZFRxIZx7YqheXhSW7b5N1i1VkXHJkeGhMs=
Message-ID: <4C31855B.7030509@suse.cz>
Date: Mon, 05 Jul 2010 09:10:19 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Ian Armstrong <ian@iarmst.demon.co.uk>,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] VIDEO: ivtvfb, remove unneeded NULL test
References: <1277206910-27228-1-git-send-email-jslaby@suse.cz>	 <1278216707.2644.32.camel@localhost>  <4C30372D.9050304@suse.cz> <1278249745.2280.46.camel@localhost>
In-Reply-To: <1278249745.2280.46.camel@localhost>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2010 03:22 PM, Andy Walls wrote:
> On Sun, 2010-07-04 at 09:24 +0200, Jiri Slaby wrote:
>> On 07/04/2010 06:11 AM, Andy Walls wrote:
>>> --- a/drivers/media/video/ivtv/ivtvfb.c
>>> +++ b/drivers/media/video/ivtv/ivtvfb.c
>>> @@ -1201,9 +1201,14 @@ static int ivtvfb_init_card(struct ivtv *itv)
>>>  static int __init ivtvfb_callback_init(struct device *dev, void *p)
>>>  {
>>>         struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
>>> -       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
>>> +       struct ivtv *itv;
>>>  
>>> -       if (itv && (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)) {
>>> +       if (v4l2_dev == NULL)
>>> +               return 0;
>>> +
>>> +       itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
>>> +
>>> +       if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT) {
>>>                 if (ivtvfb_init_card(itv) == 0) {
>>>                         IVTVFB_INFO("Framebuffer registered on %s\n",
>>>                                         itv->v4l2_dev.name);
>>> @@ -1216,10 +1221,16 @@ static int __init ivtvfb_callback_init(struct device *de
>>>  static int ivtvfb_callback_cleanup(struct device *dev, void *p)
>>>  {
>>>         struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
>>> -       struct ivtv *itv = container_of(v4l2_dev, struct ivtv, v4l2_dev);
>>> -       struct osd_info *oi = itv->osd_info;
>>> +       struct ivtv *itv;
>>> +       struct osd_info *oi;
>>> +
>>> +       if (v4l2_dev == NULL)
>>> +               return 0;
>>
>> >From my POV I NACK this. Given that it never triggered and drvdata are
>> set in v4l2_device_register called from ivtv_probe I can't see how
>> v4l2_dev be NULL. Could you elaborate?
> 
> I hemmed and hawed over that too.  I didn't do a very thorough analysis
> of the restrictions on unloading modules, but here was my line of
> reasoning:
...
> 2. Note that the ivtvfb driver is not automatically loaded nor unloaded
> by the kernel ivtv driver.  Something from userspace will reqeust the
> load and unload of the module.
> 
> There are windows of time where a struct device * will exist for a card
> in the ivtv driver, but a struct v4l2_device * may not: the end of
> ivtv_remove() and the beginning of ivtv_probe().

If there is no locking or refcounting, this won't change with the added
check. The window is still there, but it begins after the check with
your patch. Hence will still cause oopses.

> I was contemplating a case where user space requested unloading both the
> ivtvfb and the ivtv driver.  Given all the I2C devices these cards can
> have, I thought v4l2_device_unregister() at the end of ivtv_remove()
> could present a window of time large enough to worry about a race.
> v4l2_device_unregister() sets the struct device  drvdata pointer to
> NULL, and then begins unregistering the i2c clients.  I haven't profiled
> the process to know how long it typically takes, though.
> 
> I also don't know if kernel mechanisms will absolutely prevent
> initiating the unload of ivtv.ko before the unload of ivtvfb.ko is
> completely finished.  Will they?

Given ivtvfb uses functions from ivtv, no, it can't unload ivtv earlier
than ivtvfb.

regards,
-- 
js
suse labs
