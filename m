Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab2IGJFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:05:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2IGJE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:04:57 -0400
Date: Fri, 7 Sep 2012 02:04:41 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-d4c9dbc61fe0ca042b835c6f234af12fa5f18310@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, alex.shi@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        alex.shi@intel.com
In-Reply-To: <5049B65C020000780009990C@nat28.tlf.novell.com>
References: <5049B65C020000780009990C@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Fix range check in tlbflush debugfs interface
Git-Commit-ID: d4c9dbc61fe0ca042b835c6f234af12fa5f18310
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 07 Sep 2012 02:04:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4c9dbc61fe0ca042b835c6f234af12fa5f18310
Gitweb:     http://git.kernel.org/tip/d4c9dbc61fe0ca042b835c6f234af12fa5f18310
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 7 Sep 2012 07:54:52 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 7 Sep 2012 10:56:02 +0200

x86/mm: Fix range check in tlbflush debugfs interface

Since the shift count settable there is used for shifting values
of type "unsigned long", its value must not match or exceed
BITS_PER_LONG (otherwise the shift operations are undefined).

Similarly, the value must not be negative (but -1 must be
permitted, as that's the value used to distinguish the case of
the fine grained flushing being disabled).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/5049B65C020000780009990C@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/tlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..a085c56 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -320,7 +320,7 @@ static ssize_t tlbflush_write_file(struct file *file,
 	if (kstrtos8(buf, 0, &shift))
 		return -EINVAL;
 
-	if (shift > 64)
+	if (shift < -1 || shift >= BITS_PER_LONG)
 		return -EINVAL;
 
 	tlb_flushall_shift = shift;
