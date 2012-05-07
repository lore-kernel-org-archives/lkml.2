Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2EGR3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:29:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47397 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2EGR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:29:53 -0400
Date: Mon, 7 May 2012 14:29:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 5/7] perf tools: Introduce perf_target__strerror()
Message-ID: <20120507172946.GC2485@infradead.org>
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
 <1336367344-28071-6-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336367344-28071-6-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 07, 2012 at 02:09:02PM +0900, Namhyung Kim escreveu:
> The perf_target__strerror() sets @buf to a string that
> describes the (perf_target-specific) error condition
> that is passed via @errnum.
> 
> This is similar to strerror_r() and does same thing if
> @errnum has a standard errno value.

This has a problem: why should I be warned when I do, as root:

# perf top -u acme

It warns me that "UID switch overriding SYSTEM", yeah, right that is
what I asked, no need to tell me that :-)

So what is missing in this case is that top starts with system_wide set,
not from the command line.

I.e. if I had asked for:

# perf top --system_wide --user acme

Ok, the warning would make sense.

So just special case this in the top case, I think, like the patch
below, ack?

I'll fold this into this patch and add a [ committer note: ... ]

Ack?

- Arnaldo

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a2518fc..780791f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1257,7 +1257,16 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	setup_browser(false);
 
 	status = perf_target__validate(&top.target);
-	if (status != PERF_ERRNO_TARGET__SUCCESS) {
+	if (status != PERF_ERRNO_TARGET__SUCCESS &&
+	    status != PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM &&
+	    status != PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM) {
+		/*
+ 		 * Top doesn't provide an explicit way to ask for system wide
+ 		 * profiling, it is the default.
+ 		 *
+ 		 * So we shouldn't warn the user when he/she asks for --pid or
+ 		 * --uid.
+ 		 */
 		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
 		ui__warning("%s", errbuf);
 	}
