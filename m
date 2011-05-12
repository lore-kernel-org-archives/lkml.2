Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab1ELWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:22:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44967 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab1ELWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:22:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Luck\, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] Kdump and memory error handling
References: <20110504193509.GA5342@in.ibm.com>
Date: Thu, 12 May 2011 15:22:44 -0700
In-Reply-To: <20110504193509.GA5342@in.ibm.com> (K. Prasad's message of "Thu,
	5 May 2011 01:05:09 +0530")
Message-ID: <m1hb8zmudn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18HdUVUaRI2x52f4BHcXp5xHOjdt0dNDFw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> Hi All,
>         We've been trying to study and improve the kdump behaviour when
> a panic is triggered due to an unrecoverable memory error causing a
> machine check exception (MCE) followed by a kernel panic.
>
> In this context we foresee a few issues in capturing kdump and would
> like to receive comments about the ways to handle them.
>
> Probable Issues when capturing coredump through kdump following a memory
> error
> ---------------------------
> - First, a coredump of the memory from the crashing kernel isn't really
>   helpful in debugging the crash that was caused due to a faulty memory.
>   Collecting the same has some of the problems illustrated below. It should
>   therefore suffice to let the user know the reason of the crash
>   rather than provide a complete dump of the memory.
>
>   For this, a 'slim' yet crash-tool readable coredump containing:
>   - message about the cause (such as crash due to unrecoverable memory error)
>     in the coredump's elf-note section.
>   - and no data from the memory of the 'crashing' kernel (their elf
>     sections can be reduced to zero length).
>   may be suitable.
>
> - Alternatively, if the kdump kernel decides to capture the coredump,
>   its attempts to read the faulty memory location may lead to subsequent 
>   faults in the context of kdump kernel with fatal consequences. This
>   may either be avoided by:
>
>   a) Pass the address of the corrupt memory location to the kdump kernel
>   and skip reading that location while creating the vmcore. This needs
>   an instance of 'struct mce' (from the 'crashing' kernel), which
>   already contains the faulty memory address (in the physical address
>   form, which should be confirmed using the IA32_MCi_MISC[8:6] bits stored
>   in 'misc' field of 'struct mce') to be populated inside the elf
>   (-notes?) section.
>
>   b) Use modified copy applications (such as a modified 'cp' command)
>   that can map the /dev/oldmem into user-space and then initiate the
>   creation of vmcore. In this method, the user-space process performing
>   the copy will receive a SIGBUS while consuming the faulty memory (through
>   INT18 -> do_machine_check) but it must be modified to be resilient to the
>   signal, while intelligently skipping to the subsequent memory location
>   for further copying. Meanwhile the data for the faulty memory location
>   can be represented using 'zero-ed' data and the vmcore enhanced to
>   indicate the cause of the crash as one resulting from a fatal MCE.
>
> Any thoughts/suggestions?

In practice this all works for me.

I have received several crash dumps where there was an mce error.

I admit I have my userspace configured to just grab the dmesg from the
kernel log and not do a full crash dump.  So in that sense I am already
a slim crash dump.

But in practice with real hardware errors it is working today without
kernel changes.

Eric
