Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab2CSTnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:43:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33075 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297Ab2CSTnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:43:11 -0400
Date: Mon, 19 Mar 2012 15:38:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120319193842.GA8123@phenom.dumpdata.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
 <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
 <20120125134947.GF13655@zod.bos.redhat.com>
 <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
 <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319133046.GB13093@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F678C43.00AC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 09:30:46AM -0400, Josh Boyer wrote:
> On Mon, Mar 12, 2012 at 11:36:33AM -0700, Suresh Siddha wrote:
> > On Mon, 2012-03-12 at 09:24 -0400, Josh Boyer wrote:
> > > On Wed, Feb 01, 2012 at 12:00:30AM -0800, Suresh Siddha wrote:
> > > > Yes, it was helpful. Something like the appended patch should ignore the
> > > > bogus io-apic entry all together. As I can't test this, can you or the
> > > > reporter give the appended patch a try and ack please?
> > > 
> > > Hi Suresh,
> > > 
> > > Apologies for the delay.  The original reporter had to return the
> > > machine he was using.  We've since had another report where this
> > > happened and your patch below does indeed fix the issue.
> > > 
> > > I'd suggest pushing this soon.
> > > 
> > > https://bugzilla.redhat.com/show_bug.cgi?id=801501
> > > 
> > 
> > Thanks Josh. Peter/Ingo, please queue the appended patch for -tip.
> 
> Hi Suresh,
> 
> Seems this patch and Xen don't get along very well.  See the bug link
> below.  I've CC'd Konrad and hopefully he'll have some insight as to why
> that might be.

Quick glance at the code tells me that the 'mp_register_ioapic' with the
patch won't increment the gsi_top. That value (gsi_top) is used in
'get_nr_irqs_gsi()'.  And that function is used:

#ifdef CONFIG_X86_IO_APIC
        /*   
         * For an HVM guest or domain 0 which see "real" (emulated or
         * actual respectively) GSIs we allocate dynamic IRQs
         * e.g. those corresponding to event channels or MSIs
         * etc. from the range above those "real" GSIs to avoid
         * collisions.
         */
        if (xen_initial_domain() || xen_hvm_domain())
                first = get_nr_irqs_gsi();
#endif

So we get 'first' to be 16 instead of the proper GSI number.. Or perhaps
it is some other bizzare number. Would need to instrument this.


Now, the reason that read to the IOAPIC:
[    0.000000] I/O APIC 0xfec00000 regs return all ones, skipping!

is b/c we aren't suppose to read the APIC entries at all. There was
some discussion between Ingo (or Peter?) and Jeremy years ago about a pvops call
to do a hypercall to read said entries but it was established that the
initial domain should have no such business. As such it does this:

2066         memset(dummy_mapping, 0xff, PAGE_SIZE);

and :
1899                  * We just don't map the IO APIC - all access is via
1900                  * hypercalls.  Keep the address in the pte for reference.
1901                  */
1902                 pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
1903                 break;

[ignore that comment, there are no hypercalls for it]. This is in arch/x86/xen/mmu.c
So the IO_APIC is all 0xfff.. 


