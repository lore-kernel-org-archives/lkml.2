Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2JROiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:38:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:60486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2JROiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:38:50 -0400
Date: Thu, 18 Oct 2012 11:38:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
Message-ID: <20121018143835.GE2057@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
 <1350494387-10987-10-git-send-email-acme@infradead.org>
 <87y5j41rw5.fsf@sejong.aot.lge.com>
 <20121018140033.GC2057@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20121018140033.GC2057@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Thu, Oct 18, 2012 at 11:00:33AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Oct 18, 2012 at 10:38:18AM +0900, Namhyung Kim escreveu:
> > On Wed, 17 Oct 2012 14:19:45 -0300, Arnaldo Carvalho de Melo wrote:
> > I got a build error after adding 'extern unsigned int page_size' to
> > util/python.c - please see my previous reply.
> > 
> >   namhyung@sejong:perf$ make
> >       SUBDIR ../lib/traceevent/
> >       LINK perf
> >       GEN python/perf.so
> >   gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
> >   error: command 'gcc' failed with exit status 1
> >   cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
> >   make: *** [python/perf.so] Error 1
> >   TRACE_EVENT_DIR = ../lib/traceevent/
   
> >   ifneq ($(OUTPUT),)
> >   	TE_PATH=$(OUTPUT)
> >   else
> >   	TE_PATH=$(TRACE_EVENT_DIR)
> >   endif
> >   
> >   LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
> 
> I see, so we need to somehow propagate this TE_PATH variable to the setup.py file...

Can you try with the attached patch? I tested it here and works with:

 make -C tools/perf

and with O=

- Arnaldo

--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="python-libtraceevent.patch"

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f9126f8..c1c6e11 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -184,9 +184,22 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+TRACE_EVENT_DIR = ../lib/traceevent/
+
+ifneq ($(OUTPUT),)
+	TE_PATH=$(OUTPUT)
+else
+	TE_PATH=$(TRACE_EVENT_DIR)
+endif
+
+LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
+TE_LIB := -L$(TE_PATH) -ltraceevent
+
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
+export LIBTRACEEVENT
+
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
@@ -198,17 +211,6 @@ $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-TRACE_EVENT_DIR = ../lib/traceevent/
-
-ifneq ($(OUTPUT),)
-	TE_PATH=$(OUTPUT)
-else
-	TE_PATH=$(TRACE_EVENT_DIR)
-endif
-
-LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
-TE_LIB := -L$(TE_PATH) -ltraceevent
-
 #
 # Single 'perf' binary right now:
 #
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 09c3cea..73d5102 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -23,6 +23,7 @@ cflags += getenv('CFLAGS', '').split()
 
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
+libtraceevent = getenv('LIBTRACEEVENT')
 
 ext_sources = [f.strip() for f in file('util/python-ext-sources')
 				if len(f.strip()) > 0 and f[0] != '#']
@@ -31,7 +32,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
-		  extra_objects = [build_tmp + '/../../libtraceevent.a'],
+		  extra_objects = [libtraceevent],
                  )
 
 setup(name='perf',

--kXdP64Ggrk/fb43R--
