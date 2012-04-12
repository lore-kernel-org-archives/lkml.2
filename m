Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab2DLMVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 08:21:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063Ab2DLMVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 08:21:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] perf, tool: Force guest machine definition option
Date: Thu, 12 Apr 2012 14:21:00 +0200
Message-Id: <1334233262-5679-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 'perf kvm record' without any of following options:
  --guestmount
  --guestvmlinux
  --guestkallsyms
  --guestmodules

is causing the guest machine to be ommited from the data file,
and all guest samples are counted in nr_unprocessable_samples.

This patch makes sure the 'perf kvm record' command is not
let through until one of the above option is specified.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-kvm.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9fc6e0f..559d468 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -53,6 +53,16 @@ static int __cmd_record(int argc, const char **argv)
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
 
+	if (perf_guest &&
+	    !(symbol_conf.guestmount ||
+	      symbol_conf.default_guest_vmlinux_name ||
+	      symbol_conf.default_guest_modules ||
+	      symbol_conf.default_guest_kallsyms)) {
+		ui__warning("You need to define guest with one of guestmount|"
+			    "guestvmlinux|guestkallsyms|guestmodules\n");
+		return -EINVAL;
+	}
+
 	rec_argc = argc + 2;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	rec_argv[i++] = strdup("record");
-- 
1.7.1

