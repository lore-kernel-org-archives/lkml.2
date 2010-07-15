Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab0GOQjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:39:14 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51432 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695Ab0GOQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:39:08 -0400
X-AuditID: b753bd60-a7e3fba000006d9b-40-4c3f39a7c86c
Message-ID: <4C3F39A3.2030103@hitachi.com>
Date: Fri, 16 Jul 2010 01:38:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/3] perf probe: Fix error message if get_real_path()
 failed
References: <4C36EBDB.4020308@hitachi.com> <1278677899.21394.56.camel@mini>
In-Reply-To: <1278677899.21394.56.camel@mini>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Could you please merge this series, because this series
fixes some bugs which people easily hit ?

Thank you,

Chase Douglas wrote:
> On Fri, 2010-07-09 at 18:28 +0900, Masami Hiramatsu wrote:
>> Perf probe -L shows incorrect error message (Dwarf error)
>> if it fails to find source file. This can confuse users.
>>
>> # ./perf probe -s /nowhere -L vfs_read
>> Debuginfo analysis failed. (-2)
>>   Error: Failed to show lines. (-2)
>>
>> With this patch, it shows correct message.
>>
>> # ./perf probe -s /nowhere -L vfs_read
>> Failed to find source file. (-2)
>>   Error: Failed to show lines. (-2)
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Chase Douglas <chase.douglas@canonical.com>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>
>>  tools/perf/util/probe-event.c  |   59 +++++++++++++++++++++++++++++++++++++++
>>  tools/perf/util/probe-finder.c |   61 +++-------------------------------------
>>  2 files changed, 64 insertions(+), 56 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index 09cf546..8d08e75 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -195,6 +195,55 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
>>  	return ntevs;
>>  }
>>
>> +/*
>> + * Find a src file from a DWARF tag path. Prepend optional source path prefix
>> + * and chop off leading directories that do not exist. Result is passed back as
>> + * a newly allocated path on success.
>> + * Return 0 if file was found and readable, -errno otherwise.
>> + */
>> +static int get_real_path(const char *raw_path, char **new_path)
>> +{
>> +	if (!symbol_conf.source_prefix) {
>> +		if (access(raw_path, R_OK) == 0) {
>> +			*new_path = strdup(raw_path);
>> +			return 0;
>> +		} else
>> +			return -errno;
>> +	}
>> +
>> +	*new_path = malloc((strlen(symbol_conf.source_prefix) +
>> +			    strlen(raw_path) + 2));
>> +	if (!*new_path)
>> +		return -ENOMEM;
>> +
>> +	for (;;) {
>> +		sprintf(*new_path, "%s/%s", symbol_conf.source_prefix,
>> +			raw_path);
>> +
>> +		if (access(*new_path, R_OK) == 0)
>> +			return 0;
>> +
>> +		switch (errno) {
>> +		case ENAMETOOLONG:
>> +		case ENOENT:
>> +		case EROFS:
>> +		case EFAULT:
>> +			raw_path = strchr(++raw_path, '/');
>> +			if (!raw_path) {
>> +				free(*new_path);
>> +				*new_path = NULL;
>> +				return -ENOENT;
>> +			}
>> +			continue;
>> +
>> +		default:
>> +			free(*new_path);
>> +			*new_path = NULL;
>> +			return -errno;
>> +		}
>> +	}
>> +}
>> +
>>  #define LINEBUF_SIZE 256
>>  #define NR_ADDITIONAL_LINES 2
>>
>> @@ -244,6 +293,7 @@ int show_line_range(struct line_range *lr)
>>  	struct line_node *ln;
>>  	FILE *fp;
>>  	int fd, ret;
>> +	char *tmp;
>>
>>  	/* Search a line range */
>>  	ret = init_vmlinux();
>> @@ -266,6 +316,15 @@ int show_line_range(struct line_range *lr)
>>  		return ret;
>>  	}
>>
>> +	/* Convert source file path */
>> +	tmp = lr->path;
>> +	ret = get_real_path(tmp, &lr->path);
>> +	free(tmp);	/* Free old path */
>> +	if (ret < 0) {
>> +		pr_warning("Failed to find source file. (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>>  	setup_pager();
>>
>>  	if (lr->function)
>> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
>> index 3e64e1f..a934a36 100644
>> --- a/tools/perf/util/probe-finder.c
>> +++ b/tools/perf/util/probe-finder.c
>> @@ -58,55 +58,6 @@ static int strtailcmp(const char *s1, const char *s2)
>>  	return 0;
>>  }
>>
>> -/*
>> - * Find a src file from a DWARF tag path. Prepend optional source path prefix
>> - * and chop off leading directories that do not exist. Result is passed back as
>> - * a newly allocated path on success.
>> - * Return 0 if file was found and readable, -errno otherwise.
>> - */
>> -static int get_real_path(const char *raw_path, char **new_path)
>> -{
>> -	if (!symbol_conf.source_prefix) {
>> -		if (access(raw_path, R_OK) == 0) {
>> -			*new_path = strdup(raw_path);
>> -			return 0;
>> -		} else
>> -			return -errno;
>> -	}
>> -
>> -	*new_path = malloc((strlen(symbol_conf.source_prefix) +
>> -			    strlen(raw_path) + 2));
>> -	if (!*new_path)
>> -		return -ENOMEM;
>> -
>> -	for (;;) {
>> -		sprintf(*new_path, "%s/%s", symbol_conf.source_prefix,
>> -			raw_path);
>> -
>> -		if (access(*new_path, R_OK) == 0)
>> -			return 0;
>> -
>> -		switch (errno) {
>> -		case ENAMETOOLONG:
>> -		case ENOENT:
>> -		case EROFS:
>> -		case EFAULT:
>> -			raw_path = strchr(++raw_path, '/');
>> -			if (!raw_path) {
>> -				free(*new_path);
>> -				*new_path = NULL;
>> -				return -ENOENT;
>> -			}
>> -			continue;
>> -
>> -		default:
>> -			free(*new_path);
>> -			*new_path = NULL;
>> -			return -errno;
>> -		}
>> -	}
>> -}
>> -
>>  /* Line number list operations */
>>
>>  /* Add a line to line number list */
>> @@ -1256,13 +1207,11 @@ end:
>>  static int line_range_add_line(const char *src, unsigned int lineno,
>>  			       struct line_range *lr)
>>  {
>> -	int ret;
>> -
>> -	/* Copy real path */
>> +	/* Copy source path */
>>  	if (!lr->path) {
>> -		ret = get_real_path(src, &lr->path);
>> -		if (ret != 0)
>> -			return ret;
>> +		lr->path = strdup(src);
>> +		if (lr->path == NULL)
>> +			return -ENOMEM;
>>  	}
>>  	return line_list__add_line(&lr->line_list, lineno);
>>  }
>> @@ -1460,7 +1409,7 @@ int find_line_range(int fd, struct line_range *lr)
>>  		}
>>  		off = noff;
>>  	}
>> -	pr_debug("path: %lx\n", (unsigned long)lr->path);
>> +	pr_debug("path: %s\n", lr->path);
>>  	dwarf_end(dbg);
>>
>>  	return (ret < 0) ? ret : lf.found;
> 
> This seems fine to me. I don't think any functionality has really
> changed, just moving the function into probe-event.c and printing out an
> accurate error message.
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>
> 
> Thanks!
> 

