Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1CYXbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:31:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42638 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1CYXbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110325082030.GB5664@polaris.bitmath.org>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-2-git-send-email-jeffbrown@android.com> <20110325082030.GB5664@polaris.bitmath.org>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Fri, 25 Mar 2011 16:30:20 -0700
Message-ID: <AANLkTi=KotXd4TyyUrhMdKn3mEq+pz2ac3Vnraa5udFh@mail.gmail.com>
Subject: Re: [PATCH 1/4] input: Set default events per packet.
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 1:20 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> +static inline bool is_mt_axis(int axis)
>> +{
>> +     return axis == ABS_MT_SLOT ||
>> +             (axis >= ABS_MT_FIRST && axis <= ABS_MT_LAST);
>> +}
>
> It would be great to get this inline into input/mt.h instead.

Makes sense.  I'll do that.

>> +     else if (test_bit(ABS_MT_TRACKING_ID, dev->absbit))
>> +             mt_slots = dev->absinfo[ABS_MT_TRACKING_ID].maximum -
>> +                     dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1;
>
> This one is a bit iffy - the tracking id is not limited like this in
> mainline, looks like android usage. A test againts some arbitrary max
> should do it.

Yeah, I'm not sure about this one.  Tracking ID could effectively have
any range.  All of the MT Protocol A touch screen drivers I have
looked at, assuming they report tracking ids at all, report a
reasonable upper bound on the contact points they support.

Originally, I set an arbitrary maximum bound of 20 slots.  In the
interests of keeping it simple, I decided to remove that bound when I
submitted the patch for review here.

How about:

mt_slots = min(MAX_MT_SLOTS_TO_INFER_FROM_TRACKING_ID_RANGE,
   dev->absinfo[ABS_MT_TRACKING_ID].maximum -
dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1);

Where MAX_MT_SLOTS_TO_INFER_FROM_TRACKING_ID_RANGE is set to 32 or something.

There's also the question of how many slots we should infer when
neither ABS_MT_SLOT or ABS_MT_TRACKING_ID is available.  The drivers
I've seen that don't provide tracking ids, are very basic and tend to
only support 2 touch points.

I guess we could add a DEFAULT_NUMBER_OF_MT_SLOTS constant to handle that case.

Please feel free to suggest better names for these constants.

Jeff.
