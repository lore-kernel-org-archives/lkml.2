Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0IBOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:09:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57311 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0IBOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=SmPaWylwr61sFv8rmt/DMXqxMeBsz5tzLo6+l6IgtzI8NvAYoSqpLz5Yy7he07WLSo
         HEcDpbShSh4TxJb6Fwrqxt9ejD+WxV4NfPgZ1+hwBS9xi8DjJCYbNio8kfrfQs2CL8uG
         BbLIY/u/U626HI6AfHfo9j5XQ2teJYZLbnO/4=
Date: Thu, 2 Sep 2010 07:09:22 -0700
From: mark gross <markgross@thegnar.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: markgross@thegnar.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100902140922.GB2818@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100827064153.GB3414@gvim.org>
 <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
 <20100828020540.GB8341@gvim.org>
 <4C787AA9.4090906@codeaurora.org>
 <20100828225255.GA12402@gvim.org>
 <878w3o3p55.fsf@deeprootsystems.com>
 <20100831184030.GB9305@gvim.org>
 <4C7D844C.5050403@codeaurora.org>
 <20100901142804.GA13985@gvim.org>
 <4C7F1BF2.4050200@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7F1BF2.4050200@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 08:37:22PM -0700, Saravana Kannan wrote:
> mark gross wrote:
> >On Tue, Aug 31, 2010 at 03:38:04PM -0700, Saravana Kannan wrote:
> >>mark gross wrote:
> >>>On Mon, Aug 30, 2010 at 11:56:54AM -0700, Kevin Hilman
> >>>>>>Any specific reason PM QoS doesn't support a "summation" "comparitor"?
> >>>>>PM_QoS could do a summation, but keep in mind it pm_qos not qos.  pm_qos
> >>>>>is a best effort thing to constrain power management throttling, not
> >>>>>provide a true quality of service or deadline scheduling support.
> >>>>For me (and I think Saravana too), this is still all about power, but
> >>>>it's closely tied to QoS.
> >>Kevin, Thanks for explaining exactly what I had in mind. I was
> >>caught up with other work and was glad to see this discussion moved
> >>forward.
> >>
> >>I pretty much agree with all of Kevin's statements, so here is a
> >>preemptive "I agree" to all this paragraphs.
> >>
> >>>Now I get it!  For throughput we need to do a sum.  Ok, we need sum
> >>>comparator/performance aggregaters too!
> >>Yay! Finally one of my pet peeves with PM QoS is being resolved(?).
> >
> >yes, we need to add a summation aggregater to the pm_qos logic and
> >likely apply it to all the throughput pm_qos parameters.  You where
> >right about that point.  (but I'm not budging on the unit less
> >parameters)
> 
> Yeah, I gave up on the unit less parameter.
> 
> >>>Do we also need to figure out the max throughput and warn if the pm_qos
> >>>requests are going over?  I suppose the network stack could register
> >>>each device with a max bus bandwidth and pm_qos could warn on exceeding
> >>>the hardware throughput.
> >>In my opinion, here is where the "best effort" part, if any, comes
> >>in. PM QoS could do it's best to meet the QoS while keeping power
> >>low, but if the h/w can't support it, we let it run at highest
> >>performance and call it "best effort".
> >
> >so we don't need to warn if the aggregate qos request exceeds the
> >capability of the hardware then.
> 
> That should work for now. If we see a strong reason for notifying
> QoS failures we could add it in the future.
> 
> >>>>This decision is both QoS and PM related.  Without summation, the 'max'
> >>>>request is still 10Mb/s so you would keep the lower power state.  But
> >>>>you also know that none of the clients will get their requested rate.
> >>>>
> >>>>There's some gray area here since there is a choice.  Was the point
> >>>>of the request to keep the NIC at the *power-state* needed for 10Mb/s (a
> >>>>PM request) or was the request saying the app wanted at least 10Mb/s (a
> >>>>QoS request.)
> >>>I need to think on this a bit.  You are correct, and it looks like we
> >>>could use both types of interfaces.
> >>I'm not sure having both interfaces would work. Should a single
> >>client be allowed to keep the *power state* to what's needed for
> >>10Mb/s? What happens if another client votes with "I need at least
> >>20Mb/s"?
> >
> >I need to think some more on this buy its looking like for throughput
> >we may only want one type of interface because, as you say,  it will be
> >hard to reconcile one against the other.
> >
> >>I think the "limit max power-state to X" should be a specific to
> >>each PM QoS parameter (not its clients) similar to how
> >>scaling_max_freq works for CPU freq and is not set by each client
> >>(process - it uses the CPU).
> >
> >yes.  However; it follows the units of the pm_qos parameter abstraction
> >more than anything else.
> 
> Not sure I understand this line.

I think the choice of units in the abstraction mostly defines what type
of aggregation should be use, {min, max, sum}.
> >>So, will be be adding a system bus thruput parameter? Is it going to
> >>have min comparator for now?
> >
> >a summation aggregater, with units of KBS.
> 
> Ok. Who is going to add the summation "comparator"? I can write a
> patch for the system bus thruput parameter.

I'll do a patch by monday as an RFC but, I'm wondering if we want it in
the main line vrs an implementation that scales by bus integrated into
the driver model per what Kevin has been talking about....

--mgross

