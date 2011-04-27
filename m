Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab1D0WcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:32:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53334 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab1D0WcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:32:13 -0400
Date: Wed, 27 Apr 2011 15:32:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RCU+KVM: making CPU guest mode a quiescent state.
Message-ID: <20110427223209.GW2135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110426123824.GD22443@redhat.com>
 <20110426155528.GD2135@linux.vnet.ibm.com>
 <20110427124141.GM2265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427124141.GM2265@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 03:41:41PM +0300, Gleb Natapov wrote:
> On Tue, Apr 26, 2011 at 08:55:28AM -0700, Paul E. McKenney wrote:
> > On Tue, Apr 26, 2011 at 03:38:24PM +0300, Gleb Natapov wrote:
> > > Hello Paul,
> > > 
> > > I have a question about RCU + KVM. KVM does not hold any references to RCU
> > > protected data when it switches CPU into a guest mode. In fact switching
> > > to a guest mode is very similar to exiting to userspase from RCU point
> > > of view. In addition CPU may stay in a guest mode for quite a long time
> > > (up to one time slice). It looks like it will be beneficial to treat guest
> > > mode as quiescent state, just like user-mode execution. How can this be
> > > done? I was trying to find how RCU knows about cpu entering user-mode,
> > > but it seems that it does this by checking CPU mode in a timer interrupt
> > > (update_process_times()->rcu_check_callbacks()). This will not work for
> > > guest mode detection since timer interrupt will kick CPU out of a guest
> > > mode and timer interrupt will always see CPU in kernel mode. Do we have
> > > a simple function to call to notify RCU that CPU passed quiescent state
> > > which we can call just before entering guest?
> > 
> > Hello, Gleb,
> > 
> > You could call rcu_note_context_switch(), passing it the current
> > CPU.  Please note that preemption -must- be disabled when calling
> > this.  You could call this just after exiting the guest as well
> > as just before entering guest.
> > 
> x86 disable preemption and local interrupts before switching to guest
> mode. Some platforms only disable local interrupts. I assume disabling
> local irqs is as good as disabling preemption for rcu_note_context_switch()
> calling purpose, is this correct?

Yep, disabing hardirqs will suffice.

							Thanx, Paul
