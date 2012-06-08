Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2FHStR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:49:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2FHStP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:49:15 -0400
Message-ID: <1339181341.30462.5.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Fri, 08 Jun 2012 20:49:01 +0200
In-Reply-To: <CABPqkBTXfri3jNhv=XuW+EK5dX727HfdbPriaE92qMpzBD0irQ@mail.gmail.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <CABPqkBTXfri3jNhv=XuW+EK5dX727HfdbPriaE92qMpzBD0irQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 18:28 +0200, Stephane Eranian wrote:
> >  static int apply_microcode_on_target(int cpu)
> >  {
> >        struct apply_microcode_ctx ctx = { .err = 0 };
> >        int ret;
> >
> > +       ret = microcode_notifier_check(ucode_cpu_info + cpu);
> > +       if (ret)
> > +               return ret;
> > +
> >        ret = smp_call_function_single(cpu, apply_microcode_local, &ctx, 1);
> >        if (!ret)
> >                ret = ctx.err;
> >
> > +       if (!ret)
> > +               microcode_notifier_done();
> > +
> I suspect you want to do this here and not after the update() has completed over
> all CPU (for_each_online_cpu()), because you want to prevent a race condition
> with perf_event users trying PEBS at the same time. If not, then why not move
> the callback after all the smp_call() are done. 

Because not all callers are in a for_each_cpu loop. For instance, see
the reload_store() thing.

Also, since the ucode is per-cpu and not machine wide, a per-cpu
callback makes more sense.
