Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1B0USJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 15:18:09 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:47693 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1B0USG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 15:18:06 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.45
X-Originating-IP: 173.50.155.44
Message-ID: <4D6AB159.7010809@pbjtriplett.org>
Date: Sun, 27 Feb 2011 12:17:29 -0800
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
References: <20110225164239.GA24686@thinkpad-t410> <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6> <20110225212142.GC24686@thinkpad-t410> <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6> <20110225222900.GD24686@thinkpad-t410> <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6> <4D689681.1030301@pbjtriplett.org> <20110226150032.GA2053@thinkpad-t410>
In-Reply-To: <20110226150032.GA2053@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 07:00 AM, Seth Forshee wrote:
> On Fri, Feb 25, 2011 at 09:58:25PM -0800, Burt Triplett wrote:
>> Looks like the Toshiba NB305 has an Intel Atom processor in it.
>> bits-327, released today, now detects Intel Atom processors, and no
>> longer shows them as unknown.  We don't have any processor-specific
>> tests for Atom yet, though we may add some in the future.  All of
>> the general tests should work, however.
>
> The new release detects the Atom processor okay, but in bits-327 the
> system resets during the SMI frequency/latency test, whereas it didn't
> with bits-316.

The SMI Frequency and Latency test should be fixed in bits-329.

>> Can you provide more details on which MSRs show up as inconsistent
>> on your system?  They might represent actual bugs in your BIOS, but
>> we might just need to add a few more entries to the Atom
>> CPU-specific MSR blacklist as expected inconsistencies.
>
> Here's what it says:
>
>    (MSR 0x39 consistent): FAIL
>    (MSR 0x199 consistent): FAIL
>    (MSR 0x1a0 consistent): FAIL
>    Summary: 7917 passed, 3 failed
>
> I have 3 systems with this same processor, and they all report the same
> thing here.

To get more information on how the MSRs differ between CPUs, you can 
turn on verbose mode.  Go to the GRUB command line by hitting 'c', and 
enter "test_options -v 2".  Then hit Esc to go back to the menu, and 
re-run the MSR consistency check.  It will now show you the value of the 
MSR on each CPU.

MSR 0x1a0 is IA32_MISC_ENABLE, and generally any inconsistency in that 
MSR represents a BIOS bug: it didn't enable features identically on all 
CPUs.  Once you see which bits differ, you can look at the Intel 
Software Developer's Manual (specifically volume 3B) to find out what 
those bits mean and which specific features the BIOS inconsistently enabled.

MSR 0x199 is IA32_PERF_CTL.  A difference in that MSR usually means the 
BIOS left CPUs in different P-states when booting, which it really 
shouldn't do.  Again, you can decode the result with the Intel SDM.

Looking into MSR 0x39.

- Burt Triplett
