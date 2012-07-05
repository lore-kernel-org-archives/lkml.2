Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2GEGBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:01:07 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49840 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2GEGBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:01:05 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 5/7] KVM: Introduce PV kick in flush tlb
In-Reply-To: <20120705023746.GC3652@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050755.4560.24727.stgit@abhimanyu.in.ibm.com> <20120703080713.GA12579@amt.cnet> <87r4stckv5.fsf@linux.vnet.ibm.com> <20120705023746.GC3652@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Thu, 05 Jul 2012 11:23:01 +0530
Message-ID: <87pq8aah4y.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12070420-3568-0000-0000-00000216172A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012 23:37:46 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Tue, Jul 03, 2012 at 01:55:02PM +0530, Nikunj A Dadhania wrote:
> > On Tue, 3 Jul 2012 05:07:13 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > On Mon, Jun 04, 2012 at 10:38:17AM +0530, Nikunj A. Dadhania wrote:
> > > > In place of looping continuously introduce a halt if we do not succeed
> > > > after some time.
> > > > 
> > > > For vcpus that were running an IPI is sent.  In case, it went to sleep
> > > > between this, we will be doing flush_on_enter(harmless). But as a
> > > > flush IPI was already sent, that will be processed in ipi handler,
> > > > this might result into something undesireable, i.e. It might clear the
> > > > flush_mask of a new request.
> > > > 
> > > > So after sending an IPI and waiting for a while, do a halt and wait
> > > > for a kick from the last vcpu.
> > > > 
> > > > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > > > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> > > 
> > > Again, was it determined that this is necessary from data of 
> > > benchmarking on the in-guest-mode/out-guest-mode patch?
> > > 
> > No, this is more of a fix wrt algo.
> 
> Please have numbers for the improvement relative to the previous
> patch.
> 
I would consider this more of a correctness fix, rather than an
improvement. In this scenario, suppose vcpu1 was pre-empted out before
the delivery of the IPI. After the loop count, we find that vcpu1 did
not respond and is found pre-empted. We set the flush_on_enter flag for
the vcpu1 and proceed. During vcpu1's guest_enter we would do a
flush_on_enter. Now the vcpu1 will also receive an ipi interrupt in guest
mode, in which it will try to clear the flush_mask and acknowledge to
the interrupt. This processing of ipi would not be correct. So with this
patch, we execute a halt and wait for vcpu1 to clear the flush_mask
through the ipi interrupt.

> It introduces a dependency, these (pvtlbflush and pvspinlocks) are
> separate features. It is useful to switch them on/off individually.
> 
Agree, we can also get the pv kick feature separated which can be useful
to both of the approaches, so they can become independent.

Although, tests suggests that for best results both these features
should be enabled.

Nikunj

