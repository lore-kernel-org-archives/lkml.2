Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2JCTrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2JCTrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:47:02 -0400
Message-ID: <506C9628.4010400@redhat.com>
Date: Wed, 03 Oct 2012 16:46:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
References: <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com> <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com> <20121003165726.GA24577@kroah.com>
In-Reply-To: <20121003165726.GA24577@kroah.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-10-2012 13:57, Greg KH escreveu:
> On Wed, Oct 03, 2012 at 04:36:53PM +0200, Kay Sievers wrote:
>> On Wed, Oct 3, 2012 at 12:12 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>>> Mauro, what version of udev are you using that is still showing this
>>> issue?
>>>
>>> Kay, didn't you resolve this already?  If not, what was the reason why?
>>
>> It's the same in the current release, we still haven't wrapped our
>> head around how to fix it/work around it.
> 
> Ick, as this is breaking people's previously-working machines, shouldn't
> this be resolved quickly?
> 
>> Unlike what the heated and pretty uncivilized and rude emails here
>> claim, udev does not dead-lock or "break" things, it's just "slow".
>> The modprobe event handling runs into a ~30 second event timeout.
>> Everything is still fully functional though, there's only this delay.
> 
> Mauro said it broke the video drivers.  Mauro, if you wait 30 seconds,
> does everything then "work"?
> 
> Not to say that waiting 30 seconds is a correct thing here...

Before the implementation of the DVB async firmware load, as requested
by udev maintainers, and on a test case, the additional 30 seconds
wait won't hurt[1].

[1] Well, I didn't test any tm6000 devices with Kernel 3.6. On tm6000,
firmwares are needed for xc3028 tuners, via the board internal I2C bus.
Those devices only support 10 kHz speed for those transfers. Also, due
to a bug at the hardware, extra delay is needed. So, a firmware load
there takes ~30 seconds. I suspect that waiting for ~60 seconds will
trigger the max allowed time for firmware load to happen, actually
breaking completely the driver.

There are applications like MythTV, however, that opens all interfaces
produced by a media device at the same time (alsa, video nodes, dvb nodes).

I'm not a MythTV user myself, but someone told me recently that MythTV
has a 5 seconds timeout there. If it can't open an interface on that time,
it will give up for that device.

As you likely know, MythTV is used as a Media Center: there are distros
that load it (or some other applications like XBMC) at boot time.

As the media drivers are modular, the DVB, alsa and TV API's are implemented
on (almost) independent modules. On such scenario, if the DVB firmware 
load takes 30 seconds, because the DVB demod requires a firmware,
while the analog TV doesn't require a firmware, I suspect that Mythtv
will assume that DVB is not there, causing a failure to the end user.

[1] The attempt to fix the issues with udev forced us to re-design a few
drivers. One of them (drxk) now loads firmware asynchronously. That effectively
broke the driver on Kernel 3.6, for PCTV520e and similar devices, as the
tuner driver, attached just after drx-k, stopped working, likely due to
some missing clock or GPIO signals that drx-k is supposed to rise after
firmware load.

The fixes for it are at:
	http://git.linuxtv.org/media_tree.git/commit/6ae5e060840589f567c1837613e8a9d34fc9188a
	http://git.linuxtv.org/media_tree.git/commit/8e30783b0b3270736b2cff6415c68b894bc411df
	http://git.linuxtv.org/media_tree.git/commit/2425bb3d4016ed95ce83a90b53bd92c7f31091e4

In order to fix that issues, I had to defer DVB initialization for all em28xx
devices, in despite of the fact that only 5 boards (of 86 devices supported there)
require DVB firmwares. Patches are likely a little pedantic, as they are
doing async DVB initialization even when the drivers are compiled builtin,
but, as I do expect to revert the entire async thing from em28xx/drx-k, 
I didn't want to make too big changes there.

FYI, I'm planning to upstream those fixes tomorrow, if nobody detects
any issue on this approach.

> I recommend making module loading async, like it used to be, and then
> all should be fine, right?

IMHO, module loading should be async: it seems a way better and more 
POSIX compliant to take more time during init, than delaying firmware
init to happen open(),  especially when open() is called on non-block mode.

Regards,
Mauro

