Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1FUPTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:19:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:60038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1FUPTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:19:12 -0400
Date: Tue, 21 Jun 2011 15:18:57 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-bbd270e6f45a5ca30e1d3b6133c516a9dc9dd6c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.981533045@sgi.com>
References: <20110621122242.981533045@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Correct failed topology memory leak
Git-Commit-ID: bbd270e6f45a5ca30e1d3b6133c516a9dc9dd6c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:18:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbd270e6f45a5ca30e1d3b6133c516a9dc9dd6c0
Gitweb:     http://git.kernel.org/tip/bbd270e6f45a5ca30e1d3b6133c516a9dc9dd6c0
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:32 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:33 +0200

x86, UV: Correct failed topology memory leak

Fix a memory leak in init_per_cpu() when the topology check
fails.

The leak should never occur on deployed systems. It would only occur
in an unexpected topology that would make the BAU unuseable as a result.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20110621122242.981533045@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 5265842..db8b915 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1797,15 +1797,20 @@ static int __init init_per_cpu(int nuvhubs, int base_part_pnode)
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
 
 	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask))
-		return 1;
+		goto fail;
 
 	if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask))
-		return 1;
+		goto fail;
 
 	kfree(uvhub_descs);
 	kfree(uvhub_mask);
 	init_per_cpu_tunables();
 	return 0;
+
+fail:
+	kfree(uvhub_descs);
+	kfree(uvhub_mask);
+	return 1;
 }
 
 /*
