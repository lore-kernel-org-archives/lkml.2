Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2JHRHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:07:32 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:48870 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2JHRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:07:27 -0400
Message-ID: <1349716040.2674.19.camel@lorien2>
Subject: Re: [PATCH v4] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, stern@rowland.harvard.edu,
        joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Date: Mon, 08 Oct 2012 11:07:20 -0600
In-Reply-To: <20121005155108.d8d88fd2.akpm@linux-foundation.org>
References: <1347843171.4370.13.camel@lorien2>
	 <1348621517.3091.6.camel@lorien2> <1349276159.3192.4.camel@lorien2>
	 <1349400193.2547.29.camel@lorien2>
	 <20121005155108.d8d88fd2.akpm@linux-foundation.org>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 15:51 -0700, Andrew Morton wrote:

> 
> Still seems overly complicated to me, but whatev.
> 
> I think the way to handle this is pretty simple: set a flag in the dma
> entry when someone runs dma_mapping_error() and, if that flag wasn't
> set at unmap time, emit a loud warning.
> 
> From my reading of the code, this patch indeed does that, along with a
> bunch of other (unnecessary?) stuff.  But boy, the changelog conceals
> this information well!

Are you referring to the system wide error counters when you say
unnecessary stuff. The reason I added those was to catch errors when
drivers don't do unmap. Several drivers fail to do unmap. Checking flag
from unmap debug interfaces, doesn't cover these cases. However, I think
the value of system wide counters is limited in the sense that they
don't really identify the driver that needs fixing. In that sense it can
be deemed unnecessary. I dropped them in v5 patch, which I am sending
out.

I also changed the changelog to be clear.

> 
> >  Documentation/DMA-API.txt          |   13 +++++
> >  arch/x86/include/asm/dma-mapping.h |    1 +
> >  include/linux/dma-debug.h          |    7 +++
> >  lib/dma-debug.c                    |  110 ++++++++++++++++++++++++++++++++++--
> 
> Please, go through Documentation/DMA-API-HOWTO.txt with a toothcomb and
> ensure that all this is appropriately covered and that the examples are
> completed for error checking.
> 
> >
> > ...
> >
> > +static inline int check_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > +{
> > +	const struct dma_map_ops *ops = get_dma_ops(dev);
> > +	if (ops->mapping_error)
> > +		return ops->mapping_error(dev, dma_addr);
> > +
> > +	return (dma_addr == DMA_ERROR_CODE);
> > +}
> 
> I'm not a fan of functions called check_foo() because I never know
> whether their return value means "foo is true" or "foo is false".  It
> doesn't help that the return value here is undocumented.  Names such as
> has_mapping_error() or mapping_has_error() will remove this question,
> thereby making the call sites more readable.

Changed the name to has_mapping_error().

> 
> >  static void check_unmap(struct dma_debug_entry *ref)
> >  {
> >  	struct dma_debug_entry *entry;
> >  	struct hash_bucket *bucket;
> >  	unsigned long flags;
> >  
> > -	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> > +	if (unlikely(check_mapping_error(ref->dev, ref->dev_addr))) {
> > +		unmap_errors += 1;
> >  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
> >  			   "to free an invalid DMA memory address\n");
> >  		return;
> > @@ -915,6 +975,15 @@ static void check_unmap(struct dma_debug_entry *ref)
> >  			   dir2name[ref->direction]);
> >  	}
> >  
> > +	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
> > +		err_printk(ref->dev, entry,
> > +			   "DMA-API: device driver failed to check map error"
> > +			   "[device address=0x%016llx] [size=%llu bytes] "
> > +			   "[mapped as %s]",
> > +			   ref->dev_addr, ref->size,
> > +			   type2name[entry->type]);
> > +	}
> 
> It's important that this warning be associated with a backtrace so we
> can identify the offending call site in the usual fashion. 
> err_printk() does include a backtrace under some circumstances, but
> those circumstances hurt my brain.
> 
> Is it guaranteed that we'll have that backtrace?  If not, I'd suggest
> making it so.

Yes it does. Here is one from my test run:

[ 5232.368453] e1000e 0000:00:19.0: DMA-API: device driver failed to
check map error[device address=0x00000000ffe4e1c0] [size=1522 bytes]
[mapped as single]

[ 5232.368546] Pid: 0, comm: swapper/1 Not tainted 3.6.0-next-20121002+
#2
[ 5232.368549] Call Trace:
[ 5232.368553]  <IRQ>  [<ffffffff81055faf>] warn_slowpath_common
+0x7f/0xc0
[ 5232.368570]  [<ffffffff810560a6>] warn_slowpath_fmt+0x46/0x50
[ 5232.368579]  [<ffffffff81341fbe>] check_unmap+0x48e/0x860
[ 5232.368588]  [<ffffffff81092ee9>] ? check_preempt_wakeup+0x1c9/0x270
[ 5232.368595]  [<ffffffff8134251c>] debug_dma_unmap_page+0x5c/0x60
[ 5232.368616]  [<ffffffffa0016e4e>] e1000_clean_rx_irq+0x1be/0x410
[e1000e]
[ 5232.368626]  [<ffffffff8108c885>] ? wake_up_process+0x15/0x20
[ 5232.368644]  [<ffffffffa001b35c>] e1000e_poll+0x7c/0x400 [e1000e]
[ 5232.368653]  [<ffffffff8107e539>] ? enqueue_hrtimer+0x39/0xc0
[ 5232.368662]  [<ffffffff815756c4>] net_rx_action+0x134/0x240
[ 5232.368670]  [<ffffffff813b15c3>] ? arch_local_irq_enable+0x8/0xd
[ 5232.368678]  [<ffffffff8105e9d0>] __do_softirq+0xc0/0x240
[ 5232.368688]  [<ffffffff816856ce>] ? _raw_spin_lock+0xe/0x20
[ 5232.368697]  [<ffffffff8168f31c>] call_softirq+0x1c/0x30
[ 5232.368706]  [<ffffffff81016315>] do_softirq+0x65/0xa0
[ 5232.368713]  [<ffffffff8105ecae>] irq_exit+0x8e/0xb0
[ 5232.368721]  [<ffffffff8168fba3>] do_IRQ+0x63/0xe0
[ 5232.368728]  [<ffffffff81685cad>] common_interrupt+0x6d/0x6d
[ 5232.368731]  <EOI>  [<ffffffff813b15c3>] ? arch_local_irq_enable
+0x8/0xd
[ 5232.368744]  [<ffffffff813b2159>] acpi_idle_enter_c1+0x94/0xb9
[ 5232.368752]  [<ffffffff81533fd9>] cpuidle_enter+0x19/0x20
[ 5232.368758]  [<ffffffff815346ac>] cpuidle_idle_call+0xac/0x290
[ 5232.368767]  [<ffffffff8101d59f>] cpu_idle+0xcf/0x120
[ 5232.368775]  [<ffffffff81670bc6>] start_secondary+0x1ec/0x1f3
[ 5232.368780] ---[ end trace 58eeb6eaa1eca88f ]---
[ 5232.368782] Mapped at:
[ 5232.368785]  [<ffffffff81340fcb>] debug_dma_map_page+0x8b/0x150
[ 5232.368792]  [<ffffffffa001823f>] e1000_alloc_rx_buffers+0x15f/0x2d0
[e1000e]
[ 5232.368808]  [<ffffffffa0016f8b>] e1000_clean_rx_irq+0x2fb/0x410
[e1000e]
[ 5232.368823]  [<ffffffffa001b35c>] e1000e_poll+0x7c/0x400 [e1000e]
[ 5232.368838]  [<ffffffff815756c4>] net_rx_action+0x134/0x240

> 
> >  	hash_bucket_del(entry);
> >  	dma_entry_free(entry);
> >  
> >
> > ...
> >
> > +void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > +{
> > +	struct dma_debug_entry ref;
> > +	struct dma_debug_entry *entry;
> > +	struct hash_bucket *bucket;
> > +	unsigned long flags;
> > +
> > +	if (unlikely(global_disable))
> > +		return;
> > +
> > +	ref.dev = dev;
> > +	ref.dev_addr = dma_addr;
> > +	bucket = get_hash_bucket(&ref, &flags);
> > +	entry = bucket_find_exact(bucket, &ref);
> > +
> > +	if (!entry) {
> > +		/* very likley dma-api didn't call debug_dma_map_page() or
> > +		   debug_dma_map_page() detected mapping error */
> > +		if (map_errors_not_checked)
> > +			map_errors_not_checked -= 1;
> > +		goto out;
> > +	}
> > +
> > +	entry->map_err_type = MAP_ERR_CHECKED;
> > +out:
> > +	put_hash_bucket(bucket, &flags);
> > +}
> > +EXPORT_SYMBOL(debug_dma_mapping_error);
> 
> Well, it's a global, exported-to-modules symbol.  Some formal
> documentation is appropriate for such things.

I added information on what it does and who can/should call to
DMA-API.txt
> 
> >
> > ...
> >
> 


