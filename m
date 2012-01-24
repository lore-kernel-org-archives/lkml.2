Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2AXEZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 23:25:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:48621 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab2AXEZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 23:25:51 -0500
Message-ID: <1327379147.19850.29.camel@pasglop>
Subject: Probing unconfigured PCI bridge resouces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 24 Jan 2012 15:25:47 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

I was digging around chasing a different problem when I stumbled upon
this, I may be missing something but it still feels odd...

So from what I can tell, the only way that we set the flag for the 3
bridge resources of a P2P bridge (IORESOURCE_IO, IORESOURCE_MEM etc...)
is via pci_read_bridge_bases().

This will in turn only set those flags if the resource has a positive
size (limit >= start) ie. it wasn't closed by the firmware.

However what does that leave us in case where we either want to ignore
the firmware (reconfigure everything, which we do on various embedded
platforms) or if the bridge is plain uninitialized and happen to comes
up with closed resources ?

>From what I can tell, we don't set these, which means that we won't
either try to reallocate or reassign those windows later in the resource
assignment code. IE the code in setup-bus.c will use
find_free_bus_resource() which only works if the type has been set...

Or am I missing some important fact here ?

I suspect what's saved us so far on some of those embedded platforms is
that uninitialized bridges tend to come up "open" with a tiny window
0...2M (for memory, I think it's 4K for IO)... but I can see problems (I
had code to specifically re-open some windows on some Apple machines in
the past, which I think we lost over time and might need to be brought
back for example).

Cheers,
Ben.


