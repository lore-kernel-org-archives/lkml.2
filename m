Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0ITTFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:05:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44625 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754861Ab0ITTFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:05:36 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/oYK0gQLzo4CZ5qxnwU1yNjPpV0oc4FqI9SOeryG
	/l/KUAaK9XOpr7
Message-ID: <4C97B079.8050707@gmx.de>
Date: Mon, 20 Sep 2010 21:05:29 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
References: <20100919172833.14bf291e@neptune.home>	<4C963E99.9080207@gmx.de> <20100919190240.65762511@neptune.home>
In-Reply-To: <20100919190240.65762511@neptune.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

Bruno Prémont schrieb:
> Hi Florian,
> 
> On Sun, 19 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>> Hi,
>>
>> Bruno Prémont schrieb:
>>> For USB-attached (or other hot-(un)pluggable) framebuffers the current
>>> fbdev infrastructure is not very helpful. Each such driver currently
>>> needs to perform the ref-counting on its own in .fbops.fb_open and
>>> .fbops.fb_release callbacks.
>> I agree. This is a great idea even for non-hot-(un)pluggable framebuffers.
> 
> Yes, things like drmfb and drivers of multi-head capable framebuffer
> drivers would certainly appreciate as well, but they will probably also
> want to care about users (of fb_info.screen_base).

I don't see any special users of fb_info.screen_base. It's only used for 
software fallbacks of acceleration functions and fb_read/fb_write (which I'd 
consider rare to fb_mmap). The bad thing of screen_base is that it can make 
viafb try to map up to 512MB on 32 bit systems...
Much more painful IMHO are the mmaped areas in userspace which essentially 
prevent moving around of the screen framebuffer inside the video ram.

>>> If you have concerns regarding the API changes, please let me know.
>> Uhm, I'm not really happy with what we count. With the old method you mentioned 
>> we ref-counted framebuffer users, after your patch it's more counting users + 
>> uses. This might be okay as we usually are interested whether the ref_count is 0 
>> or not but it doesn't look right if we modify the refcount during nearly every 
>> framebuffer operation. Wouldn't it be sufficient to do the refcounting in 
>> fb_open & fb_release operation + in fbcon where open&release are done?
> 
> Well I'm more for counting the uses, (especially as the aim is to not
> force the driver to look exactly when it can free the fb_info struct).
> If the driver needs to know about active users (e.g. for handling memory
> reorganization on mode change or the like) that would remain driver's job.

I don't see how your counting would influence the time fb_info is freed. It is 
freed when the last reference is gone but the last remaining reference is always 
  a user reference either from the framebuffer itself or from any user. But all 
users have to keep the framebuffer open to do anything with it therfore the last 
thing they do is releasing the framebuffer. So I do not really understand your 
reasoning, for me counting the users + uses is more error prone than just the 
users. But that's not important for me as I'm only interested in whether the 
count is 0, 1 or more (want to turn off the screen if there are no active [=1] 
users) which is the same regardless on what you count. So if you really want to 
stick to your way of counting, that's no problem for me.

>>> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
>>> index 0a08f13..be5f342 100644
>>> --- a/drivers/video/fbsysfs.c
>>> +++ b/drivers/video/fbsysfs.c
>>> @@ -58,6 +58,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
>>>  		info->par = p + fb_info_size;
>>>  
>>>  	info->device = dev;
>>> +	kref_init(&info->refcount);
>> As far as I know there exist framebuffer drivers which do not call 
>> framebuffer_alloc but contain their own fb_info. I guess these would be broken 
>> as well.
> 
> For those it would be better to switch them to be using framebuffer_alloc.

I don't see any argument against this.


Thanks,

Florian Tobias Schandinat

