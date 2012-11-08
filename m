Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2KHSwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:52:46 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:32920 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2KHSwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:52:44 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: RE: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
Thread-Topic: [RFC PATCH v1 08/31] ARC: Fundamental ARCH data-types/defines
Thread-Index: AQHNvM0JfAvGDh5SKkaPccXcpLnQhpffKnwAgAEaCLw=
Date: Thu, 8 Nov 2012 18:52:40 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230750D9863@in01wembx1.internal.synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
	<1352281674-2186-9-git-send-email-vgupta@synopsys.com>,<CACM3HyHYiuhGb6tcY0kS43y+kquWF11Du+g45pzoJukSpE0ANw@mail.gmail.com>
In-Reply-To: <CACM3HyHYiuhGb6tcY0kS43y+kquWF11Du+g45pzoJukSpE0ANw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.144.160.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2012 10:47, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
>> new file mode 100644
>> index 0000000..c178357
>> --- /dev/null
>> +++ b/arch/arc/include/asm/ptrace.h
>> @@ -0,0 +1,120 @@
>> +/* THE pt_regs: Defines how regs are saved during entry into kernel */
>> +
>> +struct pt_regs {

> I'd recommend not exporting the pt_regs structure to userspace.  This
> struct is used heavily within the kernel and it's nice to have the
> leeway to be able to modify it as things evolve.  GDB doesn't need to
> know about this struct anymore as it should be using regset's for any
> recent architectures anyway, so it's the regset layout that should be
> ABI stable instead of pt_regs.
> 
> You can check the openrisc architecture as an example of how to do this.

Hi Jonas,

thanks for your review comment. I completely agree that pt_regs should not be exported and very recently a change in pt_regs forced a gdbserver change too (ABI incompatibility) which goes along what you are recommending. Infact the ptrace patch for kernel (which will follow in series #2) provides a stable regset ABI - extracting information from pt_regs.

However our current gdb/gdbserver is 6.8 based and making it switch to regset interface might not be possible for this release of tools. Since customers are already using our stuff, we can not have a broken ABI. We do have ABI versioning, so in next release we can fix gdb and remove this. 

Please note that an additional reason for exporting pt_regs is due to the fact that it is part of sigcontext. Keeping it exactly same as pt_regs helps us do batch save/restore of user context in signal handling (please look at my signal handling patch) but the flip side is that userspace SA_SIGINFO needs to be able to have access to sigcontext and hence we explicitly need pt_regs. We could arguably opencode pt_regs there - but that won't be clean IMHO.

What do you think !

-Vineet