Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1AaMuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:50:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:33139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1AaMuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:50:05 -0500
Date: Mon, 31 Jan 2011 12:49:08 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Account PERF_RECORD_LOST events in event__process
Message-ID: <tip-ef2bf6d043ac9bd4a6f38d862af407154a4754d9@git.kernel.org>
Git-Commit-ID: ef2bf6d043ac9bd4a6f38d862af407154a4754d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:49:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef2bf6d043ac9bd4a6f38d862af407154a4754d9
Gitweb:     http://git.kernel.org/tip/ef2bf6d043ac9bd4a6f38d862af407154a4754d9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 29 Jan 2011 09:04:40 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 29 Jan 2011 16:24:24 -0200

perf events: Account PERF_RECORD_LOST events in event__process

Right now this function is only used by perf top, that uses PROT_READ
only, i.e. overwrite mode, so no PERF_RECORD_LOST events are generated,
but don't forget those events.

The patch that moved this out of perf top was made so that this routine
could be used by 'perf probe' in the uprobes patchset, so perhaps there
they need to check for LOST events and warn the user, as will be done in
the following patches that will switch 'perf top' to non overwrite mode
(mmap with PROT_READ|PROT_WRITE).

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index e4db8b8..b9d4ac8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -646,6 +646,8 @@ int event__process(event_t *event, struct sample_data *sample,
 	case PERF_RECORD_EXIT:
 		event__process_task(event, sample, session);
 		break;
+	case PERF_RECORD_LOST:
+		event__process_lost(event, sample, session);
 	default:
 		break;
 	}
