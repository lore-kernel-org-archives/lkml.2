Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1B1PlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:41:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:11932 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab1B1PlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,240,1297065600"; 
   d="scan'208";a="662182671"
Date: Mon, 28 Feb 2011 15:19:43 +0000
From: Alan Cox <alan@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] USB: serial/keyspan_pda, fix potential tty NULL
 dereferences
Message-ID: <20110228151943.140546a5@bob.linux.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1102281006560.2161-100000@iolanthe.rowland.org>
References: <1298885646-9293-1-git-send-email-jslaby@suse.cz>
	<Pine.LNX.4.44L0.1102281006560.2161-100000@iolanthe.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder about these changes.  Does it makes sense to add this
> checking everywhere?  A more reasonable approach might be to make
> sure that tty_port_tty_get is never called in a context where it
> could return NULL.  Or would that involve just as much effort, making
> work routines and so on check to see whether there's an open TTY
> device before doing anything else?

The tty is refcounted so it can go away at any time including on
another processor parallel to an IRQ happening.

The right way to fix it longer term is to get every tty to be using a
tty_port (which is something we are close to) and then stuff all the
physical device related properties into the tty_port so most rx paths
simply don't dereference the tty struct.

At that point the lifetime of the relevant objects is the lifetime of
the physical port which means the driver can do

	ref count = 0
		disable interrupts
		free physical port representation & associated tty_port

the locking and tty struct use on most of the irq paths can go away for
most situations (still needed for some cases like SYSRQ).

Unfortunately there is quite a lot to move including the tty buffers,
various bits of flow control, wait queues and the like. Possibly even
the termios data.

At that point we'd only need a tty reference when we actually did the
ldisc processing or in exceptional situations.

Alan
