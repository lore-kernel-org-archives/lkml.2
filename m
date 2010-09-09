Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0IIL62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:58:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0IIL6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:58:24 -0400
Date: Thu, 9 Sep 2010 11:57:57 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, ebiederm@xmission.com, mingo@elte.hu
In-Reply-To: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
References: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, kdump: Change copy_oldmem_page() to use cached addressing
Message-ID: <tip-37a2f9f30a360fb03522d15c85c78265ccd80287@git.kernel.org>
Git-Commit-ID: 37a2f9f30a360fb03522d15c85c78265ccd80287
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 11:57:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37a2f9f30a360fb03522d15c85c78265ccd80287
Gitweb:     http://git.kernel.org/tip/37a2f9f30a360fb03522d15c85c78265ccd80287
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 8 Sep 2010 10:14:27 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 09:46:23 +0200

x86, kdump: Change copy_oldmem_page() to use cached addressing

The copy of /proc/vmcore to a user buffer proceeds much faster
if the kernel addresses memory as cached.

With this patch we have seen an increase in transfer rate from
less than 15MB/s to 80-460MB/s, depending on size of the
transfer. This makes a big difference in time needed to save a
system dump.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: kexec@lists.infradead.org
Cc: <stable@kernel.org> # as far back as it would apply
LKML-Reference: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/crash_dump_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 045b36c..bf43188 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
