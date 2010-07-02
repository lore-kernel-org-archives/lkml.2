Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0GBOYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:24:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0GBOYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:24:04 -0400
Subject: Re: [PATCH] perf wrong branches event on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
	 <1278070727.1917.253.camel@laptop>
	 <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 16:23:33 +0200
Message-ID: <1278080613.1917.258.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 09:56 -0400, Vince Weaver wrote:
> You think I have root on this machine?

Well yeah,.. I'd not want a dev job and not have full access to the
hardware. But then, maybe I'm picky.

> In any case, yes, there's the "-r" option.  Fun.  I get to modify all my 
> scripts to have some complicated case... "if AMD machine and if kernel is 
> new enough"... how new?  It gets confusing once things get backported to 
> stable.  As far as I know there's no way to get a kernel to spit out what 
> raw events it's using for the predefined events.

You can stick the knowledge in perf if you really want to.. something
like the below, add something that parses cpuid or /proc/cpuinfo and you
should be good.

---
 tools/perf/util/parse-events.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c
b/tools/perf/util/parse-events.c
index 4af5bd5..800f864 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -771,6 +771,22 @@ parse_event_symbols(const char **str, struct
perf_event_attr *attr)
 modifier:
 	parse_event_modifier(str, attr);
 
+	if (attr->type == PERF_TYPE_HARDWARE) {
+		switch (attr->config) {
+		case PERF_COUNT_HW_BRANCH_INSTRUCTIONS:
+			attr->type = PERF_TYPE_RAW;
+			attr->config = 0x00c2;
+			break;
+		case PERF_COUNT_HW_BRANCH_MISSES:
+			attr->type = PERF_TYPE_RAW;
+			attr->config = 0x00c3;
+			break;
+
+		default:
+			break;
+		}
+	}
+
 	return ret;
 }
 
> If the solution really is to use raw events in a case like this, I 
> question why the predefined events are in the kernel at all.  Pretty much 
> anyone using the braches event on an AMD machine is going to be getting 
> wrong results for all kernels between 2.6.31 and 2.6.35 and not even know 
> it unless they read the kernel list. 

And how would it be different if it the data table lived in userspace?
They'd still get the wrong thing unless they updated.
