Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1ITSie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:38:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1ITSid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:38:33 -0400
Date: Tue, 20 Sep 2011 11:38:10 -0700
From: Greg KH <gregkh@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tobias Klauser <tklauser@distanz.ch>, Matt Mooney <mfm@muteddisk.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: drivers/staging/usbip/ abuses task_is_dead/exit_state
Message-ID: <20110920183810.GA25159@suse.de>
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
 <20110920124419.GA10759@hallyn.com>
 <20110920134108.GA30749@redhat.com>
 <20110920143920.GA15859@redhat.com>
 <20110920143942.GB15859@redhat.com>
 <20110920151410.GA16569@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920151410.GA16569@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 05:14:10PM +0200, Oleg Nesterov wrote:
> (add more cc's)
> 
> On 09/20, Oleg Nesterov wrote:
> >
> > Unfortunately, we can't kill task_is_dead() right now, it has already
> > found the users in drivers/staging/, and I bet the usage is wrong.
> 
> It is used by drivers/staging/usbip/
> 
> For what? The code:
> 
> 	if (vdev->ud.tcp_rx && !task_is_dead(vdev->ud.tcp_rx))
> 		kthread_stop(vdev->ud.tcp_rx);
> 
> And how task_is_dead() can help? This helper is really "special", it
> shouldn't be used anyway. But why do we check ->exit_state? Without
> tasklist the check is racy anyway, the task can exit right after the
> check.
> 
> And. It is safe to use kthread_stop(t) even if t has already exited.
> 
> OK, this was added by 8547d4cc2b616e4f1dafebe2c673fc986422b506
> "Staging: usbip: vhci-hcd: Do not kill already dead RX/TX kthread"
> 
> 	When unbinding a device on the host which was still attached on the
> 	client, I got a NULL pointer dereference on the client.
> 
> Where?
> 
> 	This turned out
> 	to be due to kthread_stop() being called on an already dead kthread.
> 
> This should work.
> 
> I'm afraid this can only fix the symptom. Probably, the problem is that
> we do not have the reference and thus even task_is_dead(t) is not safe.
> 
> This kthread was created by kthread_run(). If it exits, nothing protects
> this task_struct.
> 
> In any case, please do not use ->exit_state. It should not be used outside
> of exit.c/etc paths, "exit_state != 0" means "exit_notify() was called".

Patches to fix this up in this driver are always gladly appreciated :)

greg k-h
