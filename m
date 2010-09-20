Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0ITW2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:28:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36343 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753830Ab0ITW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:28:34 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19DuplYepZDPmnD1fpxif1mQ99L8obOWMdH5+N8WI
	kIrO2pxkP6aVQs
Message-ID: <4C97E00B.6090103@gmx.de>
Date: Tue, 21 Sep 2010 00:28:27 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
References: <20100919172833.14bf291e@neptune.home>	<4C963E99.9080207@gmx.de>	<20100919190240.65762511@neptune.home>	<4C97B079.8050707@gmx.de>	<20100920213258.1218b284@neptune.home>	<4C97BF40.6030708@gmx.de> <20100920223608.19b4d177@neptune.home>
In-Reply-To: <20100920223608.19b4d177@neptune.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont schrieb:
> On Mon, 20 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>> Bruno Prémont schrieb:
>>> On Mon, 20 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>>>> Bruno Prémont schrieb:
>>>>> On Sun, 19 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>>>>>> Bruno Prémont schrieb:
>>>>>>> If you have concerns regarding the API changes, please let me know.
>>>>>> Uhm, I'm not really happy with what we count. With the old method you mentioned 
>>>>>> we ref-counted framebuffer users, after your patch it's more counting users + 
>>>>>> uses. This might be okay as we usually are interested whether the ref_count is 0 
>>>>>> or not but it doesn't look right if we modify the refcount during nearly every 
>>>>>> framebuffer operation. Wouldn't it be sufficient to do the refcounting in 
>>>>>> fb_open & fb_release operation + in fbcon where open&release are done?
>>>>> Well I'm more for counting the uses, (especially as the aim is to not
>>>>> force the driver to look exactly when it can free the fb_info struct).
>>>>> If the driver needs to know about active users (e.g. for handling memory
>>>>> reorganization on mode change or the like) that would remain driver's job.
>>>> I don't see how your counting would influence the time fb_info is freed. It is 
>>>> freed when the last reference is gone but the last remaining reference is always 
>>>>   a user reference either from the framebuffer itself or from any user. But all 
>>>> users have to keep the framebuffer open to do anything with it therfore the last 
>>>> thing they do is releasing the framebuffer. So I do not really understand your 
>>>> reasoning, for me counting the users + uses is more error prone than just the 
>>>> users. But that's not important for me as I'm only interested in whether the 
>>>> count is 0, 1 or more (want to turn off the screen if there are no active [=1] 
>>>> users) which is the same regardless on what you count. So if you really want to 
>>>> stick to your way of counting, that's no problem for me.
>>> In case of picoLCD driver (which uses a shadow framebuffer in system RAM) the
>>> last user can be a (userspace) process as on unplug driver unregisters that
>>> framebuffer and hands back it's own reference, the fb_destroy callback being
>>> in charge of freeing the shadow framebuffer when fb_info is being freed.
>> True. I think I understand the problem you want to solve.
>> My question is:
>> Do you keep a reference for each successful open operation until a release is done?
>> If I read your patch correctly, the answer is yes.
> 
> The reference already exists now (fb_info being assigned to file->private_data),
> but is not being accounted.
> 
>> Than the operations/counting you do between such operations should be irrelevant 
>> to when the free is performed or?
>> So the free is done either when the framebuffer releases its handle or (in your 
>> case) when the process closes the file and therefore calls fb_release. Or do you 
>> have any way to perform framebuffer operations without an open framebuffer?
> 
> Yes, the idea is to free fb_info when the last reference to it is being dropped
> not matter who does it (device file closed or driver cleaning up or whoever else).
> And do this without great complexity for the driver (fb_release callback not
> allowing driver to free fb_info inside of callback).

I totally agree.

> Tracking if/how often framebuffer is opened as such is a separate thing (though
> all users that have the framebuffer opened hold a reference to fb_info).

That's what I said. So as long as refcount <= 1 it does not matter whether you 
just count on open/release or additionally on every framebuffer operation, just 
that the later produces more noise.
So I still don't see any advantage in counting users + uses.
Please note that I do not object the idea of the patch itself, it's only that I 
have a different preference on what to count. I only want to express that your 
way is more complicated than what I would recommend.
But if you want to go on I do not object. As long as the end result works that's 
okay with me.


Thanks

Florian Tobias Schandinat
