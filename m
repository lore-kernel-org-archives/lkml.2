Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab0EDVTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:19:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab0EDVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=kAS8AQXH6hueu8LlPR213PM8M0Pr8XCg2/tZiu2gSvs9N7VigpPAet5ajyjeLoCyE9
         GuFoe8GIQkUiYlzfhSgmuH4aCc+wvJ6r8RoLIndUpT9AEqLgssfCPE03/INNNGrEtcG7
         tUNexqYEhdrlOP3TPFgMTZzoZ4OsTQR8wTNco=
Date: Tue, 4 May 2010 18:18:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/3] perf: record TRACE_INFO only if using tracepoints
 and SAMPLE_RAW
Message-ID: <20100504211843.GF970@ghostprotocols.net>
References: <1272981607-28723-1-git-send-email-acme@infradead.org>
 <1272981607-28723-2-git-send-email-acme@infradead.org>
 <20100504170642.GA5427@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100504170642.GA5427@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 04, 2010 at 07:06:45PM +0200, Frederic Weisbecker escreveu:
> On Tue, May 04, 2010 at 11:00:05AM -0300, Arnaldo Carvalho de Melo wrote:
> > From: Tom Zanussi <tzanussi@gmail.com>
> > 
> > The current perf code implicitly assumes SAMPLE_RAW means tracepoints
> > are being used, but doesn't check for that.  It happily records the
> > TRACE_INFO even if SAMPLE_RAW is used without tracepoints, but when the
> > perf data is read it won't go any further when it finds TRACE_INFO but
> > no tracepoints, and displays misleading errors.
> > 
> > This adds a check for both in perf-record, and won't record TRACE_INFO
> > unless both are true.  This at least allows perf report -D to dump raw
> > events, and avoids triggering a misleading error condition in perf
> > trace.  It doesn't actually enable the non-tracepoint raw events to be
> > displayed in perf trace, since perf trace currently only deals with
> > tracepoint events.
> > 
> > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <1272865861.7932.16.camel@tropicana>
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/perf/builtin-record.c        |   35 +++++++++++++++++++++--------------
> >  tools/perf/util/header.c           |    1 -
> >  tools/perf/util/parse-events.h     |    1 +
> >  tools/perf/util/trace-event-info.c |    5 +++++
> >  4 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index ac989e9..0ff67d1 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -560,11 +560,12 @@ static int __cmd_record(int argc, const char **argv)
> >  			return err;
> >  	}
> >  
> > -	if (raw_samples) {
> > +	if (raw_samples && have_tracepoints(attrs, nr_counters)) {
> >  		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
> >  	} else {
> 
> 
> 
> Using get_tracepoints_path() is a bit costly just to check if we use
> tracepoints as it allocates and fill the paths.

Can you please send a fix?

- Arnaldo
