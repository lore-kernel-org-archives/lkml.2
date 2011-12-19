Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1LSL7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:59:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1LSL7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:59:10 -0500
Message-ID: <4EEF26F0.1050709@redhat.com>
Date: Mon, 19 Dec 2011 13:58:40 +0200
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
References: <20111216160757.GL665@escobedo.osrc.amd.com> <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com> <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com> <20111218080443.GB4144@elte.hu> <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu>
In-Reply-To: <20111219114023.GB29855@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 01:40 PM, Ingo Molnar wrote:
>
> 2) the proper solution: creating a 'user-space vmalloc()' that 
>    is per mm and that gets inherited transparently, across 
>    fork() and exec(), and which lies outside the regular vma
>    spaces. On 64-bit this should be straightforward.

That probably has uses outside perf too, but I can see mm nacks piling up.

>    These vmas are not actually 'known' to user-space normally -
>    the kernel PMU code knows about it and does what we do with
>    PEBS: flushes it when necessary and puts it into the
>    regular perf event channels.
>
>    This solves the inherited perf record workflow immediately:
>    the parent task just creates the buffer, which gets inherited 
>    across exec() and fork(), into every portion of the workload.

The buffer still needs to be managed.  While you may be able to juggle
different threads on the same cpu using different events, threads on
other cpus need to use separate LWP contexts and buffers.

>
>    System-wide profiling is a small additional variant of this: 
>    creating such a user-vmalloc() area for all tasks in the
>    system so that the PMU code has them ready in the 
>    context-switch code.

What about security?  Do we want to allow any userspace process to mess
up the buffers?  It can even reprogram the LWP block, so you're counting
different things, or at higher frequencies, or into other processes
ordinary vmas?

You could rebuild the LWP block on every context switch I guess, but you
need to prevent access to other cpus' LWP blocks (since they may be
running other processes).  I think this calls for per-cpu cr3, even for
threads in the same process.

> Solution #2 has the additional advantage that we could migrate 
> PEBS to it and could allow interested user-space access to the 
> 'raw' PEBS buffer as well. (currently the PEBS buffer is only 
> visible to kernel-space.)

That's probably useful for jits.

> I'd suggest the easy hack first, to get things going - we can 
> then help out with the proper solution.

I think you're underestimating the complexity there.  LWP wasn't
designed for this.

-- 
error compiling committee.c: too many arguments to function

