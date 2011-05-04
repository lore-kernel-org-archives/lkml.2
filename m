Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1EDWek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:34:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:46637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1EDWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:34:39 -0400
Date: Thu, 5 May 2011 00:34:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Dave Kleikamp <dkleikamp@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, paulmck@us.ibm.com
Subject: Re: idle issues running sembench on 128 cpus
In-Reply-To: <m2pqnyyva8.fsf@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105050023070.3005@ionos>
References: <4DC1C95B.4040706@gmail.com> <m2pqnyyva8.fsf@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Andi Kleen wrote:
> Dave Kleikamp <dkleikamp@gmail.com> writes:
> > I also don't know if it makes sense to be able to tune the cpuidle
> > governors to add more resistance to enter the C3 state, or even being
> > able to switch to a performance governor at runtime, similar to
> > cpufreq.
> >
> > I'd like to hear your thoughts before I dive any deeper into this.
> 
> It's fixed on Westmere. There the APIC timer will always tick
> and all that logic is not needed anymore and disabled.
> 
> That is mostly fixed. One problem right now is that the
> CLOCK_EVT_FEAT_C3STOP test is inside the lock. But we
> can easily move it out, assuming the clock_event_device
> gets RCU freed or has a reference count.

No, it does not even need refcounting. We can access it outside of the
lock as this is atomic context called on the cpu which is about to go
idle and therefor the device cannot go away. Easy and straightforward
fix.
 
> But yes it would be still good to fix Nehalem too.
> 
> One fix would be to make all the masks hierarchical,
> similar to what RCU does. Perhaps even some code 
> could be shared with RCU on that because it's a very
> similar problem.

In theory. It's not about the mask. The mask is uninteresting. It's
about the expiry time, which we have to protect. There is nothing
hierarchical about that. It all boils down on _ONE_ single functional
device and you don't want to miss out your deadline just because you
decided to be extra clever. RCU does not care much whether you run the
callbacks a tick later on not. Time and timekeeping does.

Thanks,

	tglx
