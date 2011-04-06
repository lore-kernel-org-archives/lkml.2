Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1DFS6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:58:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51041 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1DFS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=p2a+8q4Fu0yX6O+RhSjlI/3RpB5agCO1an9km9iX0Mzc8VFiTbo3tfuULQKyvGpy6Y
         M+Rz3xsKCaS1PrUh4+8oVH/G1BE6YeUuCQdjXvR2D+SHSLjmODZ3UoGKnlbUDhqUE8tO
         3ktBNSjnpoZIBi8Lk+o36c/OtqiR2SKweNoTk=
Date: Wed, 6 Apr 2011 15:58:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH] perf script: improve validation of sample attributes for
 output fields
Message-ID: <20110406185827.GD4987@ghostprotocols.net>
References: <1301841300-14425-1-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301841300-14425-1-git-send-email-daahern@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Apr 03, 2011 at 08:35:00AM -0600, David Ahern escreveu:
> +++ b/tools/perf/builtin-script.c
> @@ -94,41 +95,111 @@ static bool output_set_by_user(void)
> +static const char *output_field2str(enum perf_output_field field)
> +{
> +	int i, imax = sizeof(all_output_options) / sizeof(struct output_option);

Use ARRAY_SIZE(all_output_options)

> +	for (i = 0; i < imax; ++i) {
> +		if (all_output_options[i].field == field) {
> +			str = all_output_options[i].str;
> +			break;

> +static int perf_attr__check_stype(struct perf_event_attr *attr,
> +				  u64 sample_type, const char *sample_msg,
> +				  enum perf_output_field field)

s/perf_attr__check_stype/perf_event_attr__check_stype/g

> +	/* user did not ask for it explicitly so remove from the default list */
> +	output[type].fields &= ~field;
> +	evname = __event_name(attr->type, attr->config);
> +	pr_debug("Samples for '%s' event do not have %s attribute set. "
> +		 "Skipping '%s' field.\n",
> +		 evname, sample_msg, output_field2str(field));

pr_warning?

> +static int perf_evsel__check_attr(struct perf_session *session,
> +				  struct perf_evsel *evsel)

for consistency, please make evsel the first parameter.

> +/* verify all user requested events exist and the samples
> + * have the expected data
> + */
> +static int perf_session__check_output_opt(struct perf_session *session)
> +{
> +	int j;
> +	struct perf_evsel *evsel;
> +
> +	for (j = 0; j < PERF_TYPE_MAX; ++j) {
> +		evsel = perf_session__find_event(session, j);

You're nog finding an specific event, you're looking for the first event
of type j, so I think perf_session__find_first_evtype is clearer.

> +
> +		/* even if fields is set to 0 (ie., show nothing) event must
> +		 * exist if user explicitly includes it on the command line
> +		 */

Please use:

		/*
  		 * even if fields is set to 0 (ie., show nothing) event must
  		 * exist if user explicitly includes it on the command line
  		 */

There are other places like this, please fix those too.

- Arnaldo
