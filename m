Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2EXJ50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:57:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52256 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2EXJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:57:25 -0400
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-3-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 11:57:20 +0200
Message-ID: <1337853440.9783.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:

> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -130,8 +130,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
>  	PERF_SAMPLE_RAW				= 1U << 10,
>  	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
> +	PERF_SAMPLE_REGS			= 1U << 12,
>  
> -	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
>  };

There's a comment update missing for PERF_RECORD_SAMPLE that describes
the output this bit generates.

> @@ -4011,6 +4042,30 @@ void perf_output_sample(struct perf_output_handle *handle,
>  			perf_output_put(handle, nr);
>  		}
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_REGS) {
> +		u64 mode = event->attr.sample_regs;
> +
> +		if (mode & PERF_SAMPLE_REGS_USER) {
> +			u64 id = PERF_REGS_ABI_NONE;
> +
> +			/*
> +			 * If there are no regs to dump, notice it through
> +			 * PERF_REGS_ABI_NONE id.
> +			 */
> +			if (data->regs_user)
> +				id = perf_reg_version();

OK, so I don't like this.. why does this exists at all? Why not use a
length field instead?

> +			perf_output_put(handle, id);
> +
> +			if (id) {
> +				u64 mask = event->attr.sample_regs_user;
> +				perf_output_sample_regs(handle,
> +							data->regs_user,
> +							mask);
> +			}
> +		}
> +	}
>  }




