Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab0H3S47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:56:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48943 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab0H3S45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:56:57 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: markgross@thegnar.org
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Organization: Deep Root Systems, LLC
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
	<1282882403-29824-2-git-send-email-skannan@codeaurora.org>
	<20100827064153.GB3414@gvim.org>
	<b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
	<20100828020540.GB8341@gvim.org> <4C787AA9.4090906@codeaurora.org>
	<20100828225255.GA12402@gvim.org>
Date: Mon, 30 Aug 2010 11:56:54 -0700
In-Reply-To: <20100828225255.GA12402@gvim.org> (mark gross's message of "Sat,
	28 Aug 2010 15:52:55 -0700")
Message-ID: <878w3o3p55.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark gross <markgross@thegnar.org> writes:

> On Fri, Aug 27, 2010 at 07:55:37PM -0700, Saravana Kannan wrote:
>> mark gross wrote:
>> >On Fri, Aug 27, 2010 at 01:10:55AM -0700, skannan@codeaurora.org wrote:
>> >>Ignoring other details for now, the biggest problem with throughput/KBps
>> >>units is that PM QoS can't handle it well in its current state. For KBps
>> >>the requests should be added together before it's "enforced". Just picking
>> >>the maximum won't work optimally.
>> >
>> >well then current pm_qos code for network throughput takes the max.
>> 
>> I don't know how the network throughput is enforced, but if the unit
>> is KBps and it's just doing a Max, then I think it's broken. If two
>> clients request 50 KBps and your network can go till 200 KBps, you
>> would still be requesting 50 KBps when you could have requested 100
>> KBps.
>> 
>> Any specific reason PM QoS doesn't support a "summation" "comparitor"?
>
> PM_QoS could do a summation, but keep in mind it pm_qos not qos.  pm_qos
> is a best effort thing to constrain power management throttling, not
> provide a true quality of service or deadline scheduling support.

For me (and I think Saravana too), this is still all about power, but
it's closely tied to QoS.  

For things like busses, which are inherently shared, PM is tightly
coupled with "true" QoS, so I'm not sure I fully follow the distinction
being made between PM QoS and QoS.  Seems like the tradeoff is always
between power and performance.

> If you stick to the full up quality of service mentality you quickly get
> into discussions just like those around memory over commit.  Its really
> hard to know when best effort or hard QoS is appropriate.
>
> If you are trying to use pm_qos as a true qos interface then, its
> definitely not up to the task.
>
> example:  you have one 100Mb NIC in your box.  With PM QoS you could
> have 4 user mode applications requesting 100Mbs PM_Q0S.  In this case
> the right thing to do is to constrain the NIC PM to keep it full on and
> the PHY going as fast as it can.  But you'll never get 400Mbs out of the
> thing.
>
> So far only max and min really have made sense for pm_qos but, if a case
> pops up where summation makes more sense for aggregating the pm_qos
> requests then I'm open to it.

Using your example above, what if the 4 apps all request 10Mb/s?

What is best effort?  Leave the NIC in 10Mb/s mode, or bump up the power
state to 100Mb/s mode?

This decision is both QoS and PM related.  Without summation, the 'max'
request is still 10Mb/s so you would keep the lower power state.  But
you also know that none of the clients will get their requested rate.

There's some gray area here since there is a choice.  Was the point
of the request to keep the NIC at the *power-state* needed for 10Mb/s (a
PM request) or was the request saying the app wanted at least 10Mb/s (a
QoS request.)  

My understanding is that PM QoS is intended to limit power-state
throttling.  IOW, in the absence of PM QoS requests, the PM core code is
free to throttle the power of the devices/subsystems/busses etc.  If
requests are present, it is no longer free to throttle blindly.

The question here seems to be whether or not the PM core code should
also be free to increase the power state to meet a combination of PM QoS
requests.  To me this is still PM related.  Just like in race-to-idle
for the CPU, it might be better for overall power to go to the highter
state for a burst and then be able to fully throttle again.

Kevin
