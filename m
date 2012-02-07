Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2BGTfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:35:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:35:43 -0500
Date: Tue, 7 Feb 2012 11:35:26 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-bf32c9ebc9890764c7a9984e3a0c8a57a059753d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1328461865-6127-1-git-send-email-jolsa@redhat.com>
References: <1328461865-6127-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix prefix matching for kernel maps
Git-Commit-ID: bf32c9ebc9890764c7a9984e3a0c8a57a059753d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:35:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf32c9ebc9890764c7a9984e3a0c8a57a059753d
Gitweb:     http://git.kernel.org/tip/bf32c9ebc9890764c7a9984e3a0c8a57a059753d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 5 Feb 2012 18:11:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Feb 2012 18:57:39 -0200

perf tools: Fix prefix matching for kernel maps

In some perf ancient versions we used '[kernel.kallsyms._text]' as the
name for the kernel map.

This got changed with commit:
  perf: 'perf kvm' tool for monitoring guest performance from host
  commit a1645ce12adb6c9cc9e19d7695466204e3f017fe
  Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

and we started to use following name '[kernel.kallsyms]_text'.

This name change is important for the report code dealing with ancient
perf data. When processing the kernel map event, we need to recognize
the old naming (dont match the last ']') and initialize the kernel map
correctly.

The subsequent call to maps__set_kallsyms_ref_reloc_sym deals with the
superfluous ']' to get correct symbol name.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328461865-6127-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 73ddaf0..2044324 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -554,7 +554,7 @@ static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
 
 	is_kernel_mmap = memcmp(event->mmap.filename,
 				kmmap_prefix,
-				strlen(kmmap_prefix)) == 0;
+				strlen(kmmap_prefix) - 1) == 0;
 	if (event->mmap.filename[0] == '/' ||
 	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
 
