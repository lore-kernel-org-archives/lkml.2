Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2KPUCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:02:46 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:35231 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2KPUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:02:44 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AueTAHGbplBV5h1yPGdsb2JhbABEili3BwOBAxkBAQEBHwIXDSeCHgEBBAEnExwjBQsIA0YUJQoaLodsCr8BFIxvg1xhA5V7hXuDTolr
X-IronPort-AV: E=Sophos;i="4.83,266,1352070000"; 
   d="scan'208";a="447536029"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 16 Nov 2012 21:09:26 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
Message-ID: <20121116200926.GA652@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
 <20121114195852.GA14840@polaris.bitmath.org>
 <50A40CB3.8070105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A40CB3.8070105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > This was not what I envisioned from the discussion yesterday, I was
> > probably too vague. Firstly, the absolute time interval checked seems
> > to be 500 ms, which is arbitrary. Second, the wrap should probably use
> 
> Not exactly. The time interval was 5s, near enough the minimum requirement for this field (6.5535 s).

Sorry about that, but the argument remains; it should depend on logical_maximum.

> > (logical_maximum + 1). Third, we are still not sure whether we should
> > take the 'time = 0 means reset' logic literally, I think it needs to
> > be tested.
> 
> Again, the device I have never does any reset at the first touch, it just wraps the counter.
> The problem is that when there is no event, we now that no events occurred since the previous timestamp, modulus 6.5535 seconds.

So the very first win8 device we test already diverges from the win8
specification, how nice.

Ok, you have conviced me that comparing to a proper time makes
sense. However, I am not happy about using a separate time for this,
given that we will fill in the event time later in the
chain.

In addition, it would make perfect sense to extend the validity of the
hardware time with the event time for longer intervals. The relative
error only makes a difference on milisecond intervals.

A patch that seamlessly extends the validity of the hardware time,
ideally using the event time, seems like a viable solution.

> > +static void mt_compute_timestamp(struct mt_device *td, struct hid_field *field,
> > +				 unsigned value)
> > +{
> > +	unsigned dt;
> > +
> > +	if (value) {
> > +		dt = (value - td->dev_time) % (field->logical_maximum + 1);
> 
> The curious thing is that this is not working on my kernel:

Oups, I suspect (value - td->dev_time) needs to be explicitly converted to unsigned.

> I don't understand the meaning of adding !td->timestamp. :/

With the definition that timestamp == 0 means an unknown interval, we
do not want to send that value by accident.

Thanks,
Henrik
