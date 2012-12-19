Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab2LSXWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:22:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47811 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2LSXWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:22:41 -0500
Message-ID: <50D24C25.5050604@zytor.com>
Date: Wed, 19 Dec 2012 15:22:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <50CCEE49.3080801@zytor.com> <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com> <50CCF6F6.4020107@zytor.com> <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com> <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic>
In-Reply-To: <20121219230329.GM24895@liondog.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 03:03 PM, Borislav Petkov wrote:
> On Wed, Dec 19, 2012 at 04:59:41PM -0600, Jacob Shin wrote:
>> I can check but right, they might be used up. But even if we had slots
>> available, the memory range that needs to be covered is in large
>> enough address and aligned in such a way that you cannot cover it with
>> variable range MTRRs.
> 
> Actually, if I'm not mistaken, you only need to cover the HT hole with
> one MTRR - the rest remains WB. And in order the mask bits to work, we
> could make it a little bigger - we waste some memory but that's nothing
> in comparison to the MCE.
> 
> You might need to talk to hw guys about the feasibility of this deal
> though.
> 

Just make the hole a bit bigger, so it starts at 0xfc00000000, then you
only need one MTRR.  This is the correct BIOS-level fix, and it really
needs to happen.

Do these systems actually exist in the field or are they engineering
prototypes?  In the latter case, we might be done at that point.

Really, though, AMD should have added a TOM3 for memory above the 1T
mark since they should have been able to see a 1T hole coming from the
design of HyperTransport.  This would be the correct hardware-level fix,
but I don't expect that to happen.

Now, calming down a little bit, we are definitely dealing with BIOS
engineers and so f*ckups are going to happen, again and again.  The
question is what to do about it.

The only truly "safe" option is to limit early mappings to 4K pages.
This is highly undesirable for a bunch of reasons.  Reducing mapping
granularity to 2M rather than 1G (what Yinghai is proposing) does reduce
the exposure somewhat; it would be interesting to gather trap statistics
and try to get a feel for if this actually changes the boot time
measurably or not.

The other bit is that building the real kernel page tables iteratively
(ignoring the early page tables here) is safer, since the real page
table builder is fully aware of the memory map.  This means any
"spillover" from the early page tables gets minimized to regions where
there are data objects that have to be accessed early.  Since Yinghai
already had iterative page table building working, I don't see any
reason to not use that capability.

Thoughts?

	-hpa

