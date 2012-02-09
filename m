Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2BIKVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:21:03 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4812 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757291Ab2BIKVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:21:01 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q19AKZ3a019371
Subject: Re: checkpatch complaint
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Joe Perches <joe@perches.com>, Arend van Spriel <arend@broadcom.com>,
        Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 09 Feb 2012 11:20:36 +0100
In-Reply-To: <20120209050551.GA25763@ericsson.com>
References: <4F32E062.1020709@broadcom.com>
	 <1328744534.6909.2.camel@joe2Laptop> <20120209050551.GA25763@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1328782838.25984.205.camel@thorin>
Mime-Version: 1.0
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2012-02-08 at 21:05 -0800, Guenter Roeck wrote:
> On Wed, Feb 08, 2012 at 06:42:14PM -0500, Joe Perches wrote:
> > On Wed, 2012-02-08 at 21:51 +0100, Arend van Spriel wrote:
> > > checkpatch complains on code below and I must overlook something or
> > > checkpatch gives a false negative/positive/whatever:
> > > 
> > > #define IFPTR(usb, idx)         ((usb)->actconfig->interface[(idx)])
> > > #define IFALTS(usb, idx)        (IFPTR((usb), (idx))->altsetting[0])
> > > #define IFDESC(usb, idx)        IFALTS((usb), (idx)).desc
> > > #define IFEPDESC(usb, idx, ep)  \
> > > 	(IFALTS((usb), (idx)).endpoint[(ep)]).desc
> > > 
> > > checkpatch errors:
> > > ERROR: Macros with complex values should be enclosed in parenthesis
> > > #169: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:58:
> > > +#define IFDESC(usb, idx)        (IFALTS((usb), (idx))).desc
> > > 
> > > ERROR: Macros with complex values should be enclosed in parenthesis
> > > #170: FILE: drivers/net/wireless/brcm80211/brcmfmac/usb.c:59:
> > > +#define IFEPDESC(usb, idx, ep)  ((IFALTS((usb),
> > > (idx))).endpoint[(ep)]).desc
> > > 
> > > Any ideas? I tried extra parenthesis around IFALTS but that does not
> > > resolve it.

You probably did it wrong. Sent the next time what you *really* did and
not only description .....

> > I think the entries should be surround by ()
> > I think it's reasonable too.
> > 
> > I tried:
> > 
> > $ cat cp.c
> > #define IFPTR(usb, idx)		((usb)->actconfig->interface[(idx)])
> > #define IFALTS(usb, idx)	(IFPTR((usb), (idx))->altsetting[0])
> > #define IFDESC(usb, idx)	(IFALTS((usb), (idx)).desc)
> > #define IFEPDESC(usb, idx, ep)	((IFALTS((usb), (idx)).endpoint[(ep)]).desc)
> > 
> > $ ./scripts/checkpatch.pl -f cp.c
> > total: 0 errors, 0 warnings, 5 lines checked
> > 
> > cp.c has no obvious style problems and is ready for submission.
> >
> Hi Joe,
>  
> different example, same message:
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #339: FILE: hwmon/ltc4245.c:339:
> +#define LTC4245_ALARM(name, mask, reg) \
> +       static SENSOR_DEVICE_ATTR_2(name, S_IRUGO, \
> +       ltc4245_show_alarm, NULL, (mask), reg)

*eg* Make it one (long) line. IMHO this is a prototype example to ignore
the 80-column limit.

I haven't looked the the reg-exps (or the code in `checkpatch`) but
either make `checkpatch` recognize the "\" at the end of lines and merge
the lines before doing these checks (since they apparently assume that
the complete macro definition is on one line) or allow "\\\n" within the
reg-exps.

> and:
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #585: FILE: hwmon/pc87360.c:585:
> +#define VIN_UNIT_ATTRS(X) \
> +       &in_input[X].dev_attr.attr,     \
> +       &in_status[X].dev_attr.attr,    \
> +       &in_min[X].dev_attr.attr,       \
> +       &in_max[X].dev_attr.attr,       \
> +       &in_min_alarm[X].dev_attr.attr, \
> +       &in_max_alarm[X].dev_attr.attr
[...]
> Other than labeling them as "false positive", I have no idea what to do about it.
> Sure, we could replace all the macros with immediate code, but that doesn't sound
> very compelling. If you have an idea, please let me know.

Given that the above gives after the preprocessor the desired results:
Add special comments (like `indent` allows to disable it temporarily) so
that checkpatch doesn't complain about these macros.
Yes, that can be abused but review should catch that. And newbies won't
see false positives.
Listing the to-be-ignored #define's in `checkpatch` (or some external
file) or enhancing it with some "known false positives, do not emit
*that* warning there" is also a maintenance burden (hmm, how often do
they change?).

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

