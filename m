Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2K2Odt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:33:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2K2Ods (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:33:48 -0500
Date: Thu, 29 Nov 2012 14:40:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf hists: Fix period symbol_conf.field_sep display, again
Message-ID: <20121129134001.GG1096@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <1354110769-2998-4-git-send-email-jolsa@redhat.com>
 <878v9kq1uz.fsf@sejong.aot.lge.com>
 <20121129115344.GB1096@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129115344.GB1096@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:53:44PM +0100, Jiri Olsa wrote:
> On Thu, Nov 29, 2012 at 04:56:04PM +0900, Namhyung Kim wrote:

SNIP

> > > -		if (!sep || !first) {
> > > -			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
> > > -			advance_hpp(hpp, ret);
> > > -			first = false;
> > > -		}
> > > +		ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
> > > +		advance_hpp(hpp, ret);
> > 
> > It will display the separator even before the first column so that the
> > output can be messed up with this.  I can see that there's a bug setting
> > 'first' to false - the line should be moved out of the block otherwise
> > it's pointless since we cannot enter the block.
> 
> hum, I'll retest

you're right, fix is attached

Arnaldo, I know you've already pulled this one.. I can resend v2
if needed, which is shorter (just that 'first = false' move as
Namhyyung said)

thanks,
jirka


---
Last fix of this place was wrong and caused the separator
field to be displayed even before period column.

Should be fixed properly this time by introducing 'first' bool
like on other places doing the same stuff.

Screwed-up-by: Jiri Olsa <jolsa@redhat.com>
Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/ui/hist.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 2447e0c..6e639b5 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -466,13 +466,21 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 	struct perf_hpp_fmt *fmt;
 	char *start = hpp->buf;
 	int ret;
+	bool first = true;
 
 	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
-		ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
-		advance_hpp(hpp, ret);
+		/*
+		 * If there's no field_sep, we still need
+		 * to display initial '  '.
+		 */
+		if (!sep || !first) {
+			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
+			advance_hpp(hpp, ret);
+		} else
+			first = false;
 
 		if (color && fmt->color)
 			ret = fmt->color(hpp, he);
-- 
1.7.11.7
