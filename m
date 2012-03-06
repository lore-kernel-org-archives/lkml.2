Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273Ab2CFThf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:37:35 -0500
Received: from sym2.noone.org ([178.63.92.236]:42630 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965259Ab2CFThd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:37:33 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 14:37:33 EST
Date: Tue, 6 Mar 2012 20:30:40 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: ping: drivers/staging/usbip/ abuses task_is_dead/exit_state
Message-ID: <20120306193040.GD21503@distanz.ch>
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
 <20110920124419.GA10759@hallyn.com>
 <20110920134108.GA30749@redhat.com>
 <20110920143920.GA15859@redhat.com>
 <20110920143942.GB15859@redhat.com>
 <20110920151410.GA16569@redhat.com>
 <20110920183810.GA25159@suse.de>
 <20120306173925.GA17551@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306173925.GA17551@redhat.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-06 at 18:39:25 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/20, Greg KH wrote:
> >
> > On Tue, Sep 20, 2011 at 05:14:10PM +0200, Oleg Nesterov wrote:
> > > (add more cc's)
> > >
> > > On 09/20, Oleg Nesterov wrote:
> > > >
> > > > Unfortunately, we can't kill task_is_dead() right now, it has already
> > > > found the users in drivers/staging/, and I bet the usage is wrong.
> > >
> > > It is used by drivers/staging/usbip/
> > >
> > > For what? The code:
> > >
> > > 	if (vdev->ud.tcp_rx && !task_is_dead(vdev->ud.tcp_rx))
> > > 		kthread_stop(vdev->ud.tcp_rx);
> > >
> > > And how task_is_dead() can help? This helper is really "special", it
> > > shouldn't be used anyway. But why do we check ->exit_state? Without
> > > tasklist the check is racy anyway, the task can exit right after the
> > > check.
> > >
> > > And. It is safe to use kthread_stop(t) even if t has already exited.
> > >
> > > OK, this was added by 8547d4cc2b616e4f1dafebe2c673fc986422b506
> > > "Staging: usbip: vhci-hcd: Do not kill already dead RX/TX kthread"
> > >
> > > 	When unbinding a device on the host which was still attached on the
> > > 	client, I got a NULL pointer dereference on the client.
> > >
> > > Where?
> > >
> > > 	This turned out
> > > 	to be due to kthread_stop() being called on an already dead kthread.
> > >
> > > This should work.
> > >
> > > I'm afraid this can only fix the symptom. Probably, the problem is that
> > > we do not have the reference and thus even task_is_dead(t) is not safe.
> > >
> > > This kthread was created by kthread_run(). If it exits, nothing protects
> > > this task_struct.
> > >
> > > In any case, please do not use ->exit_state. It should not be used outside
> > > of exit.c/etc paths, "exit_state != 0" means "exit_notify() was called".
> >
> > Patches to fix this up in this driver are always gladly appreciated :)
> 
> OK, since nobody cares, probably I should make the patch even if I don't
> understand this code at all and can't test the change.
> 
> But, Tobias, may be you can explain what this task_is_dead() check was
> supposed to do?

As mentioned in the commit message, this was needed for me to work
around a NULL pointer dereference I got during unbinding (I only
experienced this behaviour on the nios2 platform though, couldn't
reproduce it on e.g. x86_64).

I wasn't really familiar with the codebase of usbip (and still am not)
but came up with the fix by more or less blindly copying what the
opposite side is checking for in stub_shutdown_connection(). This fixed
the behaviour for me and seemed legitimate as it was done equally there.

Tobias
