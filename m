Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2EOOpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:45:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36449 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2EOOo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:44:58 -0400
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1337077973.27694.24.camel@twins>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	 <1336994000.2443.24.camel@twins>  <20120514115551.GA6479@gmail.com>
	 <1337007985.1552.5.camel@leonhard>  <1337077973.27694.24.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 23:44:40 +0900
Message-ID: <1337093080.1493.22.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-05-15 (화), 12:32 +0200, Peter Zijlstra:
> On Tue, 2012-05-15 at 00:06 +0900, Namhyung Kim wrote:
> 
> > perf_evlist__config_attrs() has this:
> > 
> > 	if (evlist->cpus->map[0] < 0)
> > 		opts->no_inherit = true;
> > 
> > meaning that per task profiling won't enable event inheritance. I don't
> > know why it's needed though.
> 
> Because you cannot have inherited per-task counters. It only works for
> per-task-per-cpu counters. Otherwise you'll have a scalability
> nightmare.
> 

Got it. So it means that we do need to create an event for each cpu
in order to profile a task (and its children), right? (Originally, I
thought it's a bug :-p)

If so, yes, the commit 55261f46702c ("perf evlist: Fix creation of
cpu map") should be reverted like below (note that target->cpu_list
check no longer needed since perf_target__validate() will handle
those cases). If it looks ok to you guys, I'll send a formal patch
with name changes (to avoid the double negation suggested by Ingo):


diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1201daf71719..f6979ba391d1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,10 +609,10 @@ int perf_evlist__create_maps(struct perf_evlist 
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (!perf_target__no_cpu(target))
-		evlist->cpus = cpu_map__new(target->cpu_list);
-	else
+	if (!perf_target__no_task(target))
 		evlist->cpus = cpu_map__dummy_new();
+	else
+		evlist->cpus = cpu_map__new(target->cpu_list);
 
 	if (evlist->cpus == NULL)
 		goto out_delete_threads;



-- 
Regards,
Namhyung Kim


