Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab2CMLpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:45:15 -0400
Received: from sym2.noone.org ([178.63.92.236]:56415 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2CMLpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:45:13 -0400
Date: Tue, 13 Mar 2012 12:45:12 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: ping: drivers/staging/usbip/ abuses task_is_dead/exit_state
Message-ID: <20120313114512.GM21503@distanz.ch>
References: <20110920122202.GA26504@redhat.com>
 <20110920124419.GA10759@hallyn.com>
 <20110920134108.GA30749@redhat.com>
 <20110920143920.GA15859@redhat.com>
 <20110920143942.GB15859@redhat.com>
 <20110920151410.GA16569@redhat.com>
 <20110920183810.GA25159@suse.de>
 <20120306173925.GA17551@redhat.com>
 <20120306193040.GD21503@distanz.ch>
 <20120308185739.GA18935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308185739.GA18935@redhat.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-08 at 19:57:39 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/06, Tobias Klauser wrote:
> >
> > On 2012-03-06 at 18:39:25 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > OK, since nobody cares, probably I should make the patch even if I don't
> > > understand this code at all and can't test the change.
> > >
> > > But, Tobias, may be you can explain what this task_is_dead() check was
> > > supposed to do?
> >
> > As mentioned in the commit message, this was needed for me to work
> > around a NULL pointer dereference I got during unbinding
> 
> Where? OK, I guess you do not remember the trace ;)

Yup, sorry I can't precisely recall where it happened anymore.

> > (I only
> > experienced this behaviour on the nios2 platform though, couldn't
> > reproduce it on e.g. x86_64).
> 
> OK,
> 
> > I wasn't really familiar with the codebase of usbip (and still am not)
> > but came up with the fix by more or less blindly copying what the
> > opposite side is checking for in stub_shutdown_connection(). This fixed
> > the behaviour for me and seemed legitimate as it was done equally there.
> 
> But this looks "obviously wrong", and afaics just hides the problem.
> Not to mention this check is racy, it is simply unsafe to dereference
> this task_struct if the kthread has already exited.
> 
> At first glance we need something like the patch below (and stub_dev.c
> needs the same fix). It assumes that:
> 
> 	- vhci_shutdown_connection() is the only caller of kthread_stop(),
> 	  iow nobody else does kthread_stop(tcp_*x)
> 
> 	- we can't leak the task_struct, vhci_shutdown_connection() should
> 	  be called in any case at some point.
> 
> I'll try to grep more, but perhaps you can ack my understanding?

Looks OK to me at a first glance. I'll try to dig up my test system
where I was able to produce that NULL pointer dereference and test your
patch there and will then let you know my results.

Thanks
Tobias
