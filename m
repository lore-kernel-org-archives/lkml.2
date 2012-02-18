Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2BRTL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 14:11:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52246 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2BRTLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 14:11:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 20:11:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] firewire: core: fix race at address_handler
 unregistration
Message-ID: <20120218201139.38f03f4b@stein>
In-Reply-To: <20120218195445.564114ea@stein>
References: <20120218195339.13d36f44@stein>
	<20120218195445.564114ea@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18 Stefan Richter wrote:
> Fix the following unlikely but possible race:
> 
> CPU 1                             CPU 2
> ------------------------------------------------------------------------
> AR-request tasklet
>     lookup handler
>                                   unregister handler
> 				  free handler->callback_data or handler
>     call handler->callback
> 
> The application which registered the handler has no way to stop nodes
> sending new requests to their address range, hence cannot prevent this
> race.
> 
> Fix it simply by extending the address_handler_lock-protected region
> from only around the lookup to around both lookup and call.  We only
> need to do so in the exclusive region handler; the FCP region handler
> already holds the lock around the handler->callback call.
> 
> Alas this removes the current ability to execute the callback in
> parallel on different CPUs if it was called for different FireWire cards
> at the same time.  (For a single card, the handler is already
> serialized.)  If this loss of a rather obscure feature is not tolerable,
> a more complex fix would be required:  Add a handler reference counter;
> wait in fw_core_remove_address_handler() for this conter to become zero.

Oh, and the other downside is that the region in which local IRQs are
disabled is extended.  So I guess I should at least the core, maybe also
the application layer drivers, to spin_lock_bh instead, sooner than later.
-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
