Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1AQTuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:50:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65501 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1AQTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=cnAgtpfd0r5sQe35upLgxkXQSvKnD5lyaRoiYe7rnysP82Kx5aSMj3I6Vpfu51ag4R
         tVVENq0tUNkQIFwkMFpx1QV0maIRvQH9nLXuyZhPJuvx5M7CBNyDjld6iIaFsO6YZd16
         wxSs+SfsyFNGUEE7/S4lysJ2GXFdR8WS5J+lg=
Date: Mon, 17 Jan 2011 17:50:34 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Han Pingtian <phan@redhat.com>
Subject: Re: [PATCH 1/2] perf-tools: Fix tracepoint event type recording
Message-ID: <20110117195034.GF2085@ghostprotocols.net>
References: <m34o97wg94.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m34o97wg94.fsf@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 17, 2011 at 07:13:11PM +0100, Franck Bui-Huu escreveu:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Tracepoint event registering was done by store_event_type() which took
> the full event name (sys + ':' + event) as argument.
> 
> However commit f006d25a15216a483cec71e886786874f66f9452 broke this
> by only passing a subset of this full name, that is the substring
> following the colon.
> 
> The consequence of this is that no more tracepoint event type was
> valid, hence making the trace info section empty.
> 
> This patch fixes this by merging store_event_type() into
> parse_single_tracepoint_event(), so a tracepoint type event is
> registered when parsed.

Please try not to do multiple, unrelated changes in a single patch, see
below:
 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/header.c       |   15 ++++++++++-----
>  tools/perf/util/header.h       |    2 +-
>  tools/perf/util/parse-events.c |   38 ++++++--------------------------------
>  3 files changed, 17 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 989fa2d..35b707c 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -104,10 +104,12 @@ int perf_header__add_attr(struct perf_header *self,
>  static int event_count;
>  static struct perf_trace_event_type *events;
>  
> -int perf_header__push_event(u64 id, const char *name)
> +int perf_header__push_event(u64 id, const char *name, size_t len)
>  {
> -	if (strlen(name) > MAX_EVENT_NAME)
> +	if (len > MAX_EVENT_NAME - 1) {
>  		pr_warning("Event %s will be truncated\n", name);
> +		len = MAX_EVENT_NAME - 1;
> +	}
>  
>  	if (!events) {
>  		events = malloc(sizeof(struct perf_trace_event_type));
> @@ -123,7 +125,8 @@ int perf_header__push_event(u64 id, const char *name)
>  	}
>  	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
>  	events[event_count].event_id = id;
> -	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
> +	strncpy(events[event_count].name, name, len);
> +	events[event_count].name[len] = '\0';

Is this change related to what you describe in the changelog comment? It
is a cleanup, can be done as a follow up patch, for perf/core.

The problem you describe deserves perf/urgent treatment, please redo
this patch with just the essential bits for that fix.

>  	event_count++;
>  	return 0;
>  }
> @@ -1126,8 +1129,10 @@ int event__synthesize_event_types(event__handler_t process,
>  int event__process_event_type(event_t *self,
>  			      struct perf_session *session __unused)
>  {
> -	if (perf_header__push_event(self->event_type.event_type.event_id,
> -				    self->event_type.event_type.name) < 0)
> +	struct perf_trace_event_type *event_type = &self->event_type.event_type;
> +
> +	if (perf_header__push_event(event_type->event_id,
> +				    event_type->name, strlen(event_type->name)) < 0)
>  		return -ENOMEM;

Ditto.
 
>  	return 0;
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 33f16be..0603a02 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -72,7 +72,7 @@ int perf_header__write_pipe(int fd);
>  int perf_header__add_attr(struct perf_header *self,
>  			  struct perf_header_attr *attr);
>  
> -int perf_header__push_event(u64 id, const char *name);
> +int perf_header__push_event(u64 id, const char *name, size_t name_len);
>  char *perf_header__find_event(u64 id);
>  
>  struct perf_header_attr *perf_header_attr__new(struct perf_event_attr *attr);
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 5cb6f4b..a58407e 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -417,6 +417,7 @@ parse_single_tracepoint_event(char *sys_name,
>  	char id_buf[4];
>  	u64 id;
>  	int fd;
> +	size_t len;
>  
>  	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
>  		 sys_name, evt_name);
> @@ -434,7 +435,6 @@ parse_single_tracepoint_event(char *sys_name,
>  	id = atoll(id_buf);
>  	attr->config = id;
>  	attr->type = PERF_TYPE_TRACEPOINT;
> -	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
>  
>  	attr->sample_type |= PERF_SAMPLE_RAW;
>  	attr->sample_type |= PERF_SAMPLE_TIME;
> @@ -442,7 +442,11 @@ parse_single_tracepoint_event(char *sys_name,
>  
>  	attr->sample_period = 1;
>  
> +	len = strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
> +	if (perf_header__push_event(id, *strp, len) < 0)
> +		return EVT_FAILED;

Since you're changing the point where perf_header__push_event() is
called, consider doing it _after_ parse_events() finishes, by traversing
the evsel_list, that way, as a bonus, later, in perf/core we can kill
some more global variables:

static int event_count;
static struct perf_trace_event_type *events;

These variables should be in 'struct perf_header', but anyway, this is
for later, I'm digressing, please just try to do it after
parse_events(), traversing the evsel_list and getting the tracepoint
name in string form using event_name(evsel) (that also uses an static
variagle, argh, another fix to do).

Doing it that way and excluding the strnlen cleanup, the patch should be
much smaller.

We also untie event parsing from header handling, that are only together
in record, not in, say, top.
  
- Arnaldo
