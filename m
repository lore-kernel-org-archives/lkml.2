Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2EYAO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 20:14:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:20448 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab2EYAOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 20:14:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148173931"
Date: Thu, 24 May 2012 17:14:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: tracing ring_buffer_resize oops.
Message-ID: <20120525001407.GC12234@tassilo.jf.intel.com>
References: <20120524160146.GA6226@redhat.com>
 <1337876398.13348.178.camel@gandalf.stny.rr.com>
 <20120524172223.GA10689@redhat.com>
 <1337902816.13348.224.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337902816.13348.224.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:40:16PM -0400, Steven Rostedt wrote:
> On Thu, 2012-05-24 at 13:22 -0400, Dave Jones wrote:
> 
> I found a clue!
> 
> 
> > [ 1013.243754] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> > [ 1013.272665] IP: [<ffff880145cc0000>] 0xffff880145cbffff
> > [ 1013.285186] PGD 1401b2067 PUD 14324c067 PMD 0 
> > [ 1013.298832] Oops: 0010 [#1] PREEMPT SMP 
> > [ 1013.310600] CPU 2 
> > [ 1013.317904] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
> > [ 1013.401848] 
> > [ 1013.407399] Pid: 112, comm: kworker/2:1 Not tainted 3.4.0+ #30 
> > [ 1013.437943] RIP: 8eb8:[<ffff88014630a000>]  [<ffff88014630a000>] 0xffff880146309fff
> 
> RIP is always near the GS segment. As GS points to the per_cpu area, we
> may somehow be getting our GS screwed up. I'm not sure why that would
> affect the RIP. Maybe stacks are not being processed properly somewhere?
> 
> It's strange because I can either trigger it on the first try, or it
> never triggers at all??

I think this could happen if you get your SWAPGS state screwed up
(so you do a mismatched swapgs) In the early days of the port I fought a 
lot with this.

One easy way to debug it is to read the GS msr early and double
check it's as expected.

-Andi
