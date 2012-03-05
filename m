Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2CEBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:09:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46952 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab2CEBJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:09:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.236.3 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <201203042330.34083.rjw@sisk.pl>
References: <1330408010-25780-1-git-send-email-myungjoo.ham@samsung.com>
	<1330508617-6490-1-git-send-email-myungjoo.ham@samsung.com>
	<CAJOA=zNQ_fqVXvRdGjwB+GnQZMRzYO-WuLNZh50BMsj4V=ThyQ@mail.gmail.com>
	<201203042330.34083.rjw@sisk.pl>
Date: Mon, 5 Mar 2012 10:09:23 +0900
Message-ID: <CAJ0PZbQc3Tbb5Qf+6Bp6Vdie5RMf+6D1_DkPQXOY2DhDZndFJA@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] PM / devfreq: add PM QoS support
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Turquette, Mike" <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, mark gross <markgross@thegnar.org>,
        Jean Pihet <jean.pihet@newoldbits.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 7:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, February 29, 2012, Turquette, Mike wrote:
>> On Wed, Feb 29, 2012 at 1:43 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> > +       /* Check the sanity of qos_list/qos_type */
>> > +       if (profile->qos_type || profile->qos_list) {
>> > +               switch (profile->qos_type) {
>> > +               case PM_QOS_CPU_DMA_LATENCY:
>> > +               case PM_QOS_NETWORK_LATENCY:
>> > +                       devfreq->qos_use_max = false;
>> > +                       break;
>> > +               case PM_QOS_NETWORK_THROUGHPUT:
>> > +                       devfreq->qos_use_max = true;
>> > +                       break;
>>
>> Hello MyungJoo!
>>
>> I see that you re-using the same old PM QoS handles in this
>> implementation.  Do you feel this is the right way to do it?  Your
>> example of using DMA for multimedia devices (given in the changelog)
>> has nothing to do with network throughput, yet that constraint-type is
>> used here.
>>
>> I wonder if a better solution than overloading these classifications exist.
>>
>> Just to toss around ideas, what about having per-device PM QoS
>> throughput constraints which are generalized (e.g., not tied to a
>> concept such as "network").  I've Cc'd Jean Pihet (yet again) who has
>> some good experience making PM QoS-type interfaces work on a
>> per-device basis.
>>
>> I wonder, ultimately, if instead of feeding QoS constraints into
>> devfreq if a better design might be to have devfreq feed input into a
>> greater QoS framework.  E.g:
>>
>> A scalable bus used by many devices might have two different device
>> drivers that want to call pm_qos_device_tput(...), and also the
>> devfreq driver for that bus also calls pm_qos_device_tput(...).  So
>> essentially there are three points in the code where inputs can be
>> driven into one common per-device QoS layer for the generic concept of
>> "device throughput".  This way devfreq support is not a prerequisite
>> for scaling a device in a generic way, but a nice framework for
>> devices which can monitor their own activity level, built on top of a
>> per-device pm qos layer.
>>
>> Thoughts?
>
> I agree with the general idea, definitely would prefer it to what is
> currently being proposed.

Supporting per-device PM-QoS at devfreq is an option that I'm
considering as well as this global PM-QoS. I simply thought to
implement that after global Pm-QoS. (I'm intendeing to support both at
devfreq)

First of all, this is not going to be tied to DMA-BUS only as
currently we are implementing this on other types of devices as well
including GPU, Memory-interface, and others (IPs related with graphics
and/or multimedia); other manufactorers told that they are
implementing these. Although devfreq is now related with DMA_LATENCY
only, those NETWORK_* are added for the generality. And DMA_THROUGHPUT
and DVFS_LATENCY will be added as well if they are added to global
PM_QOS classes.

However, with BUS(w/ DMA) devfreq, the problem with using per-device
PM-QoS only at devfreq is that the devices that requests QoS on the
bus may be attached to different types of bus. The QoS value for bus
in Exynos4210 will be different from Exynos4412 or Exynos5410 while an
identical IP (or in-SoC device) can be attached to all the three chips
(which we are experiencing). When that IP requests QoS value to the
bus, we need a standardized value, not a value specific to an SoC. We
may ensure that the all Exynos bus drivers to use the same metrics if
the IP is only attached to SoCs of a single company. However, there
are IPs that are attached to multiple companies' SoCs; such as most
GPUs. (And GPUs often request QoS values to busses.)


Cheers!
MyungJoo.


-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
