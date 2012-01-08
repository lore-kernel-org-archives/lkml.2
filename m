Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2AHJCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 04:02:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2AHJCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 04:02:21 -0500
Date: Sun, 8 Jan 2012 10:00:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [ERROR] perf build failure on current tip:perf/core
Message-ID: <20120108090018.GB7168@elte.hu>
References: <1325950949.1486.20.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325950949.1486.20.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@gmail.com> wrote:

> Hi,
> 
> When I tried to build perf, I was faced with following error:
> 
>     CC util/trace-event-info.o
> cc1: warnings being treated as errors
> util/trace-event-info.c: In function ‘record_file’:
> util/trace-event-info.c:192: error: implicit declaration of function
> ‘pwrite’
> util/trace-event-info.c:192: error: nested extern declaration of
> ‘pwrite’
> make: *** [util/trace-event-info.o] Error 1
> 
> The code I tried was latest tip:perf/core - 9e183426bfb5 ("perf kvm: Fix
> copy & paste error in description") and code in mainline (v3.2) doesn't
> have this problem. Looking at the code, I couldn't find any clue to
> this. Any idea?
> 
> FYI, my system is Ubuntu 10.04 on x86_64. gcc version is 4.4.3:

Which header does pwrite() belong to on that system - what does 
'map pwrite' say? It ought to be unistd.h, which is directly 
included in util/trace-event-info.c.

My guess is that it might be related to:

tools/perf/Makefile:ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

Which introduces pwrite64() and defines pwrite() to them.

Does the patch below help? It's only a workaround really as 
pwrite() ought to exist ... Also, i have only tested this on 
64-bit.

Thanks,

	Ingo

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index ac6830d..ba8b024 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -189,7 +189,7 @@ static void record_file(const char *file, size_t hdr_sz)
 	if (bigendian())
 		sizep += sizeof(u64) - hdr_sz;
 
-	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
+	if (hdr_sz && pwrite64(output_fd, sizep, hdr_sz, hdr_pos) < 0)
 		die("writing to %s", output_file);
 }
 
