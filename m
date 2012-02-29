Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2B2WUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:20:13 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:60960 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932292Ab2B2WUM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:20:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.14.98.133 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
In-Reply-To: <1330508617-6490-1-git-send-email-myungjoo.ham@samsung.com>
References: <1330408010-25780-1-git-send-email-myungjoo.ham@samsung.com> <1330508617-6490-1-git-send-email-myungjoo.ham@samsung.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 29 Feb 2012 14:19:48 -0800
Message-ID: <CAJOA=zNQ_fqVXvRdGjwB+GnQZMRzYO-WuLNZh50BMsj4V=ThyQ@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] PM / devfreq: add PM QoS support
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        mark gross <markgross@thegnar.org>, myungjoo.ham@gmail.com,
        Jean Pihet <jean.pihet@newoldbits.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 1:43 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> +       /* Check the sanity of qos_list/qos_type */
> +       if (profile->qos_type || profile->qos_list) {
> +               switch (profile->qos_type) {
> +               case PM_QOS_CPU_DMA_LATENCY:
> +               case PM_QOS_NETWORK_LATENCY:
> +                       devfreq->qos_use_max = false;
> +                       break;
> +               case PM_QOS_NETWORK_THROUGHPUT:
> +                       devfreq->qos_use_max = true;
> +                       break;

Hello MyungJoo!

I see that you re-using the same old PM QoS handles in this
implementation.  Do you feel this is the right way to do it?  Your
example of using DMA for multimedia devices (given in the changelog)
has nothing to do with network throughput, yet that constraint-type is
used here.

I wonder if a better solution than overloading these classifications exist.

Just to toss around ideas, what about having per-device PM QoS
throughput constraints which are generalized (e.g., not tied to a
concept such as "network").  I've Cc'd Jean Pihet (yet again) who has
some good experience making PM QoS-type interfaces work on a
per-device basis.

I wonder, ultimately, if instead of feeding QoS constraints into
devfreq if a better design might be to have devfreq feed input into a
greater QoS framework.  E.g:

A scalable bus used by many devices might have two different device
drivers that want to call pm_qos_device_tput(...), and also the
devfreq driver for that bus also calls pm_qos_device_tput(...).  So
essentially there are three points in the code where inputs can be
driven into one common per-device QoS layer for the generic concept of
"device throughput".  This way devfreq support is not a prerequisite
for scaling a device in a generic way, but a nice framework for
devices which can monitor their own activity level, built on top of a
per-device pm qos layer.

Thoughts?
Mike
