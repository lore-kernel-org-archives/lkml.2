Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1E2SYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:24:21 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:40011 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab1E2SYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:24:20 -0400
Message-ID: <4DE28F3F.2010709@tilera.com>
Date: Sun, 29 May 2011 14:23:59 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH v2] arch/tile: add hypervisor-based character driver for
 SPI flash ROM
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <20110529114517.GA13513@suse.de> <4DE2399C.9090500@tilera.com> <201105291745.26468.arnd@arndb.de>
In-Reply-To: <201105291745.26468.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2011 11:45 AM, Arnd Bergmann wrote:
> On Sunday 29 May 2011 14:18:36 Chris Metcalf wrote:
>> On 5/29/2011 7:45 AM, Greg KH wrote:
>>> On Sat, May 28, 2011 at 08:32:07PM -0400, Chris Metcalf wrote:
>>>>> As you are only using 1 minor device, why not just use a misc device
>>>>> instead?  It's simpler, and you get the sysfs code for free, which you
>>>>> forgot to do, so your device node will never show up in userspace :(
>>>> Interesting; this appears to be a bug.  We use 4 minors (see "srom_devs =
>>>> 4" higher up).  I'll fix this.  We may have some other devices that would
>>>> benefit from being recast as misc devices, so I'll look at our set of
>>>> internal devices.
>>> This kind of implies that you didn't test this code, right?  You might
>>> want to do that next time :)
>> No, this bug has been in the code since day one (I just double-checked our
>> SCM), and it has always worked fine.  I'm looking into how this is possible
>> now, but trust me, we've tested this aspect of the driver the whole time. :-)
>>
> AFAICT, the driver just calls cdev_add in a loop, adding one device
> add a time. This is actually a correct way to register multiple
> character devices, but simply passing the number of devices you
> want to add as the third argument would be simpler.

Good catch!  Amusingly, I audited our other drivers that we haven't tried
to push back yet, and did find one that actually did have this bug: it was
doing cdev_add() without the surrounding loop, but without passing the
right minor count from alloc_chrdev_region() (although in that case the
default value was "1" in any case).

I restructured the tile-srom init code to call cdev_add() once, using a
single global "struct cdev".  The "open" routine now uses "iminor()"
instead of "container_of()" to get the proper srom_dev structure with the
driver's per-partition info.

> On a related note, the number of devices you add is a module parameter,
> which seems a bit backwards, since the hypervisor should actually
> know how many devices there are. Can't you just ask the hypervisor?

Fair point.  I restructured the init so we loop calling hv_dev_open() until
the hypervisor says we've hit a bad partition number, and that's the number
of partitions the Linux driver then supports.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


