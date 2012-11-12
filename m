Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2KLN67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:58:59 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:53911 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2KLN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:58:55 -0500
Message-ID: <50A10091.6020606@synopsys.com>
Date: Mon, 12 Nov 2012 19:28:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-9-git-send-email-vgupta@synopsys.com> <CACM3HyHYiuhGb6tcY0kS43y+kquWF11Du+g45pzoJukSpE0ANw@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA230750D9863@in01wembx1.internal.synopsys.com> <CACM3HyHAKgJ2aTGjidZr5T9WFL3m+FTbUz_1QtO2gAgSFQm8fA@mail.gmail.com>
In-Reply-To: <CACM3HyHAKgJ2aTGjidZr5T9WFL3m+FTbUz_1QtO2gAgSFQm8fA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 November 2012 02:06 AM, Jonas Bonn wrote:
> On 8 November 2012 19:52, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> On 7 November 2012 10:47, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>> I'd recommend not exporting the pt_regs structure to userspace.  This
>>> struct is used heavily within the kernel and it's nice to have the
>>> leeway to be able to modify it as things evolve.  GDB doesn't need to
>>> know about this struct anymore as it should be using regset's for any
>>> recent architectures anyway, so it's the regset layout that should be
>>> ABI stable instead of pt_regs.
>>>
>>> You can check the openrisc architecture as an example of how to do this.
>> Hi Jonas,
>>
>> thanks for your review comment. I completely agree that pt_regs should not be exported and very recently a change in pt_regs forced a gdbserver change too (ABI incompatibility) which goes along what you are recommending. Infact the ptrace patch for kernel (which will follow in series #2) provides a stable regset ABI - extracting information from pt_regs.
>>
>> However our current gdb/gdbserver is 6.8 based and making it switch to regset interface might not be possible for this release of tools. Since customers are already using our stuff, we can not have a broken ABI. We do have ABI versioning, so in next release we can fix gdb and remove this.
> For generic syscalls it was generally decided that the upstream kernel
> would drop support for legacy syscalls, _even though_ userspace bits
> like uClibc required them.  For _new_ architectures, userspace would
> need to adapt to the _mainline_ kernel; and as a stop-gap for existing
> software, external patches could be carried in an external git
> repository where _non-mainline_ kernel patches could be carried to
> provide a working kernel until userspace could catch up.
>
> I'd say the same applies here: GDB 6.8 may continue work with a
> mainline kernel plus a patch that restores the export of pt_regs, but
> GDB 7.2 (or whatever version you move on to) would be the one that
> fully supports an unpatched mainline.

So there are 2 points/issues to discuss here.
1. Not exporting pt_regs
2. Asking customers to refer to a non mainline tree.

Will adding a #ifdef __KERNEL__ guard over pt_regs (which my ptrace
patch posted today as 33/55 already does), help serve the cause. So we
don't export any real "C" structs (pt_regs and/or user_regs_struct....).
All we export now is just a bunch of #defs called PT_xxx, to refer to
offsets with user_regs_struct.
And it doesn't matter if user_regs_struct has pt_regs as an element -
since we don't export the struct at all.

But just to clarify, gdbserver will still use ARC specific
ptrace(PEEKUSR) as opposed to regset interface. The switch to new gdb
version is non trivial and I can't ask our active customers to go to
some out-of-mainline tree until that gets fixed.


>> Please note that an additional reason for exporting pt_regs is due to the fact that it is part of sigcontext. Keeping it exactly same as pt_regs helps us do batch save/restore of user context in signal handling (please look at my signal handling patch) but the flip side is that userspace SA_SIGINFO needs to be able to have access to sigcontext and hence we explicitly need pt_regs. We could arguably opencode pt_regs there - but that won't be clean IMHO.
> It's not really pt_regs you need here, but the userspace equivalent
> thereof.  On OpenRISC, for example, we have user_regs_struct which is
> an ABI stable version of pt_regs.  These may even be identical to
> begin with, but at least the distinction can be made now between the
> kernel-internal struct and the ABI stable one.
>
> /Jonas

