Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1EDTfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:35:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34502 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1EDTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:35:20 -0400
Date: Thu, 5 May 2011 01:05:09 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC] Kdump and memory error handling
Message-ID: <20110504193509.GA5342@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
        We've been trying to study and improve the kdump behaviour when
a panic is triggered due to an unrecoverable memory error causing a
machine check exception (MCE) followed by a kernel panic.

In this context we foresee a few issues in capturing kdump and would
like to receive comments about the ways to handle them.

Probable Issues when capturing coredump through kdump following a memory
error
---------------------------
- First, a coredump of the memory from the crashing kernel isn't really
  helpful in debugging the crash that was caused due to a faulty memory.
  Collecting the same has some of the problems illustrated below. It should
  therefore suffice to let the user know the reason of the crash
  rather than provide a complete dump of the memory.

  For this, a 'slim' yet crash-tool readable coredump containing:
  - message about the cause (such as crash due to unrecoverable memory error)
    in the coredump's elf-note section.
  - and no data from the memory of the 'crashing' kernel (their elf
    sections can be reduced to zero length).
  may be suitable.

- Alternatively, if the kdump kernel decides to capture the coredump,
  its attempts to read the faulty memory location may lead to subsequent 
  faults in the context of kdump kernel with fatal consequences. This
  may either be avoided by:

  a) Pass the address of the corrupt memory location to the kdump kernel
  and skip reading that location while creating the vmcore. This needs
  an instance of 'struct mce' (from the 'crashing' kernel), which
  already contains the faulty memory address (in the physical address
  form, which should be confirmed using the IA32_MCi_MISC[8:6] bits stored
  in 'misc' field of 'struct mce') to be populated inside the elf
  (-notes?) section.

  b) Use modified copy applications (such as a modified 'cp' command)
  that can map the /dev/oldmem into user-space and then initiate the
  creation of vmcore. In this method, the user-space process performing
  the copy will receive a SIGBUS while consuming the faulty memory (through
  INT18 -> do_machine_check) but it must be modified to be resilient to the
  signal, while intelligently skipping to the subsequent memory location
  for further copying. Meanwhile the data for the faulty memory location
  can be represented using 'zero-ed' data and the vmcore enhanced to
  indicate the cause of the crash as one resulting from a fatal MCE.

Any thoughts/suggestions?

Thanks,
K.Prasad

