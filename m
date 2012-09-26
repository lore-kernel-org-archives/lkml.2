Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2IZJDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:03:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:20016 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab2IZJDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="226661998"
Date: Wed, 26 Sep 2012 16:56:41 +0800
From: Feng Tang <feng.tang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v3 3/9] perf script: Add more filter to find_scripts()
Message-ID: <20120926165641.74f2e5b3@feng-i7>
In-Reply-To: <87lifyyiug.fsf@sejong.aot.lge.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-4-git-send-email-feng.tang@intel.com>
	<87lifyyiug.fsf@sejong.aot.lge.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 10:47:03 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Feng,
> 
> On Mon, 24 Sep 2012 23:24:05 +0800, Feng Tang wrote:
> > As suggested by Arnaldo, many scripts have their own usages and need
> > capture specific events or tracepoints, so only those scripts whose
> > targe events match the events in current perf data file should be
> > listed in the script browser menu.
> >
> > This patch will add the event match checking.
> >
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  tools/perf/builtin-script.c |   76 +++++++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 73 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> > index 4e2f10f..37a0df8 100644
> > --- a/tools/perf/builtin-script.c
> > +++ b/tools/perf/builtin-script.c
> > @@ -1031,6 +1031,63 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
> >  }
> >  
> >  /*
> > + * Some scripts specify the required events in their "xxx-record" file,
> > + * this function will check if the events in perf.data match those
> > + * mentioned in the "xxx-record".
> > + */
> > +static int check_ev_match(char *dir_name, char *scriptname,
> > +			struct perf_session *session)
> > +{
> > +	char filename[MAXPATHLEN], evname[128];
> > +	char line[BUFSIZ], *p, *temp;
> > +	struct perf_evsel *pos;
> > +	int match;
> > +	FILE *fp;
> > +
> > +	sprintf(filename, "%s/bin/%s-record", dir_name, scriptname);
> > +
> > +	fp = fopen(filename, "r");
> > +	if (!fp)
> > +		return -1;
> > +
> > +	while (fgets(line, sizeof(line), fp)) {
> > +		p = ltrim(line);
> > +		if (strlen(p) == 0 ||*p == '#')
> > +			continue;
> > +
> > +		while (strlen(p)) {
> > +			temp = strstr(p, "-e");
> > +			if (!temp)
> > +				break;
> > +
> > +			p = temp + 3;
> > +			temp = strchr(p, ' ');
> > +			snprintf(evname, (temp - p) + 1, "%s", p);
> 
> It can't recognize extra spaces, multiple events connected by commas,
> event groups and probably more..  So I think it'd better if we can use
> parse_events() here - but w/o an evlist.  Jiri, what do you think?

Yes, this func was really a pain to me :) And fortunately, current
intree "xxx-record" scripts are all in simple format: "-e eventname ",
and this lightweight func basically works fine.

I agree that we'd better have a separate parse_events() similar func 
to cherry-pick the events names in parse-events.c, to not make
hists.c too heavy. 

And frankly speaking, I'm not familiar at all with these flex/bison
handling, so can we do things in steps: fixes those space issue, add
a "fixme" in comments and push the basically working version first?

Any comments? Thanks

- Feng



