Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0EODUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 23:20:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53797 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0EODUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 23:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HdYvgSYp4Q0xpnXs7IJrTyAHbzB45liFgL8gIxX+eefu0yHr+Ts1fIA3sNnIYPJIiv
         F976xxTKzzLyCmWb536Gm8V0s9mJ1SpllCrpS/TupTO9m3x2HmIMjuAVHApbDBXed3yF
         11n9zw4aAt0ic/pAOB3zZmpucrviOk93DzdM0=
Date: Sat, 15 May 2010 05:20:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 2/7] perf trace: Correctly handle arrays
Message-ID: <20100515032032.GB8150@nowhere>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com> <1273730632-21008-3-git-send-email-imunsie@au1.ibm.com> <1273768145.27703.1095.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273768145.27703.1095.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 12:29:05PM -0400, Steven Rostedt wrote:
> On Thu, 2010-05-13 at 16:03 +1000, Ian Munsie wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > Previously, perf was assuming that an array from an ftrace event was an
> > array of longs, which will not always be the case. Additionally,
> > long_size is not even being initialised, so it would fail to read the
> > data and would erroneously report that the array was filled with zeroes.
> > 
> > This patch adds two extra entries into the field structure - arraylen
> > and elementsize, so that the code can easily look them up instead of
> > assuming that the elements are long_size. The element size is currently
> > derived by the size of the entire array and the number of elements
> > within the array.
> > 
> > This problem can be demonstrated with:
> > perf record -e raw_syscalls:sys_enter -a sleep 0.1
> > perf trace
> > 
> 
> I'm added this to trace-cmd too.
> 
> > Without this patch, output similar to the following is produced:
> >  perf-4355  [004]  1871.504685: sys_enter: NR 319 (0, 0, 0, 0, 0, 0)
> >  perf-4355  [004]  1871.504723: sys_enter: NR 3 (0, 0, 0, 0, 0, 0)
> >  perf-4355  [004]  1871.504733: sys_enter: NR 204 (0, 0, 0, 0, 0, 0)
> > 
> > After applying this patch, the output looks like:
> >  perf-4355  [004]  1871.504685: sys_enter: NR 319 (10247ac0, ffffffff, 5, ffffffff, 0, 107a80d8)
> >  perf-4355  [004]  1871.504723: sys_enter: NR 3 (a, ffb6fcf0, 20, ffffffff, 0, 10112c20)
> >  perf-4355  [004]  1871.504733: sys_enter: NR 204 (a, 4, 800, 6, 0, 10112c20)
> > 
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > ---
> >  tools/perf/util/trace-event-parse.c |   11 ++++++++++-
> >  tools/perf/util/trace-event.h       |    2 ++
> >  2 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> > index 8f470f6..f360f75 100644
> > --- a/tools/perf/util/trace-event-parse.c
> > +++ b/tools/perf/util/trace-event-parse.c
> > @@ -852,6 +852,9 @@ static int event_read_fields(struct event *event, struct format_field **fields)
> >  			field->flags |= FIELD_IS_ARRAY;
> >  
> >  			type = read_token(&token);
> > +			if (test_type(type, EVENT_ITEM))
> > +				goto fail;
> 
> Note this will incorrectly fail on:
> 
> 	field:__data_loc char[] name;
> 
> -- Steve



Nice patch, but indeed this part needs to be fixed.

Thanks.

