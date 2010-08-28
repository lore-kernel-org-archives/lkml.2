Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0H1WxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 18:53:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64540 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0H1Ww7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 18:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=lw0gDS+VoeZD0JRbfTyrV7E/dkextdmL2iBw8oCYg3HpOReEzZRYpUNrSdHzDAdmXD
         t64Wh93clsyAV8Ldv+w9goshNceShcXOjj/GdlbIZRrGTW7o8QzxdsJSlhLw3OL/D6BT
         24Yp8EXnfHHdHQBBvgfzfNijqOr3vJQ5yIrEI=
Date: Sat, 28 Aug 2010 15:52:55 -0700
From: mark gross <markgross@thegnar.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: markgross@thegnar.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, khilman@deeprootsystems.com
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100828225255.GA12402@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
 <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
 <20100827064153.GB3414@gvim.org>
 <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
 <20100828020540.GB8341@gvim.org>
 <4C787AA9.4090906@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C787AA9.4090906@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 07:55:37PM -0700, Saravana Kannan wrote:
> mark gross wrote:
> >On Fri, Aug 27, 2010 at 01:10:55AM -0700, skannan@codeaurora.org wrote:
> >>Ignoring other details for now, the biggest problem with throughput/KBps
> >>units is that PM QoS can't handle it well in its current state. For KBps
> >>the requests should be added together before it's "enforced". Just picking
> >>the maximum won't work optimally.
> >
> >well then current pm_qos code for network throughput takes the max.
> 
> I don't know how the network throughput is enforced, but if the unit
> is KBps and it's just doing a Max, then I think it's broken. If two
> clients request 50 KBps and your network can go till 200 KBps, you
> would still be requesting 50 KBps when you could have requested 100
> KBps.
> 
> Any specific reason PM QoS doesn't support a "summation" "comparitor"?

PM_QoS could do a summation, but keep in mind it pm_qos not qos.  pm_qos
is a best effort thing to constrain power management throttling, not
provide a true quality of service or deadline scheduling support.

If you stick to the full up quality of service mentality you quickly get
into discussions just like those around memory over commit.  Its really
hard to know when best effort or hard QoS is appropriate.

If you are trying to use pm_qos as a true qos interface then, its
definitely not up to the task.

example:  you have one 100Mb NIC in your box.  With PM QoS you could
have 4 user mode applications requesting 100Mbs PM_Q0S.  In this case
the right thing to do is to constrain the NIC PM to keep it full on and
the PHY going as fast as it can.  But you'll never get 400Mbs out of the
thing.

So far only max and min really have made sense for pm_qos but, if a case
pops up where summation makes more sense for aggregating the pm_qos
requests then I'm open to it.

> >>Another problem with using KBps is that the available throughput is going
> >>to vary depending on the CPU frequency since the CPU running at a higher
> >>freq is going to use more bandwidth/throughput than the same CPU running
> >>at a lower freq.
> >
> >um, if your modem SPI needs a min freq its really saying it needs a min
> >throughput (throughput is just a scaler times freq, and 8KBS is a 13 bit
> >shift away from HZ for SPI)
> 
> I think my point wasn't clear. Say the driver is doing mem
> read/write and it needs 10 MBps and the system bus maxes out at 20
> MBps.
> 
> When the CPU is idling, and isn't using the system bus, it would be
> sufficient for the system bus to run at 10MBps speeds. But when CPU
> starts executing at full speed, it's going to eat up some bandwidth
> and the system bus will have to operate at 15 or 20 MBps speeds.

This is a quality of service problem not a power management problem.
For this the summation is more correct.  I don't think pm_qos will be
the right tool for this problem.

> >>A KHz unit will side step both problems. It's not the most ideal in theory
> >>but it's simple and gets the job done since, in our case, there aren't
> >>very many fine grained levels of system bus frequencies (and corresponding
> >>throughputs).
> >
> >I think your getting too wrapped up with this Hz thing and need write a
> >couple of shift macros to convert between Kbs and Hz and be happy.
> 
> Yes, I could just do this and call it a day. Although, in my opinon,
> it's a misrepresentation of the parameter since we aren't doing a
> summation of the requests.
> 
> >>I understand that other architectures might have different practical
> >>constraints and abilities and I didn't want to impose the KHz limitation
> >>on them. That's the reason I proposed a parameter whose units is defined
> >>by the "enforcer".
> >
> >The problem is that doing this will result in too many one-off drivers
> >that don't port nicely to my architecture when I use the same
> >peripheral as you.
> 
> Most of the drivers/devices that really need PM QoS and don't
> degrade gracefully are internal to SoCs. I can't think of too many
> external or loosely coupled devices that don't degrade gracefully.
> Anyway, theoritically, your point is valid.
> 
> >>Thoughts?
> >>
> >not really anything additional, other than I wonder why kbs isn't
> >working for you.  Perhaps I'm missing something subtle.
> 
> I don't think that PM QoS in it's current state can meet all the
> real requirements of bus bandwidth configuration or management.

I agree with you on this.  The problem I'm reading into your words is a
pretty interesting one, but I don't think pm_qos is the right place to
start.  You seem to be looking for a QoS facility that will either
return an error, or bug, when a QoS request cannot be met and you want
guarantees not best efforts.

pm_qos != QoS

How far would you be willing to take it?  You're example is talking
about shared bus bandwidth, what about CPU cycles, deadline scheduling,
network bw,storage bw, RAM, and god knows what else?

Regardless; I don't see where its a PM problem.

> Which is fine -- we need to start somewhere. Something like what
> Kevin mentions or a different method would be needed to get this
> right for the complex cases. I too would be very eager to join this
> discussion in one of the conferences (Linux Plumbers?).

I think plumbers would be a good place for such a discussion.  As is
this mailing list (or perhaps another if we are not talking about PM.)

I am now wondering if Kevin was thinking QoS or PM in what he was
talking about at the colab summit last spring.

We need to keep these requirements separated and understood WRT what
they are for.  I think there is a need for a separate QoS API and, parts
of this API could even smell a bit like pm_qos.

> My thought was that till that's ready (this has been in discussion
> for _at least_ 8 months) we could go with a PM QoS parameter
> (preferably without units) and switch to the new design when it's
> available. I would be more than glad to switch to the new/future
> design when it's available.
> 
> Did I convince you to allow a unit less parameter? :-)

nope :(

but, this is an interesting problem!  and, there is likely some reuse
that could be had taking from pm_qos.  Heck, you could take pm_qos,
insert a summation aggregater (s/pm_qos/qos  in the source code) and
make the return values for requests exceeding the performance of the bus
or device meaningful, and provide notifications whenever a granted QoS
can no longer be met.

I don't think you are talking about a power management problem at this
point and, perhaps I'm just not seeing it because I'm dense.


Note: I think a qos interface should indeed call into pm_qos where it
makes sense.  But, I don't think its a good idea to overload pm_qos as a
QoS.  (perhaps I picked a bad name with pm_qos)

--mark
