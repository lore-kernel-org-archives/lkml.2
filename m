Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1AQPWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:22:44 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52967 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1AQPWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:22:42 -0500
Date: Mon, 17 Jan 2011 20:52:22 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        suzuki@in.ibm.com
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
Message-ID: <20110117152222.GA19233@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 01:08:44PM -0800, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Maintain a flag in both LSBs of the ticket lock which indicates whether
> anyone is in the lock slowpath and may need kicking when the current
> holder unlocks.  The flags are set when the first locker enters
> the slowpath, and cleared when unlocking to an empty queue.
> 
> In the specific implementation of lock_spinning(), make sure to set
> the slowpath flags on the lock just before blocking.  We must do
> this before the last-chance pickup test to prevent a deadlock
> with the unlocker:
> 
> Unlocker			Locker
> 				test for lock pickup
> 					-> fail
> test slowpath + unlock
> 	-> false
> 				set slowpath flags
> 				block
> 
> Whereas this works in any ordering:
> 
> Unlocker			Locker
> 				set slowpath flags
> 				test for lock pickup
> 					-> fail
> 				block
> test slowpath + unlock
> 	-> true, kick

I think this is still racy ..

Unlocker				Locker

				
test slowpath
	-> false
		
				set slowpath flag
				test for lock pickup
					-> fail
				block


unlock

unlock needs to happen first before testing slowpath? I have made that change
for my KVM guest and it seems to be working well with that change .. Will
cleanup and post my patches shortly

- vatsa
