Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab0FWLiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:38:12 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:41468 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0FWLiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:38:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C21F2F1.3080707@jic23.retrosnub.co.uk>
Date: Wed, 23 Jun 2010 12:41:37 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Mair <christoph.mair@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Datta Shubhrajyoti <shubhrajyoti@ti.com>
Subject: Re: [PATCH] Support for the pressure sensor BMP085 from Bosch Sensortec.
References: <4C1DF4DE.5090403@jic23.retrosnub.co.uk> <1277067058-6929-1-git-send-email-christoph.mair@gmail.com> <20100621144958.d5fc694e.akpm@linux-foundation.org> <201006230126.48452.christoph.mair@gmail.com>
In-Reply-To: <201006230126.48452.christoph.mair@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph
>>> This driver adds support for the BMP085 digital pressure sensor
>>> from Bosch Sensortec.
>>
>> If there's a datasheet available, it would be nice to provide a
>> reference to that in the driver.
> I will send a patch to fix this.
> 
>> Please do send a full description of the proposed API so we can review
>> that.  What are the contents of these files?  What are the units of
>> those contents, etc?
> There is a short description before the methods bmp085_get_temperature() and 
> bmp085_get_pressure(), but anyway.
> 
> Here is a Description of the current sysfs user interface:
> 
> The BMP085 digital pressure sensor can measure ambient air pressure and 
> temperature. Both values can be obtained from sysfs files. The pressure is 
> measured by reading from pressure0_input. Valid values range from 30000 to 
> 110000 pascal with a resolution of 1 pascal (=0.01 millibar).
> 
> temp0_input holds the current temperature in degree celsius, multiplied by 10. 
> This results in a resolution of a tenth degree celsius. Values range from -400 
> to 850.
> 
> To increase the accuracy, this chip can calculate the average of 1, 2, 4 or 8 
> samples. This behavior is controlled through the oversampling sysfs file. Two 
> to the power of the value written to that file specifies how many samples will 
> be used. Valid values: 0..3.
> 
> 
>> Are there any similar drivers in the tree (I don't think so) and if so
>> does this new driver offer the same interface?
> I did not find one.
> 
>> Bear in mind that if new drivers for similar devices _do_ come along
>> then we'd prefer that those drivers implement the same interface as
>> this one.  So is this driver's interface well-designed from that point
>> of view?
> The pressure0_input and temp0_input should follow the naming convention of 
> hwmon devices. I think that would be ok for other sensors too. The 
> oversampling is special to this device and others may not support this.
> 
> A more general problem is the obtainable resolution. I work on a humidity 
> sensor driver for the SHT21. It measures temperatures with a resolution of 
> 0.01 celsius, ten times higher than the bmp085.
> Maybe we need an additional sysfs file which contains the current measurement 
> resolution.
Follow the hwmon abi where you can.  For reference if you haven't seen it, there
is a driver for the sht15 there already. I see sensirion have moved to a sensible
bus which will make life somewhat easier for you!  I look forward to seeing the
driver.

The scaling you are talking about is handled in IIO with a series of extensions
to the hwmon abi. (drivers/staging/iio/Documentation/)
> 
> I think it would be nice to have a general sensor api which for example 
> specifies the sensor type, the units used for this type and the resolution of 
> each result.
Covered by IIO though principally for a different reason.  There we are interested
enough in speed of capture that we don't want to do simple linear transforms
of raw data in kernel and hence pass the values necessary to do it up to userspace.
Note we still use 'standard' units.   The scaling parameters don't have to be integer
so almost any accuracy is possible.

In cases like these sensors, things are generally pretty slow, so just stick to the
conventions of hwmon (and the units specified there) unless you have very specific reasons
not to do so.

When you say sensor type... What do you mean?  The current standards make the type
of reading apparent in the naming of the attributes.  Do you mean something more detailed
and if so do you have an example of when userspace might care?  Likewise on resolution.
Again we have reason to do it in IIO, but that doesn't apply here.
> Any thoughts on this?
> 
>> Also, we're supposed to docuemnt these things formally in
>> Documentation/ABI/.
> I will send a patch for this one too.
> 
Good :)

Jonathan
