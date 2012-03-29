Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab2C2QZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:25:54 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:21579
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757915Ab2C2QZr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:25:47 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dI9371Ic89bh1432N98dK4015Izz1202hzz8275dhz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F748CF6.4010205@am.sony.com>
Date: Thu, 29 Mar 2012 09:25:26 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
References: <20120328210631.GB2297@fifo99.com> <20120329145055.GE13912@fifo99.com>
In-Reply-To: <20120329145055.GE13912@fifo99.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 07:50 AM, Daniel Walker wrote:
> On Wed, Mar 28, 2012 at 02:06:32PM -0700, Daniel Walker wrote:
>>
>>
>>       I went to Linaro Connect a few weeks ago. While I was there they held a
>> meeting with some of the Android developers and some community developers.
>> During the meeting Brian Swetland and Tim Bird were talking about upstreaming
>> Android's logger kernel changes. Brian mentioned that logger was in the kernel
>> for “performance reasons”. 

...
>         I made no attempt to address any security issues in logger. Since logger has
> no security built into it currently. There are at least two ways to provide security
> to the shared memory interface that I know of, but I'm not planning to discuss them in
> this analysis.

At the mainlining meeting at Connect, we discussed some of the security and
robustness issues with logger, that would affect whether a user-space-only
solution would work.

See the etherpad at:
http://summit.linaro.org/lcq1-12/meeting/20039/linaro-kernel-q112-android-mainlining-f2f-2/

There is concern about applications leaking sensitive data into the logs,
and a desire to possibly (in the future) support per-application logs
for some apps.  Having the code in-kernel means that things like the
timestamp, tid and pid cannot be forged by the process.  The separation
into channels and kernel management of the read/write position provide
an impediment to denial of service attacks.

At the moment, I'm not considering an alternative for logger that runs
completely in user-space.  Having said that, this test is certainly interesting,
and may provide some performance numbers for logger or alternatives that would
be useful to compare.

I like that you've put the gettimeofday() into the shared memory test, to
capture the cost of the timestamp operation.  Presumably, the fact that
x86 has VDSO and ARM does not is contributing to the performance difference
between the two platforms.

I'm a little worried about caching effects for this test, since it
seems like it would run in a very tight loop (with the
exception of the gettimeofday() or the call to logger.


> x86:
> +-----------------+----------------------+-------------------+
> |Clocksource      |         TSC          |       ACPI_PM     |
> +-----------------+----------------------+-------------------+
> |Shared Memory    |     457172567.4B/s   |     28708407.6B/s |
> +-----------------+----------------------+-------------------+
> |Android Logger   |      77531671.5B/s   |     79575677.3B/s |
> +-----------------+----------------------+-------------------+
>
> ARM:
> +-----------------+----------------------+
> |Shared Memory    |    15336338.6B/s     |
> +-----------------+----------------------+
> |Android Logger   |     6615796.3B/s     |
> +-----------------+----------------------+

Tests were 60 seconds.  I presume there were multiple runs and these are
averages.  Can you provide the number of runs and the standard deviation for
each set?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

