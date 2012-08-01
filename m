Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2HAXcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:32:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:16768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2HAXcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:32:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="174349581"
Date: Wed, 1 Aug 2012 16:32:15 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Alexis R. Cortes" <alexis.cortes@ti.com>
Cc: "'Peter Stuge'" <peter@stuge.se>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        brian.quach@ti.com, jorge.llamas@ti.com
Subject: Re: [PATCH] usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP
 Hardware
Message-ID: <20120801233215.GD7564@xanatos>
References: <50197DC2.5060905@ti.com>
 <20120801200131.15606.qmail@stuge.se>
 <20120801211840.GC7564@xanatos>
 <007b01cd702f$1b5e4870$521ad950$@cortes@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007b01cd702f$1b5e4870$521ad950$@cortes@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:46:27PM -0500, Alexis R. Cortes wrote:
> Hi Sarah,
> 
> Sure!! I'll update the patch's description and will send another patch in a
> few moments.
> 
> As an additional comment, I ran the 'checkpatch.pl' script and verified
> there were no errors before submitting the patch. I only got a few Warnings
> related to the line limits. 

Can you break the code up a bit so the line limit warnings don't appear?
The long line warnings are really indicative of a deeper problem,
usually that the parent function has gotten much too long, and should be
broken into smaller functions.

The only exception to the long line rule (and one that checkpatch
doesn't usually complain about) is that we don't break up lines in the
middle of strings.  It makes searching for the strings later much
harder.  So either leave the really long string line, or break it up
into two xhci_dbg statements.

In general, warnings from checkpatch.pl stop my patch application and
submission work flow, so I don't accept patches with warnings.

For instance:

			if (xhci->quirks & XHCI_COMP_MODE_QUIRK) {
				if (xhci->port_status_u0 != ((1 << xhci->num_usb3_ports)-1)) {
					if ((temp & PORT_PLS_MASK) == XDEV_U0) {
						xhci->port_status_u0 |= 1 << wIndex;
						if (xhci->port_status_u0 == ((1 << xhci->num_usb3_ports)-1)) {
							del_timer_sync(&xhci->comp_mode_recovery_timer);
							xhci_dbg(xhci, "Compliance Mode Recovery Timer Deleted. "
                                                                       "All USB3 ports have entered U0 at least once.\n");
                                               }
                                       }
                               }
                       }

Could be broken out into a new function, like so:

void xhci_del_comp_mod_timer(struct xhci_hcd *xhci)
{
	unsigned int all_ports_seen_u0 = ((1 << xhci->num_usb3_ports)-1));
	boolean this_port_in_u0 = ((temp & PORT_PLS_MASK) == XDEV_U0);

	if (!(xhci->quirks & XHCI_COMP_MODE_QUIRK))
		return;

	if (xhci->port_status_u0 != all_ports_seen_u0 && this_port_in_u0) {
		xhci->port_status_u0 |= 1 << wIndex;
		if (xhci->port_status_u0 == all_ports_seen_u0) {
			del_timer_sync(&xhci->comp_mode_recovery_timer);
			xhci_dbg(xhci, "All USB3 ports have entered U0 at least once.\n");
			xhci_dbg(xhci, "Compliance Mode Recovery Timer Deleted.\n");
		}
	}
}

Then you can call that new function in the ugly long indent-heavy function
in xhci-hub.c.

Sarah Sharp
