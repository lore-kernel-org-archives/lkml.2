Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1COL3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:29:07 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:56157 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab1COL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:29:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7F4DBA.1060502@cam.ac.uk>
Date: Tue, 15 Mar 2011 11:30:02 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "carmine.iascone@st.com" <carmine.iascone@st.com>,
        "matteo.dameno@st.com" <matteo.dameno@st.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <20110314224244.3d6d23ba@endymion.delvare> <20110314224859.GA16970@ericsson.com> <201103151024.26436.arnd@arndb.de>
In-Reply-To: <201103151024.26436.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/11 09:24, Arnd Bergmann wrote:
> On Monday 14 March 2011 23:48:59 Guenter Roeck wrote:
>> On Mon, Mar 14, 2011 at 05:42:44PM -0400, Jean Delvare wrote:
>>> On Mon, 14 Mar 2011 21:36:43 +0100, Arnd Bergmann wrote:
>>>> On Monday 14 March 2011 21:18:09 Jean Delvare wrote:
>>>>> Jonathan is correct. Pressure sensors are not hardware monitoring
>>>>> devices, their drivers have nothing to do in drivers/hwmon. This is
>>>>> something for drivers/misc or staging/iio.
>>>>
>>>> I generally try to prevent people from adding more ad-hoc interfaces
>>>> to drivers/misc. Anything that is called a drivers/misc driver to me
>>>> must qualify as "there can't possibly be a second driver with the
>>>> same semantics", otherwise it should be part of another subsystem
>>>> with clear rules, or be put into its own file system.
>>>
>>> I see drivers/misc differently. I see it as "not enough drivers of the
>>> same type to justify a new subsystem". So I encourage people to put
>>> things there in the absence of any suitable subsystem, until someone
>>> gets enough motivation to start such a subsystem. This is more
>>> pragmatic than requesting subsystems to be created upfront.
>>>
>> Agreed.
>>
>> Note that there is already a pressure sensor in drivers/misc - bmp085.c.
>> That chip also includes a temperature sensor.
> 
> That driver proves exactly what I was trying to say about drivers/misc.
> Even though bmp085 has done everything correctly according to the
> rules (its interface is documented and it has gone into drivers/misc
> instead of another subsystem), we're now stuck with an interface that
> was written for a specific chip without widespread review, and need
> to apply it to all other similar drivers, or risk breaking applications.
> 
> The interface used in bmp085 has no way of finding out which devices
> are actually pressure/temparature sensors, other than by looking
> at the name of the attributes in every i2c device. There are probably
> ways to retrofit this without breaking compatibility, but the options
> are now fairly limited.
Agreed entirely, though that particular device actually has a reasonable
interface which bares a startling resemblence to hwmon / iio.
(I pushed back on that during review and Christoph was happy to
make merging later easy).

As an aside IIO very deliberately only makes type of sensor apparent in
via naming of sysfs attributes, as does hwmon. Obviously you'll
be looking in roughly the right place though so not quite so bad as
searching all possible buses though!
Any subgrouping doesn't really work as so many devices have fairly
random sets of sensors on them. (not sure if you were suggesting that
though!)
> 
>>> That being said, staging is another option nowadays.
>>>
>>>> While it seems that right now everyone is just trying to keep move
>>>> the driver to some other subsystem, I think it's worth noting that
>>>> it is indeed a useful thing to have the driver, I'm optimistic
>>>> that we can find some place for it. ;-)
>>>>
>>>> Now how about the IIO stuff? This is the first time I've even
>>>> heard about it. Does it have any major disadvantages besides
>>>> being staging-quality?
>>>
>>> This is indeed the major disadvantage. IIO seems to take a lot of time
>>> to move out of staging, although I don't know what the current ETA is.
>>>
>> In general it would be nice to have a "sensors" subsystem. iio is going into
>> that direction, so creating another one might not make much sense at this point.
> 
> It depends on the quality of the iio code base, which I have not looked
> at. If it's good enough, we could use that, and ideally find a way to
> be backwards-compatible with bmp085. Otherwise, creating a new subsystem
> could work as well, but only if the people behind iio support that move.
> A new subsystem of that sort would need to start out with a well-designed
> user interface, and allow moving over drivers from staging/iio without
> too much pain.
Interfaces (well sysfs ones anyway) is an area we have hammered pretty hard.
Arnd, if I you do have time to look at anything, take a look at the abi docs
in drivers/staging/iio/Documentation/ (mainly sysfs-bus-iio).  I've been
pushing others introducing similar drivers into misc/input to use these
unless they can come up with a good argument of why not.  Some fight back
on the basis we are only in staging so why should they take any notice.
Moves to agree these agreed across the kernel (mainly directed at
accelerometers as some of these make sense in input whereas others
definitely don't) didn't get very far sadly.  Right now Dmitry is
pretty much blocking any accelerometer sysfs interface purely because
he hasn't seen a consensus yet.

It took a lot of time to pin those interfaces down, so whilst we welcome
suggestions for changes/additions, they must keep generality if at all
possible.

Jonathan
