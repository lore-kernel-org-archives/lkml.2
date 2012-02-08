Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2BHUUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:20:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2BHUUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:20:21 -0500
Date: Wed, 8 Feb 2012 15:19:40 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <ying.huang@intel.com>,
        "'ak@linux.intel.com'" <ak@linux.intel.com>,
        "'hughd@chromium.org'" <hughd@chromium.org>,
        "'mingo@elte.hu'" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Message-ID: <20120208201940.GZ5650@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com>
 <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
 <32727E9A83EE9A42A1F0906295A3A77B2C78F49973@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
 <20120203171809.GL5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F02B380@ORSMSX104.amr.corp.intel.com>
 <20120203225740.GO5650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203225740.GO5650@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 05:57:40PM -0500, Don Zickus wrote:
> On Fri, Feb 03, 2012 at 10:32:31PM +0000, Luck, Tony wrote:
> > > What if we send the REBOOT_IPI first and let it block for up to a second.
> > > Most code paths that are done with spin_locks will use
> > > spin_lock_irqrestore.  As soon as the interrupts are re-enabled the
> > > REBOOT_IPI comes in and takes the processor.  If after a second the cpu
> > > still is blocking interrupts, just use the NMI as a big hammer to shut it
> > > down.
> > 
> > This looks good - it certainly deals with my "if we just let them run
> > a bit, they'd release the locks" quibble.  One second sounds very
> > generous - but I'm not going to bikeshed that (so long as it is a total
> > of one second - not one second per cpu). So the pseudo-code is:
> 

Hi Tony,

If I put together a patch to address this would you be willing to let
Seiji move the kmsg_dump to below smp_send_stop()?

Cheers,
Don

> This is how the stop_cpus is implemented on x86 and the one second comes
> from there
> 
> arch/x86/kernel/smp.c::native_irq_stop_other_cpus and
> native_nmi_stop_other_cpus
> 
> > 
> > 	send_reboot_ipi_to_everyone_else()
> > 
> > 	wait_1_second()
> > 
> > 	for_each_cpu_that_didnt_respond_to_reboot_ipi {
> > 		hit_that_cpu_with_NMI()
> > 	}
> > 
> > Perhaps a notification printk() if we had to use the NMI hammer?
> 
> Yes.
> 
> Again this is for x86, but I guess that is our common case with pstore.
> 
> Cheers,
> Don
