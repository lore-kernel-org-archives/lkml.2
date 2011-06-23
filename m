Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab1FWVC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:02:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759892Ab1FWVC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:02:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support for generic domains (v3)
Date: Thu, 23 Jun 2011 23:03:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <Pine.LNX.4.44L0.1106231421470.2033-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106231421470.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106232303.38321.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 23, 2011, Alan Stern wrote:
> On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > It should say "system suspend" rather than "system sleep".
> > 
> > It says "system sleep" to distinguish between the state of the system
> > ("system sleep") and the operation leading to that state ("system suspend").
> > That terminology is used all over the document, so I don't think it's a good
> > idea to change it just for this specific paragraph.
> > 
> > I agree that "suspend" should be used where it talks about starting, stopping
> > etc.
> > 
> > > Then to drive the point home, the following sentence chould say 
> > > something like this:
> > > 
> > > If that is the case and none of the situations listed above takes place
> > > (in particular, if the system is waking up from suspend and not from
> > > hibernation), it may be more efficient to leave the devices that had
> > > been suspended before the system suspend began in the suspended state.
> > 
> > That's fine by me, except that I'd simply say "(in particular, if the system
> > is not waking up from hibernation)".
> 
> Okay.

Cool. :-)

Appended is an updated patch.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Update documentation of interactions with system sleep

The documents describing the interactions between runtime PM and
system sleep generally refer to the model in which the system sleep
state is entered through a global firmware or hardware operation.
As a result, some recommendations given in there are not entirely
suitable for systems in which this is not the case.  Update the
documentation take the existence of those systems into accout.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt    |    6 +++---
 Documentation/power/runtime_pm.txt |   27 +++++++++++++++++++--------
 2 files changed, 22 insertions(+), 11 deletions(-)

Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -537,9 +537,9 @@ suspend routine).  It may be necessary t
 in order to do so.  The same is true if the driver uses different power levels
 or other settings for run-time suspend and system sleep.
 
-During system resume, devices generally should be brought back to full power,
-even if they were suspended before the system sleep began.  There are several
-reasons for this, including:
+During system resume, the simplest approach is to bring all devices back to full
+power, even if they had been suspended before the system suspend began.  There
+are several reasons for this, including:
 
   * The device might need to switch power levels, wake-up settings, etc.
 
@@ -556,16 +556,27 @@ reasons for this, including:
   * Even though the device was suspended, if its usage counter was > 0 then most
     likely it would need a run-time resume in the near future anyway.
 
-  * Always going back to full power is simplest.
-
-If the device was suspended before the sleep began, then its run-time PM status
-will have to be updated to reflect the actual post-system sleep status.  The way
-to do this is:
+If the device had been suspended before the system suspend began and it's
+brought back to full power during resume, then its run-time PM status will have
+to be updated to reflect the actual post-system sleep status.  The way to do
+this is:
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+On some systems, however, system sleep is not entered through a global firmware
+or hardware operation.  Instead, all hardware components are put into low-power
+states directly by the kernel in a coordinated way.  Then, the system sleep
+state effectively follows from the states the hardware components end up in
+and the system is woken up from that state by a hardware interrupt or a similar
+mechanism entirely under the kernel's control.  As a result, the kernel never
+gives control away and the states of all devices during resume are precisely
+known to it.  If that is the case and none of the situations listed above takes
+place (in particular, if the system is not waking up from hibernation), it may
+be more efficient to leave the devices that had been suspended before the system
+suspend began in the suspended state.
+
 7. Generic subsystem callbacks
 
 Subsystems may wish to conserve code space by using the set of generic power
Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -604,7 +604,7 @@ state temporarily, for example so that i
 disabled.  This all depends on the hardware and the design of the subsystem and
 device driver in question.
 
-During system-wide resume from a sleep state it's best to put devices into the
-full-power state, as explained in Documentation/power/runtime_pm.txt.  Refer to
-that document for more information regarding this particular issue as well as
+During system-wide resume from a sleep state it's easiest to put devices into
+the full-power state, as explained in Documentation/power/runtime_pm.txt.  Refer
+to that document for more information regarding this particular issue as well as
 for information on the device runtime power management framework in general.
