Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2JVMxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2JVMxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:53:07 -0400
Date: Mon, 22 Oct 2012 14:53:01 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Avi Kivity <avi@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
Message-ID: <20121022125301.GS29310@redhat.com>
References: <5081033C.4060503@linux.vnet.ibm.com>
 <20121022091615.GG29310@redhat.com>
 <50852972.305@linux.vnet.ibm.com>
 <20121022112314.GO29310@redhat.com>
 <50852F9C.9020808@siemens.com>
 <20121022114311.GQ29310@redhat.com>
 <508531E1.2030307@siemens.com>
 <508539A8.40404@redhat.com>
 <50853FF1.8010809@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50853FF1.8010809@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:45:37PM +0200, Jan Kiszka wrote:
> On 2012-10-22 14:18, Avi Kivity wrote:
> > On 10/22/2012 01:45 PM, Jan Kiszka wrote:
> > 
> >>> Indeed. git pull, recheck and call for kvm_flush_coalesced_mmio_buffer()
> >>> is gone. So this will break new userspace, not old. By global you mean
> >>> shared between devices (or memory regions)?
> >>
> >> Yes. We only have a single ring per VM, so we cannot flush multi-second
> >> VGA access separately from other devices. In theory solvable by
> >> introducing per-region rings that can be driven separately.
> > 
> > But in practice unneeded.  Real time VMs can disable coalescing and not
> > use planar VGA modes.
> 
> A) At least right now, we do not differentiate between the VGA modes and
> if flushing is needed. So that device is generally taboo for RT cores of
> the VM.
> B) We need to disable coalescing in E1000 as well - if we want to use
> that model.
> C) Gleb seems to propose using coalescing far beyond those two use cases.
> 
Since the userspace change is needed the idea is dead, but if we could
implement it I do not see how it can hurt the latency if it would be the
only mechanism to use coalesced mmio buffer. Checking that the ring buffer
is empty is cheap and if it is not empty it means that kernel just saved
you a lot of 8 bytes exists so even after iterating over all the entries there
you still saved a lot of time.

--
			Gleb.
