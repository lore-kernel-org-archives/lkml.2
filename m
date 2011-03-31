Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab1CaSC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:02:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab1CaSCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Hy5WMeXuPMlbmdZl6aMnCWFF2Chn/NYopHe+KrmGV404dWjuHIAfRgteiCJZ6qPOsH
         m9KN3MygJu9ap++q9Wws/Rz9lJqKVh3+A0MPQ/kycGLa3FYp0NbElCmrpZWTLUk5C8ah
         sYBN37nhaWxI0ovVYGI9+doAlba8z4EOTJS4Q=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        cl@linux-foundation.org, yinghai@kernel.org
Cc: torvalds@linux-foundation.org, aarcange@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCHSET tip:x86/mm] Remove DISCONTIGMEM support from x86-32
Date: Thu, 31 Mar 2011 20:02:42 +0200
Message-Id: <1301594566-10139-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset removes DISCONTIGMEM support from x86-32 leaving it with
FLATMEM for UMA and SPARSEMEM for NUMA.  At this point, DISCONTIGMEM
doesn't really have much benefit over SPARSEMEM.  The only remaining
benefit is that it can have finer granularity with memsections
regardless of the number of bits available in page->flags.

There are two obstacles to removing DISCONTIGMEM support in x86-32.
One is that ARCH_SUPPORTS_MEMORY_FAILURE is dependent on !SPARSEMEM,
so if a NUMA kernel wants to use memory failure, it has to use
DISCONTIGMEM.  At least SLE11SP1 kernel seems to have chosen that
route.

This is solved by reducing the number of page->flags bits used for
memsection selection by one, which I think is the right thing to do
regardless of this change.  Please read the patch description on the
second patch for details.

The other obstable is that due to the limited number of page->flags
bits available and the relatively large physical address area when PAE
is enabled, the granularity of sparse memsections is somewhat coarse.
It was originally 512MiB but increased to 1GiB with the second patch.

For unaligned memsections, this can result in some amount of wasted
struct page allocations, which I think shouldn't be a problem but not
completely sure and thus the RFC status.

This patchset contains the following four patches.

 0001-x86-Clean-up-memory-model-related-configs-in-arch-x8.patch
 0002-x86-32-Increment-SECTION_SIZE_BITS-to-30-when-X86_PA.patch
 0003-x86-32-Remove-restrictions-on-ARCH_SUPPORTS_MEMORY_F.patch
 0004-x86-32-NUMA-Remove-support-for-DISCONTIGMEM.patch

0001 is a cleanup which I'll probably queue regardless of this series
unless there are objections.  0002-0003 solve the first obstacle
described above and 0004 removes DISCONTIGMEM.

The patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_32-remove-DISCONTIGMEM

diffstat follows.

 arch/x86/Kconfig                  |   49 +++++++++------------------------
 arch/x86/include/asm/mmzone_32.h  |   48 --------------------------------
 arch/x86/include/asm/pgtable_32.h |    5 ---
 arch/x86/include/asm/sparsemem.h  |    2 -
 arch/x86/mm/numa_32.c             |   56 ++++----------------------------------
 5 files changed, 22 insertions(+), 138 deletions(-)

Thanks.

-- 
tejun
