Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2E3OXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:23:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58476 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2E3OXl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 30 May 2012 10:23:41 -0400
Message-Id: <4FC649790200007800086E51@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 30 May 2012 15:23:21 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andre Przywara" <andre.przywara@amd.com>
Cc: "Jacob Shin" <Jacob.Shin@amd.com>, <mingo@elte.hu>, <jeremy@goop.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com>
In-Reply-To: <4FC62888.9010407@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 16:02, Andre Przywara <andre.przywara@amd.com> wrote:
> On 05/30/2012 03:33 PM, Jan Beulich wrote:
>> Further, I can't see how checking_wrmsrl() is being paravirtualized
>> any better than wrmsrl_amd_safe() - both have nothing but an
>> exception handling fixup attached to the wrmsr invocation. Care
>> to point out what actual crash it is that was seen?
> 
> AFAIK, the difference is between the "l" and the regs version for 
> rd/wrmsr. We have a patch already here to fix this. Will send it out 
> soon. Jacob, can you comment on this?

I see - the Xen code blindly overwrites pv_cpu_ops, despite not
having initialized all members. That's an obvious oversight of the
patch that introduced the _regs variants.

Plus having secondary instances of things like rdmsrl_amd_safe()
in asm/paravirt.h seems pretty strange an approach (which was
why initially I didn't spot how a crash could happen there) - only
the lowest level functions should get re-implemented here.

>> Finally, I would question whether re-enabling the topology
>> extensions under Xen shouldn't be skipped altogether, perhaps
>> even on Dom0 (as the hypervisor is controlling this MSR, but in
>> any case on DomU - the hypervisor won't allow (read: ignore,
>> not fault on) the write anyway (and will log a message for each
>> (v)CPU that attempts this).
> 
> This is probably right. Let me think about this.

I'll submit a respective hypervisor side patch soonish.

Jan

