Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1CUSZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:25:39 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:41207 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1CUSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:25:37 -0400
Message-ID: <4D879810.9000408@seas.upenn.edu>
Date: Mon, 21 Mar 2011 14:25:20 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, chatty@enac.fr, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/2] hid-ntrig: calibration
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu> <1299829072-19489-2-git-send-email-rafi@seas.upenn.edu> <20110321171550.GA4602@polaris.bitmath.org>
In-Reply-To: <20110321171550.GA4602@polaris.bitmath.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-21_06:2011-03-16,2011-03-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1103210114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 03/21/11 13:15, Henrik Rydberg wrote:
> Hi Rafi,
> 
> On Fri, Mar 11, 2011 at 02:37:52AM -0500, Rafi Rubin wrote:
>> Adding a function to tell the device to run its calibration routine.
>> A number written to the sysfs specifies the duration of the calibration
>> in milliseconds
>>
>> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
>> ---
> 
> This is great functionality, and from what it seems, it
> works. However, the poking at the usb layer makes me wonder if there
> is another way... Jiri? Dmitry? Awaiting answers from someone more
> knowledgeable, please find some comments inline.
> 
>> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
>> index 24ab6a5..ddf2c76 100644
>> --- a/drivers/hid/hid-ntrig.c
>> +++ b/drivers/hid/hid-ntrig.c
>> @@ -490,6 +490,53 @@ static ssize_t store_mode(struct device *dev,
>>  }
>>  static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, show_mode, store_mode);
>>  
>> +static ssize_t ntrig_calibrate(struct device *dev,
>> +			       struct device_attribute *attr,
>> +			       const char *buf, size_t count)
>> +{
>> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>> +	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
>> +	struct usbhid_device *usbhid = hdev->driver_data;
>> +	int ret;
>> +	unsigned long t;
>> +	unsigned char *data;
>> +
>> +	if (strict_strtoul(buf, 0, &t))
>> +		return -EINVAL;
>> +
>> +	data = kmalloc(4, GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	spin_lock(&usbhid->lock);
>> +	set_bit(HID_DISCONNECTED, &usbhid->iofl);
>> +	spin_unlock(&usbhid->lock);
> 
> Perhaps an addition to the internal HID api instead of the above?

I don't have a personal preference.  I figured this is probably unusual enough
that there might not be a point in putting the support in the core, but that's
part of the point of review by other people who know if this would be useful
elsewhere.

>> +
>> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
>> +			      USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
>> +			      | USB_RECIP_INTERFACE | USB_DIR_IN,
>> +			      0x30b, 1, data, 4, USB_CTRL_GET_TIMEOUT);
>> +	if (ret < 0)
>> +		goto fail;
> 
> How about launching restoration work here, instead of waiting?

The user needs some feedback bracketing the calibration routine.  If one touches
the screen during calibration alters the result and typically results in dead
zones (a useful check to verify it works).

Perhaps during the loading of the driver that would make more sense.  I hadn't
really thought about it.


I would like some pointers of how to use work queues.  That's the last item
holding me back from sending in my new track and filter code for review.

>> +
>> +	msleep(t);
>> +
>> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
>> +			      USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
>> +			      | USB_RECIP_INTERFACE | USB_DIR_IN,
>> +			      0x311, 1, data, 4, USB_CTRL_GET_TIMEOUT);
>> +
>> +fail:
>> +	kfree(data);
>> +	spin_lock(&usbhid->lock);
>> +	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
>> +	spin_unlock(&usbhid->lock);
>> +	schedule_work(&usbhid->reset_work);
>> +
>> +	return (ret < 0) ? ret : count;
>> +}
>> +static DEVICE_ATTR(calibrate, S_IWUSR, NULL, ntrig_calibrate);
>> +
>>  static struct attribute *sysfs_attrs[] = {
>>  	&dev_attr_sensor_physical_width.attr,
>>  	&dev_attr_sensor_physical_height.attr,
>> @@ -502,6 +549,7 @@ static struct attribute *sysfs_attrs[] = {
>>  	&dev_attr_activation_height.attr,
>>  	&dev_attr_deactivate_slack.attr,
>>  	&dev_attr_mode.attr,
>> +	&dev_attr_calibrate.attr,
> 
> Maybe one could actually run the calibration at module load, or even
> at start/stop? A few seconds of unresponsiveness might be ok at that
> time.

I still have mixed feelings about that.  I like the idea, but I'm concerned
about keeping hands off the screen during calibration.  This seems like a
Hippocratic issue, first do no harm.  For the devices that are stable, I
wouldn't be surprised if we actually make things worse more often than better.

For the devices that are really screwed up (I've heard reports of machines that
are stable for a few hours at best), we'll need something more active than load
time calibration.

I've been thinking for a while about using feedback from the filters to decide
when its time to recalibrate (a problem that's closer to my day job than most of
this).  In those cases it would be nice to either notify that it needs
calibration, or in the extreme that calibration is already running and to keep
hands off.

I need to play more with short calibrations, I've played a bit, but not
carefully.  If we can do some good with a few milliseconds of calibrations that
would make auto-calibration more tempting.

Also I don't know how frequent calibrations will affect the device.  If, for
example, calibration is stored in flash that's only intended to be written a few
hundred times we could wear it out pretty quickly.  If only we had some feedback
from the folks that build these things....

>>  	NULL
>>  };
> 
> Thanks,
> Henrik
> 

Thanks for the feedback,
Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNh5gQAAoJEPILXytRLnK2Kl0P+we4k9fhKOPx/VP7gW1l0KZT
61PNdKXhMdeg4T4ZmOa2n6pz2xzfDozP+vuRJgkilS0eEz3TZqKvTdiiw0ykjZlK
+Ko1a+T7gAN+ZnSP4AFFglF82K4mbW/Vd0vVwbbC3tUbyzwqxvPrLRxWKhgDJ6FY
CP4i0jW4AJawpB3UoIVwli66X1DzD9RaPNqCJrQiSEDxcay6H1oPB3rwDKGdrZ51
RMKsMaGF7kfeQ1SfrnDhrhEM/8tvs86FQTkHkZ2m2bHdjDEh3uMwfavCe7z4hWUL
4Ln1RMc4fjBoudSMU20WkT38PyqnC5FMfhtxcP50SNjxzsDIQttXU6WE6xjBGAG1
Jt0AKbM/nr3QjhlD7AbbC8NjvgP6JY4ZfneBm5e2tFATluzeRoTfY2e9m76PRr1t
QUhdF26qKZf6Vzt7OnOSxHWH5SyL92C+3q0ScV0c7F8l0MFCnALKCxs7RXIPE1kT
DCmN5fEp6SvtYdkWOtddvR3qex6gCipaUu4lq7mf/snHn4yw2iuMsisns0XGv7AU
MRF0gwzYhWAkbeFvHPuhwE0/R10w7pZXXiPGyARH92nlpGJxOiHb6gZ32TdMUlm/
h5DOhggXGI0wSLSAAP6BTz2f0+pMihTGNvlgKgu5AnvTbYS5coYkpufGQ+qKltHV
oQHICuniy4uI6s88PrZ/
=Fx2M
-----END PGP SIGNATURE-----
