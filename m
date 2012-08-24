Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab2HXNel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:34:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37545 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983Ab2HXNej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:34:39 -0400
Date: Fri, 24 Aug 2012 15:34:34 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, andi@firstfloor.org,
        borislav.petkov@amd.com
Subject: [PATCH] perf/x86: fix microcode revision check for SNB-PEBS
Message-ID: <20120824133434.GA8014@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch, relative to 3.6.0-rc3, makes
the microcode update code path actually invoke the
perf_check_microcode() function and thus potentially
renabling SNB PEBS.

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
---

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
 
