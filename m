Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2FFIag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:30:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2FFIac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:30:32 -0400
Message-ID: <1338971412.2749.67.camel@twins>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 10:30:12 +0200
In-Reply-To: <alpine.LFD.2.02.1206052337300.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	    <alpine.LFD.2.02.1206042203590.3086@ionos>
	    <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	    <1338881971.28282.150.camel@twins>
	    <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	   <1338912565.2749.9.camel@twins>
	    <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
	    <1338913190.2749.10.camel@twins>
	    <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	  <1338918625.2749.29.camel@twins>
	 <alpine.LFD.2.02.1206052106440.3086@ionos>
	  <1338925756.2749.36.camel@twins>
	 <alpine.LFD.2.02.1206052153200.3086@ionos> <1338931856.2749.57.camel@twins>
	 <alpine.LFD.2.02.1206052337300.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 00:09 +0200, Thomas Gleixner wrote:
> > I don't think so. Its perfectly fine to get TLB invalidate IPIs or
> 
> No it's not. It's silly. I've observed the very issue more than once
> and others have done as well. 
> 
> If you have a process which has N threads where each thread is pinned
> to a core. Only one of them is doing file operations, which result in
> mmap/munmap and therefor in TLB shoot down IPIs even if it's ensured
> that the other pinned threads will never ever touch that
> mapping. That's a PITA as the workaround is to use NFS (how
> performant) or split the process into separate processes with shared
> memory to avoid the sane design of a single process where the
> housekeeping thread just writes to disk.
> 
> This is exactly one of the issues where the application has more
> knowlegde than the kernel and there is no way to deal with it.

But simply refusing IPIs just because isn't going to work either.
Suppose the RT thing did touch the memory region.. then you'll end up
with stale TLB entries, those are not fun either.

We simply cannot not send TLB invalidates, me must assume userspace is
malicious - such is the burden of a general purpose kernel.

The only solution here is using multiple processes and shared memory.
