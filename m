Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2ESKaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:30:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57513 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab2ESKaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:30:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 19 May 2012 12:29:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire-sbp2: Initialise sbp2_orb->rcode for
 management ORBs
Message-ID: <20120519122949.0024a909@stein>
In-Reply-To: <20120304134802.2ed6fbd6@stein>
References: <1329600949-55157-1-git-send-email-bootc@bootc.net>
	<20120304134802.2ed6fbd6@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 04 Stefan Richter wrote:
> On Feb 18 Chris Boot wrote:
> > When sending ORBs the struct sbp2_orb->rcode field should be initialised
> > to -1 otherwise complete_transaction() assumes the request is successful
> > (RCODE_COMPLETE is 0). When sending managament ORBs, such as LOGIN or
> > LOGOUT, this was not done and so the initiator would wait for the
> > request to time out before trying again.
> > 
> > Without this, LOGINs are only retried when the management ORB times out,
> > rather than the initiator noticing an error occurred and retrying soon
> > after. For targets that advertise more than one LUN per unit, and can
> > only accept one management request at a time, this means LUNs are only
> > logged in one per timeout period.
[...]
> I left this hanging in my inbox for too long, sorry...
> 
> While I agree that the current initialization of orb->base.rcode with 0 is
> wrong, I don't think your change alone is sufficient:
> 
> Consider the case that a login request to LU 0 causes the target to pull
> out the hardware behind that LU out of a powered-down state --- which may
> take a very long time --- and login requests to LU 1 would be aborted by
> the target with resp_conflict_error on any Management_Agent write
> request.  Of course a reasonably clever target would accept login before
> full power-up, but you never now.
> 
> We retry login 5 times in 0.2 seconds intervals, and this 1 s in total may
> not be enough.
[...]

Chris, I obviously haven't done anything about this potentially too short
retry period yet; it is still on my list.

Perhaps we should not count the number of retries but watch the time that
retries take.  I.e. accumulate the time that each try takes; break out of
the retry loop after a maximum time; but reset the accumulated time at a
bus reset as a precaution for buses with many nodes coming online at
different times.
-- 
Stefan Richter
-=====-===-- -=-= =--==
http://arcgraph.de/sr/
