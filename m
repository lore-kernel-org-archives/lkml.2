Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2BPOND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:13:03 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52020 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2BPONB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:13:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 16 Feb 2012 15:12:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 07/11] firewire-sbp-target: add
 sbp_management_agent.{c,h}
Message-ID: <20120216151219.151c2339@stein>
In-Reply-To: <4F3CDA54.3030905@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-8-git-send-email-bootc@bootc.net>
	<20120215204836.063bbd36@stein>
	<4F3CDA54.3030905@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16 Chris Boot wrote:
> Reading about mutexes though I see I can't use them from interrupt 
> context, but doesn't the FireWire address handler execute in interrupt 
> context? I have to check the state of the management agent in the 
> address handler to properly reject requests from the initiator when the 
> agent is busy. I guess a spinlock is called for in this situation, 
> possibly using spin_trylock() in the address handler to avoid blocking?

Yes; the request-receive callback (address handler) is executed in tasklet
context.  All drivers which use this currently use the spin_lock_irqsave
API variant.  I am considering to change the entire subsystem to use
spin_lock_bh only.  IMO you could use spin_lock_bh in your target code, or
spin_lock for locks which are _only_ ever taken in tasklet context.

Plain spin_lock cannot be used, neither in the address handler nor in any
process context which grabs the same lock as the address handler.

The use cases for trylock variants of the locking APIs are somewhat
special.  If in doubt, ignore that trylock APIs exist.

In strict terms, spin_trylock avoids busy-waiting for a contended lock.
mutex_trylock avoids blocking in the sense of sleeping wait for a contended
mutex.  However, to expand on the obvious, the trylock variants are only
useful if whatever action which was meant to be performed can be aborted
without problem, e.g. if upper layers would be able to retry at some later
occasion.

(I am still interested in closer looks at the execution contexts and object
lifetime rules in your code, but spare time vs. mental capacity seem
regularly at odds...)
-- 
Stefan Richter
-=====-===-- --=- =----
http://arcgraph.de/sr/
