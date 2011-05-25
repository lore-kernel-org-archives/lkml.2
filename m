Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab1EYWJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:09:21 -0400
Received: from n1.taur.dk ([217.198.219.102]:33102 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab1EYWJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:09:20 -0400
Message-ID: <4DDD7D9E.60100@kasperkp.dk>
Date: Thu, 26 May 2011 00:07:26 +0200
From: Kasper Pedersen <kkp2010@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <johnstul@us.ibm.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v3] x86: tsc: make TSC calibration immune to interrupts
References: <4DDC0B4F.6060202@kasperkp.dk> <alpine.LFD.2.02.1105251243330.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105251243330.3078@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 12:51 PM, Thomas Gleixner wrote:
>> The 8 additional samples costs us 28 microseconds in startup
>> time.
> 
> That's a good reason to avoid the whole conditional thing and just do
> the best of 5 always.

I do not mind removing it again.
The additional 170us only happen when quick_pit_calibrate fails,
and then native_calibrate_tsc burns 30ms extra anyway.

>> +
>> +	*p = tp;
> 
> The value is completely uninteresting when we return ULLONG_MAX.
> 

native_calibrate_tsc() depends on *p being written regardless of
whether we can get a SMI-free reading:

	/* We don't have an alternative source, disable TSC */
	if (!hpet && !ref1 && !ref2) {
		printk("TSC: No reference (HPET/PMTIMER) available\n");
		return 0;
	}

this works since acpi_pm_read_early() returns 0 when pmtmr_ioport 
is 0, or CONFIG_X86_PM_TIMER is not set.

Without it we would report "calibration failed" rather than 
"No reference" or "Using PIT" when there is neither pmtimer nor 
hpet.

/Kasper Pedersen
