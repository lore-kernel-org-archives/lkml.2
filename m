Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab2CSTrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:47:31 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:53670 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2CSTr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:47:29 -0400
Date: Mon, 19 Mar 2012 20:47:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Colin Walters <walters@verbum.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20120319194725.GA31940@gmail.com>
References: <1332184368-1655-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332184368-1655-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling, now there are two pull request worth of
> changesets in my perf/core branch,
> 
> - Arnaldo
> 
> The following changes since commit 6db6127c4dad634ab98709b81e2f2770890b0d53:
> 
>   perf report: Treat an argument as a symbol filter (2012-03-16 16:44:36 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to c31a94570552dcaa517c4f7a043ffd28835016be:
> 
>   perf report: Add a simple GTK2-based 'perf report' browser (2012-03-19 15:13:29 -0300)
> 
> ----------------------------------------------------------------
> Fixes for the last batch from Namhyung and the initial GTK report browser
> from Pekka.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (2):
>       perf ui browser: Clean lines inside of the input window
>       perf report: Document --symbol-filter option
> 
> Pekka Enberg (1):
>       perf report: Add a simple GTK2-based 'perf report' browser
> 
>  tools/perf/Documentation/perf-report.txt |    5 +
>  tools/perf/Makefile                      |   14 +++
>  tools/perf/builtin-report.c              |   19 ++-
>  tools/perf/config/feature-tests.mak      |   15 +++
>  tools/perf/util/cache.h                  |   12 ++
>  tools/perf/util/gtk/browser.c            |  189 ++++++++++++++++++++++++++++++
>  tools/perf/util/gtk/gtk.h                |    8 ++
>  tools/perf/util/hist.h                   |   17 +++
>  tools/perf/util/ui/util.c                |   10 +-
>  9 files changed, 282 insertions(+), 7 deletions(-)
>  create mode 100644 tools/perf/util/gtk/browser.c
>  create mode 100644 tools/perf/util/gtk/gtk.h

Pulled, thanks Arnaldo!

I noticed that there's no help text for GTK support - how will a 
user find that 'perf report --gtk' will do something nice?

Another detail is that if GTK support is not compiled in:

Makefile:515: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev

then the --gtk output is not very informative:

  earth5:~/tip/tools/perf> perf report --gtk
  earth5:~/tip/tools/perf> 

:-)

A third detail, I do have gtk2-devel installed:

 Package gtk2-devel-2.24.10-1.fc17.x86_64 already installed and latest version

yet I got the above message.

It is not easy to figure out *why* a feature test failed, 
unfortunately. It would be nice if V=1 or something like that 
would output the failure.

I applied the hack below and ran the gtk testcase, which gave:

earth5:~/tip/tools/perf> . ./test.4273.sh
In file included from /usr/lib64/glib-2.0/include/glibconfig.h:9:0,
                 from /usr/include/glib-2.0/glib/gtypes.h:34,
                 from /usr/include/glib-2.0/glib/galloca.h:34,
                 from /usr/include/glib-2.0/glib.h:32,
                 from /usr/include/glib-2.0/gobject/gbinding.h:30,
                 from /usr/include/glib-2.0/glib-object.h:25,
                 from /usr/include/glib-2.0/gio/gioenums.h:30,
                 from /usr/include/glib-2.0/gio/giotypes.h:30,
                 from /usr/include/glib-2.0/gio/gio.h:28,
                 from /usr/include/gtk-2.0/gdk/gdkapplaunchcontext.h:30,
                 from /usr/include/gtk-2.0/gdk/gdk.h:32,
                 from /usr/include/gtk-2.0/gtk/gtk.h:32,
                 from test.4273.c:2:
/usr/include/glib-2.0/glib/gmacros.h:346:7: error: "_MSC_VER" is not defined [-Werror=undef]
cc1: all warnings being treated as errors

Which allowed me to fix the feature test and the gtk.h include 
file wrapper via the second patch below.

And then I was greeted by the GTK report window on 'perf report 
--gtk' ;-)

Thanks,

	Ingo

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 8046182..68cf795 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -183,6 +183,8 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
 	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
+	 echo "$(1)" > test.$$$$.c;					  \
+	 echo $(CC) -x c test.$$$$.c $(2) -o "$$TMP" > test.$$$$.sh;		  \
 	 echo "$(1)" |						  \
 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
 	 rm -f "$$TMP"')

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index d9084e0..ae8b471 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -68,7 +68,9 @@ endif
 ifndef NO_GTK2
 define SOURCE_GTK2
 #pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
+#pragma GCC diagnostic ignored \"-Wundef\"
 #include <gtk/gtk.h>
+#pragma GCC diagnostic error \"-Wundef\"
 #pragma GCC diagnostic error \"-Wstrict-prototypes\"
 
 int main(int argc, char *argv[])
diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/util/gtk/gtk.h
index 75177ee..c7a941f 100644
--- a/tools/perf/util/gtk/gtk.h
+++ b/tools/perf/util/gtk/gtk.h
@@ -2,7 +2,9 @@
 #define _PERF_GTK_H_ 1
 
 #pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#pragma GCC diagnostic ignored "-Wundef"
 #include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wundef"
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
 #endif /* _PERF_GTK_H_ */
