Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1HOHSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:18:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1HOHSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:18:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=smtDTfDF/5tumV46pvzK3LIZptoYFlXANqVVemGGC9NefadKOVnrmb2JMTmWe9uFk
	+FY9gEz0g3QElpM29ghWQ==
MIME-Version: 1.0
In-Reply-To: <20110812210911.GA9124@polaris.bitmath.org>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
 <1313169407-4358-5-git-send-email-djkurtz@chromium.org> <20110812210911.GA9124@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 15 Aug 2011 15:17:57 +0800
X-Google-Sender-Auth: 3QVNlGH_uIUaAA-xJXWInT_-vE0
Message-ID: <CAGS+omAo1tPzBQ_s+vz-7_5SS6vWv4bdzD1JfqepUS7wYxK5sA@mail.gmail.com>
Subject: Re: [PATCH 4/8 v3] Input: synaptics - add image sensor support
To: Henrik Rydberg <rydberg@euromail.se>
Cc: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Thanks for the great feedback.

On Sat, Aug 13, 2011 at 5:09 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Daniel,
>
> looks good, some details below.
>
>> +static void synaptics_report_slot_empty(struct input_dev *dev, int slot)
>> +{
>> +     input_mt_slot(dev, slot);
>> +     input_mt_report_slot_state(dev, MT_TOOL_FINGER, false);
>> +}
>> +
>> +static void synaptics_report_slot_sgm(struct input_dev *dev, int slot,
>> +                                   const struct synaptics_hw_state *sgm)
>> +{
>> +     input_mt_slot(dev, slot);
>> +     input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
>> +     input_report_abs(dev, ABS_MT_POSITION_X, sgm->x);
>> +     input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(sgm->y));
>> +     input_report_abs(dev, ABS_MT_PRESSURE, sgm->z);
>> +     /* SGM can sometimes contain valid width */
>> +     if (sgm->w >= 4)
>> +             input_report_abs(dev, ABS_MT_TOUCH_MAJOR, sgm->w);
>> +}
>
> The ABS_MT_TOUCH_MAJOR is supposed to have zero intercept, to remain
> compatible with user space handling of type A devices. Also, the scale
> should match the screen/pad size, such that the actual size of the
> touch area can be deduced. In addition, based on the current sensor
> technologies, ABS_MT_PRESSURE and ABS_MT_TOUCH_MAJOR are normally
> mutually exclusive.
>
> All in all, I would prefer to only report width via (the single-finger
> axis) ABS_TOOL_WIDTH, and only for compatibility reasons.
>
> +
> +static void synaptics_report_slot_agm(struct input_dev *dev, int slot,
> +                                   const struct synaptics_hw_state *agm)
> +{
> +     input_mt_slot(dev, slot);
> +     input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
> +     input_report_abs(dev, ABS_MT_POSITION_X, agm->x);
> +     input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(agm->y));
> +     input_report_abs(dev, ABS_MT_PRESSURE, agm->z);
> +}

With ABS_MT_TOUCH_MAJOR dropped, sgm and agm seems to coincide...
....
>
> Looks good otherwise.
>
> Thanks,
> Henrik
>

Ahh....  ok, this makes sense.  I missed this detail previously.
Basically:
  * Only report synaptics "w" as ABS_TOOL_WIDTH (for backwards compatibility)
  * Report synaptics "z" as ABS_MT_TOUCH_MAJOR (assuming it is really
'width of finger in surface units'), and ABS_PRESSURE (for backwards
compatibility).
  * Don't use ABS_MT_PRESSURE.
  * This will simplify agm/sgm reporting by making them both reoprt
the same axes.

I will rework these patches to do this.

Thanks,
-Dan
