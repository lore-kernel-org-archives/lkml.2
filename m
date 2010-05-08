Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0EHPyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:54:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49973 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0EHPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cNe6U5XgqgME9dcbLxPnHZa7k9yZR5WYJvtW0S/J6kYKNOrz4yLr68f7o8YgB8cVvQ
         5VojDTuZBW9c8HxNcOkleez8d0C424pdk8Au79qthDMImaCSBmPAWXPDkwmn1MQr95CM
         Uh8ebMO3R3v3+KyT50hI3+Z3/YiueOdZakzh4=
Date: Sat, 8 May 2010 17:54:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/2] perf: Redesign trace events reordering
Message-ID: <20100508155404.GA5444@nowhere>
References: <1273017811-16880-1-git-send-regression-fweisbec@gmail.com> <1273038527.6383.51.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273038527.6383.51.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 12:48:47AM -0500, Tom Zanussi wrote:
> Hi Frederic,
> 
> On Wed, 2010-05-05 at 02:03 +0200, Frederic Weisbecker wrote:
> > I recently noticed that the new reordering design is broken
> > when it deals with tons of events.
> > 
> > This patchset provides another algorithm to deal with that,
> > tested without any problem.
> > 
> > And since it involves more frequent flushes, I guess it could
> > plug nicely with the live mode.
> 
> Very nice!  I tried these out with live mode and it seems to work fine,
> after applying the patch below.
> 
> I initially had a problem with 'unexpected end of event stream' errors,
> then noticed that the FINISHED_ROUND events were basically just headers
> with no data, which caused the read of the 0-length payload to appear as
> end-of-stream.
> 
> I'll do some more testing (and fix some warnings in the scripts that
> this mode seems to elicit), but it seems so far to work pretty well for
> live mode...
> 
> Tom


Cool, I'm applying your patch then,

Thanks.




> 
> From: Tom Zanussi <tzanussi@gmail.com>
> Date: Wed, 5 May 2010 00:27:40 -0500
> Subject: [PATCH] perf/live-mode: handle payload-less events
> 
> Some events, such as the PERF_RECORD_FINISHED_ROUND event consist of
> only an event header and no data.  In this case, a 0-length payload
> will be read, and the 0 return value will be wrongly interpreted as an
> 'unexpected end of event stream'.
> 
> This patch allows for proper handling of data-less events by skipping
> 0-length reads.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> ---
>  tools/perf/util/session.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 9401909..00ab298 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -696,15 +696,18 @@ more:
>  	p = &event;
>  	p += sizeof(struct perf_event_header);
>  
> -	err = do_read(self->fd, p, size - sizeof(struct perf_event_header));
> -	if (err <= 0) {
> -		if (err == 0) {
> -			pr_err("unexpected end of event stream\n");
> -			goto done;
> -		}
> +	if (size - sizeof(struct perf_event_header)) {
> +		err = do_read(self->fd, p,
> +			      size - sizeof(struct perf_event_header));
> +		if (err <= 0) {
> +			if (err == 0) {
> +				pr_err("unexpected end of event stream\n");
> +				goto done;
> +			}
>  
> -		pr_err("failed to read event data\n");
> -		goto out_err;
> +			pr_err("failed to read event data\n");
> +			goto out_err;
> +		}
>  	}
>  
>  	if (size == 0 ||
> -- 
> 1.6.4.GIT
> 
> 
> 

