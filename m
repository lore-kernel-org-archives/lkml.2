Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2HMVrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:47:32 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:10608 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab2HMVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:47:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8PR6W-01-KHZ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 0/5] x86: Create direct mappings for E820_RAM only
Date: Mon, 13 Aug 2012 16:46:59 -0500
Message-ID: <1344894424-4434-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernel direct mappings are created for all pfns between
[ 0 to max_low_pfn ) and [ 4GB to max_pfn ). When we introduce memory
holes, we end up mapping memory ranges that are not backed by physical
DRAM. This is fine for lower memory addresses which can be marked as UC
by fixed/variable range MTRRs, however we run in to trouble with high
addresses.

The following patchset creates direct mappings only for E820_RAM regions
between 0 ~ max_low_pfn and 4GB ~ max_pfn. And leaves non-E820_RAM and
memory holes unmapped.

This revision of the patchset attempts to resolve comments and concerns
from the following threads:

https://lkml.org/lkml/2012/8/11/95

and

https://lkml.org/lkml/2011/12/16/486

Jacob Shin (5):
  x86: Only direct map addresses that are marked as E820_RAM
  x86: find_early_table_space based on memory ranges that are being
    mapped
  x86: Keep track of direct mapped pfn ranges
  x86: Fixup code testing if a pfn is direct mapped
  x86: Move enabling of PSE and PGE out of init_memory_mapping

 arch/x86/include/asm/page_types.h |    9 +++
 arch/x86/kernel/amd_gart_64.c     |    4 +-
 arch/x86/kernel/cpu/amd.c         |    6 +-
 arch/x86/kernel/setup.c           |  118 ++++++++++++++++++++++++++++++++-----
 arch/x86/mm/init.c                |   72 +++++++++++-----------
 arch/x86/mm/init_64.c             |    3 +-
 arch/x86/platform/efi/efi.c       |    8 +--
 arch/x86/platform/efi/efi_64.c    |    2 +
 8 files changed, 157 insertions(+), 65 deletions(-)

-- 
1.7.9.5


