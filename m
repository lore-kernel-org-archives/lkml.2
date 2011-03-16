Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1CPQx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:53:57 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:50192 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1CPQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:53:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D80EB5F.6030805@cam.ac.uk>
Date: Wed, 16 Mar 2011 16:54:55 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <4D80A5B5.2020805@cam.ac.uk>
In-Reply-To: <4D80A5B5.2020805@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/11 11:57, Jonathan Cameron wrote:
> Hi Arnd,
>> I've started looking at the current code base in staging,
>> this is basically a log of what I'm finding there that
>> may get improved:
> Thanks for taking a look!
>>
>> * Your bus_type is not really a bus in the sense we normally
>> use it, because it does not have any driver/device matching.
>> You only register devices from the same files that drive
>> the hardware. This is normally done using a class, not
>> a bus.
> That's what I originally thought and indeed how it was
> initially done.  The responses from Greg KH and Kay Sievers
> to one of our ABI discussions convinced me otherwise.
> 
> http://lkml.org/lkml/2010/1/20/233 + the previous email in
> that thread.
> 
>>
>> * Since you specify the sysfs attributes globally in the
>> documentation, it would be nice if drivers did not have
>> to implement them as attribute show function, but as
>> a function that simply returns a value that is then
>> printed by common code. You can do this using a structure
>> of function pointers that each driver fills with the
>> relevant ones, like file_operations, replacing the
>> attribute groups.
> This may indeed work.  However it would be a fair bit
> more fiddly than that a simple function pointer structure
> as the sets of attributes supplied by different devices
> vary considerably.  
> 
> So to confirm I understand you correctly we either have something like:
> /* access ops */
> 
> int (*get_accel_x)(struct iio_dev *devinfo)
> char *(*get_accel_offset)(struct iio_dev *devinfo); /* note these can't return a value as
> they may well be floating point */
> char *(*get_accel_gain)(struct iio_dev *devinfo)
> int (*get_accel_y)(struct iio_dev *devinfo)
> 
> Sticky cases that will make this fiddly.
> 
> * Unknown maximum number of some types of attributes.
>   - Could use a 
> 	int (*get_in)(struct iio_dev dev_info, int channel);
> 	int num_in;
> * Whatever you pick also immediately becomes restrictive as the main
> class has to be updated to handle any new elements.
> * Note we'll have function points for all the scan element related stuff
> as well.  Basically the set that would be needed is huge. 
> 
> At the end of the day I'm unconvinced this makes sense from the point
> of view of simplifying the driver code.  The gain is that it enforces the abi
> and may allow in kernel uses.
> Ultimately we lifted this approach from hwmon where it works well
> under similar circumstances.
> 
> Alternative is a small set such as:
> 
> /* access ops */
> int (*get_channel_value)(struct iio_dev *info, enum CHANNEL);
> char (*get_channel_offset)(struct iio_dev *info, enum CHANNEL);
> 
> and a list of which channels exist.  Then the driver side becomes a massive
> switch statement rather than the attribute tables.  Again, I'm not convinced
> that is actually cleaner or easier to understand. Also this approach pretty
> much means you end up with large numbers of equal attributes as you can't
> trivially group them.  e.g we have accel_scale to cover case where it's the
> same for all accelerometer axes.
>>
>> * iio_allocate_device() could get a size argument and
>> allocate the dev_data together with the iio_dev in 
>> a single allocation, like netdev_alloc does. In addition,
>> you can pass a structure with all constant data, such
>> as THIS_MODULE, and the operations and/or attribute groups,
>> instead of having to set them individually for each dev.
> Good idea.
There is an issue here I'd forgotten.  Some of our structures have a
elements which are cacheline aligned.  For first version of this I'll
set our alignment requirements as L1_CACHE_BYTES.  Would be nice to be
able to relax that down the line though as it means we use at least two
cachelines even if we don't care about that alignment requirement.

