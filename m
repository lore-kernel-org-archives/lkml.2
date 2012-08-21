Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2HUNO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:14:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62073 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2HUNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:14:56 -0400
Date: Tue, 21 Aug 2012 10:14:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] perf: create a helper structure perf_event_context
Message-ID: <20120821131451.GA7162@infradead.org>
References: <1344957803-2635317-1-git-send-email-avagin@openvz.org>
 <20120821095920.GA3241@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821095920.GA3241@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 21, 2012 at 11:59:20AM +0200, Ingo Molnar escreveu:
> * Andrew Vagin <avagin@openvz.org> wrote:
> >  18 files changed, 222 insertions(+), 255 deletions(-)
> > -static int process_sample_event(struct perf_tool *tool,
> > -				union perf_event *event,
> > -				struct perf_sample *sample,
> > -				struct perf_evsel *evsel,
> > -				struct machine *machine)
> > +static int process_sample_event(struct perf_event_context *ectx)
> >  {
> > -	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
> > +	struct perf_sample *sample = ectx->sample;
> > +	struct perf_annotate *ann = container_of(ectx->tool, struct perf_annotate, tool);
> >  	struct addr_location al;
> 
> that looks like a nice cleanliness win.
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>

I don't like it, in most cases it just moves variables from the function
signature to the start of the function.

I do agree tho that we should reduce the number of parameters as much as
we can, as I did removing that pevent one that we used to look up
event_format from the sample ID, that just was not natural as we already
had the evsel and did the lookup when reading the perf.data headers, so
it was just a matter of linking evsel to event_format at that point and
remove the pevent parameter and eliminate the needless relookups, see:

 "perf evsel: Cache associated event_format"
 fcf65bf149afa91b875ffde4455967cb63ee0be9

In the above function signature there is already room for tool specific
state in perf_tool/container_of, the other parameters are per event
natural objects.

- Arnaldo
