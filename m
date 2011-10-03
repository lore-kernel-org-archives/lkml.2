Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1JCMD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:03:59 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46905 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1JCMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:03:52 -0400
Date: Mon, 3 Oct 2011 17:33:36 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        anderson@redhat.com, tachibana@mxm.nes.nec.co.jp,
        oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111003120336.GK2223@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m162k64c7w.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11100302-3568-0000-0000-00000072CE2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:10:43AM -0700, Eric W. Biederman wrote:
> "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> 
> > There are certain types of crashes induced by faulty hardware in which
> > capturing crashing kernel's memory (through kdump) makes no sense (or sometimes
> > dangerous).
> >
> > A case in point, is unrecoverable memory errors (resulting in fatal machine
> > check exceptions) in which reading from the faulty memory location from the
> > kexec'ed kernel will cause double fault and system reset (leaving no
> > information for the user).
> 
> It does make plenty of sense, and I capture the all of the time.
> It totally doesn't make sense to do this in the kernel when we can
> filter this from userspace just fine.
> 

It's interesting...according to Intel's Software Developer Manual
(quoting from Volume 3A, Chapter 15), the MCIP bit in IA32_MCG_STATUS
MSR behaves as described below.

"MCIP (machine check in progress) flag, bit 2 Indicates (when set)
that a machine-check exception was generated. Software can set or clear this
flag. The occurrence of a second Machine-Check Event while MCIP is set will
cause the processor to enter a shutdown state."

While in do_machine_check function, we enter the panic path (for
unrecoverable errors) much before the IA32_MCG_STATUS MSR is reset and
this is likely to dangerous.

911 void do_machine_check(struct pt_regs *regs, long error_code)
912 {
.............
................
1055         if (no_way_out && tolerant < 3)
1056                 mce_panic("Fatal machine check on current CPU", final, msg);
.............
................
1073         mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
1074 out:

It'd be interesting to know the type of memory error (as classified by
the processor) for which you're able to capture the memory dump.
Maybe a dump of the various MCE status registers (and struct mce) would
help us understand the behaviour on your system better.

> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> I thought we already had this discussion.  Why is this silliness coming
> back?
> 
> I especially dislike the notion of hardcoding policy in the kernel like this.
> 

The last time this was discussed in the community, the kernel was hardcoded to
prevent anybody from reading the kernel memory, while this time it is NOT.

This kernel patch is different from the last time, in that it only adds an
elf-note to denote a particular type of crash. However in the user-space, using
'cp' for instance, the entire coredump can be read from /proc/vmcore. Similarly
'makedumpfile' can be used to extract the dmesg from the crashed kernel and the
new elf-note does not interfere with the same.

Hope this addresses your concerns.

Thanks,
K.Prasad

