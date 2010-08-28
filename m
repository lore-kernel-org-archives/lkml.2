Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0H1Czj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:55:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38674 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0H1Czi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:55:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6087"; a="52534556"
Message-ID: <4C787AA9.4090906@codeaurora.org>
Date: Fri, 27 Aug 2010 19:55:37 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: markgross@thegnar.org
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, khilman@deeprootsystems.com
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org> <1282882403-29824-2-git-send-email-skannan@codeaurora.org> <20100827064153.GB3414@gvim.org> <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org> <20100828020540.GB8341@gvim.org>
In-Reply-To: <20100828020540.GB8341@gvim.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark gross wrote:
> On Fri, Aug 27, 2010 at 01:10:55AM -0700, skannan@codeaurora.org wrote:
>> Ignoring other details for now, the biggest problem with throughput/KBps
>> units is that PM QoS can't handle it well in its current state. For KBps
>> the requests should be added together before it's "enforced". Just picking
>> the maximum won't work optimally.
> 
> well then current pm_qos code for network throughput takes the max.

I don't know how the network throughput is enforced, but if the unit is 
KBps and it's just doing a Max, then I think it's broken. If two clients 
request 50 KBps and your network can go till 200 KBps, you would still 
be requesting 50 KBps when you could have requested 100 KBps.

Any specific reason PM QoS doesn't support a "summation" "comparitor"?

>> Another problem with using KBps is that the available throughput is going
>> to vary depending on the CPU frequency since the CPU running at a higher
>> freq is going to use more bandwidth/throughput than the same CPU running
>> at a lower freq.
> 
> um, if your modem SPI needs a min freq its really saying it needs a min
> throughput (throughput is just a scaler times freq, and 8KBS is a 13 bit
> shift away from HZ for SPI)

I think my point wasn't clear. Say the driver is doing mem read/write 
and it needs 10 MBps and the system bus maxes out at 20 MBps.

When the CPU is idling, and isn't using the system bus, it would be 
sufficient for the system bus to run at 10MBps speeds. But when CPU 
starts executing at full speed, it's going to eat up some bandwidth and 
the system bus will have to operate at 15 or 20 MBps speeds.

>> A KHz unit will side step both problems. It's not the most ideal in theory
>> but it's simple and gets the job done since, in our case, there aren't
>> very many fine grained levels of system bus frequencies (and corresponding
>> throughputs).
> 
> I think your getting too wrapped up with this Hz thing and need write a
> couple of shift macros to convert between Kbs and Hz and be happy.

Yes, I could just do this and call it a day. Although, in my opinon, 
it's a misrepresentation of the parameter since we aren't doing a 
summation of the requests.

>> I understand that other architectures might have different practical
>> constraints and abilities and I didn't want to impose the KHz limitation
>> on them. That's the reason I proposed a parameter whose units is defined
>> by the "enforcer".
> 
> The problem is that doing this will result in too many one-off drivers
> that don't port nicely to my architecture when I use the same
> peripheral as you.

Most of the drivers/devices that really need PM QoS and don't degrade 
gracefully are internal to SoCs. I can't think of too many external or 
loosely coupled devices that don't degrade gracefully. Anyway, 
theoritically, your point is valid.

>> Thoughts?
>>
> not really anything additional, other than I wonder why kbs isn't
> working for you.  Perhaps I'm missing something subtle.

I don't think that PM QoS in it's current state can meet all the real 
requirements of bus bandwidth configuration or management. Which is fine 
-- we need to start somewhere. Something like what Kevin mentions or a 
different method would be needed to get this right for the complex 
cases. I too would be very eager to join this discussion in one of the 
conferences (Linux Plumbers?).

My thought was that till that's ready (this has been in discussion for 
_at least_ 8 months) we could go with a PM QoS parameter (preferably 
without units) and switch to the new design when it's available. I would 
be more than glad to switch to the new/future design when it's available.

Did I convince you to allow a unit less parameter? :-)

-Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
