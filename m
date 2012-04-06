Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2DFLkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:40:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38951 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2DFLkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:40:35 -0400
Date: Fri, 6 Apr 2012 13:40:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
Message-ID: <20120406114031.GC30425@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <srostedt@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
	Namhyung Kim <namhyung.kim@lge.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 12:47:53AM +0200, Frederic Weisbecker wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Copy over the files from trace-cmd to the Linux tools directory
> such that applications like perf and latencytrace can use the
> more advanced parsing code.
> 
> Because some of the file names of perf conflict with trace-cmd file
> names, the trace-cmd files have been renamed as follows:
> 
>  parse-events.c ==> event-parse.c
>  parse-events.h ==> event-parse.h
>  utils.h        ==> event-utils.h
> 
> The files have been updated to handle the changes to the header files
> but other than that, they are identical to what was in the trace-cmd
> repository. The history of these files, including authorship is
> available at the git repo:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> 
> The Makefile was also copied over, but most of it was removed to
> focus on the parse-events code first. The parts of the Makefile for
> the plugins have also been removed, but will be added back when the
> plugin code is copied over as well. But that may be in its own
> separate directory.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/lib/traceevent/Makefile       |  303 +++
>  tools/lib/traceevent/event-parse.c  | 4971 +++++++++++++++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.h  |  806 ++++++
>  tools/lib/traceevent/event-utils.h  |   64 +
>  tools/lib/traceevent/parse-filter.c | 2262 ++++++++++++++++
>  tools/lib/traceevent/parse-utils.c  |  110 +
>  tools/lib/traceevent/trace-seq.c    |  199 ++
>  7 files changed, 8715 insertions(+), 0 deletions(-)
>  create mode 100644 tools/lib/traceevent/Makefile
>  create mode 100644 tools/lib/traceevent/event-parse.c
>  create mode 100644 tools/lib/traceevent/event-parse.h
>  create mode 100644 tools/lib/traceevent/event-utils.h
>  create mode 100644 tools/lib/traceevent/parse-filter.c
>  create mode 100644 tools/lib/traceevent/parse-utils.c
>  create mode 100644 tools/lib/traceevent/trace-seq.c
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> new file mode 100644
> index 0000000..3d69aa9
> --- /dev/null
> +++ b/tools/lib/traceevent/Makefile
> @@ -0,0 +1,303 @@
> +# trace-cmd version
> +EP_VERSION = 1
> +EP_PATCHLEVEL = 1
> +EP_EXTRAVERSION = 0
> +
> +# file format version
> +FILE_VERSION = 6
> +
> +MAKEFLAGS += --no-print-directory
> +
> +
> +# Makefiles suck: This macro sets a default value of $(2) for the
> +# variable named by $(1), unless the variable has been set by
> +# environment or command line. This is necessary for CC and AR
> +# because make sets default values, so the simpler ?= approach
> +# won't work as expected.
> +define allow-override
> +  $(if $(or $(findstring environment,$(origin $(1))),\
> +            $(findstring command line,$(origin $(1)))),,\
> +    $(eval $(1) = $(2)))
> +endef
> +
> +# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
> +$(call allow-override,CC,$(CROSS_COMPILE)gcc)
> +$(call allow-override,AR,$(CROSS_COMPILE)ar)
> +
> +EXT = -std=gnu99
> +INSTALL = install
> +
> +# Use DESTDIR for installing into a different root directory.
> +# This is useful for building a package. The program will be
> +# installed in this directory as if it was the root directory.
> +# Then the build tool can move it later.
> +DESTDIR ?=
> +DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
> +
> +prefix ?= /usr/local
> +bindir_relative = bin
> +bindir = $(prefix)/$(bindir_relative)
> +man_dir = $(prefix)/share/man
> +man_dir_SQ = '$(subst ','\'',$(man_dir))'
> +html_install = $(prefix)/share/kernelshark/html
> +html_install_SQ = '$(subst ','\'',$(html_install))'
> +img_install = $(prefix)/share/kernelshark/html/images
> +img_install_SQ = '$(subst ','\'',$(img_install))'
> +
> +export man_dir man_dir_SQ html_install html_install_SQ INSTALL
> +export img_install img_install_SQ
> +export DESTDIR DESTDIR_SQ
> +
> +# copy a bit from Linux kbuild

FWIW, I'm moving all the Kbuild-related stuff into
tools/scripts/Makefile.include: http://lkml.org/lkml/2012/3/23/167
so it could shave off a couple of lines from this one here.

-- 
Regards/Gruss,
    Boris.
