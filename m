Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0LMEJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:09:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57982 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753235Ab0LMEJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:09:20 -0500
Date: Sun, 12 Dec 2010 23:09:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH 4/4] PM: Permit registrarion of parentless devices
 during system suspend
In-Reply-To: <201012130133.52072.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012122253120.4379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The registration of a new parentless device during system suspend
> will not lead to any complications affecting the PM core (the device
> will be effectively seen after the subsequent resume has completed),
> so remove the code used for detection of such events.

Actually the tests you're changing were never as strong as they should
have been.  Drivers are supposed to avoid registering new children
beneath a device as soon as the device has gone through the "prepare"
stage, not just after the device is suspended.  Should there be a 
"prepared" bitflag to help implement this stronger test?

In principle the same idea applies to parentless devices, since they
can be considered children of the "system device" (a fictitious node at
the root of the device tree).  The "system" goes into the prepared
state before all the real devices; that's what the transition_started
variable was all about.  It's nothing more than the "prepared" bitflag
for the "system device".

I guess it's okay to be lenient and not check for this.  But should we
then change the documentation to match?  (Note that the warning won't
be triggered if a new child is registered _as_ the parent is
suspending.  Not to mention the possibilities for mischief when devices
are suspended asynchronously.  But as you say, these complications
don't affect the PM core.)

Alan Stern

