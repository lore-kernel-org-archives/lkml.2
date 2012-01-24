Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2AXXIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:50950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2AXXIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jan Beulich <jbeulich@suse.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf bench: Make "default" memcpy() selection actually use glibc's implementation
Date: Tue, 24 Jan 2012 21:07:55 -0200
Message-Id: <1327446481-5505-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

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
-- 
1.7.9.rc2.1.g69204

