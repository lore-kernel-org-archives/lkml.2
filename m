Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1ACK6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:58:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55973 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1ACK6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:58:17 -0500
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1293526288.2457.4.camel@minggr.sh.intel.com>
References: <1293464211.2695.104.camel@localhost>
	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	 <1293526288.2457.4.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 11:58:32 +0100
Message-ID: <1294052312.2016.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 16:51 +0800, Lin Ming wrote:
> > +static bool ht_enabled(int cpu)
> > +{
> > +       int total_logical_processors, total_cores;
> > +       unsigned int eax, ebx, ecx, edx;
> > +
> > +       cpuid(1, &eax, &ebx, &ecx, &edx);
> > +
> > +       /* Bit 28 in EDX indicates if it's HT capable */
> > +       if (!(edx & 0x10000000))
> > +               return false;
> > +
> > +       total_logical_processors = (ebx >> 16) & 0xff;
> > +
> > +       ecx = 0;
> > +       cpuid(4, &eax, &ebx, &ecx, &edx);
> > +       total_cores = ((eax >> 26) & 0x3f) + 1;
> > +
> > +       /* Thread nums per core */
> > +       return (total_logical_processors / total_cores) > 1;
> > +}
> > +
> 
> This function can be simplified as below,
> 
> static bool ht_enabled()
> {
>         if (!cpu_has(&boot_cpu_data, X86_FEATURE_HT))
>                 return false;
> 
>         return smp_num_siblings > 1;
> }
> 
> But this still can't detect if HT is on or off.
> smp_num_siblings is always 2 even if HT is disabled in BIOS.
> 
> Any idea how to detect if HT is on or not?

Not quite sure, the intel docs aren't really clear on how the HW
supports HT, has 2 siblings but BIOS disabled it thing works. I just
tried reading the arch/x86 code but that only got me more confused.

hpa, could you comment?
