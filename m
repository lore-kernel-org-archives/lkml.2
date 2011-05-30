Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1E3MYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab1E3MYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:24:17 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Cc: kvm@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix mwait_play_dead() faulting on mwait-incapable cpus
Date: Mon, 30 May 2011 08:23:57 -0400
Message-Id: <1306758237-9327-1-git-send-email-avi@redhat.com>
In-Reply-To: <201105301143.p4UBhco4001230@demeter2.kernel.org>
References: <201105301143.p4UBhco4001230@demeter2.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A logic error in mwait_play_dead() causes the kernel to use mwait
even on cpus which don't support it, such as KVM virtual cpus.

Introduced by 349c004e3d31fd.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=36222

Reported-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eefd967..33a0c11 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1332,7 +1332,7 @@ static inline void mwait_play_dead(void)
 	void *mwait_ptr;
 	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c))
+	if (!(this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c)))
 		return;
 	if (!this_cpu_has(X86_FEATURE_CLFLSH))
 		return;
-- 
1.7.5.3

