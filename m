Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2JBNLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab2JBNK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:10:59 -0400
Date: Tue, 2 Oct 2012 15:10:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ben Guthro <ben.guthro@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tool: Fix build for NO_DWARF=1 case
Message-ID: <20121002131049.GC6379@krava.brq.redhat.com>
References: <CAOvdn6WPUDqYPpHZip7dxVVXJXT0-zJOUCpgDGb=o+zqq98F0Q@mail.gmail.com>
 <1349148496-sup-4820@delenn.ozlabs.ibm.com>
 <CAOvdn6VELd9vPGyptmeBePsNsnQNtgXdgj4bYRfuLyz0cXsD9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOvdn6VELd9vPGyptmeBePsNsnQNtgXdgj4bYRfuLyz0cXsD9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 07:39:23AM -0400, Ben Guthro wrote:
> Hi Ian,
> 
> Once again - apologies for multiple copies of this email. Please reply
> to this (plain text) version so it will get through LKML filters.
> 
> On Tue, Oct 2, 2012 at 12:24 AM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> >
> >
> > >  CC arch/x86/util/dwarf-regs.o
> >
> > Is this correct? i.e. Are you building perf for x86?
> 
> Yes, x86_64, specifically.
> 
> >
> > What commandline are you using to build?
> 
> cd /data/home/bguthro/dev/orc-newdev.git/linux/build/tools/tools/perf
> && make EXTRAVERSION=-orc
> 
> >
> > Any exported environment variables that may be relevant?
> 
> none that I can think of.
> 
> >
> > What dev libraries does perf warn is missing (Is libdw-dev among them)?
> 
> make[3]: Entering directory
> `/data/home/bguthro/dev/orc-newdev.git/linux/build/tools/tools/perf'
> Makefile:502: No libunwind found, disabling post unwind support.
> Please install libunwind-dev[el] >= 0.99
> Makefile:537: No libdw.h found or old libdw.h found or elfutils is
> older than 0.138, disables dwarf support. Please install new
> elfutils-devel/libdw-dev
> Makefile:567: No libaudit.h found, disables 'trace' tool, please
> install audit-libs-devel or libaudit-dev
> Makefile:580: newt not found, disables TUI support. Please install
> newt-devel or libnewt-dev
> Makefile:752: No bfd.h/libbfd found, install
> binutils-dev[el]/zlib-static to gain symbol demangling
> 
> Actually - I hadn't noticed these warnings before.
> 
> After installing libdw-dev - the perf build completed successfully.
> Perhaps this should be fatal, rather than a warning?
> 
> Thanks for your help
> 
> Ben

hi,
attached patch fixies the issue for me. Adding Arnaldo to the loop.

jirka


---
We need to include arch Makefile after we decide the NO_DWARF value,
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
index 6958ba4..0ca8f45 100644
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
@@ -635,6 +633,8 @@ else
 	endif
 endif
 
+-include arch/$(ARCH)/Makefile
+
 disable-python = $(eval $(disable-python_code))
 define disable-python_code
   BASIC_CFLAGS += -DNO_LIBPYTHON
-- 
1.7.11.4

