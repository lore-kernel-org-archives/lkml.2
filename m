Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1LLTZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:25:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab1LLTZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:25:33 -0500
Date: Tue, 13 Dec 2011 00:55:04 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
Message-ID: <20111212192504.GC6316@amit-x200.redhat.com>
References: <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
 <20111123103852.GG16665@amit-x200.redhat.com>
 <CAB8RdaoDxMCgTjuGP70bGrsrtgh=USYtU3Spo5OPtVMYAM5EzQ@mail.gmail.com>
 <20111129142149.GE2822@amit-x200.redhat.com>
 <CAB8RdapuPRym2dH_9mgmGdzpCxnP1KpS+hS8JJ-geVkga5fMcw@mail.gmail.com>
 <CAB8Rdapfuf5XH+X9gsUL+CJ9gTQcSNfq4Dj9DoYWQeFgD04ODQ@mail.gmail.com>
 <20111205105452.GB27683@amit-x200.redhat.com>
 <CAB8Rdar=qOokxZkjQVRmo=zN_f75jPwzU+6=WBRo0g+P7w+pAw@mail.gmail.com>
 <20111208120804.GF23531@amit-x200.redhat.com>
 <CAB8RdapDDV0kYW_uASpBoJ3hbx6zScKnG+LWWcjYtqMnqXN4Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB8RdapDDV0kYW_uASpBoJ3hbx6zScKnG+LWWcjYtqMnqXN4Xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 12 Dec 2011 [11:11:55], Miche Baker-Harvey wrote:
> So on a CONSOLE_PORT_ADD message, we would take the
> (existing)ports_device::ports_lock, and for other control messages we
> would justtake the (new) port::port_lock?  You are concerned that just
> takingthe ports_lock for all control messages could be too
> restrictive?  Iwouldn't have expected these messages to be frequent
> occurrences, butI'll defer to your experience here.

No, I mean we'll have to take the new port_lock() everywhere we
currently take the port lock, plus in a few more places.  I only
suggest using port_lock() helper since we'll need a dependency on the
portdev lock as well.

> The CONSOLE_CONSOLE_PORT message calls hvc_alloc, which also
> needsserialization.  That's in another one of these three patches; are
> youthinking we could leave that patch be, or that we would we use
> theport_lock for CONSOLE_CONSOLE_PORT?  Using the port_lock
> wouldprovide the HVC serialization "for free" but it would be cleaner
> if weput HVC related synchronization in hvc_console.c.

Yes, definitely, since other users of hvc_console may get bitten in
similar ways.  However, I'm not too familiar with the hvc code, the
people at linux-ppc can be of help.

> On Thu, Dec 8, 2011 at 4:08 AM, Amit Shah <amit.shah@redhat.com> wrote:
> > On (Tue) 06 Dec 2011 [09:05:38], Miche Baker-Harvey wrote:
> >> Amit,
> >>
> >> Ah, indeed.  I am not using MSI-X, so virtio_pci::vp_try_to_find_vqs()
> >> calls vp_request_intx() and sets up an interrupt callback.  From
> >> there, when an interrupt occurs, the stack looks something like this:
> >>
> >> virtio_pci::vp_interrupt()
> >>   virtio_pci::vp_vring_interrupt()
> >>     virtio_ring::vring_interrupt()
> >>       vq->vq.callback()  <-- in this case, that's virtio_console::control_intr()
> >>         workqueue::schedule_work()
> >>           workqueue::queue_work()
> >>             queue_work_on(get_cpu())  <-- queues the work on the current CPU.
> >>
> >> I'm not doing anything to keep multiple control message from being
> >> sent concurrently to the guest, and we will take those interrupts on
> >> any CPU. I've confirmed that the two instances of
> >> handle_control_message() are occurring on different CPUs.
> >
> > So let's have a new helper, port_lock() that takes the port-specific
> > spinlock.  There has to be a new helper, since the port lock should
> > depend on the portdev lock being taken too.  For the port addition
> > case, just the portdev lock should be taken.  For any other
> > operations, the port lock should be taken.
> >
> > My assumption was that we would be able to serialise the work items,
> > but that will be too restrictive.  Taking port locks sounds like a
> > better idea.
> >
> > We'd definitely need the port lock in the control work handler.  We
> > might need it in a few more places (like module removal), but we'll
> > worry about that later.
> >
> > Does this sound fine?
> >
> >                Amit

		Amit
