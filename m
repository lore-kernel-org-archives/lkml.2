Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1CEF4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 00:56:33 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:50754 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1CEF4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 00:56:31 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 173.50.155.44
Message-ID: <4D71D068.2090803@pbjtriplett.org>
Date: Fri, 04 Mar 2011 21:55:52 -0800
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
References: <20110225164239.GA24686@thinkpad-t410> <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6> <20110225212142.GC24686@thinkpad-t410> <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6> <20110225222900.GD24686@thinkpad-t410> <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6> <4D689681.1030301@pbjtriplett.org> <20110226150032.GA2053@thinkpad-t410> <4D6AB159.7010809@pbjtriplett.org> <20110228151008.GA29142@thinkpad-t410>
In-Reply-To: <20110228151008.GA29142@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 07:10 AM, Seth Forshee wrote:
> On Sun, Feb 27, 2011 at 12:17:29PM -0800, Burt Triplett wrote:
>>> The new release detects the Atom processor okay, but in bits-327 the
>>> system resets during the SMI frequency/latency test, whereas it didn't
>>> with bits-316.
>>
>> The SMI Frequency and Latency test should be fixed in bits-329.
>
> Yes, it's fixed now, thanks.

Glad to hear it.

>> To get more information on how the MSRs differ between CPUs, you can
>> turn on verbose mode.  Go to the GRUB command line by hitting 'c',
>> and enter "test_options -v 2".  Then hit Esc to go back to the menu,
>> and re-run the MSR consistency check.  It will now show you the
>> value of the MSR on each CPU.
>>
>> MSR 0x1a0 is IA32_MISC_ENABLE, and generally any inconsistency in
>> that MSR represents a BIOS bug: it didn't enable features
>> identically on all CPUs.  Once you see which bits differ, you can
>> look at the Intel Software Developer's Manual (specifically volume
>> 3B) to find out what those bits mean and which specific features the
>> BIOS inconsistently enabled.
>
>   (MSR 0x1a0 consistent) FAIL (2 different values)
>   1 CPUs 0x0000000364950089: 0x0
>   1 CPUs 0x0000000364950081: 0x1
>
>   Bit 3: Automatic Thermal Control Circuit Enable
>
> I'm not sure of the impact of this, since there's really only one core
> in the CPU. One of the others differs has bit 3 inconsistent as well. On
> the third bit 3 is the same but bit 0 (fast-strings enable) is
> inconsistent.

0x1a0 bit 3 definitely shouldn't differ between CPUs; that's a BIOS bug.

Fast-strings should *always* be turned on, and should always be 
consistent across processors.  That's also a BIOS bug, which will cause 
suboptimal performance of the string instructions on any CPU with that 
bit disabled.

>> MSR 0x199 is IA32_PERF_CTL.  A difference in that MSR usually means
>> the BIOS left CPUs in different P-states when booting, which it
>> really shouldn't do.  Again, you can decode the result with the
>> Intel SDM.
>
>   (MSR 0x199 consistent): FAIL (2 different values)
>   1 CPUs 0x0000000000000a1f: 0x0
>   1 CPUs 0x0000000000000613: 0x1
>
> So yes, the cores are in different P-states. The results from the other
> machines are similar, but the values for CPU1 are slightly different for
> each machine. CPU1 has the same value on all three machines.

Intel recommends that BIOSes set all CPUs to the same P-state before 
booting (partly for the case where the OS never touches P-states 
itself).  So, that's a BIOS bug, though it'll go away the moment Linux 
starts using P-states itself.

>> Looking into MSR 0x39.
>
> Yeah, this one isn't in the SDM at all. Here are the values I got:
>
>   (MSR 0x39 consistent): FAIL (2 different values)
>   1 CPUs 0x0000000000000000: 0x0
>   1 CPUs 0x0000000000000001: 0x1
>
> Values are identical for all three machines.

After investigating this MSR, I've blacklisted it from the MSR 
consistency check as of bits-332.  This isn't a BIOS bug, and the 
difference is expected.

> I'm not really getting the idea that any of these is contributing to the
> problems I'm seeing with this machine though.

No, none of the issues BITS has detected on your system should affect 
the original problem you reported.  Thanks for providing the additional 
information, though.

- Burt Triplett
