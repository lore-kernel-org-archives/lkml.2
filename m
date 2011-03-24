Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab1CXUeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab1CXUeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:34:18 -0400
Date: Thu, 24 Mar 2011 17:32:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH RFC 0/2] Hardware Anomaly Report Mechanism (HARM)
Message-ID: <20110324173259.64a30b0b@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those RFC patches are meant to match the target of unifying the several 
hardware event mechanisms found on Linux Kernel into one. Specifically, 
they are meant to write a replacement mechanism to report the errors 
covered by both EDAC and MCE log event mechanisms into an unified way
via the perf/trace subsystem.

It is the first concrete result of the EDAC/MCE mini-summit and the 
Hardware Error report BoF that happened during LPC/2010.

For now, only the EDAC traces were mapped, as a proof of concept. If 
this way is OK, Tony should start working on MCE part, for Intel 
devices. 

AMD MCE driver is already reporting MCE errors as events, but it is just 
replicating the way mcelog does. So, I think we'll need further 
discussions in order to migrate the trace events into something more
palatable to the end users (e. g. decoding the error events inside
the kernel).

As a general rule, all events provide a log like:

mce#0: Corrected Error <foo> at label "bar" (some tech info)

The information before the parenthesis specify the type of the error and 
the silk screen label of the affected device (like "DIMM 1"). So, for
the system admin to recover a machine that have too many errors, all
he needs to do is to replace DIMM 1.

The information inside parenthesis are the ones that have meaning to the 
OEM provider (grain, syndrome, row, channel, etc).

TODO:

- Use the same mechanism for MCE;

- Have some userspace daemon to collect those events and distribute to
  syslog, remote consoles, network management systems, etc;

- Have persistence to avoid loosing events between the start of collect
  and the start of something monitoring them.

Those patches compile fine, but I was not able to test the event collect
on the second patch, as I'm currently having some troubles to inject
 errors on my hardware, probably due to a BIOS upgrade. I'm currently
 working on it, so I'll post a version 2 if needed, after testing it.

It makes sense to apply the first patch as soon as possible and send it
upstream, as it just moves some EDAC structures to include/linux/edac.h,
where they could be used also by the HARM mechanism. There's no functional
changes on it, and not applying would mean the need of rebase it if
some change happens at EDAC MCI structures.

Mauro Carvalho Chehab (2):
  edac: Move edac main structs to include/linux/edac.h
  events/hw_event: Create a Hardware Anomaly Report Mecanism (HARM)

 drivers/edac/edac_core.h        |  354 +--------------------------------------
 drivers/edac/edac_mc.c          |   32 ++++
 include/linux/edac.h            |  354 +++++++++++++++++++++++++++++++++++++++
 include/trace/events/hw_event.h |  322 +++++++++++++++++++++++++++++++++++
 4 files changed, 709 insertions(+), 353 deletions(-)
 create mode 100644 include/trace/events/hw_event.h

