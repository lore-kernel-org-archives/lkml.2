Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1LHMIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1LHMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:08:41 -0500
Date: Thu, 8 Dec 2011 17:38:04 +0530
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
Message-ID: <20111208120804.GF23531@amit-x200.redhat.com>
References: <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
 <874nybqo0o.fsf@rustcorp.com.au>
 <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
 <20111123103852.GG16665@amit-x200.redhat.com>
 <CAB8RdaoDxMCgTjuGP70bGrsrtgh=USYtU3Spo5OPtVMYAM5EzQ@mail.gmail.com>
 <20111129142149.GE2822@amit-x200.redhat.com>
 <CAB8RdapuPRym2dH_9mgmGdzpCxnP1KpS+hS8JJ-geVkga5fMcw@mail.gmail.com>
 <CAB8Rdapfuf5XH+X9gsUL+CJ9gTQcSNfq4Dj9DoYWQeFgD04ODQ@mail.gmail.com>
 <20111205105452.GB27683@amit-x200.redhat.com>
 <CAB8Rdar=qOokxZkjQVRmo=zN_f75jPwzU+6=WBRo0g+P7w+pAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8Rdar=qOokxZkjQVRmo=zN_f75jPwzU+6=WBRo0g+P7w+pAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 06 Dec 2011 [09:05:38], Miche Baker-Harvey wrote:
> Amit,
> 
> Ah, indeed.  I am not using MSI-X, so virtio_pci::vp_try_to_find_vqs()
> calls vp_request_intx() and sets up an interrupt callback.  From
> there, when an interrupt occurs, the stack looks something like this:
> 
> virtio_pci::vp_interrupt()
>   virtio_pci::vp_vring_interrupt()
>     virtio_ring::vring_interrupt()
>       vq->vq.callback()  <-- in this case, that's virtio_console::control_intr()
>         workqueue::schedule_work()
>           workqueue::queue_work()
>             queue_work_on(get_cpu())  <-- queues the work on the current CPU.
> 
> I'm not doing anything to keep multiple control message from being
> sent concurrently to the guest, and we will take those interrupts on
> any CPU. I've confirmed that the two instances of
> handle_control_message() are occurring on different CPUs.

So let's have a new helper, port_lock() that takes the port-specific
spinlock.  There has to be a new helper, since the port lock should
depend on the portdev lock being taken too.  For the port addition
case, just the portdev lock should be taken.  For any other
operations, the port lock should be taken.

My assumption was that we would be able to serialise the work items,
but that will be too restrictive.  Taking port locks sounds like a
better idea.

We'd definitely need the port lock in the control work handler.  We
might need it in a few more places (like module removal), but we'll
worry about that later.

Does this sound fine?

		Amit
