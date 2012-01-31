Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2AaAed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:34:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60322 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2AaAea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:34:30 -0500
Date: Mon, 30 Jan 2012 22:34:23 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf top: Use active evsel for non-sample events on
 old kernel
Message-ID: <20120131003423.GA25293@infradead.org>
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
 <20120130185532.GC15935@infradead.org>
 <4F273651.2020908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F273651.2020908@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 31, 2012 at 09:31:13AM +0900, Namhyung Kim escreveu:
> 2012-01-31 3:55 AM, Arnaldo Carvalho de Melo wrote:
> >Em Sun, Jan 29, 2012 at 05:55:52PM +0900, Namhyung Kim escreveu:
> >>If multiple events are specified on old kernel,
> >>perf_evlist__id2evsel() returns NULL for non-sampling events
> >>since the sample.id doesn't contain valid value, and it triggers
> >>assert below. If only one event is given, the function returns
> >>the evsel regardless of sample.id, this is why most case cause
> >>no problem on old kernel.
> >>
> >>Fix it by using active evsel.
> >
> >How about this one instead:
> >
> >diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> >index a6d50e3..3ffb320 100644
> >--- a/tools/perf/util/evlist.c
> >+++ b/tools/perf/util/evlist.c
> >@@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
> >  	hlist_for_each_entry(sid, pos, head, node)
> >  		if (sid->id == id)
> >  			return sid->evsel;
> >+
> >+	if (!perf_evlist__sample_id_all(evlist))
> >+		return list_entry(evlist->entries.next, struct perf_evsel, node);
> >+
> >  	return NULL;
> >  }
> >
> >That way we won't have to patch other tools that would get the same
> >problem in such new tool/old kernel combos, right?
> >
> 
> Right, looks good to me.

Please resend that way and I'll apply, or lemme know if you prefer for
me to do it and just stick your 'Acked-by: ' or 'Tested-by:' on it.
 
> 
> >Do you see any problem with not checking the header type?
> >
> 
> No, I don't, at least for now :)
> 
> 
> >Also please try to avoid using perf_session fields, prefer to use
> >perf_{evlist,evsel} when possible, in this case you could use
> >perf_evlist__sample_id_all(evlist), for instance.
> >
> >- Arnaldo
> >
> 
> OK, will do that later.
> 
> Thanks,
> Namhyung
