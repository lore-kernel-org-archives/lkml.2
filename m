Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2BLONX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:13:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34174 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab2BLONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:13:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Feb 2012 15:12:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [RFC][PATCH 00/13] firewire-sbp-target: FireWire SBP-2 SCSI
 target
Message-ID: <20120212151247.3d33d45b@stein>
In-Reply-To: <1328989452-20921-1-git-send-email-bootc@bootc.net>
References: <4E4BD560.4010806@bootc.net>
	<1328989452-20921-1-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11 Chris Boot wrote:
> Well after lots of work I have a working and generally (at least I think)
> sensible starting point for the FireWire target. It appears to work fine in all
> the configurations I've tested it against, including Linux and Mac OS X
> initiators.

I only very quickly scrolled through your patches yet.  Looks all very
readable and well laid out.  Some random thoughts:

Some of the smaller source files could certainly be merged with other
ones without loss of readability.

Some comments about what the code is doing can be removed since the
function names are very well readable on their own.  Example:
+	/* read the peer's GUID */
+	ret = read_peer_guid(&guid, req);

The APIs which you include from "../../firewire/core.h" should eventually
be moved to <linux/firewire.h>.  I think it does not matter whether this
is done before or after mainline merge.  When we do so we should check
whether the affected APIs can be improved for usage in drivers.

Many of the printks should surely be demoted to debug messages with
runtime on-and-off switch.

There are list traversals and list manipulations that make an impression
as if they wanted to be mutex- or lock-protected, but I haven't looked yet
in which contexts these accesses happen.

sbp_proto.c:
+/*
+ * Handlers for Serial Attached SCSI (SBP)
+ */
                 ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ Serial Bus Protocol
Though this is also readily apparent from the top comment in the file.

The four EXPORT_SYMBOLs in sbp_proto.c can be removed, it seems.

sbp_login.c:
+			pr_notice("initiator already logged-in\n");
+
+			/*
+			 * SBP-2 R4 says we should return access denied, but
+			 * that can confuse initiators. Instead we need to
+			 * treat this like a reconnect, but send the login
+			 * response block like a fresh login.
+			 */
Are there initiators which don't bother with reconnect but send relogin
straight away?

Kconfig:
"default n" is redundant.
"*older* Apple computers":  They are still manufactured with this feature.
-- 
Stefan Richter
-=====-===-- --=- -==--
http://arcgraph.de/sr/
