Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2FMKWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:22:30 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43211 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2FMKWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:22:25 -0400
X-IronPort-AV: E=Sophos;i="4.75,762,1330923600"; 
   d="scan'208";a="198566593"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86/mm: remove arch-specific PTE/PMD get-and-clear functions
Date: Wed, 13 Jun 2012 11:20:43 +0100
Message-ID: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes the x86-specific implementation of
ptep_get_and_clear() and pmdp_get_and_clear().

The principal reason for this is it allows Xen paravitualized guests
to batch the PTE clears which is a significant performance
optimization of munmap() and mremap() -- the number of entries into
the hypervisor is reduced by about a factor of about 30 (60 in 32-bit
guests) for munmap().

There may be minimal gains on native and KVM guests due to the removal
of the locked xchg.

Removal of arch-specific functions where generic ones are suitable
seems to be a generally useful thing to me.

The full reasoning for why this is safe is included in the commit
message of patch 1 but to summarize.  The atomic get-and-clear does
not guarantee that the latest dirty/accessed bits are returned as TLB
as there is a still a window after the get-and-clear and before the
TLB flush that the bits may be updated on other processors.  So, user
space applications accessing pages that are being unmapped or remapped
already have unpredictable behaviour.

David

