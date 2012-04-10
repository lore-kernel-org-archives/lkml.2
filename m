Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2DJQdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:33:13 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63319 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2DJQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:33:12 -0400
Message-ID: <4F8460C4.4010503@gmail.com>
Date: Tue, 10 Apr 2012 10:33:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, acme@redhat.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        namhyung.kim@lge.com
Subject: Re: [PATCH] perf report: fix error with -g in pipe mode
References: <20120410101327.GA8104@quad>
In-Reply-To: <20120410101327.GA8104@quad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/12 4:13 AM, Stephane Eranian wrote:
> In pipe mode, we cannot check the validity of sample_type
> or the branch view mode until we start processing the events.
> There is no meta-data information at the beginning of the pipe
> mode stream. Instead, all the meta data is pushed via pseudo
> records and those get processed by process_sample_events().
>
> Without this patch:
>    $ perf record -g -o - foo | perf inject -b | perf report -g -i -
>    Selected -g but no callchain data. Did you call 'perf record' without -g?
>
> Signed-off-by: Stephane Eranian<eranian@google.com>

Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>


> ---
>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 2e31743..c338b97 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -249,6 +249,13 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
>   {
>   	struct perf_session *self = rep->session;
>
> +	/*
> +	 * cannot determine sample type, branch mode until we have
> +	 * processed the meta-data pseudo records via process_sample_events()
> +	 */
> +	if (self->fd_pipe)
> +		return 0;
> +
>   	if (!(self->sample_type&  PERF_SAMPLE_CALLCHAIN)) {
>   		if (sort__has_parent) {
>   			ui__warning("Selected --sort parent, but no "

