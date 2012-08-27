Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2H0RSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:18:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2H0RSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:18:34 -0400
Date: Mon, 27 Aug 2012 10:18:21 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-e3e45c01ae690e65f2650e5288b9af802e95a136@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <20120824133434.GA8014@quad>
References: <20120824133434.GA8014@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Fix microcode revision check for SNB-PEBS
Git-Commit-ID: e3e45c01ae690e65f2650e5288b9af802e95a136
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:18:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3e45c01ae690e65f2650e5288b9af802e95a136
Gitweb:     http://git.kernel.org/tip/e3e45c01ae690e65f2650e5288b9af802e95a136
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 24 Aug 2012 15:34:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 27 Aug 2012 08:48:19 +0200

perf/x86: Fix microcode revision check for SNB-PEBS

The following patch makes the microcode update code path
actually invoke the perf_check_microcode() function and
thus potentially renabling SNB PEBS.

By default, CONFIG_MICROCODE_OLD_INTERFACE is
forced to Y in arch/x86/Kconfig. There is no
way to disable this. That means that the code
path used in arch/x86/kernel/microcode_core.c
did not include the call to perf_check_microcode().

Thus, even though the microcode was updated to a
version that fixes the SNB PEBS problem, perf_event
would still return EOPNOTSUPP when enabling precise
sampling.

This patch simply adds a call to perf_check_microcode()
in the call path used when OLD_INTERFACE=y.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: peterz@infradead.org
Cc: andi@firstfloor.org
Link: http://lkml.kernel.org/r/20120824133434.GA8014@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/microcode_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 4873e62..9e5bcf1 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -225,6 +225,9 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	if (do_microcode_update(buf, len) == 0)
 		ret = (ssize_t)len;
 
+	if (ret > 0)
+		perf_check_microcode();
+
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
