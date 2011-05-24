Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1EXV3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:29:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab1EXV3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:29:37 -0400
Date: Tue, 24 May 2011 23:29:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression -- missing /sys/devices/system/cpu/perf_events
Message-ID: <20110524212925.GL27634@elte.hu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
 <1306246306.18455.36.camel@twins>
 <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu>
 <20110524194810.GB27634@elte.hu>
 <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
 <4DDC1BB2.4090503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDC1BB2.4090503@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 05/24/11 14:12, Vince Weaver wrote:
> > On Tue, 24 May 2011, Ingo Molnar wrote:
> >>
> >> So, what is wrong with the method Peter suggested: the presence of the perf 
> >> syscall (it not returning -ENOSYS) is bona fide evidence that perf is 
> >> available.
> > 
> > it's just hard to do that from a shell script.
> 
> What about kallsyms:
> 
> grep sys_perf_event_open /proc/kallsyms

that looks pretty roundabout and expensive - kallsyms can be large.

Nor is there a guarantee that the function will always be called 
sys_perf_event_open() - we already renamed it from sys_perf_counter_open() as 
you yourself mentioned it :-)

Plus the kernel can be built without /proc/kallsyms, and root can chmod off the 
file permissions of /proc/kallsyms for unprivileged user-space as well. So it's 
not a particularly robust check.

I agree with Vince that as far as shell scripts are concerned, checking 
/proc/sys/kernel/perf_event_paranoid would work best - and it works better than 
having to check the perf syscall.

Vince: mind sending a patch that adds a comment to perf_event_paranoid that 
userspace relies on the existence of that file as a feature check? Having such 
reminders in the code works even better than frequent testing ;-)

As far as the actual PAPI library goes i really hope it checks the syscall 
itself: that's much faster and more robust than an 
access("/proc/sys/kernel/perf_event_paranoid") call ...

Thanks,

	Ingo
