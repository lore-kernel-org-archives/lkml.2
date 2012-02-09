Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2BIFH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:07:27 -0500
Received: from imr3.ericy.com ([198.24.6.13]:41801 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2BIFH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:07:26 -0500
Date: Wed, 8 Feb 2012 21:05:51 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Arend van Spriel <arend@broadcom.com>, Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch complaint
Message-ID: <20120209050551.GA25763@ericsson.com>
References: <4F32E062.1020709@broadcom.com>
 <1328744534.6909.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1328744534.6909.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 06:42:14PM -0500, Joe Perches wrote:
> On Wed, 2012-02-08 at 21:51 +0100, Arend van Spriel wrote:
> > checkpatch complains on code below and I must overlook something or
> > checkpatch gives a false negative/positive/whatever:
> > 
> > #define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
> > #define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
> > #define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
> > #define IFEPDESC(usb, idx, ep)  \
> > 	(IFALTS((usb), (idx)).endpoint[(ep)]).desc
> > 
> > checkpatch errors:
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #169: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:58:
> > +#define IFDESC(usb, idx)        (IFALTS((usb), (idx))).desc
> > 
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #170: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:59:
> > +#define IFEPDESC(usb, idx, ep)  ((IFALTS((usb),
> > (idx))).endpoint[(ep)]).desc
> > 
> > Any ideas? I tried extra parenthesis around IFALTS but that does not
> > resolve it.
> 
> I think the entries should be surround by ()
> I think it's reasonable too.
> 
> I tried:
> 
> $ cat cp.c
> #define IFPTR(usb, idx)		((usb)->actconfig->interface[(idx)])
> #define IFALTS(usb, idx)	(IFPTR((usb), (idx))->altsetting[0])
> #define IFDESC(usb, idx)	(IFALTS((usb), (idx)).desc)
> #define IFEPDESC(usb, idx, ep)	((IFALTS((usb), (idx)).endpoint[(ep)]).desc)
> 
> $ ./scripts/checkpatch.pl -f cp.c
> total: 0 errors, 0 warnings, 5 lines checked
> 
> cp.c has no obvious style problems and is ready for submission.
>
Hi Joe,
 
different example, same message:

ERROR: Macros with complex values should be enclosed in parenthesis
#339: FILE: hwmon/ltc4245.c:339:
+#define LTC4245_ALARM(name, mask, reg) \
+       static SENSOR_DEVICE_ATTR_2(name, S_IRUGO, \
+       ltc4245_show_alarm, NULL, (mask), reg)

and:

ERROR: Macros with complex values should be enclosed in parenthesis
#585: FILE: hwmon/pc87360.c:585:
+#define VIN_UNIT_ATTRS(X) \
+       &in_input[X].dev_attr.attr,     \
+       &in_status[X].dev_attr.attr,    \
+       &in_min[X].dev_attr.attr,       \
+       &in_max[X].dev_attr.attr,       \
+       &in_min_alarm[X].dev_attr.attr, \
+       &in_max_alarm[X].dev_attr.attr

and:

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#291: FILE: hwmon/sis5595.c:291:
+#define show_in_offset(offset)                                 \
+static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO,         \
+               show_in, NULL, offset);                         \
+static SENSOR_DEVICE_ATTR(in##offset##_min, S_IRUGO | S_IWUSR, \
+               show_in_min, set_in_min, offset);               \
+static SENSOR_DEVICE_ATTR(in##offset##_max, S_IRUGO | S_IWUSR, \
+               show_in_max, set_in_max, offset);

Those are all pretty common in the hwmon subsystem and all quite annnoying.
Other than labeling them as "false positive", I have no idea what to do about it.
Sure, we could replace all the macros with immediate code, but that doesn't sound
very compelling. If you have an idea, please let me know.

Thanks,
Guenter
