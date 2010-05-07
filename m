Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0EGPUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:20:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58842 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755343Ab0EGPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:20:20 -0400
Date: Fri, 7 May 2010 11:20:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Alek" <alek.du@intel.com>
cc: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
In-Reply-To: <20100507093200.28ecd63c@dxy2>
Message-ID: <Pine.LNX.4.44L0.1005071106570.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Du, Alek wrote:

> Alan,
> 
> As I tested, with the second patch, after entering phy low power mode, the port cannot detect any USB devices that plugged in.

Ooh, that's not good.  It almost violates the EHCI spec (see the last
line on p.60 in table 4.4).

> I also confirm that after set PHCD flag, any write to PORTSC is illegal. (I have another patch will send out soon named "Clear PHCD before resuming",
> but the patch is not related with this one) 

I'm afraid we are going to have to modify the wakeup bits in PORTSC
after PHCD is set.  Can we clear PHCD, modify PORTSC, and then set PHCD
again?

> So it seems wakeup bits must set before set PHCD. So we may revise the flowchart a little bit, for example, if the HCD has hostpc,
> then set the wakeup bits like before, if the HCD is the normal one, then go your new way?

For normal HCDs, the wakeup bits don't matter when the controller is in
D0.  Therefore we can continue to set them as before during bus or port
suspend.

But during controller suspend, if the controller isn't supposed to be
remote-wakeup-enabled then we will need to clear the wakeup bits
(and set them again during controller resume).  Will that work?

Alan Stern

