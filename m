Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161000Ab1FABuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:50:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6870 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab1FABuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:50:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 31 May 2011 18:50:47 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 31 May 2011 18:50:45 -0700
Subject: RE: [PATCH 4/5 v2] [media] ov9740: Remove hardcoded resolution regs
Thread-Topic: [PATCH 4/5 v2] [media] ov9740: Remove hardcoded resolution regs
Thread-Index: Acwd7FivYLHV3s6GTJSYmHNCNjWRWwCEOWDw
Message-ID: <643E69AA4436674C8F39DCC2C05F76382A75BF37C3@HQMAIL03.nvidia.com>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
 <1306368272-28279-4-git-send-email-achew@nvidia.com>
 <Pine.LNX.4.64.1105291221450.18788@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105291221450.18788@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Width must be a multiple of 4 pixels. */
> > +	*width += *width % 4;
> 
> No, this doesn't make it a multiple of 4, unless it was 
> even;) Just take 5 
> as an example. What you really want here is

Geez, you're right.  Not sure what was going on in my head when I did this.  Thanks for catching it.


> > +	/*
> > +	 * Try to use as much of the sensor area as possible 
> when supporting
> > +	 * smaller resolutions.  Depending on the aspect ratio of the
> > +	 * chosen resolution, we can either use the full width 
> of the sensor,
> > +	 * or the full height of the sensor (or both if the 
> aspect ratio is
> > +	 * the same as 1280x720.
> > +	 */
> > +	if ((OV9740_MAX_WIDTH * height) > (OV9740_MAX_HEIGHT * width)) {
> > +		scale_input_x = (OV9740_MAX_HEIGHT * width) / height;
> > +		scale_input_y = OV9740_MAX_HEIGHT;
> >  	} else {
> > -		dev_err(&client->dev, "Failed to select resolution!\n");
> > -		return -EINVAL;
> > +		scale_input_x = OV9740_MAX_WIDTH;
> > +		scale_input_y = (OV9740_MAX_WIDTH * height) / width;
> >  	}
> 
> I don'z know how this sensor works, but the above two divisions round 
> down. And these are input sizes. Cannot it possibly lead to 
> the output 
> window being smaller, than required? Maybe you have to round 
> up (hint: 
> use DIV_ROUND_UP())?

The intention is to do some ratio math without floating point instructions, which resulted in some algebraic twiddling (which is why that math looks so weird).  I think what's there is okay.  If there's any rounding at all (and there shouldn't be any rounding, if "standard" image dimensions are called for), then there's going to be some aspect ratio weirdness no matter which way you round that division.