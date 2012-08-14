Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2HNWja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:39:30 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:12536
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552Ab2HNWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:39:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8RO9M-01-LYT-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V3 0/4] x86: Create direct mappings for E820_RAM only
Date: Tue, 14 Aug 2012 17:39:13 -0500
Message-ID: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
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

This third revision of the patchset attempts to resolve comments and
concerns from the following threads:

* https://lkml.org/lkml/2012/8/13/512
* https://lkml.org/lkml/2012/8/9/536
* https://lkml.org/lkml/2011/10/20/323

Jacob Shin (4):
  x86: Move enabling of PSE and PGE out of init_memory_mapping
  x86: find_early_table_space based on memory ranges that are being
    mapped
  x86: Only direct map addresses that are marked as E820_RAM
  x86: Fixup code testing if a pfn is direct mapped

 arch/x86/include/asm/page_types.h |    9 +++
 arch/x86/kernel/cpu/amd.c         |    6 +-
 arch/x86/kernel/setup.c           |  121 +++++++++++++++++++++++++++++++------
 arch/x86/mm/init.c                |   74 +++++++++++------------
 arch/x86/mm/init_64.c             |    6 +-
 arch/x86/platform/efi/efi.c       |    8 +--
 6 files changed, 155 insertions(+), 69 deletions(-)

-- 
1.7.9.5


