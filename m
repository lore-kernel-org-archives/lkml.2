Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3AELmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:42:04 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:48267 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AELmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:42:00 -0500
Message-ID: <50E81166.6050605@ahsoftware.de>
Date: Sat, 05 Jan 2013 12:41:26 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Borislav Petkov <bp@alien8.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
References: <20121116192606.11799.35711.stgit@localhost.localdomain> <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com> <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com> <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com> <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com> <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com> <20121227045301.GB17472@x1.alien8.de> <20121228115022.GA28009@S2101-09.ap.freescale.net> <20121228124026.GB12918@x1.alien8.de> <50E6D01D.6040304@ahsoftware.de> <20130104132557.70e0c527@pyramind.ukuu.org.uk> <50E6DAC9.802@ahsoftware.de>
In-Reply-To: <50E6DAC9.802@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.01.2013 14:36, schrieb Alexander Holler:
> Am 04.01.2013 14:25, schrieb Alan Cox:
>> On Fri, 04 Jan 2013 13:50:37 +0100
>> Alexander Holler <holler@ahsoftware.de> wrote:

...
>>> Btw. I think all the usb-fb's (udlfb, smscufx and udl) are broken, at
>>> least on ARM(v5). When I have linked in udlfb the following happens on
>>> boot (with an attached USB-LCD and with or without the "Rework locking
>>> patch):
>>
>> They are broken if used as the system console (has been known for years).

>> Fixing the console isn't that difficult - you just need to make your
>> device queue the console I/O to a worker thread of some kind. We don't
>
> That is what I wanted to try next. ;)
>
>> want to do that by default because we want to get the messages out
>> reliably and immediately on saner hardware. Given there are several
>> such cases a general helper and a console "I am crap" flag might be
>> better
>> than hacking each driver.
>
> All those drivers look very similiar. I will see if I'm successfull in
> writing such an IamCrapHelper. Might need some time, but I will post a
> patch for review, if I've done and tested it. I'm only using the USB-LCD
> on occasion, so it doesn't have high priority for me because I don't
> really need it.

I've just added a work queue for dlfb_handle_damage. Up to now I've only 
tested the console, seems to work without any problems (even with lock 
checking on).

In regard to that "I am crap" handler, I'm not sure how to do that.

Just queuing the ops wherever they are used outside the drivers doesn't 
work, because e.g.

if(i_am_crap)
   queue_work(ops.fb_imageblit(..., image))
else
   ops.fb_imageblit(..., image)

doesn't work, because e.g. image will become destroyed before the work 
gets executed. And copying the whole image doesn't make sense. 
handle_damage() in contrast just needs the coordinates for a rectangle 
(x, y, w, h).

So to add such an "I am crap" flag my idea would be to add an 
.fb_handle_damage to struct fb_ops and then call that (if exists) 
whenever something was changed.

But I don't like that very much. I think that might end up in more 
changes than just changing those 3 very similiar drivers (I'm not sure 
if the queuing is needed for udl at all).

Maybe it would make sense, to unify the stuff in those 3 similiar 
drivers moving the shared functions to one file which is used by them 
all. udl seems to have already split some stuff into different files.

My patch (for udlfb) follows as an reply to this message. If that patch 
is ok, it should be applied to smscufx too (I would make it). In regard 
to udl I don't know, I haven't had a deeper look at it nor used it up to 
now.

Regards,

Alexander
