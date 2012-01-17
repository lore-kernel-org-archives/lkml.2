Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2AQKcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:32:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47461 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2AQKcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120113044757.GB6004@mgross-G62>
References: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com>
	<CAJOA=zMkRxx=PhznO5VSb3H4bSx7oTYiazesasYY_X7SzSf48A@mail.gmail.com>
	<CAJ0PZbRKknwF1LwJP6M93-GPXJ9xKuzZnDjZMF8C1id026-X4A@mail.gmail.com>
	<20120113044757.GB6004@mgross-G62>
Date: Tue, 17 Jan 2012 19:32:05 +0900
Message-ID: <CAJ0PZbTMuJfBL4iZyc=R4TkdfFuh1_XzV-KQr73330PUt6fcNQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM / devfreq: add min/max_freq limit requested by users.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: markgross@thegnar.org
Cc: "Turquette, Mike" <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 1:47 PM, mark gross <markgross@thegnar.org> wrote:
> On Thu, Jan 12, 2012 at 11:08:44AM +0900, MyungJoo Ham wrote:
>>
>> In practice, we have been using min/max to test DVFS behaviors and its
>> side effects. And we are going to use them to 1. restrict power
>> consumption forcibly by the platform software if it is too hot or the
>> battery is low, and to 2. guarantee the minimum performance for
>> specific tasks controlled by the platform software.
>>
>> Anyway, the reason 2 could be tackled by pm-qos if we allow more
>> options in pm-qos with 1. pm qos type to enforce DVFS response time.
> what would pm_qos do with DVFS response time?  What power management
> knob would it enable a constraint for?
>
> pm_qos doesn't do anything but enable power throttling code to consider
> a constraint on how far to throttle "something".  pm_qos has no
> enforcement power.


- The control knob: polling interval of ondemand-like DVFS mechanisms
- It's ok to have no enforcement power. The DVFS mechanism only needs
an interface (PM QoS seems fine for this) from user space / device
drivers to get the response-time requirement.

With some events, we need to adjust DVFS polling interval.

For now, we do this in our devices for user input events (key input,
touchscreen input, ...). And some peripheral device drivers want to
get "guaranteed response time" depending on their operational modes
from memory and bus at the start of their operations.

With user input events, user may (doing something heavy) or may not
(doing something light) want fast reaction from CPU/MEM/GPU/... in
many occasions, and we cannot determine it until the DVFS polling has
been done.

In average, with near 100% threshold, ondemand-like governors will
take 1.5 x polling interval to response. In a system with 100ms
polling interval, DVFS mechanism will take usuallly 150ms (and up to
200ms) to react and this is significantly noticable to human users.
With 60Hz display system, this is loss of almost 10 frames.

In order to address this, a touch event handler (or any
thread/callback or anything deals with it) may request QoS with an
incoming event to reduce polling interval temporarily.

Although PM-QoS does not have the QoS Type for this kind of metric;
however, DVFS response time seems to be another QoS metric candidate.



>
>> 2. pm qos type to enforce graphics performance. And adding a duration
>> option to pm-qos requests will be helpful (sort of a helper function):
>> i.e., pm_qos_timed_request(struct pm_qos_request *req, int
>> pm_qos_class, s32 value, unsigned long duration_ms);
>
> What would be good units for graphics throughput?
> Where in the graphics driver would you insert the equivalent of cpufreq?
> to control the GPU core frequency?

I've not thought about this much yet. I've just seen the need for QoS
requirements from GPU people because DVFS mechanism loses a frame or
frames often during GPU usage without QoS information.

I'm not so familiar with GPUs, so I can't be sure about the metric for
graphics throughput. However, could it be "FLOPS", "triangles per
second", or GPU clock speed?

We have GPU DVFS drivers in linux/drivers/media/video/..., which
controls GPU core frequency and measures GPU usage. However, they can
be implemented with devfreq framework and move into drivers/devfreq/
later.



Cheers!
MyungJoo.


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
