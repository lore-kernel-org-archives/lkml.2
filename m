Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab1AJUA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:00:58 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54232 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1AJUA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Y7gwFyPJpUXvoJvxYcCE66+pdFVZyMqCG0l16PXEQ1sj/Eq9uD7PeNDtas1PbBb+0h
         92y+R1vXY4klMszVuWm6btfGA9pkbDGjVHhDyqkPXu0qbLBPpBFwQQWpYwd5mt/DHIXx
         5EYr3NfwW0m/RoKVhKK8XPuu+Qp+0aEFrS658=
Date: Mon, 10 Jan 2011 18:00:32 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, tzanussi@gmail.com,
        Paul Mackerras <paulus@samba.org>, imunsie@au1.ibm.com,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: perf: commit 55b4462 causes perf record to hang
Message-ID: <20110110200032.GA19703@ghostprotocols.net>
References: <4D2B544F.1050803@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B544F.1050803@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 10, 2011 at 11:47:43AM -0700, David Ahern escreveu:
> With latest version of perf-core branch, a variant of perf record hangs:
> # /tmp/build-perf/perf record -v -e cs -fo /tmp/perf.data  -- sleep 1
> [ perf record: Captured and wrote 0.003 MB /tmp/perf.data (~120 samples) ]
> 
> It sits there forever. Back trace is:
> 
> (gdb) bt
> #0  0x0000000000447658 in __perf_session__process_events (session=0xab9500, data_offset=208, data_size=2896, file_size=3104, ops=0x685580) at util/session.c:1006
> #1  0x00000000004107dd in process_buildids () at builtin-record.c:466
> #2  0x000000000041084d in atexit_header () at builtin-record.c:477
 
> git bisect traced the hang to
> 
> commit 55b44629f599a2305265ae9c77f9d9bcfd6ddc17
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Tue Nov 30 17:49:46 2010 +0000

Can you try with this patch, not reverting tglx's patch?

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6fb4694..313dac2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1007,7 +1007,7 @@ more:
 	if (size == 0)
 		size = 8;
 
-	if (head + event->header.size >= mmap_size) {
+	if (head + event->header.size > mmap_size) {
 		if (mmaps[map_idx]) {
 			munmap(mmaps[map_idx], mmap_size);
 			mmaps[map_idx] = NULL;
