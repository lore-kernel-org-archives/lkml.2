Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab2BJRjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2BJRjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:39:53 -0500
Date: Fri, 10 Feb 2012 18:33:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Chris Evans <scarybeasts@gmail.com>,
        Indan Zupancic <indan@nul.nu>
Subject: [PATCH 2/2] ptrace: don't send SIGTRAP on exec if SEIZED
Message-ID: <20120210173319.GH8908@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <20120210173237.GF8908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210173237.GF8908@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_event(PTRACE_EVENT_EXEC) sends SIGTRAP if PT_TRACE_EXEC is
not set. This is because this SIGTRAP predates PTRACE_O_TRACEEXEC
option, we do not need/want this with PT_SEIZED which can set the
options during attach.

Suggested-by: Pedro Alves <palves@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 6dffe18..407c678 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -194,9 +194,10 @@ static inline void ptrace_event(int event, unsigned long message)
 	if (unlikely(ptrace_event_enabled(current, event))) {
 		current->ptrace_message = message;
 		ptrace_notify((event << 8) | SIGTRAP);
-	} else if (event == PTRACE_EVENT_EXEC && unlikely(current->ptrace)) {
+	} else if (event == PTRACE_EVENT_EXEC) {
 		/* legacy EXEC report via SIGTRAP */
-		send_sig(SIGTRAP, current, 0);
+		if ((current->ptrace & (PT_PTRACED|PT_SEIZED)) == PT_PTRACED)
+			send_sig(SIGTRAP, current, 0);
 	}
 }
 
-- 
1.5.5.1


