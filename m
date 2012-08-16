Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2HPQA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:00:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890Ab2HPQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:00:23 -0400
Date: Thu, 16 Aug 2012 12:57:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
Message-ID: <20120816155739.GA23247@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <20120810181422.GA14892@amt.cnet>
 <502A5A01.6040505@redhat.com>
 <20120814155106.GA22249@amt.cnet>
 <502B7D7E.20902@redhat.com>
 <20120815175338.GA18452@amt.cnet>
 <502CB745.8060709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502CB745.8060709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:03:01PM +0300, Avi Kivity wrote:
> On 08/15/2012 08:53 PM, Marcelo Tosatti wrote:
> > On Wed, Aug 15, 2012 at 01:44:14PM +0300, Avi Kivity wrote:
> >> On 08/14/2012 06:51 PM, Marcelo Tosatti wrote:
> >> >> 
> >> >> Userspace may want to modify the ROM (for example, when programming a
> >> >> flash device).  It is also possible to map an hva range rw through one
> >> >> slot and ro through another.
> >> > 
> >> > Right, can do that with multiple userspace maps to the same anonymous 
> >> > memory region (see other email).
> >> 
> >> Yes it's possible.  It requires that we move all memory allocation to be
> >> fd based, since userspace can't predict what memory will be dual-mapped
> >> (at least if emulated hardware allows this).
> > 
> > It can:
> > - Create named memory object, with associated fd.
> > - Copy data from large anonymous memory region to named memory.
> 
> That doesn't work if dma is in progress (assigned device).  It also
> doubles the amount of memory in use.
>
> > - Unmap region that must be dual-mapped from large anonymous memory chunk.
> > - Map named memory object at address.
> > 
> > The last step can be replaced by adjusting KVM memory slots.
> > 
> > The disadvantage of protection information in memory slots
> > is that it duplicates functionality that is handled by 
> > userspace mappings.
> 
> Agree.  So does the memory slots mechanism, and even dirty logging.
>
> > Moreover, multiple memory maps are necessary for any
> > split-qemu-into-smaller-pieces solutions.
> 
> Complex users can use complex mechanism, but let's keep the simple stuff
> simple.
> 
> > 
> >>  Is this a reasonable
> >> requirement?  Do ksm/thp/autonuma work with this?
> > 
> > As mentioned, only memory used for ROM purposes must be dual mapped. 
> > 
> > I don't think there is any way to create multiple mappings 
> > to one anonymous memory object ATM, but POSIX defines it
> > (posix_typed_mem_open).
> > 
> > The limitation of thp/ksm on shared memory also affects any other user
> > of shared memory, so it should be fixed there.
> > 
> > Also, QEMU ROM is allocated separately from RAM, correct?
> > 
> 
> Correct.  But the chipset is also able to to write-protect some ranges
> in the 0xc0000-0x100000 area via the PAM.  It is able to write-protect
> both RAM and PCI memory (usually mapped to flash).

You are convinced that adding read-write protection information to the
memory slots, which controls access by the guest, in addition to the
userspace host pagetables, is useful. OK.

