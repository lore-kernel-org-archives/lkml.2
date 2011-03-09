Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1CIXaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:30:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56616 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1CIXap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P6V8L5eLLIs8tGtUypDbMW95o/mOAvpkaTiSMDVUUJC7S0QCx+mCL2w4Xt39Ee66aL
         lHQowJUEP4bKMdrsZNc0d7nlho8gH/Np3/9B5dZ+gSGF8CeR2Oks7L8pPG9SjINHGWUr
         VUsgNqjVLzMxpz0aumxUnqwx09oRWmSfxfyPo=
Date: Thu, 10 Mar 2011 00:30:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <daahern@cisco.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 09/10] perf script: Add support for dumping symbols
Message-ID: <20110309233039.GA2533@nowhere>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
 <1299695491-15786-10-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299695491-15786-10-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 03:31:30PM -0300, Arnaldo Carvalho de Melo wrote:
> @@ -868,6 +892,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
>  		exit(-1);
>  	}
>  
> +	symbol_conf.use_callchain = no_callchain ? false : true;
> +

That also depend on (sample_type & PERF_SAMPLE_CALLCHAIN)...

>  	if (rec_script_path)
>  		script_path = rec_script_path;
>  	if (rep_script_path)
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index f642615..51fac44 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1145,3 +1145,64 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
>  
>  	return ret;
>  }
> +
> +void perf_session__print_symbols(union perf_event *event,
> +				struct perf_sample *sample,
> +				struct perf_session *session)
> +{
> +	struct addr_location al;
> +	const char *symname, *dsoname;
> +	struct callchain_cursor *cursor = &session->callchain_cursor;
> +	struct callchain_cursor_node *node;
> +
> +	if (perf_event__preprocess_sample(event, session, &al, sample,
> +					  NULL) < 0) {
> +		error("problem processing %d event, skipping it.\n",
> +			event->header.type);
> +		return;
> +	}
> +
> +	if (symbol_conf.use_callchain && sample->callchain) {

...otherwise you may deref some crap there. sample->callchain is
random when there is actually no callchain.

> +
> +		if (perf_session__resolve_callchain(session, al.thread,
> +						sample->callchain, NULL) != 0) {
> +			if (verbose)
> +				error("Failed to resolve callchain. Skipping\n");
> +			return;
> +		}
