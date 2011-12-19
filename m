Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1LSLNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:13:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1LSLNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:13:35 -0500
Message-ID: <4EEF1C3B.3010307@redhat.com>
Date: Mon, 19 Dec 2011 13:12:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robert Richter <robert.richter@amd.com>, Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
References: <20111216160757.GL665@escobedo.osrc.amd.com> <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com> <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com> <20111218080443.GB4144@elte.hu> <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu>
In-Reply-To: <20111219105429.GC19861@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 12:54 PM, Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
>
> > On 19.12.11 00:43:10, Ingo Molnar wrote:
> >
> > > So the question becomes, how well is it integrated: can perf 
> > > 'record -a + perf report', or 'perf top' use LWP, to do 
> > > system-wide precise [user-space] profiling and such?
> > 
> > There is only self-monitoring of a process possible, no kernel 
> > and system-wide profiling. This is because we can not allocate 
> > memory regions in the kernel for a thread other than the 
> > current. This would require a complete rework of mm code.
>
> Hm, i don't think a rework is needed: check the 
> vmalloc_to_page() code in kernel/events/ring_buffer.c. Right now 
> CONFIG_PERF_USE_VMALLOC is an ARM, MIPS, SH and Sparc specific 
> feature, on x86 it turns on if CONFIG_DEBUG_PERF_USE_VMALLOC=y.
>
> That should be good enough for prototyping the kernel/user 
> shared buffering approach.
>

LWP wants user memory, vmalloc is insufficient.  You need do_mmap() with
a different mm.

You could let a workqueue call use_mm() and then do_mmap().  Even then
it is subject to disruption by the monitored thread (and may disrupt the
monitored thread by playing with its address space).  This is for thread
monitoring only, I don't think system-wide monitoring is possible with LWP.

-- 
error compiling committee.c: too many arguments to function

