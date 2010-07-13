Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0GMHuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:50:24 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:44973 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0GMHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:50:23 -0400
Date: Tue, 13 Jul 2010 16:50:20 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: david@lang.hm
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mori.keisuke@oss.ntt.co.jp, Chris Wright <chrisw@redhat.com>,
        Dor Laor <dlaor@redhat.com>, Lon Hohberger <lhh@redhat.com>,
        "Perry N. Myers" <pmyers@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, berrange@redhat.com
Subject: Re: [RFC] High availability in KVM
Message-Id: <20100713165020.5ae64155.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <alpine.DEB.2.00.1007120236500.5188@asgard.lang.hm>
References: <4C199348.6050108@oss.ntt.co.jp>
	<alpine.DEB.2.00.1007101510180.27626@asgard.lang.hm>
	<4C3AB489.4020700@oss.ntt.co.jp>
	<alpine.DEB.2.00.1007120236500.5188@asgard.lang.hm>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 02:49:55 -0700 (PDT)
david@lang.hm wrote:

> On Mon, 12 Jul 2010, Takuya Yoshikawa wrote:
> 

[...]

> > 1: Pacemaker starts Qemu.
> >
> > 2: Pacemaker checks the state of Qemu via RA.
> >   RA checks the state of Qemu using virsh(libvirt).
> >   Qemu replies to RA "RUNNING"(normally executing), (*1)
> >   and RA returns the state to Pacemaker as it's running correctly.
> >
> >  (*1): libvirt defines the following domain states:
> >
> >    enum virDomainState {
> >
> >    VIR_DOMAIN_NOSTATE  = 0 : no state
> >    VIR_DOMAIN_RUNNING  = 1 : the domain is running
> >    VIR_DOMAIN_BLOCKED  = 2 : the domain is blocked on resource
> >    VIR_DOMAIN_PAUSED   = 3 : the domain is paused by user
> >    VIR_DOMAIN_SHUTDOWN = 4 : the domain is being shut down
> >    VIR_DOMAIN_SHUTOFF  = 5 : the domain is shut off
> >    VIR_DOMAIN_CRASHED  = 6 : the domain is crashed
> >
> >    }
> >
> >    We took the most common case RUNNING as an example, but this might be
> >    other states except for failover targets: SHUTOFF and CRASHED ?
> >
> >  --- SOME ERROR HAPPENS ---
> >
> > 3: Pacemaker checks the state of Qemu via RA.
> >   RA checks the state of Qemu using virsh(libvirt).
> >   Qemu replies to RA "SHUTOFF", (*2)
> 
> why would it return 'shutoff' if an error happened instead of 'crashed'?


Yes, it would be 'crashed'.

But 'shutoff' may also be returned I think: it depends on the type of the error
and how KVM/qemu handle it.

  I take into my mind not only hardware errors but virtualization specific
  errors like emulation errors.


> 
> >   and RA returns the state to Pacemaker as it's already stopped.
> >
> >  (*2): Currently we are checking "shut off" answer from domstate command.
> >   Yes, we should care about both SHUTOFF and CRASHED if possible.
> >
> > 4: Pacemaker finally tries to confirm if it can safely start failover by
> >   sending stop command. After killing Qemu, RA replies to Pacemaker
> >   "OK" so that Pacemaker can start failover.
> >
> > Problems: We lose debuggable information of VM such as the contents of
> >   guest memory.
> 
> the OCF interface has start, stop, status (running or not) or an error 
> (plus API info)
> 
> what I would do in this case is have the script notice that it's in 
> crashed status and return an error if it's told to start it. This will 
> cause pacemaker to start the service on another system.


I see.
So the key point is to how to check target, crashed in this case, status.

In the HA's point of view, we need that qemu guarantees:
 - Guest never start again
 - VM never modify external resources

But I'm not so sure if qemu currently guarantees such conditions in generic
manner.



Generically I agree that we always start the guest in another node for
failover.  But are there any benefits if we can start the guest in the
same node?


> 
> if it's told to stop it, do whatever you can to save state, but definantly 
> pause/freeze the instance and return 'stopped'
> 
> 
> 
> no need to define some additional state. As far as pacemaker is concerned 
> it's safe as long as there is no chance of it changing the state of any 
> shared resources that the other system would use, so simply pausing the 
> instance will make it safe. It will be interesting when someone wants to 
> investigate what's going on inside the instance (you need to have it be 
> functional, but not able to use the network or any shared 
> drives/filesystems), but I don't believe that you can get that right in a 
> generic manner, the details of what will cause grief and what won't will 
> vary from site to site.


If we cannot say in a generic manner, we usually choose the most conservative
one: memory and ... perservation only.

What we concern the most is qemu actually guarantees the conditions we are
talking in this thread.



> 
> 
> > B. Our proposal: "introduce a new domain state to indicate failover-safe"
> >
> >   Pacemaker...(OCF)....RA...(libvirt)...Qemu
> >       |                 |                 |
> >       |                 |                 |
> > 1:     +---- start ----->+---------------->+ state=RUNNING
> >       |                 |                 |
> >       +---- monitor --->+---- domstate -->+
> > 2:     |                 |                 |
> >       +<---- "OK" ------+<--- "RUNNING" --+
> >       |                 |                 |
> >       |                 |                 |
> >       |                 |                 * Error: state=FROZEN
> >       |                 |                 |   Qemu releases resources
> >       |                 |                 |   and VM gets frozen. (*3)
> >       +---- monitor --->+---- domstate -->+
> > 3:     |                 |                 |
> >       +<-- "STOPPED" ---+<--- "FROZEN" ---+
> >       |                 |                 |
> >       +---- stop ------>+---- domstate -->+
> > 4:     |                 |                 |
> >       +<---- "OK" ------+<--- "FROZEN" ---+
> >       |                 |                 |
> >       |                 |                 |
> >
> >
> > 1: Pacemaker starts Qemu.
> >
> > 2: Pacemaker checks the state of Qemu via RA.
> >   RA checks the state of Qemu using virsh(libvirt).
> >   Qemu replies to RA "RUNNING"(normally executing), (*1)
> >   and RA returns the state to Pacemaker as it's running correctly.
> >
> >   --- SOME ERROR HAPPENS ---
> >
> > 3: Pacemaker checks the state of Qemu via RA.
> >   RA checks the state of Qemu using virsh(libvirt).
> >   Qemu replies to RA "FROZEN"(VM stopped in a failover-safe state), (*3)
> >   and RA keeps it in mind, then replies to Pacemaker "STOPPED".
> >
> >  (*3): this is what we want to introduce as a new state. Failover-safe means
> >    that Qemu released the external resources, including some namespaces, to 
> > be
> >    available from another instance.
> 
> it doesn't need to release the resources. It just needs to not be able to 
> modify them.
> 
> pacemaker on the host won't try to start another instance on the same 
> host, it will try to start an instance on another host. so you don't need 
> to worry about releaseing memory, file locks, etc locally. for remote 
> resources you _can't_ release them gracefully if you crash, so your apps 
> already need to be able to handle that situation. there's no difference to 
> the other instances between a machine that gets powered off via STONITH 
> and a virtual system that gets paused.


Can't pacemaker start another instance on the same host by configuration?
Of course I agree that it may not be valuable in most situations.


  Takuya



