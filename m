Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2HXX5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 19:57:00 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:41808
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756612Ab2HXX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 19:56:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9AAHQ-01-KWN-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V4 0/5] x86: Create direct mappings for E820_RAM only
Date: Fri, 24 Aug 2012 18:55:11 -0500
Message-ID: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
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

This fourth revision of the patchset attempts to resolve comments and
concerns from the following threads:

* https://lkml.org/lkml/2012/8/22/680
* https://lkml.org/lkml/2012/8/13/512
* https://lkml.org/lkml/2012/8/9/536
* https://lkml.org/lkml/2011/10/20/323

Jacob Shin (5):
  x86: Move enabling of PSE and PGE out of init_memory_mapping
  x86: find_early_table_space based on memory ranges that are being
    mapped
  x86: Only direct map addresses that are marked as E820_RAM
  x86: Fixup code testing if a pfn is direct mapped
  x86: if kernel .text .data .bss are not marked as E820_RAM, complain
    and fix

 arch/x86/include/asm/page_types.h |    9 +++
 arch/x86/kernel/cpu/amd.c         |    6 +-
 arch/x86/kernel/setup.c           |  130 ++++++++++++++++++++++++++++++++-----
 arch/x86/mm/init.c                |   74 ++++++++++-----------
 arch/x86/mm/init_64.c             |    6 +-
 arch/x86/platform/efi/efi.c       |    8 +--
 6 files changed, 167 insertions(+), 66 deletions(-)

-- 
1.7.9.5


