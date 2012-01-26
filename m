Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab2AZNb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:31:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2AZNby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:31:54 -0500
Date: Thu, 26 Jan 2012 05:31:30 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-9ea811973d49a1df0be04ff6e4df449e4fca4fb5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F16D6FD020000780006D72F@nat28.tlf.novell.com>
References: <4F16D6FD020000780006D72F@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Make "default" memcpy()
  selection actually use glibc's implementation
Git-Commit-ID: 9ea811973d49a1df0be04ff6e4df449e4fca4fb5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:31:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ea811973d49a1df0be04ff6e4df449e4fca4fb5
Gitweb:     http://git.kernel.org/tip/9ea811973d49a1df0be04ff6e4df449e4fca4fb5
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 18 Jan 2012 13:28:13 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Jan 2012 19:50:19 -0200

perf bench: Make "default" memcpy() selection actually use glibc's implementation

Since arch/x86/lib/memcpy_64.S implements not only __memcpy, but also
memcpy, without further precautions this function will get chose by the
static linker for resolving all references, and hence the "default"
measurement didn't really measure anything else than the
"x86-64-unrolled" one.

Fix this by renaming (through the pre-processor) the conflicting symbol.

On my Westmere system, the glibc variant turns out to require about 4%
less instructions, but 15% more cycles for the default 1Mb block size
measured.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F16D6FD020000780006D72F@nat28.tlf.novell.com
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index a57b66e..384b607 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,2 @@
-
+#define memcpy MEMCPY /* don't hide glibc's memcpy() */
 #include "../../../arch/x86/lib/memcpy_64.S"
