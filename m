Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1CXNra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:47:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:47497 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab1CXNr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="407932756"
Subject: Re: [PATCH] perf probe: Add fastpath to do lookup by function name
From: Lin Ming <ming.m.lin@intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4D8B0A13.8000008@hitachi.com>
References: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
	 <4D8B0A13.8000008@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 21:47:28 +0800
Message-Id: <1300974448.2283.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 17:08 +0800, Masami Hiramatsu wrote:
> (2011/03/25 0:38), Lin Ming wrote:
> > The vmlinux file may have thousands of CUs.
> > We can lookup function name from .debug_pubnames section
> > to avoid the slow loop on CUs.
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  tools/perf/util/probe-finder.c |   38 ++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/probe-finder.h |    1 +
> >  2 files changed, 39 insertions(+), 0 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > index 194f9e2..b2034c2 100644
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -1876,6 +1876,30 @@ static int find_line_range_by_func(struct line_finder *lf)
> >  	return param.retval;
> >  }
> >  
> > +static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
> > +{
> > +	struct line_finder *lf = data;
> > +	struct line_range *lr = lf->lr;
> > +
> > +	if (dwarf_offdie(dbg, gl->die_offset, &lf->sp_die)) {
> > +		if (dwarf_tag(&lf->sp_die) != DW_TAG_subprogram)
> > +			return DWARF_CB_OK;
> > +
> > +		if (die_compare_name(&lf->sp_die, lr->function)) {
> > +			if (!dwarf_offdie(dbg, gl->cu_offset, &lf->cu_die))
> > +				return DWARF_CB_OK;
> > +
> 
> Just one comment.
> Could you ensure that the decl_file of sp_die matches lr->file (by strtailcmp) here?

OK, so the file name compare with cu_find_realpath(..) can be removed,
as below.

This makes the lookup a bit more faster again.

Thanks, I'll post a new version with below changes.

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index b2034c2..38e4a05 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1880,6 +1880,7 @@ static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
 {
 	struct line_finder *lf = data;
 	struct line_range *lr = lf->lr;
+	const char *file;
 
 	if (dwarf_offdie(dbg, gl->die_offset, &lf->sp_die)) {
 		if (dwarf_tag(&lf->sp_die) != DW_TAG_subprogram)
@@ -1889,8 +1890,12 @@ static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
 			if (!dwarf_offdie(dbg, gl->cu_offset, &lf->cu_die))
 				return DWARF_CB_OK;
 
-			if (lr->file && !cu_find_realpath(&lf->cu_die, lr->file))
-				return DWARF_CB_OK;
+			if (lr->file) {
+				file = dwarf_decl_file(&lf->sp_die);
+
+				if (file && strtailcmp(file, lr->file))
+					return DWARF_CB_OK;
+			}
 
 			lf->found = 1;
 			return DWARF_CB_ABORT;




