Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2CEIk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 03:40:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab2CEIk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 03:40:26 -0500
Date: Mon, 5 Mar 2012 00:39:42 -0800
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-901b04450a0ff44d579158b8b0492ce7e66cd442@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        alex.shi@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com, mingo@elte.hu
In-Reply-To: <1330774047-18597-1-git-send-email-alex.shi@intel.com>
References: <1330774047-18597-1-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/numa: Improve internode cache alignment
Git-Commit-ID: 901b04450a0ff44d579158b8b0492ce7e66cd442
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 00:40:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  901b04450a0ff44d579158b8b0492ce7e66cd442
Gitweb:     http://git.kernel.org/tip/901b04450a0ff44d579158b8b0492ce7e66cd442
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Sat, 3 Mar 2012 19:27:27 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 09:19:20 +0100

x86/numa: Improve internode cache alignment

Currently cache alignment among nodes in the kernel is still 128
bytes on x86 NUMA machines - we got that X86_INTERNODE_CACHE_SHIFT
default from old P4 processors.

But now most modern x86 CPUs use the same size: 64 bytes from L1 to
last level L3. so let's remove the incorrect setting, and directly
use the L1 cache size to do SMP cache line alignment.

This patch saves some memory space on kernel data, and it also
improves the cache locality of kernel data.

The System.map is quite different with/without this change:

	before patch			after patch
  ...
  000000000000b000 d tlb_vector_|  000000000000b000 d tlb_vector
  000000000000b080 d cpu_loops_p|  000000000000b040 d cpu_loops_
  ...

Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: asit.k.mallick@intel.com
Link: http://lkml.kernel.org/r/1330774047-18597-1-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 3c57033..6443c6f 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -303,7 +303,6 @@ config X86_GENERIC
 config X86_INTERNODE_CACHE_SHIFT
 	int
 	default "12" if X86_VSMP
-	default "7" if NUMA
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
