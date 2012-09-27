Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2I0Fty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:49:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:52114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab2I0Ftx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,493,1344236400"; 
   d="scan'208";a="198406861"
Date: Thu, 27 Sep 2012 13:43:31 +0800
From: Feng Tang <feng.tang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        a.p.zijlstra@chello.nl, andi@firstfloor.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] perf hists browser: Add option for runtime
 switching perf data file
Message-ID: <20120927054331.GA10038@feng-i7>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-9-git-send-email-feng.tang@intel.com>
 <87d31ayhpy.fsf@sejong.aot.lge.com>
 <20120925162053.51f60773@feng-i7>
 <20120925111703.GC28902@infradead.org>
 <20120926075707.GA4919@feng-i7>
 <874nmkw1tu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nmkw1tu.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On Thu, Sep 27, 2012 at 01:02:05PM +0900, Namhyung Kim wrote:
> Hi Feng,
> 
> On Wed, 26 Sep 2012 15:57:07 +0800, Feng Tang wrote:
> > On Tue, Sep 25, 2012 at 08:17:03AM -0300, Arnaldo Carvalho de Melo wrote:
> >> Em Tue, Sep 25, 2012 at 04:20:53PM +0800, Feng Tang escreveu:
> >> > On Tue, 25 Sep 2012 11:11:21 +0900
> >> > Namhyung Kim <namhyung@kernel.org> wrote:
> >> > > Ditto.  Plus it might leak previous input_name.
> >> > 
> >> > Nice catch, will check the return value of "strdup". 
> >> > 
> >> > For input_name mem leak, in some cases the input_name can't be called
> >> >  with free(), like those got from parse "-i" option. In case the old
> >> > input_name is got from malloc through strdup, I think it's not a big
> >> > issue given that buffer will be freed any way when the application exit.
> >> 
> >> I think this is a matter of discipline, leaking is bad, kernel or
> >> userspace, why special case it?
> >>
> >
> > I see, then we need make sure all "input_name" point to a malloced buffer, 
> > here is a initial debug patch will only touch the annotate/report/script
> > cmds, pls review and more suggestions are welcomed:
> 
> Well, how about adding a flag like "input_name_alloced" and checking it
> before new allocation?  This way we can avoid needless strdup when
> runtime switching is not used.

Right, myself have checked that only the runtime switch will malloc a
buffer for the new "input_name", IOW "input_name" in other case can't be
called with free(). So one flag only inside hists.c is ok to cover this,
like the following code.

btw, thanks for your patch about the parse-events()! will try it out.

- Feng

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 6048820..c29335a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1125,6 +1125,13 @@ static inline void free_popup_options(char **options, int n)
 	}
 }
 
+/*
+ * Only runtime switching of perf data file will make "input_name" point
+ * to a malloced buffer. So add "is_input_name_malloced" flag to decide
+ * whether we need to call free() for current "input_name" during the switch.
+ */
+static bool is_input_name_malloced = false;
+
 static int switch_data_file(void)
 {
 	char *pwd, *options[256], *abs_path[256], *tmp;
@@ -1186,8 +1193,10 @@ close_file_and_continue:
 		if (choice < nr_options && choice >= 0) {
 			tmp = strdup(abs_path[choice]);
 			if (tmp) {
+				if (is_input_name_malloced)
+					free((void *)input_name);
 				input_name = tmp;
+				is_input_name_malloced = true;
 				ret = 0;
 			}
 		}


