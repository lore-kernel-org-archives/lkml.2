Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2HOQjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:39:32 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44683 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab2HOQja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:39:30 -0400
Date: Wed, 15 Aug 2012 18:39:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120815163923.GD15989@aftab.osrc.amd.com>
References: <20120813132438.GA18990@aftab.osrc.amd.com>
 <1344867782.6935.119.camel@gandalf.stny.rr.com>
 <20120813142909.GC18990@aftab.osrc.amd.com>
 <20120813180249.GB6840@infradead.org>
 <20120815102722.GB4640@aftab.osrc.amd.com>
 <20120815130634.GE2370@infradead.org>
 <20120815131806.GC4640@aftab.osrc.amd.com>
 <1345041485.31459.89.camel@twins>
 <20120815144255.GB15989@aftab.osrc.amd.com>
 <20120815145935.GI2370@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815145935.GI2370@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:59:35AM -0300, Arnaldo Carvalho de Melo wrote:
> Of course! Those are the ultimate kernel killers!

Haha, this is what I'm answering next time I'm asked about what I do for
a living :-).

How about this?

--
From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 13 Aug 2012 10:23:02 -0400
Subject: [PATCH] perf: Let O= makes handle relative paths

When I did a compile of perf using a relative path for the output
directory, the build failed when it tried to compile libtraceevent. This
is because it continues to use the same relative path when the new
working directory is in a different path.

    SUBDIR ../lib/traceevent/
/bin/sh: line 0: cd: ../../../nobackup/perf/: No such file or directory
Makefile:74: *** output directory "../../../nobackup/perf/" does not exist.  Stop.
make: *** [../../../nobackup/perf///libtraceevent.a] Error 2

Make the path used an absolute path when building perf with O=.

Boris:

Teach Makefile to check whether the supplied O= directory exists and
bail out if not. Reportedly, kernel dudes are idiots and need to be
guarded so as not to shoot themselves in the foot when playing in the
sandbox.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/scripts/Makefile.include | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index bde8521d56bb..96ce80a3743b 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,6 +1,8 @@
 ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-	COMMAND_O := O=$(O)
+	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
+	ABSOLUTE_O := $(shell cd $(O) ; pwd)
+	OUTPUT := $(ABSOLUTE_O)/
+	COMMAND_O := O=$(ABSOLUTE_O)
 endif
 
 ifneq ($(OUTPUT),)
-- 
1.7.11.rc1

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
