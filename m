Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0E2H3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 03:29:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57643 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0E2H3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 03:29:51 -0400
Date: Sat, 29 May 2010 09:29:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] perf tools: Make target to generate self contained
	source tarball
Message-ID: <20100529072948.GE16257@merkur.ravnborg.org>
References: <20100528185357.GA28009@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528185357.GA28009@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 03:53:57PM -0300, Arnaldo Carvalho de Melo wrote:
> Hi Michal, Sam,
> 
> 	Are you OK with with this change?

No - I do not like it :-)

But I like the concept.

We have some minimal infrastructure to support packaging
and this seems like an OK fit for this too.
Only drawback is that you need to configure your kernel
before you can pack the source tarball.

Moving the packaging support to scripts/package/
avoiding any changes to the top-level Makefile.

Appended is my attemt to add it to said file.
But my git did not support the '-o' option so it is untested.

To apply it you need your MANIFEST file (obviously).

Help will say:
$ make help | grep perf
  perf-pkg        - Build perf-2.6.34.tar.gz source tarball


You may consider to restructure cmd_perf a little so
it exits on error. I just did the quick version here.

	Sam



diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 62fcc3a..475f023 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -111,6 +111,24 @@ tar%pkg: FORCE
 clean-dirs += $(objtree)/tar-install/
 
 
+# perf-pkg - generate a source tarball with perf source
+# ---------------------------------------------------------------------------
+perf-tar=perf-$(KERNELVERSION)
+
+quiet_cmd_perf = TAR
+      cmd_perf = \
+git archive --prefix=$(perf-tar)/ HEAD^{tree}                      \
+            $$(cat tools/perf/MANIFEST) -o $(perf-tar).tar;        \
+mkdir -p $(perf-tar);                                              \
+git rev-parse HEAD > $(perf-tar)/HEAD;                             \
+tar rf $(perf-tar).tar $(perf-tar)/HEAD;                           \
+rm -r $(perf-tar);                                                 \
+gzip -f -9 $(perf-tar).tar
+
+
+perf-pkg: FORCE
+	$(call cmd,perf)
+
 # Help text displayed when executing 'make help'
 # ---------------------------------------------------------------------------
 help: FORCE
@@ -120,4 +138,5 @@ help: FORCE
 	@echo '  tar-pkg         - Build the kernel as an uncompressed tarball'
 	@echo '  targz-pkg       - Build the kernel as a gzip compressed tarball'
 	@echo '  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball'
+	@echo '  perf-pkg        - Build $(perf-tar).tar.gz source tarball'
 
