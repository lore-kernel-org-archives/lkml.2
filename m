Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2IYBza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:55:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60758 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2IYBz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:55:29 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-11-50610f0e9b6d
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v3 3/9] perf script: Add more filter to find_scripts()
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-4-git-send-email-feng.tang@intel.com>
Date: Tue, 25 Sep 2012 10:47:03 +0900
In-Reply-To: <1348500251-9937-4-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Mon, 24 Sep 2012 23:24:05 +0800")
Message-ID: <87lifyyiug.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On Mon, 24 Sep 2012 23:24:05 +0800, Feng Tang wrote:
> As suggested by Arnaldo, many scripts have their own usages and need
> capture specific events or tracepoints, so only those scripts whose
> targe events match the events in current perf data file should be
> listed in the script browser menu.
>
> This patch will add the event match checking.
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  tools/perf/builtin-script.c |   76 +++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 73 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 4e2f10f..37a0df8 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1031,6 +1031,63 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
>  }
>  
>  /*
> + * Some scripts specify the required events in their "xxx-record" file,
> + * this function will check if the events in perf.data match those
> + * mentioned in the "xxx-record".
> + */
> +static int check_ev_match(char *dir_name, char *scriptname,
> +			struct perf_session *session)
> +{
> +	char filename[MAXPATHLEN], evname[128];
> +	char line[BUFSIZ], *p, *temp;
> +	struct perf_evsel *pos;
> +	int match;
> +	FILE *fp;
> +
> +	sprintf(filename, "%s/bin/%s-record", dir_name, scriptname);
> +
> +	fp = fopen(filename, "r");
> +	if (!fp)
> +		return -1;
> +
> +	while (fgets(line, sizeof(line), fp)) {
> +		p = ltrim(line);
> +		if (strlen(p) == 0 ||*p == '#')
> +			continue;
> +
> +		while (strlen(p)) {
> +			temp = strstr(p, "-e");
> +			if (!temp)
> +				break;
> +
> +			p = temp + 3;
> +			temp = strchr(p, ' ');
> +			snprintf(evname, (temp - p) + 1, "%s", p);

It can't recognize extra spaces, multiple events connected by commas,
event groups and probably more..  So I think it'd better if we can use
parse_events() here - but w/o an evlist.  Jiri, what do you think?

Thanks,
Namhyung
