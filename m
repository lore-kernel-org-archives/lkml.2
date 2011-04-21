Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1DUTsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:48:11 -0400
Received: from n1.taur.dk ([217.198.219.102]:32994 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1DUTsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:48:09 -0400
Message-ID: <4DB08987.20403@kasperkp.dk>
Date: Thu, 21 Apr 2011 21:46:15 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x86: tsc: v2 make TSC calibration more immune to interrupts
References: <4DAF2B57.6010100@kasperkp.dk> <1303326959.2796.136.camel@work-vm> <4DAF37B4.3040408@kasperkp.dk> <1303331280.2796.154.camel@work-vm> <4DAF4E8B.6030506@kasperkp.dk> <20110420223929.GB5563@feather>
In-Reply-To: <20110420223929.GB5563@feather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 12:39 AM, Josh Triplett wrote:
> 
> Have you considered disabling interrupts while calibrating?  That would
> ensure that you only have to care about SMIs, not arbitrary interrupts.
>
> Also, on more recent x86 systems you could look at MSR_SMI_COUNT (MSR
> 0x34) to detect if any SMIs have occurred during the sample period.
> rdmsr, start sample period, stop sample period, rdmsr, if delta of 0
> then no SMIs occurred.  Exists on Nehalem and newer, at least.


I have now tested this, and it is worth doing.

+		local_irq_save(flags);
		t1 = get_cycles();
		if (hpet)
			tp = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
		else
			tp = acpi_pm_read_early();
		t2 = get_cycles();
+		local_irq_restore(flags);

On P3, when no SMI occur, the sample is now always perfect.
On Core2 there is still very rare variation - up to 8000 clock,
maybe bus contention?
Thinking it was cache I tried keeping irqs disabled for 5M
iterations, and that makes it occur _more_ often.

Atom shows the same as Core2, but even more rarely.

So, even if we have a Nehalem with SMI counter, the 5 samples
will still have benefit.


/Kasper Pedersen
-- 
This is my second patch ever, tell me when I do something wrong.
