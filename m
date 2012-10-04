Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2JDUQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:16:38 -0400
Received: from 1wt.eu ([62.212.114.60]:35905 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2JDUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:16:37 -0400
Date: Thu, 4 Oct 2012 22:16:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>, Avi Kivity <avi@redhat.com>
Subject: Re: [ 022/180] ioat2: kill pending flag
Message-ID: <20121004201609.GJ10245@1wt.eu>
References: <20121001225159.521191640@1wt.eu> <20121004173513.GC13292@decadent.org.uk> <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225159.352867398@1wt.eu> <20121004172054.GB13292@decadent.org.uk> <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225159.310279850@1wt.eu> <20121004171533.GA13292@decadent.org.uk> <20121001225158.550410866@1wt.eu> <1349362057.16173.27.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004173513.GC13292@decadent.org.uk> <20121004172054.GB13292@decadent.org.uk> <20121004171533.GA13292@decadent.org.uk> <1349362057.16173.27.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

I'm doing a grouped reply for your reports.

On Thu, Oct 04, 2012 at 03:47:37PM +0100, Ben Hutchings wrote:
> On Tue, 2012-10-02 at 00:52 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > commit 281befa5592b0c5f9a3856b5666c62ac66d3d9ee upstream.
> > 
> > The pending == 2 case no longer exists in the driver so, we can use
> > ioat2_ring_pending() outside the lock to determine if there might be any
> > descriptors in the ring that the hardware has not seen.
> [...]
> 
> What bug does this fix?

Quoting Mike Galbraith :

  "While testing tbench 40 throughput on a 40 core (+SMT) Intel SDV S3E37,
   I found spin_lock_bh() consuming _90%_ of the box, driving throughput
   straight through the floor.  The commit below fixed it up.

   This looks horrific enough to me to qualify for 2.6.32-longterm."

>  Is ioat2_ring_pending() *really* safe to call without the ring_lock?

I'll let Dan respond on this, he's the original path author.

On Thu, Oct 04, 2012 at 06:15:34PM +0100, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:52:37AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: =?latin1?q?Stephan=20B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
> > 
> > commit 0769c5de24621141c953fbe1f943582d37cb4244 upstream
> [...]
> 
> I'm not sure where this comes from - but probably from cherry-picking
> backporting in my local repo.  The correct upstream commit hash is
> bdb42f5afebe208eae90406959383856ae2caf2b.

I did some mistakes when cherry-picking patches, I used cherry-pick -x
on some of them because my fingers type "-x" automatically here, but
some of my scripts are used to automatically write the commit line from
the cherry-pick line.

When I noticed the error, I reviewed all the affected patches and fixed
the few erroneous ones by hand, but it seems like 2 of them have slipped
through the cracks, or I failed a copy-paste during the fix.

I'll fix the commits, thanks for checking !

On Thu, Oct 04, 2012 at 06:35:13PM +0100, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:52:42AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Avi Kivity <avi@redhat.com>
> > 
> > commit 3e515705a1f46beb1c942bb8043c16f8ac7b1e9e upstream
> [...]
> > --- a/arch/ia64/kvm/kvm-ia64.c
> > +++ b/arch/ia64/kvm/kvm-ia64.c
> > @@ -1185,6 +1185,11 @@ out:
> >  
> >  #define PALE_RESET_ENTRY    0x80000000ffffffb0UL
> >  
> > +bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
> > +{
> > +	return irqchip_in_kernel(vcpu->kcm) == (vcpu->arch.apic != NULL);
> > +}
> > +
> [...]
> 
> Fails to build; fixed by commit 8281715b4109b5ee26032ff7b77c0d575c4150f7.

Queued now, thanks very much!

Willy

