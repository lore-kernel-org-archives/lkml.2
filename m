Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2BUWaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:30:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2BUWad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:30:33 -0500
Date: Tue, 21 Feb 2012 23:30:25 +0100
From: Holger Macht <holger@homac.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
Message-ID: <20120221223025.GA12989@homac.suse.de>
References: <20120217230107.GA12929@homac.suse.de>
 <alpine.LSU.2.00.1202171541040.3155@eggly.anvils>
 <20120218111419.GA2488@homac.suse.de>
 <CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com>
 <20120218132610.GA15265@homac.suse.de>
 <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com>
 <20120218140449.GA2558@homac.suse.de>
 <alpine.LSU.2.00.1202181034380.3512@eggly.anvils>
 <20120218195722.GA2590@homac.suse.de>
 <4F441998.5080600@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F441998.5080600@garzik.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21. Feb - 17:24:24, Jeff Garzik wrote:
> On 02/18/2012 02:57 PM, Holger Macht wrote:
> >On Sa 18. Feb - 10:46:04, Hugh Dickins wrote:
> >>On Sat, 18 Feb 2012, Holger Macht wrote:
> >>>How about that one?
> >>
> >>It's more broken than that.  Here's my attempt.  It boots on the
> >>systems with dock_station_count 0, and it boots on my laptop with
> >>dock_station_count 2; but I don't actually have any docking station,
> >>so it still doesn't test very much (dock is 0 after the loop).
> >
> >Well, there doesn't have to actually exist a physical dock station (or
> >bay device) for dock_station_count to be>  0. It just tells that the
> >ACPI objects are present and thus the system is capable of it.
> >
> >So does this function actually also break on your laptop and you're
> >getting the oops there, too?
> >
> >>I have no idea if what goes on in the loop is correct, but it looks
> >>to me as if (as predicted) there's further breakage, that it would
> >>have been writing beyond the end of what it allocated if I did have
> >>a docking station.
> >>
> >>Hugh
> >>
> >>[PATCH] dock: fix bootup oops and other dock_link breakage
> >>
> >>dock_link_device() and dock_unlink_device() should bail out early
> >>to avoid oops on zero-length kmalloc() when dock_station_count is 0.
> >>
> >>But isn't there an off-by-one in that kmalloc() length anyway?
> >>An extra NULL appended at the end suggests so.
> >>
> >>Rework the ordering with gotos on failure to fix several issues.
> >>
> >>And presumably dock_unlink_device() should be presenting the same
> >>interface as dock_link_device(), with NULL returned when none found.
> >>
> >>Signed-off-by: Hugh Dickins<hughd@google.com>
> >
> >Fine with me.
> 
> So, just to be clear, the preferred patch is Hugh's, and I should
> drop your earlier proposed fix found in this thread?

Correct.

> And what about that warning?

You mean the fix for the compile error when compiling with
CONFIG_ACPI_DOCK=n? Here it is again:

[PATCH] acpi: Fix compiler error when setting CONFIG_ACPI_DOCK=n

When compiling with CONFIG_ACPI_DOCK=n,
is_registered_hotplug_dock_device() needs to be defined

Signed-off-by: Holger Macht <holger@homac.de>
---
 include/acpi/acpi_drivers.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 3c4e381..3319574 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -155,6 +155,10 @@ static inline int register_hotplug_dock_device(acpi_handle handle,
 static inline void unregister_hotplug_dock_device(acpi_handle handle)
 {
 }
+static inline int is_registered_hotplug_dock_device(const struct acpi_dock_ops *ops)
+{
+	return 0;
+}
 static inline struct device **dock_link_device(acpi_handle handle)
 {
 	return NULL;
-- 
1.7.7

