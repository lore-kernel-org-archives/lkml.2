Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1DZSYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:24:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57711 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab1DZSYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:24:18 -0400
Date: Tue, 26 Apr 2011 08:55:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RCU+KVM: making CPU guest mode a quiescent state.
Message-ID: <20110426155528.GD2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110426123824.GD22443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426123824.GD22443@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:38:24PM +0300, Gleb Natapov wrote:
> Hello Paul,
> 
> I have a question about RCU + KVM. KVM does not hold any references to RCU
> protected data when it switches CPU into a guest mode. In fact switching
> to a guest mode is very similar to exiting to userspase from RCU point
> of view. In addition CPU may stay in a guest mode for quite a long time
> (up to one time slice). It looks like it will be beneficial to treat guest
> mode as quiescent state, just like user-mode execution. How can this be
> done? I was trying to find how RCU knows about cpu entering user-mode,
> but it seems that it does this by checking CPU mode in a timer interrupt
> (update_process_times()->rcu_check_callbacks()). This will not work for
> guest mode detection since timer interrupt will kick CPU out of a guest
> mode and timer interrupt will always see CPU in kernel mode. Do we have
> a simple function to call to notify RCU that CPU passed quiescent state
> which we can call just before entering guest?

Hello, Gleb,

You could call rcu_note_context_switch(), passing it the current
CPU.  Please note that preemption -must- be disabled when calling
this.  You could call this just after exiting the guest as well
as just before entering guest.

Longer term, it might be interesting to try Frederic Weisbecker's
patch, which disables scheduling-clock interrupts while in user
mode if there is only one runnable task on the CPU in question.

							Thanx, Paul
