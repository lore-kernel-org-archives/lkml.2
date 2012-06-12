Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2FLRNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:13:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2FLRNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:13:39 -0400
Message-ID: <1339521203.31548.92.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Tue, 12 Jun 2012 19:13:23 +0200
In-Reply-To: <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120612170725.GE5046@erda.amd.com>
	 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 19:09 +0200, Stephane Eranian wrote:
> > Instead of registering a microcode notifier, why not checking the
> > availability of pebs dynamically with each syscall in
> > intel_pmu_hw_config()? It looks like intel_snb_verify_ucode() is not
> > that much expensive. We can perform the check only if the event
> could
> > be for pebs and if pebs is broken. The check could be repeated when
> > setting up a new event after ucode could potentially has been
> updated
> > (e.g. after bringing a cpu online or so).

Because you then end up with a for_each_online_cpu() loop in there,
that's not pretty and quite horrible on large systems when you need to
create nr_cpus events.

Furthermore, ucode update is the rare thing, creating events happens
much more frequently.

> That's what I had in my original version. 

Right, but you really need to check all cpus, not just the one you
happen to run on or the boot cpu.
