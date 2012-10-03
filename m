Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2JCONF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:13:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab2JCONC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:13:02 -0400
Message-ID: <506C47E0.5000600@redhat.com>
Date: Wed, 03 Oct 2012 11:12:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com> <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
In-Reply-To: <20121002222333.GA32207@kroah.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-10-2012 19:23, Greg KH escreveu:
> On Tue, Oct 02, 2012 at 03:12:39PM -0700, Greg KH wrote:
>> On Tue, Oct 02, 2012 at 09:33:03AM -0700, Linus Torvalds wrote:
>>> I don't know where the problem started in udev, but the report I saw
>>> was that udev175 was fine, and udev182 was broken, and would deadlock
>>> if module_init() did a request_firmware(). That kind of nested
>>> behavior is absolutely *required* to work, in order to not cause
>>> idiotic problems for the kernel for no good reason.
>>>
>>> What kind of insane udev maintainership do we have? And can we fix it?
>>>
>>> Greg, I think you need to step up here too. You were the one who let
>>> udev go. If the new maintainers are causing problems, they need to be
>>> fixed some way.
>>
>> I've talked about this with Kay in the past (Plumbers conference I
>> think) and I thought he said it was all fixed in the latest version of
>> udev so there shouldn't be any problems anymore with this.
>>
>> Mauro, what version of udev are you using that is still showing this
>> issue?
>>
>> Kay, didn't you resolve this already?  If not, what was the reason why?
> 
> Hm, in digging through the udev tree, the only change I found was this
> one:
> 
> commit 39177382a4f92a834b568d6ae5d750eb2a5a86f9
> Author: Kay Sievers <kay@vrfy.org>
> Date:   Thu Jul 19 12:32:24 2012 +0200
> 
>     udev: firmware - do not cancel requests in the initrd
> 
> diff --git a/src/udev/udev-builtin-firmware.c b/src/udev/udev-builtin-firmware.c
> index 56dc8fc..de93d7b 100644
> --- a/src/udev/udev-builtin-firmware.c
> +++ b/src/udev/udev-builtin-firmware.c
> @@ -129,7 +129,13 @@ static int builtin_firmware(struct udev_device *dev, int argc, char *argv[], boo
>                                  err = -errno;
>                  } while (err == -ENOENT);
>                  rc = EXIT_FAILURE;
> -                set_loading(udev, loadpath, "-1");
> +                /*
> +                 * Do not cancel the request in the initrd, the real root might have
> +                 * the firmware file and the 'coldplug' run in the real root will find
> +                 * this pending request and fulfill or cancel it.
> +                 * */
> +                if (!in_initrd())
> +                        set_loading(udev, loadpath, "-1");
>                  goto exit;
>          }
>  
> 
> which went into udev release 187 which I think corresponds to the place
> when people started having problems, right Mauro?

I'm using here udev-182. 

> If so, Mauro, is the solution just putting the firmware into the initrd?

I don't think that putting firmware on initrd is something that we want to
for media drivers. None of the webcam drivers currently need a firmware;
those are required on more complex devices (typically digital TV ones).

While there are a number of PCI devices that require firmware, in practice,
we're seeing more people using USB devices. IMO, it doesn't make any sense
that a hot-pluggable USB device to require a firmware at initrd/initramfs,
with is available only at boot time.

> No wait, it looks like this change was trying to fix the problem where
> firmware files were not in the initrd, so it would stick around for the
> real root to show up so that they could be loaded.
>
> So this looks like it was fixing firmware loading problems for people?

I'll run some tests with this patch applied and see what happens.

> Kay, am I just looking at the totally wrong place here, and this file in
> udev didn't have anything to do with the breakage?
> 
> thanks,
> 
> greg k-h
> 

