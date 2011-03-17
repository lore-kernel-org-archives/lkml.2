Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1CQQpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:45:46 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:42973 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1CQQpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:45:44 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D823AF8.8070408@cam.ac.uk>
Date: Thu, 17 Mar 2011 16:46:48 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103171447.17960.arnd@arndb.de> <4D821DE2.4050707@cam.ac.uk> <201103171603.35700.arnd@arndb.de>
In-Reply-To: <201103171603.35700.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/11 15:03, Arnd Bergmann wrote:
> On Thursday 17 March 2011, Jonathan Cameron wrote:
>> On 03/17/11 13:47, Arnd Bergmann wrote:
> 
>>> What about hardware devices that have multiple unrelated streams
>>> of buffered input data?
>>
>> Certainly plausible, but so far the only ones I've seen that actually
>> do this are really just two bits of silicon in the same plastic
>> package.  They tend to use different i2c addresses or spi chip
>> selects anyway so as far as the kernel is concerned are completely
>> separate.  You are correct that any device which truly has different
>> streams of data would indeed need more than one device.
> 
> Ok.
> 
>>>>> * One chardev for each iio device
>>>>
>>>> currently 1-3. (event line, buffer access, buffer event)
>>>
>>> It would be really nice to unify this, as I said. What
>>> are the reasons why you think it cannot or should not be
>>> done?
>>
>> Simplicity perhaps, but I'll definitely give your suggestions
>> a go and see where we end up. 
> 
> Since I haven't fully understood the distinction between the
> three chardevs, it may of course turn out a bad idea, but I
> think it would simplify the core code if you could assume
> that every iio device has exactly one chardev interface,
> so you could give them the same unique number and manage
> the life time together.
It simplifies that corner, but I'm a little worried that it
will add a lot of interlinks between the currently fairly
disconnected elements that go through a character device.

If we can keep those links to a minimum (which I think
we can, but haven't tried yet!) it will be a sensible move.

> 
>>>>> * Use epoll to wait for data and/or out-of-band messages
>>>>> * Use chrdev read to get events from the buffer
>>>>
>>>> and data?
>>>
>>> I mean get the data associated with the event. The event
>>> itself as you said does not have any data, so we would not
>>> need to read it, just to use poll()/epoll() in order to
>>> wait for it.
>>
>> Sure. But devices can do a heck of a lot of different events.
>> (certainly 10's or maybe more).  I'm not immediately clear
>> on how to handle this via poll etc.  This is probably just
>> because I've never tried though!
> 
> (e)poll can generally distinguish between very few types of
> activity: data for reading available, space for writing available,
> out-of-band events (to be read with e.g. ioctl) and errors.
> 
> If you want to wait for multiple equal types of events for
> one hardware device, it would be logical to have multiple 
> character devices for them, so a user could open and wait
> for some of them independent of the others.
> 
> Intuitively, I would also expect these to be separate iio
> devices for the same hardware (each with one chardev), but
> there may be good reasons why that is not possible.
For reasons above, there can only be one iio device per
physical hardware.  We could define some other intermediate
representation similar to the bus structure we currently have,
but then I'm not sure where we gain.

As we only care about single reader cases here,
the reader can simply configure which events it is interested
in to be the only ones produced.  A good chunk of the sysfs
interface is concerned with doing this.

The ioctl approach you suggest can then be used to query what
actually occurred.

