Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1JDGes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:34:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55623 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1JDGer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:34:47 -0400
Date: Tue, 4 Oct 2011 08:34:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        crash-utility@redhat.com, kexec@lists.infradead.org,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111004063440.GB5723@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, crash-utility@redhat.com,
	kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	"Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
	tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111003120336.GK2223@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:33:36PM +0530, K.Prasad wrote:
> It's interesting...according to Intel's Software Developer Manual
> (quoting from Volume 3A, Chapter 15), the MCIP bit in IA32_MCG_STATUS
> MSR behaves as described below.
> 
> "MCIP (machine check in progress) flag, bit 2 Indicates (when set)
> that a machine-check exception was generated. Software can set or clear this
> flag. The occurrence of a second Machine-Check Event while MCIP is set will
> cause the processor to enter a shutdown state."
> 
> While in do_machine_check function, we enter the panic path (for
> unrecoverable errors) much before the IA32_MCG_STATUS MSR is reset and
> this is likely to dangerous.
> 
> 911 void do_machine_check(struct pt_regs *regs, long error_code)
> 912 {
> .............
> ................
> 1055         if (no_way_out && tolerant < 3)
> 1056                 mce_panic("Fatal machine check on current CPU", final, msg);
> .............
> ................
> 1073         mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
> 1074 out:
> 
> It'd be interesting to know the type of memory error (as classified by
> the processor) for which you're able to capture the memory dump.
> Maybe a dump of the various MCE status registers (and struct mce) would
> help us understand the behaviour on your system better.

Well, there are MCE types for which we need to panic but we don't
necessarily corrupt memory. Your approach is to unconditionally avoid
dumping core whenever we panic while you should look at the MCE
signature and decide then whether to capture crashed kernel memory or
not.

For example, if the MCE signature says UC DRAM error, then you can
be pretty sure that there is a landmine somewhere in the DRAM region
mapping the crashed kernel. If it is, say, a UC when doing data fills
from L2 to L1, that doesn't necessarily mean that DRAM is corrupted. But
even in the first case, you can evaluate the MCi_ADDR reported with the
UC DRAM error and simply skip that particular cacheline when dumping the
core instead of not capturing anything at all.

Btw, the doublefault example you give above - is this something you
experience on real hardware or just a theoretical thing?

Thanks.

-- 
Regards/Gruss,
    Boris.
