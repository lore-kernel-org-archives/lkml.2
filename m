Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2DDUWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab2DDUV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:21:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/8] perf, tool: Fix NULL deref in hists browsing code
Date: Wed,  4 Apr 2012 22:21:31 +0200
Message-Id: <1333570898-10505-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
References: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's an event with no samples in data file, the perf report
command can segfault after entering the event details menu.

Following steps reproduce the issue:

 # ./perf record -e syscalls:sys_enter_kexec_load,syscalls:sys_enter_mmap ls
 # ./perf report
 # enter '0 syscalls:sys_enter_kexec_load' menu
 # pres ENTER twice

Above steps are valid assuming ls wont run kexec.. ;)

The check for sellection to be NULL is missing. The fix makes sure
it's being check. Above steps now endup with menu being displayed
allowing 'Exit' as the only option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index d7a1c4a..2f83e5d 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -125,6 +125,9 @@ static int callchain__count_rows(struct rb_root *chain)
 
 static bool map_symbol__toggle_fold(struct map_symbol *self)
 {
+	if (!self)
+		return false;
+
 	if (!self->has_children)
 		return false;
 
-- 
1.7.7.6

