Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab2EXXxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:53:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:22032 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab2EXXxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:53:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147555203"
Message-ID: <4FBEC9E6.8040301@linux.intel.com>
Date: Thu, 24 May 2012 16:53:10 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: tracing ring_buffer_resize oops.
References: <20120524160146.GA6226@redhat.com>  <1337876398.13348.178.camel@gandalf.stny.rr.com>  <20120524172223.GA10689@redhat.com> <1337902816.13348.224.camel@gandalf.stny.rr.com>
In-Reply-To: <1337902816.13348.224.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 04:40 PM, Steven Rostedt wrote:
> On Thu, 2012-05-24 at 13:22 -0400, Dave Jones wrote:
> 
> I found a clue!
> 
> 
>> [ 1013.243754] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
>> [ 1013.272665] IP: [<ffff880145cc0000>] 0xffff880145cbffff
>> [ 1013.285186] PGD 1401b2067 PUD 14324c067 PMD 0 
>> [ 1013.298832] Oops: 0010 [#1] PREEMPT SMP 
>> [ 1013.310600] CPU 2 
>> [ 1013.317904] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
>> [ 1013.401848] 
>> [ 1013.407399] Pid: 112, comm: kworker/2:1 Not tainted 3.4.0+ #30 
>> [ 1013.437943] RIP: 8eb8:[<ffff88014630a000>]  [<ffff88014630a000>] 0xffff880146309fff
> 
> RIP is always near the GS segment. As GS points to the per_cpu area, we
> may somehow be getting our GS screwed up. I'm not sure why that would
> affect the RIP. Maybe stacks are not being processed properly somewhere?
> 
> It's strange because I can either trigger it on the first try, or it
> never triggers at all??
> 

Much more fundamentally, RIP should never leave the range [-2G, 0).
What is happening here is almost certainly that we jump through
something which isn't a function pointer.

The other thing worth noting is that the code segment is not the
standard Linux code segment, not even close; it *also* doesn't look like
the typical Xen code segment.  This makes be believe that we did an IRET
with the stack pointer set to something other than a valid interrupt
stack frame.  Specifically, note that the value of R12 is the same
value; R12 is a preserved register and may have been pushed onto the
stack by something that wants to save it.

Waitaminute... this isn't related to your using R12 to save a pointer to
something, is it?

> [ 1013.459871] RSP: ffffffff8165e919:ffff88014780f408  EFLAGS: 00010046

	-hpa

