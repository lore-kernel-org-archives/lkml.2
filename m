Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1DDCNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 22:13:04 -0400
Received: from fep12.mx.upcmail.net ([62.179.121.32]:50391 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1DDCNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 22:13:01 -0400
X-SourceIP: 84.114.185.220
Message-ID: <4D992920.4040400@gmx.at>
Date: Mon, 04 Apr 2011 04:12:48 +0200
From: Andreas Huber <hobrom@gmx.at>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org, Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com, Ben Hutchings <ben@decadent.org.uk>,
        Trent Piepho <xyzzy@speakeasy.org>, Roland Stoll <dvb.rs@xindex.de>
Subject: Re: [PATCH 3/3] [media] cx88: use a mutex to protect cx8802_devlist
References: <20110327150610.4029.95961.reportbug@xen.corax.at> <20110327152810.GA32106@elie> <20110402093856.GA17015@elie> <20110402094451.GD17015@elie> <4D971B8D.4040305@corax.at> <20110402192902.GD20064@elie> <4D978378.7060106@gmx.at>
In-Reply-To: <4D978378.7060106@gmx.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=tMVj8KYobzzX0EiRnC7vY2isLrCxFvdg4RrHWPZXwJ0= c=1 sm=0 a=5CFtLWRejkUA:10 a=z4zzRH9NVs0A:10 a=8nJEP1OIZ-IA:10 a=5gMABGCrHb4GJhbDDZMA:9 a=8K0FriAfKJutQ6CoVx0A:7 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added some printk entries and finally got suspicious output after

rmmod cx88_blackbird ; modprobe cx88_blackbird debug=true

[...]
cx88[0]/2: registered device video3 [mpeg]
cx88[0]/2-bb: mpeg_open
[cx88-blackbird.c,mpeg_open(),line 1059] mutex_lock(&dev->core->lock);
cx88[0]/2-bb: Initialize codec
[...]
cx88[0]/2-bb: open dev=video3
[cx88-blackbird.c,mpeg_open(),line 1103] mutex_unlock(&dev->core->lock); 
// normal exit
[...]
cx88[1]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
[cx88-blackbird.c,mpeg_release(),line 1122] mutex_lock(&dev->core->lock);
cx88[0] core->active_ref=0
[cx88-mpeg.c,cx8802_request_release(),line 655]                         
   // BANG !!!!!!!!!!!!!!! core->active_ref=-1
[cx88-blackbird.c,mpeg_release(),line 1129] drv->request_release(drv); 
// drv->core->active_ref=(0->0)
[cx88-blackbird.c,mpeg_release(),line 1133] 
mutex_unlock(&dev->core->lock); // normal exit
cx88[1]/2-bb: cx8802_blackbird_probe
[...]

Analyzing this lead me to the conclusion, that a call to mpeg_open() in 
cx88-blackbird.c
returns with 0 (= success)
while not actually having increased the active_ref count.

Here's the relevant code fragment ...

static int mpeg_open(struct file *file)
{
[...]
     /* Make sure we can acquire the hardware */
     drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);      // HOW TO 
DEAL WITH NULL  ??????
     if (drv) {
         err = drv->request_acquire(drv);
         if(err != 0) {
             dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, 
err);
             mutex_unlock(&dev->core->lock);
             return err;
         }
     }
[...]
     return 0;
}

I suspect, that

drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);

in my case might evaluates to NULL (not normally but during driver 
initialization!?)
which then leads to

1) mpeg_open() returns with success

and

2) active_ref count has not been increased

which results in a negative active_ref count later on.

But I might as well be totally wrong.

Andi

On 02.04.2011 22:13, Andreas Huber wrote:
> Hi Jonathan, thanks for locking into it.
> I'll try to debug more deeply what's going wrong and keep you up to date.
> Andi.
>
> On 02.04.2011 21:29, Jonathan Nieder wrote:
>> Hi Andreas,
>>
>> (please turn off HTML mail.)
>> Andreas Huber wrote:
>>
>>> There is a reference count bug in the driver code. The driver's
>>> active_ref count may become negative which leads to unpredictable
>>> behavior. (mpeg video device inaccessible, etc ...)
>> Hmm, the patchset didn't touch active_ref handling.
>>
>> active_ref was added by v2.6.25-rc3~132^2~7 (V4L/DVB (7194):
>> cx88-mpeg: Allow concurrent access to cx88-mpeg devices, 2008-02-11)
>> and relies on three assumptions:
>>
>>   * (successful) calls to cx8802_driver::request_acquire are balanced
>>     with calls to cx8802_driver::request_release;
>>
>>   * cx8802_driver::advise_acquire is non-null if and only if
>>     cx8802_driver::advise_release is (since both are NULL for
>>     blackbird, non-NULL for dvb);
>>
>>   * no data races.
>>
>> I suppose it would be more idiomatic to use an atomic_t, but access to
>> active_ref was previously protected by the BKL and now it is protected
>> by core->lock.  So it's not clear to me why this doesn't work.
>>
>> Any hints?  (e.g., a detailed reproduction recipe, or a log after
>> adding a printk to find out when exactly active_ref becomes negative)
>>
>> Thanks for reporting.
>> Jonathan
>

