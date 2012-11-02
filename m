Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647Ab2KBCTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:19:03 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53258 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304Ab2KBCS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:18:58 -0400
X-AuditID: 9c930197-b7c0bae00000042f-49-50932d90c286
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHv2 03/25] perf tests: Add framework for automated perf_event_attr tests
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
	<1351634526-1516-4-git-send-email-jolsa@redhat.com>
	<20121030230120.GA1067@krava.redhat.com>
	<20121031142600.GB28061@ghostprotocols.net>
	<20121031145247.GB1027@krava.brq.redhat.com>
Date: Fri, 02 Nov 2012 11:18:56 +0900
In-Reply-To: <20121031145247.GB1027@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 31 Oct 2012 15:52:47 +0100")
Message-ID: <87fw4s4ui7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 15:52:47 +0100, Jiri Olsa wrote:
> Adding automated test to check event's perf_event_attr values.
>
> The idea is run perf session with kidnapping sys_perf_event_open
> function. For each sys_perf_event_open call we store the
> perf_event_attr data to the file to be checked later against what
> we expect.
>
> You can run this by:
>   $ python ./tests/attr.py -d ./tests/attr/ -p ./perf -v
>
> v2 changes:
>   - preserve errno value in the hook
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/Makefile      |   1 +
>  tools/perf/perf.c        |   2 +
>  tools/perf/perf.h        |  16 ++-
>  tools/perf/tests/attr.c  | 140 +++++++++++++++++++++
>  tools/perf/tests/attr.py | 313 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 470 insertions(+), 2 deletions(-)
>  create mode 100644 tools/perf/tests/attr.c
>  create mode 100644 tools/perf/tests/attr.py
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 2d3427f..1da87a3 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -430,6 +430,7 @@ LIB_OBJS += $(OUTPUT)arch/common.o
>  
>  LIB_OBJS += $(OUTPUT)tests/parse-events.o
>  LIB_OBJS += $(OUTPUT)tests/dso-data.o
> +LIB_OBJS += $(OUTPUT)tests/attr.o

It'd better if it has more specific name like 'event-attr' but it'd not
a big deal so no strong objection. :)

>  
>  BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
[snip]
> +#define WRITE_ASS(str, fmt, data)					\
> +do {									\
> +	char buf[BUFSIZE];						\
> +	size_t size;							\
> +									\
> +	size = snprintf(buf, BUFSIZE, #str "=%"fmt "\n", data);		\
> +	if (1 != fwrite(buf, size, 1, file)) {				\
> +		perror("test attr - failed to write event file");	\
> +		fclose(file);						\
> +		return -1;						\
> +	}								\
> +									\
> +} while (0)

What is ASS?

> +
> +static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
> +		       int fd, int group_fd, unsigned long flags)
> +{
> +	FILE *file;
> +	char path[PATH_MAX];
> +
> +	snprintf(path, PATH_MAX, "%s/event-%d-%llu-%d", dir,
> +		 attr->type, attr->config, fd);
> +
> +	file = fopen(path, "w+");
> +	if (!file) {
> +		perror("test attr - failed to open event file");
> +		return -1;
> +	}
> +
> +	if (fprintf(file, "[event-%d-%llu-%d]\n",
> +		    attr->type, attr->config, fd) < 0) {
> +		perror("test attr - failed to write event file");
> +		fclose(file);
> +		return -1;
> +	}
> +
> +	/* syscall arguments */
> +	WRITE_ASS(fd,       "d", fd);
> +	WRITE_ASS(group_fd, "d", group_fd);
> +	WRITE_ASS(cpu,      "d", cpu);
> +	WRITE_ASS(pid,      "d", pid);
> +	WRITE_ASS(flags,   "lu", flags);
> +
> +	/* struct perf_event_attr */
> +	WRITE_ASS(type,   PRIu32,  attr->type);
> +	WRITE_ASS(size,   PRIu32,  attr->size);
> +	WRITE_ASS(config,  "llu",  attr->config);
> +	WRITE_ASS(sample_period, "llu", attr->sample_period);
> +	WRITE_ASS(sample_type,   "llu", attr->sample_type);
> +	WRITE_ASS(read_format,   "llu", attr->read_format);
> +	WRITE_ASS(disabled,       "d", attr->disabled);
> +	WRITE_ASS(inherit,        "d", attr->inherit);
> +	WRITE_ASS(pinned,         "d", attr->pinned);
> +	WRITE_ASS(exclusive,      "d", attr->exclusive);
> +	WRITE_ASS(exclude_user,   "d", attr->exclude_user);
> +	WRITE_ASS(exclude_kernel, "d", attr->exclude_kernel);
> +	WRITE_ASS(exclude_hv,     "d", attr->exclude_hv);
> +	WRITE_ASS(exclude_idle,   "d", attr->exclude_idle);
> +	WRITE_ASS(mmap,           "d", attr->mmap);
> +	WRITE_ASS(comm,           "d", attr->comm);
> +	WRITE_ASS(freq,           "d", attr->freq);
> +	WRITE_ASS(inherit_stat,   "d", attr->inherit_stat);
> +	WRITE_ASS(enable_on_exec, "d", attr->enable_on_exec);
> +	WRITE_ASS(task,           "d", attr->task);
> +	WRITE_ASS(watermask,      "d", attr->watermark);
> +	WRITE_ASS(precise_ip,     "d", attr->precise_ip);
> +	WRITE_ASS(mmap_data,      "d", attr->mmap_data);
> +	WRITE_ASS(sample_id_all,  "d", attr->sample_id_all);
> +	WRITE_ASS(exclude_host,   "d", attr->exclude_host);
> +	WRITE_ASS(exclude_guest,  "d", attr->exclude_guest);
> +	WRITE_ASS(exclude_callchain_kernel, "d",
> +		  attr->exclude_callchain_kernel);
> +	WRITE_ASS(exclude_callchain_user, "d",
> +		  attr->exclude_callchain_user);
> +	WRITE_ASS(wakeup_events, PRIu32, attr->wakeup_events);
> +	WRITE_ASS(bp_type, PRIu32, attr->bp_type);
> +	WRITE_ASS(config1, "llu", attr->config1);
> +	WRITE_ASS(config2, "llu", attr->config2);
> +	WRITE_ASS(branch_sample_type, "llu", attr->branch_sample_type);
> +	WRITE_ASS(sample_regs_user,   "llu", attr->sample_regs_user);
> +	WRITE_ASS(sample_stack_user,  PRIu32, attr->sample_stack_user);
> +	WRITE_ASS(optional, "d", 0);

How about rename current WRITE_ASS to __WRITE_ASS and create a wrapper
WRITE_ASS like this:

  #define WRITE_ASS(field, fmt)  __WRITE_ASS(field, fmt, attr->field)

and use __WRITE_ASS for 'optional'.

> +
> +	fclose(file);
> +	return 0;
> +}
[snip]
> +    def compare_data(self, a, b):
> +        a_list = a.split('|')
> +        b_list = b.split('|')
> +
> +        for a_item in a_list:
> +            for b_item in b_list:
> +                if (a_item == b_item):
> +                    return True
> +                elif (a_item == '*') or (b_item == '*'):
> +                    return True
> +
> +        return False

I think it needs some comments about how it works.

> +
[snip]
> +    def load_events(self, path, events):
> +        parser_event = ConfigParser.SafeConfigParser()
> +        parser_event.read(path)
> +
> +        for section in filter(self.is_event, parser_event.sections()):
> +
> +            parser_items = parser_event.items(section);
> +            base_items   = {}
> +
> +            if (':' in section):
> +                base = section[section.index(':') + 1:]
> +                parser_base = ConfigParser.SafeConfigParser()
> +                parser_base.read(self.test_dir + '/' + base)
> +                base_items = parser_base.items('event')
> +
> +            e = Event(section, parser_items, base_items)
> +            events[section] = e

And this too. :)

Thanks,
Namhyung
