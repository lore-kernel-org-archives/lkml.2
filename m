Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1A1RCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:02:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1A1RCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:02:39 -0500
Message-ID: <4D42F686.8010104@redhat.com>
Date: Fri, 28 Jan 2011 15:01:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D40C3D7.90608@teksavvy.com> <4D40C551.4020907@teksavvy.com> <20110127021227.GA29709@core.coreip.homeip.net> <4D40E41D.2030003@teksavvy.com> <20110127063815.GA29924@core.coreip.homeip.net> <4D414928.80801@redhat.com> <20110127172128.GA19672@core.coreip.homeip.net> <4D41C071.2090201@redhat.com> <20110128093922.GA3357@core.coreip.homeip.net> <4D42AECE.3020402@redhat.com> <20110128164057.GA6252@core.coreip.homeip.net>
In-Reply-To: <20110128164057.GA6252@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-01-2011 14:40, Dmitry Torokhov escreveu:
> On Fri, Jan 28, 2011 at 09:55:58AM -0200, Mauro Carvalho Chehab wrote:

>> The rc-core register (and the corresponding input register) is done when
>> the device detected a remote controller, so, it should be safe to register
>> on that point. If not, IMHO, there's a bug somewhere. 
> 
> It is not a matter of safe or unsafe registration. Registration is fine.
> The problem is that with the current set up is that utility is fired
> when trunk of [sub]tree is created, but the utility wants to operate on
> leaves which may not be there yet.

I'm not an udev expert. Is there a udev event that hits only after having
the driver completely loaded? Starting an udev rule while modprobe is
still running is asking for race conditions.

I'm not entirely convinced that this is the bug that Mark is hitting, as
rc-core does all needed setups before registering the evdev device. We
need the core and the dmesg to be sure about what's happening there.

>> Yet, I agree that udev tries to set devices too fast.
> 
> It tries to set devices exacty when you tell it to do so. It's not like
> it goes trolling for random devices is sysfs.
> 
>> It would be better if
>> it would wait for a few milisseconds, to reduce the risk of race conditions.
> 
> Gah, I really prefer using properly engineered solutions instead of
> adding crutches.

I agree.

>>> And this could be easily added to the udev's keymap utility that is
>>> fired up when we discover evdevX devices.
>>
>> Yes, it can, if you add the IR protocol selection on that tool. A remote 
>> controller keycode table has both the protocol and the keycodes.
>> This basically means to merge 99% of the logic inside ir-keytable into the
>> evdev generic tool.
> 
> Or just have an utility producing keymap name and feed it as input to
> the generic tools. The way most of utilities work...

I don't like the idea of running a some logic at udev that would generate
such keymap in runtime just before calling the generic tool. The other
alternative (e. g.) to maintain the RC-protocol dependent keytables separate
from the RC protocol used by each table will be a maintenance nightmare.

>>>> Also, I'm currently working on a way to map media keys for remote controllers 
>>>> into X11 (basically, mapping them into the keyspace between 8-255, passing 
>>>> through Xorg evdev.c, and then mapping back into some X11 symbols). This way,
>>>> we don't need to violate the X11 protocol. (Yeah, I know this is hacky, but
>>>> while X11 cannot pass the full evdev keycode, at least the Remote Controllers
>>>> will work). This probably means that we may need to add some DBus logic
>>>> inside ir-keytable, when called via udev, to allow it to announce to X11.
>>>
>>> The same issue is present with other types of input devices (multimedia
>>> keyboards emitting codes that X can't consume) and so it again would
>>> make sense to enhance udev's utility instead of confining it all to
>>> ir-keytable.
>>
>> I agree with you, but I'm not sure if we can find a solution that will
>> work for both RC and media keyboards, as X11 evdev just maps keyboards
>> on the 8-255 range. I was thinking to add a detection there for RC, and
>> use a separate map for them, as RC don't need most of the normal keyboard
>> keys.
> 
> Well, there will always be clashes - there is reason why evdev goes
> beyond 255 keycodes...

Yeah. The most appropriate fix would be for X to just use the full evdev
keycode range. However, I'm not seeing any indication that such change
will happen soon. Not sure if there are some news about it at LCA, as
there were one speech about this subject there.

Cheers,
Mauro
