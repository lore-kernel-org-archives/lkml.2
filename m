Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2ABLHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:07:32 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50427 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab2ABLH2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:07:28 -0500
MIME-Version: 1.0
In-Reply-To: <1323969824-9711-2-git-send-email-robert.richter@amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
	<1323969824-9711-2-git-send-email-robert.richter@amd.com>
Date: Mon, 2 Jan 2012 11:07:26 +0000
Message-ID: <CABPqkBQFBP+No8twfR0O3i-zGVbTdvsu_U7GWit0dGfViSSAKQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf tool: Parse general/raw events from sysfs
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

I must be missing somerthing but which patch adds:

/sys/bus/event_source/devices/ibs_op/events/r0

It seems the modified perf tool insists on getting the event encoding from sysfs
yet I don't see that in your patchset.

On Thu, Dec 15, 2011 at 5:23 PM, Robert Richter <robert.richter@amd.com> wrote:
> From: Lin Ming <ming.m.lin@intel.com>
>
> PMU can export general events to sysfs, for example,
>
> /sys/bus/event_source/devices/uncore/events
> └── cycle
>
> Then specify the event as <pmu>:<event>,
>
> $ sudo perf stat -a -C 0 -e uncore:cycle
> ^C
>  Performance counter stats for 'CPU 0':
>
>        56,547,314 uncore:cycle
>
> Raw event can be specified as <pmu>:rXXXX
>
> $ sudo perf stat -a -C 0 -e uncore:r0101
> ^C
>  Performance counter stats for 'CPU 0':
>
>             8,504 uncore:r0101
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/util/parse-events.c |   84 +++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 82 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 586ab3f..4ce9404 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -685,7 +685,7 @@ parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
>  }
>
>  static enum event_result
> -parse_raw_event(const char **strp, struct perf_event_attr *attr)
> +parse_raw_config(const char **strp, struct perf_event_attr *attr)
>  {
>        const char *str = *strp;
>        u64 config;
> @@ -700,7 +700,6 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
>                        return EVT_FAILED;
>
>                *strp = end;
> -               attr->type = PERF_TYPE_RAW;
>                attr->config = config;
>                return EVT_HANDLED;
>        }
> @@ -708,6 +707,83 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
>  }
>
>  static enum event_result
> +parse_raw_event(const char **strp, struct perf_event_attr *attr)
> +{
> +       if (parse_raw_config(strp, attr) != EVT_HANDLED)
> +               return EVT_FAILED;
> +
> +       attr->type = PERF_TYPE_RAW;
> +       return EVT_HANDLED;
> +}
> +
> +#define EVENT_SOURCE_DIR "/sys/bus/event_source/devices"
> +
> +static u64 read_sysfs_entry(const char *path)
> +{
> +       char buf[19];
> +       int fd;
> +
> +       fd = open(path, O_RDONLY);
> +       if (fd < 0)
> +               return -1;
> +
> +       if (read(fd, buf, sizeof(buf)) < 0) {
> +               close(fd);
> +               return -1;
> +       }
> +
> +       close(fd);
> +       return atoll(buf);
> +}
> +
> +static u64 get_pmu_type(const char *pmu_name)
> +{
> +       char evt_path[MAXPATHLEN];
> +
> +       snprintf(evt_path, MAXPATHLEN, "%s/%s/type", EVENT_SOURCE_DIR,
> +                pmu_name);
> +
> +       return read_sysfs_entry(evt_path);
> +}
> +
> +static u64 get_pmu_event_config(const char *pmu_name, const char *evt_name)
> +{
> +       char evt_path[MAXPATHLEN];
> +
> +       snprintf(evt_path, MAXPATHLEN, "%s/%s/events/%s", EVENT_SOURCE_DIR,
> +                pmu_name, evt_name);
> +
> +       return read_sysfs_entry(evt_path);
> +}
> +
> +static enum event_result
> +parse_sysfs_event(const char **strp, struct perf_event_attr *attr)
> +{
> +       char *pmu_name, *evt_name;
> +       u64 type, config;
> +
> +       pmu_name = strchr(*strp, ':');
> +       if (!pmu_name)
> +               return EVT_FAILED;
> +       pmu_name = strndup(*strp, pmu_name - *strp);
> +       type = get_pmu_type(pmu_name);
> +       if ((int)type < 0)
> +               return EVT_FAILED;
> +       attr->type = type;
> +
> +       evt_name = strchr(*strp, ':') + 1;
> +       config = get_pmu_event_config(pmu_name, evt_name);
> +       *strp += strlen(pmu_name) + 1; /* + 1 for the ':' */
> +
> +       if ((int)config < 0)
> +               return parse_raw_config(strp, attr);
> +
> +       attr->config = config;
> +       *strp += strlen(evt_name);
> +       return EVT_HANDLED;
> +}
> +
> +static enum event_result
>  parse_numeric_event(const char **strp, struct perf_event_attr *attr)
>  {
>        const char *str = *strp;
> @@ -788,6 +864,10 @@ parse_event_symbols(struct perf_evlist *evlist, const char **str,
>  {
>        enum event_result ret;
>
> +       ret = parse_sysfs_event(str, attr);
> +       if (ret != EVT_FAILED)
> +               goto modifier;
> +
>        ret = parse_tracepoint_event(evlist, str, attr);
>        if (ret != EVT_FAILED)
>                goto modifier;
> --
> 1.7.7
>
>
