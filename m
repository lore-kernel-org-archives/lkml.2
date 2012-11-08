Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2KHUgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:36:39 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51550 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab2KHUgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:36:38 -0500
MIME-Version: 1.0
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230750D9863@in01wembx1.internal.synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
	<1352281674-2186-9-git-send-email-vgupta@synopsys.com>
	<CACM3HyHYiuhGb6tcY0kS43y+kquWF11Du+g45pzoJukSpE0ANw@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230750D9863@in01wembx1.internal.synopsys.com>
Date: Thu, 8 Nov 2012 21:36:34 +0100
Message-ID: <CACM3HyHAKgJ2aTGjidZr5T9WFL3m+FTbUz_1QtO2gAgSFQm8fA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2012 19:52, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> On 7 November 2012 10:47, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> I'd recommend not exporting the pt_regs structure to userspace.  This
>> struct is used heavily within the kernel and it's nice to have the
>> leeway to be able to modify it as things evolve.  GDB doesn't need to
>> know about this struct anymore as it should be using regset's for any
>> recent architectures anyway, so it's the regset layout that should be
>> ABI stable instead of pt_regs.
>>
>> You can check the openrisc architecture as an example of how to do this.
>
> Hi Jonas,
>
> thanks for your review comment. I completely agree that pt_regs should not be exported and very recently a change in pt_regs forced a gdbserver change too (ABI incompatibility) which goes along what you are recommending. Infact the ptrace patch for kernel (which will follow in series #2) provides a stable regset ABI - extracting information from pt_regs.
>
> However our current gdb/gdbserver is 6.8 based and making it switch to regset interface might not be possible for this release of tools. Since customers are already using our stuff, we can not have a broken ABI. We do have ABI versioning, so in next release we can fix gdb and remove this.

For generic syscalls it was generally decided that the upstream kernel
would drop support for legacy syscalls, _even though_ userspace bits
like uClibc required them.  For _new_ architectures, userspace would
need to adapt to the _mainline_ kernel; and as a stop-gap for existing
software, external patches could be carried in an external git
repository where _non-mainline_ kernel patches could be carried to
provide a working kernel until userspace could catch up.

I'd say the same applies here: GDB 6.8 may continue work with a
mainline kernel plus a patch that restores the export of pt_regs, but
GDB 7.2 (or whatever version you move on to) would be the one that
fully supports an unpatched mainline.

>
> Please note that an additional reason for exporting pt_regs is due to the fact that it is part of sigcontext. Keeping it exactly same as pt_regs helps us do batch save/restore of user context in signal handling (please look at my signal handling patch) but the flip side is that userspace SA_SIGINFO needs to be able to have access to sigcontext and hence we explicitly need pt_regs. We could arguably opencode pt_regs there - but that won't be clean IMHO.

It's not really pt_regs you need here, but the userspace equivalent
thereof.  On OpenRISC, for example, we have user_regs_struct which is
an ABI stable version of pt_regs.  These may even be identical to
begin with, but at least the distinction can be made now between the
kernel-internal struct and the ABI stable one.

/Jonas
