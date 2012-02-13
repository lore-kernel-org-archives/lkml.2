Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab2BMUMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:12:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39121 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2BMUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:12:51 -0500
Date: Mon, 13 Feb 2012 18:12:43 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] perf tools: Introduce struct perf_maps_opts
Message-ID: <20120213201243.GM15955@infradead.org>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
 <1329118064-9412-2-git-send-email-namhyung.kim@lge.com>
 <20120213183232.GD15955@infradead.org>
 <4F395B75.4060800@gmail.com>
 <20120213190542.GL15955@infradead.org>
 <4F396249.2050001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F396249.2050001@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 13, 2012 at 12:19:37PM -0700, David Ahern escreveu:
> 
> 
> On 02/13/2012 12:05 PM, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Feb 13, 2012 at 11:50:29AM -0700, David Ahern escreveu:
> >> Today's perf if you give it an invalid pid, scandir fails and the
> >> command spits out the usage statement. Which is completely confusing --
> >> ie., not clear that the command failed b/c the pid does not exist.

> > Humm, ok, but then I think we should have an enum + a strerror(3)
> > equivalent, i.e.:

> > 	enum perf_target_error perf_evlist__create_maps(...);

> > 	int perf_target__strerror(struct perf_target *target, int errnum,
> > 				  char *buf, size_t buflen);

> ok, so you are proposing an internal generation of enum error codes and
> correlating them to strings rather than adding a buffer into
> perf_target. If that's the case perhaps we need a libperf-wide design:

> enum perf_error perf__strerror(enum perf_error)
> 
> which effectively taps an array similar to _sys_errlist_internal based
> on enum index.

I think a per class mechanism is better. I.e. some errors are too
specific.

I couldn't find any standard way to know the max errno value used :-\ If
we had that we could reuse strerror_r and use a different range for per
class specific errnos, i.e.:

 int perf_target__strerror(struct perf_target *target, int errnum,
                           char *buf, size_t buflen)
 {
	if (errnum < MAX_ERRNO)
		return strerror_r(errnum, buf, buflen);

	errnum -= MAX_ERRNO;

	if (errnum >= PERF_TARGET__MAX_ERRNO)
		return -1;

	snprintf(buf, buflen, "%s", perf_target__error_str[errnum]);
	return 0;
 }

 
> > Please see 'man strerror_r", and make it work like the POSIX compliant
> > variant.
> 
> No globals are in use, so I would expect the _r to be redundant. I have
> glibc source; scanning __strerror_r implementation ....
> 
> > 
> > Ok, so it may be better to first process Kim's patches and then you
> > rework yours?
> 
> The current patch is ready to go; I just don't like the error handling
> and lack of a useful message. That said, it is no worse than what
> happens today.

Yeah, we can go with what you have and then add the
perf_target__strerror on top, I'll read it now.

- Arnaldo
