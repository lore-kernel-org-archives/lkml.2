Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0CSIB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:01:28 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:53623 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab0CSIB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:01:27 -0400
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
In-Reply-To: <201003182143.22929.trenn@suse.de>
References: <1268399863.3407.15.camel@localhost>
	 <201003171736.00550.trenn@suse.de> <4BA10642.8070208@linux.intel.com>
	 <201003182143.22929.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 09:01:19 +0100
Message-ID: <1268985679.3395.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.03.2010, 21:43 +0100 schrieb Thomas Renninger:
> On Wednesday 17 March 2010 05:41:38 pm Arjan van de Ven wrote:
> > On 3/17/2010 9:36, Thomas Renninger wrote:
> > > On Tuesday 16 March 2010 17:40:18 Arjan van de Ven wrote:
> > >> On 3/16/2010 7:50, Thomas Renninger wrote:
> > >>> Still, as this is totally broken:
> > >>>      - by design ->   only one of a dozen cpufreq drivers is supported
> > >>
> > >> the one I care about is supported.
> > >
> > > And that's the problem, before it's not removed, you do not care to
> > > provide/suggest a proper solution that could fit others as well.
> >
> > why don't you provide the others then?
> Is it possible somehow to provide a kind of wrapper/backup function:
> trace_power_frequency_cpu(POWER_PSTATE, frequency, cpu);
As I understood the tracing correctly this would imply the usage of
smp_call_function_single which should be aoided.
> or another trace interface with eventually some more overhead?
> Then it should be easy to support all drivers.
> Otherwise you'll for example miss the pcc driver which supports
> latest/upcoming Intel CPUs and which does IO based switching which needs not
> to run on the cpu that gets switched.
> 
>      Thomas
This wrapper would make things easier of course, since one might add the
same line for every driver. Or even call it from
cpufreq_notify_transition (POSTCHANGE) which would add this event for
other architectures then x86 (which I would approve).
But - and here's the problem - the tracing infrastructure should provide
as less overhead as possible. It should be called directly after writing
the new frequency for the specific cpu and by this optimally in a
funtion wich is already executed on the cpu.

Otherwise the following might happen (4 cpu system):
cpu 3 wants to change freq of cpu 0:
...
switch to cpu 0 (some overhead)
write new frequency
switch back (some overhead)
switch to cpu 0 (some overhead)
write trace
switch back (some overhead)
...
It's easy to see, that writing of the frequency and writing the trace
should be called directly one after another. It increases the accuracy
of the trace and decreases the overhead.

Robert

