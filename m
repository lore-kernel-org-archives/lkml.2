Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2AWJxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:53:03 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:52156 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab2AWJxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:53:01 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhxHAGktHU9V5qrvPGdsb2JhbABCiVCkVRkBAQEBNzKBcgEBBScTHCMQCANGFCUKGogRuBkTizBjBJUYhWeMaQ
X-IronPort-AV: E=Sophos;i="4.71,555,1320620400"; 
   d="scan'208";a="255453618"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 23 Jan 2012 10:52:48 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: Add EVIOC mechanism for MT slots
Message-ID: <20120123095248.GA6667@polaris.bitmath.org>
References: <1326396275-2492-1-git-send-email-rydberg@euromail.se>
 <4F0FEC84.7020605@canonical.com>
 <20120113091556.GA21749@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113091556.GA21749@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> > > +static int evdev_handle_mt_request(struct input_dev *dev,
> > > +				   unsigned int size,
> > > +				   int __user *ip)
> > > +{
> > > +	const struct input_mt_slot *mt = dev->mt;
> > > +	unsigned int code;
> > > +	int i;
> > > +
> > > +	if (get_user(code, &ip[0]))
> > > +		return -EFAULT;
> > > +	if (!input_is_mt_value(code))
> > > +		return -EINVAL;
> > > +
> > > +	if (size < sizeof(struct input_mt_request) + dev->mtsize * sizeof(int))
> > > +		return -EINVAL;
> > 
> > Why not fill in up to the size of the array provided?
> 
> Yes, I think we do the same with other ioctls as well.

Agreed, will do it that way.

> > > +/**
> > > + * struct input_mt_request - used by EVIOCGMTSLOTS ioctl
> > > + * @code: ABS_MT code to read
> > > + * @num_values: number of values written to the value array
> > > + * @values: value array, one value per slot
> > > + *
> > > + * The structure is used to retrieve MT slot data. Before the call,
> > > + * code is set to the wanted ABS_MT event type. On return, the value
> > > + * array is filled with the slot values for the specified ABS_MT code,
> > > + * and num_values is set to the actual number of slots.
> > > + *
> > > + * The call argument (len) is the size of the return buffer, satisfying
> > > + *
> > > + * len >= sizeof(input_mt_request) + sizeof(__s32) * number_of_slots
> > > + *
> > > + * If the request code is not an ABS_MT value, or if len is too small,
> > > + * -EINVAL is returned.
> > > + */
> > > +struct input_mt_request {
> > > +	__u32 code;
> > > +	__u32 num_values;
> 
> Hmm, might avoid this one... Userspace can do EVIOCGABS to get number of
> slots and then it will know how much data EVIOCGMTSLOTS will return...

I think it might be good to keep the length, to avoid possible future
synchronization problems. Perhaps we could get rid of the structure
though, for instance by specifying the write as a 32-bit code and the
read buffer as length, value, value...

Thanks,
Henrik
