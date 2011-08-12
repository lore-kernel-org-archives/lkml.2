Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HLRtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:49:49 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:7799
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab1HLRts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:49:48 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPTTIS-01-F4U-02
X-M-MSG: 
Date: Fri, 12 Aug 2011 19:49:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] perf, x86: Implement IBS initialization
Message-ID: <20110812174938.GC17199@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-3-git-send-email-robert.richter@amd.com>
 <1312285741.1147.124.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1312285741.1147.124.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.11 07:49:01, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > +/*
> > + * This runs only on the current cpu. We try to find an LVT offset and
> > + * setup the local APIC. For this we must disable preemption. On
> > + * success we initialize all nodes with this offset. This updates then
> > + * the offset in the IBS_CTL per-node msr. The per-core APIC setup of
> > + * the IBS interrupt vector is handled by perf_ibs_cpu_notifier that
> > + * is using the new offset.
> > + */
> > +static int force_ibs_eilvt_setup(void)
> > +{
> > +       int offset;
> > +       int ret;
> > +
> > +       preempt_disable();
> > +       /* find the next free available EILVT entry, skip offset 0 */
> > +       for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
> > +               if (get_eilvt(offset))
> > +                       break;
> > +       }
> > +       preempt_enable();
> > +
> > +       if (offset == APIC_EILVT_NR_MAX) {
> > +               printk(KERN_DEBUG "No EILVT entry available\n");
> > +               return -EBUSY;
> > +       }
> > +
> > +       ret = setup_ibs_ctl(offset);
> > +       if (ret)
> > +               goto out;
> > +
> > +       if (!ibs_eilvt_valid()) {
> > +               ret = -EFAULT;
> > +               goto out;
> > +       }
> > +
> > +       pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
> > +       pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
> > +
> > +       return 0;
> > +out:
> > +       preempt_disable();
> > +       put_eilvt(offset);
> > +       preempt_enable();
> > +       return ret;
> > +} 
> 
> So I don't get any of that preempt_disable/enable crap in this patch,
> but the above is esp. confusing. How is that preempt_disable() at out:
> still valid? We could be running on an entirely different cpu from when
> we did get_eilvt at the start.

Yes, this code is strange due to the hardware mixing up per-cpu and
per-node configuration. This code did many iterations in the oprofile
driver.

get/put_eilvt() accesses APIC registers on one *cpu* and then globally
reserves/releases the offset by keeping it in eilvt_offsets[]. To
avoid switching cpus in the middle of an apic access the funcions are
protected with preempt_disable/enable.

setup_ibs_ctl() then sets up this offset on all *nodes*. During node
setup the pci cpu devices are accessed and thus may not be called with
preemption disabled.

The offset is later taken from the per-node msr IBS_CTL and used for a
per-core setup of the NMI vector on each cpu.

It is save to have get_eilvt and put_eilvt on different cpus as the
offset is kept globally.

I was thinking of moving preempt_disable/enable to get/put_eilvt, but
also wanted to avoid switching to a different cpu while searching for
an offset in the for-loop.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

