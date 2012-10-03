Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2JCK3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab2JCK3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:29:37 -0400
Date: Wed, 3 Oct 2012 12:29:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ben Guthro <ben.guthro@gmail.com>, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf tool: Fix build for NO_DWARF=1 case
Message-ID: <20121003102928.GA945@krava.brq.redhat.com>
References: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
 <1349148496-sup-4820@delenn.ozlabs.ibm.com>
 <CAOvdn6VELd9vPGyptmeBePsNsnQNtgXdgj4bYRfuLyz0cXsD9w@mail.gmail.com>
 <20121002131049.GC6379@krava.brq.redhat.com>
 <20121002214536.GA23354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121002214536.GA23354@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:45:36PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 02, 2012 at 03:10:49PM +0200, Jiri Olsa escreveu:
> > On Tue, Oct 02, 2012 at 07:39:23AM -0400, Ben Guthro wrote:
> > > Actually - I hadn't noticed these warnings before.
> 
> > > After installing libdw-dev - the perf build completed successfully.
> > > Perhaps this should be fatal, rather than a warning?
> 
> > attached patch fixies the issue for me. Adding Arnaldo to the loop.
> 
> [acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
> cc1: warnings being treated as errors
> arch/x86/util/dwarf-regs.c:72: error: no previous prototype for ‘get_arch_regstr’
> make: *** [/home/acme/git/build/perf/arch/x86/util/dwarf-regs.o] Error 1
> make: *** Waiting for unfinished jobs....
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@sandy linux]$
> 
> - Arnaldo

ugh.. forgot the way you build perf ;)
(also smells like 'automated make test' adept)

Anyway, there's Makefile dependency on PERF_HAVE_DWARF_REGS which
is defined in arch/x86/Makefile.

So, there's only one right place for '-include arch/$(ARCH)/Makefile'.
We should think of some other solution, since this seems fragile.

I checked your make and simple make with attached patch
(only x86_64 arch, and with and without libdw installed).

jirka


---
We need to include arch Makefile after we decide the NO_DWARF,
otherwise we get might get build failure.

The reason is the arch Makefile could include objects based on
the NO_DWARF value, as it is for x86 case.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6958ba4..c287c1d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -505,8 +505,6 @@ ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
 endif # Libunwind support
 endif # NO_LIBUNWIND
 
--include arch/$(ARCH)/Makefile
-
 ifneq ($(OUTPUT),)
 	BASIC_CFLAGS += -I$(OUTPUT)
 endif
@@ -539,6 +537,8 @@ ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 	NO_DWARF := 1
 endif # Dwarf support
 
+-include arch/$(ARCH)/Makefile
+
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-- 
1.7.11.4

