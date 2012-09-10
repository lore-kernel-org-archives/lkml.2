Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2IJWlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2IJWlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:41:09 -0400
Date: Mon, 10 Sep 2012 19:31:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
Message-ID: <20120910223140.GA24275@amt.cnet>
References: <5032F8FD.2020306@linux.vnet.ibm.com>
 <5032FA78.9040405@linux.vnet.ibm.com>
 <5034CB60.30107@redhat.com>
 <5034D4E3.2080801@linux.vnet.ibm.com>
 <5048AE96.3050909@redhat.com>
 <5049C4D7.50101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5049C4D7.50101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:56:39PM +0800, Xiao Guangrong wrote:
> On 09/06/2012 10:09 PM, Avi Kivity wrote:
> > On 08/22/2012 03:47 PM, Xiao Guangrong wrote:
> >> On 08/22/2012 08:06 PM, Avi Kivity wrote:
> >>> On 08/21/2012 06:03 AM, Xiao Guangrong wrote:
> >>>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
> >>>> caused by write access on readonly memslot
> >>>
> >>> Please document this in chapter 5 of apic.txt.
> >>>
> >>
> >> Okay, please review this one.
> >>
> >> Subject: [PATCH v6 12/12] KVM: indicate readonly access fault
> >>
> >> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
> >> caused by write access on readonly memslot
> >>
> > 
> > I'm not sure whether this indication can be trusted by userspace.  By
> > the time userspace gets to process this, the slot may no longer exist,
> > or it may be writable.
> 
> The case of deleting memslot is ok, because userspace just skips this fault
> if no readonly mem or no fault handler can be found.
> 
> Switching memslot from readonly to writable sounds strange, i agree with you
> that this flag is untrusty under this case.
> 
> Marcelo, any comments?

The same can happen with slot deletion, for example. 

Userspace (which performed the modification which can result in faults
to non-existant/read-only/.../new-tag memslot), must handle the faults 
properly or avoid the possibility for reference to memslot information 
from the past.

I think its worthwhile to add a note about this in the API
documentation: "The user of this interface is responsible for handling 
references to stale memslot information, either by handling
exit notifications which reference stale memslot information or not
allowing these notifications to exist by stopping all vcpus in userspace
before performing modifications to the memslots map".

> > (in the same way an mmio exit might actually hit RAM)
> 
> So, in the userspace, for the safe reason, we should walk all memslots not
> just walking mmio handlers?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
