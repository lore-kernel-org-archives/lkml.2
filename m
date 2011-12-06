Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab1LFOFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:05:22 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49198 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab1LFOFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:05:20 -0500
Message-ID: <4EDE20F5.4030601@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 19:34:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com> <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu> <4EDDE5D0.7030906@linux.vnet.ibm.com> <20111206103500.GD15966@elte.hu> <4EDDF2DE.7020701@linux.vnet.ibm.com> <20111206130020.GB28735@gere.osrc.amd.com>
In-Reply-To: <20111206130020.GB28735@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120604-0260-0000-0000-0000002CB96C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 06:30 PM, Borislav Petkov wrote:

> On Tue, Dec 06, 2011 at 04:17:58PM +0530, Srivatsa S. Bhat wrote:
>> In this case, the other patch that I mentioned in my previous mail
>> would be required (or an equivalent), because the optimization
>> patch which is now in mainline, would apply the same old microcode
>> image on this new CPU too, blindly.
> 
> Not blindly, the microcode is still verified.
> 


I saw your other mail about the validity of this whole scenario, and I
kind of agree to your point.

My thoughts below might not be so relevant/significant considering that,
but anyways, just to understand what you said above:
I didn't quite find where the microcode is verified if the kernel happens
to have the microcode image already.

>From what I saw, microcode image is not freed nor invalidated when a
CPU goes down (which was introduced by the optimization patch). And hence,
when the CPU comes back up, the call sequence would look something like:

case CPU_ONLINE:
case CPU_ONLINE_FROZEN:
    * microcode_update_cpu(cpu);
        * microcode_resume_cpu(cpu) /* Because uci->valid was 1 */
            * eventually calls apply_microcode_amd(cpu) for AMD or
                               apply_microcode(cpu) for Intel

And both these functions simply write the microcode image to the CPU
and then check whether the _write_ was successful, (not whether the required
microcode version was applied).

That was why, to take care of this, the other patch (below) was written, IMHO.
http://thread.gmane.org/gmane.linux.kernel/1205405/
 
Regards,
Srivatsa S. Bhat

