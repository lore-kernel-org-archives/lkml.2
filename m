Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab0GFWSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:18:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0GFWSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:18:47 -0400
X-Authority-Analysis: v=1.1 cv=jfMbZ+4tkgrYlaJBi3iJCtg6TDszHDHJJpQ3TdTfnr0= c=1 sm=0 a=gxuL1jqCDv4A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=zd2uoN0lAAAA:8 a=20KFwNOVAAAA:8 a=ZEadiM_zAAAA:8 a=hJDOu6ZJwdLTcnfSLuIA:9 a=e6Xh0V1NmVxnq58KowgA:7 a=4vgbMKqC2AO-ldaVSTtX5owB1pMA:4 a=PUjeQqilurYA:10 a=Sf_gFPzhefAA:10 a=wu_e27o_rKQA:10 a=jEp0ucaQiEUA:10 a=uSNbezbojJ8A:10 a=cHmjwS8CyfDqHojr:21 a=CJthTETqVgbguP8P:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 15/21] perf: Export trace event utils
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1277999763-20357-16-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
	 <1277999763-20357-16-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Jul 2010 18:18:43 -0400
Message-ID: <1278454723.1537.60.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

I'm actually working on making a libparsevent.a that does some of what
you are doing.

The idea is, if I can separate out this code from perf, I can then bring
it up to speed with what I have in trace-cmd.

-- Steve


On Thu, 2010-07-01 at 17:55 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Those are indirectly needed by parse-events.c too.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  tools/lib/Makefile                  |    3 +
>  tools/lib/trace/trace-event-info.c  |  563 ++++++
>  tools/lib/trace/trace-event-parse.c | 3233 +++++++++++++++++++++++++++++++++++
>  tools/lib/trace/trace-event-read.c  |  539 ++++++
>  tools/perf/Makefile                 |    3 -
>  tools/perf/util/trace-event-info.c  |  563 ------
>  tools/perf/util/trace-event-parse.c | 3233 -----------------------------------
>  tools/perf/util/trace-event-read.c  |  539 ------
>  8 files changed, 4338 insertions(+), 4338 deletions(-)
>  create mode 100644 tools/lib/trace/trace-event-info.c
>  create mode 100644 tools/lib/trace/trace-event-parse.c
>  create mode 100644 tools/lib/trace/trace-event-read.c
>  delete mode 100644 tools/perf/util/trace-event-info.c
>  delete mode 100644 tools/perf/util/trace-event-parse.c
>  delete mode 100644 tools/perf/util/trace-event-read.c
> 
> diff --git a/tools/lib/Makefile b/tools/lib/Makefile
> index cabef46..795fa3a 100644
> --- a/tools/lib/Makefile
> +++ b/tools/lib/Makefile
> @@ -49,6 +49,9 @@ LIB_OBJS += $(OUTPUT)perf/hist.o
>  LIB_OBJS += $(OUTPUT)perf/thread.o
>  LIB_OBJS += $(OUTPUT)perf/sort.o
>  LIB_OBJS += $(OUTPUT)perf/event.o
> +LIB_OBJS += $(OUTPUT)trace/trace-event-read.o
> +LIB_OBJS += $(OUTPUT)trace/trace-event-info.o
> +LIB_OBJS += $(OUTPUT)trace/trace-event-parse.o
>  
>  LIBFILE = lklib.a
>  
> diff --git a/tools/lib/trace/trace-event-info.c b/tools/lib/trace/trace-event-info.c
> new file mode 100644
> index 0000000..e1ad23f
> --- /dev/null
> +++ b/tools/lib/trace/trace-event-info.c
> @@ -0,0 +1,563 @@
> +/*
> + * Copyright (C) 2008,2009, Steven Rostedt <srostedt@redhat.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License (not later!)
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +#define _GNU_SOURCE
> +#include <dirent.h>
> +#include <mntent.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdarg.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/wait.h>
> +#include <pthread.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <ctype.h>
> +#include <errno.h>
> +#include <stdbool.h>
> +#include <linux/kernel.h>
> +
> +#include <perf.h>
> +#include <util/trace-event.h>
> +#include <lk/debugfs.h>
> +
> +#define VERSION "0.5"
> +
> +#define _STR(x) #x
> +#define STR(x) _STR(x)
> +#define MAX_PATH 256
> +
> +#define TRACE_CTRL	"tracing_on"
> +#define TRACE		"trace"
> +#define AVAILABLE	"available_tracers"
> +#define CURRENT		"current_tracer"
> +#define ITER_CTRL	"trace_options"
> +#define MAX_LATENCY	"tracing_max_latency"
> +
> +unsigned int page_size;
> +
> +static const char *output_file = "trace.info";
> +static int output_fd;
> +
> +struct event_list {
> +	struct event_list *next;
> +	const char *event;
> +};
> +
> +struct events {
> +	struct events *sibling;
> +	struct events *children;
> +	struct events *next;
> +	char *name;
> +};
> +
> +
> +
> +static void die(const char *fmt, ...)
> +{
> +	va_list ap;
> +	int ret = errno;
> +
> +	if (errno)
> +		perror("trace-cmd");
> +	else
> +		ret = -1;
> +
> +	va_start(ap, fmt);
> +	fprintf(stderr, "  ");
> +	vfprintf(stderr, fmt, ap);
> +	va_end(ap);
> +
> +	fprintf(stderr, "\n");
> +	exit(ret);
> +}
> +
> +void *malloc_or_die(unsigned int size)
> +{
> +	void *data;
> +
> +	data = malloc(size);
> +	if (!data)
> +		die("malloc");
> +	return data;
> +}
> +
> +static const char *find_debugfs(void)
> +{
> +	const char *path = debugfs_mount(NULL);
> +
> +	if (!path)
> +		die("Your kernel not support debugfs filesystem");
> +
> +	return path;
> +}
> +
> +/*
> + * Finds the path to the debugfs/tracing
> + * Allocates the string and stores it.
> + */
> +static const char *find_tracing_dir(void)
> +{
> +	static char *tracing;
> +	static int tracing_found;
> +	const char *debugfs;
> +
> +	if (tracing_found)
> +		return tracing;
> +
> +	debugfs = find_debugfs();
> +
> +	tracing = malloc_or_die(strlen(debugfs) + 9);
> +
> +	sprintf(tracing, "%s/tracing", debugfs);
> +
> +	tracing_found = 1;
> +	return tracing;
> +}
> +
> +static char *get_tracing_file(const char *name)
> +{
> +	const char *tracing;
> +	char *file;
> +
> +	tracing = find_tracing_dir();
> +	if (!tracing)
> +		return NULL;
> +
> +	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
> +
> +	sprintf(file, "%s/%s", tracing, name);
> +	return file;
> +}
> +
> +static void put_tracing_file(char *file)
> +{
> +	free(file);
> +}
> +
> +static ssize_t calc_data_size;
> +
> +static ssize_t write_or_die(const void *buf, size_t len)
> +{
> +	int ret;
> +
> +	if (calc_data_size) {
> +		calc_data_size += len;
> +		return len;
> +	}
> +
> +	ret = write(output_fd, buf, len);
> +	if (ret < 0)
> +		die("writing to '%s'", output_file);
> +
> +	return ret;
> +}
> +
> +int bigendian(void)
> +{
> +	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
> +	unsigned int *ptr;
> +
> +	ptr = (unsigned int *)(void *)str;
> +	return *ptr == 0x01020304;
> +}
> +
> +static unsigned long long copy_file_fd(int fd)
> +{
> +	unsigned long long size = 0;
> +	char buf[BUFSIZ];
> +	int r;
> +
> +	do {
> +		r = read(fd, buf, BUFSIZ);
> +		if (r > 0) {
> +			size += r;
> +			write_or_die(buf, r);
> +		}
> +	} while (r > 0);
> +
> +	return size;
> +}
> +
> +static unsigned long long copy_file(const char *file)
> +{
> +	unsigned long long size = 0;
> +	int fd;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		die("Can't read '%s'", file);
> +	size = copy_file_fd(fd);
> +	close(fd);
> +
> +	return size;
> +}
> +
> +static unsigned long get_size_fd(int fd)
> +{
> +	unsigned long long size = 0;
> +	char buf[BUFSIZ];
> +	int r;
> +
> +	do {
> +		r = read(fd, buf, BUFSIZ);
> +		if (r > 0)
> +			size += r;
> +	} while (r > 0);
> +
> +	lseek(fd, 0, SEEK_SET);
> +
> +	return size;
> +}
> +
> +static unsigned long get_size(const char *file)
> +{
> +	unsigned long long size = 0;
> +	int fd;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		die("Can't read '%s'", file);
> +	size = get_size_fd(fd);
> +	close(fd);
> +
> +	return size;
> +}
> +
> +static void read_header_files(void)
> +{
> +	unsigned long long size, check_size;
> +	char *path;
> +	int fd;
> +
> +	path = get_tracing_file("events/header_page");
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		die("can't read '%s'", path);
> +
> +	/* unfortunately, you can not stat debugfs files for size */
> +	size = get_size_fd(fd);
> +
> +	write_or_die("header_page", 12);
> +	write_or_die(&size, 8);
> +	check_size = copy_file_fd(fd);
> +	close(fd);
> +
> +	if (size != check_size)
> +		die("wrong size for '%s' size=%lld read=%lld",
> +		    path, size, check_size);
> +	put_tracing_file(path);
> +
> +	path = get_tracing_file("events/header_event");
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0)
> +		die("can't read '%s'", path);
> +
> +	size = get_size_fd(fd);
> +
> +	write_or_die("header_event", 13);
> +	write_or_die(&size, 8);
> +	check_size = copy_file_fd(fd);
> +	if (size != check_size)
> +		die("wrong size for '%s'", path);
> +	put_tracing_file(path);
> +	close(fd);
> +}
> +
> +static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
> +{
> +	while (tps) {
> +		if (!strcmp(sys, tps->name))
> +			return true;
> +		tps = tps->next;
> +	}
> +
> +	return false;
> +}
> +
> +static void copy_event_system(const char *sys, struct tracepoint_path *tps)
> +{
> +	unsigned long long size, check_size;
> +	struct dirent *dent;
> +	struct stat st;
> +	char *format;
> +	DIR *dir;
> +	int count = 0;
> +	int ret;
> +
> +	dir = opendir(sys);
> +	if (!dir)
> +		die("can't read directory '%s'", sys);
> +
> +	while ((dent = readdir(dir))) {
> +		if (dent->d_type != DT_DIR ||
> +		    strcmp(dent->d_name, ".") == 0 ||
> +		    strcmp(dent->d_name, "..") == 0 ||
> +		    !name_in_tp_list(dent->d_name, tps))
> +			continue;
> +		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
> +		sprintf(format, "%s/%s/format", sys, dent->d_name);
> +		ret = stat(format, &st);
> +		free(format);
> +		if (ret < 0)
> +			continue;
> +		count++;
> +	}
> +
> +	write_or_die(&count, 4);
> +
> +	rewinddir(dir);
> +	while ((dent = readdir(dir))) {
> +		if (dent->d_type != DT_DIR ||
> +		    strcmp(dent->d_name, ".") == 0 ||
> +		    strcmp(dent->d_name, "..") == 0 ||
> +		    !name_in_tp_list(dent->d_name, tps))
> +			continue;
> +		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
> +		sprintf(format, "%s/%s/format", sys, dent->d_name);
> +		ret = stat(format, &st);
> +
> +		if (ret >= 0) {
> +			/* unfortunately, you can not stat debugfs files for size */
> +			size = get_size(format);
> +			write_or_die(&size, 8);
> +			check_size = copy_file(format);
> +			if (size != check_size)
> +				die("error in size of file '%s'", format);
> +		}
> +
> +		free(format);
> +	}
> +	closedir(dir);
> +}
> +
> +static void read_ftrace_files(struct tracepoint_path *tps)
> +{
> +	char *path;
> +
> +	path = get_tracing_file("events/ftrace");
> +
> +	copy_event_system(path, tps);
> +
> +	put_tracing_file(path);
> +}
> +
> +static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
> +{
> +	while (tps) {
> +		if (!strcmp(sys, tps->system))
> +			return true;
> +		tps = tps->next;
> +	}
> +
> +	return false;
> +}
> +
> +static void read_event_files(struct tracepoint_path *tps)
> +{
> +	struct dirent *dent;
> +	struct stat st;
> +	char *path;
> +	char *sys;
> +	DIR *dir;
> +	int count = 0;
> +	int ret;
> +
> +	path = get_tracing_file("events");
> +
> +	dir = opendir(path);
> +	if (!dir)
> +		die("can't read directory '%s'", path);
> +
> +	while ((dent = readdir(dir))) {
> +		if (dent->d_type != DT_DIR ||
> +		    strcmp(dent->d_name, ".") == 0 ||
> +		    strcmp(dent->d_name, "..") == 0 ||
> +		    strcmp(dent->d_name, "ftrace") == 0 ||
> +		    !system_in_tp_list(dent->d_name, tps))
> +			continue;
> +		count++;
> +	}
> +
> +	write_or_die(&count, 4);
> +
> +	rewinddir(dir);
> +	while ((dent = readdir(dir))) {
> +		if (dent->d_type != DT_DIR ||
> +		    strcmp(dent->d_name, ".") == 0 ||
> +		    strcmp(dent->d_name, "..") == 0 ||
> +		    strcmp(dent->d_name, "ftrace") == 0 ||
> +		    !system_in_tp_list(dent->d_name, tps))
> +			continue;
> +		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
> +		sprintf(sys, "%s/%s", path, dent->d_name);
> +		ret = stat(sys, &st);
> +		if (ret >= 0) {
> +			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
> +			copy_event_system(sys, tps);
> +		}
> +		free(sys);
> +	}
> +
> +	closedir(dir);
> +	put_tracing_file(path);
> +}
> +
> +static void read_proc_kallsyms(void)
> +{
> +	unsigned int size, check_size;
> +	const char *path = "/proc/kallsyms";
> +	struct stat st;
> +	int ret;
> +
> +	ret = stat(path, &st);
> +	if (ret < 0) {
> +		/* not found */
> +		size = 0;
> +		write_or_die(&size, 4);
> +		return;
> +	}
> +	size = get_size(path);
> +	write_or_die(&size, 4);
> +	check_size = copy_file(path);
> +	if (size != check_size)
> +		die("error in size of file '%s'", path);
> +
> +}
> +
> +static void read_ftrace_printk(void)
> +{
> +	unsigned int size, check_size;
> +	char *path;
> +	struct stat st;
> +	int ret;
> +
> +	path = get_tracing_file("printk_formats");
> +	ret = stat(path, &st);
> +	if (ret < 0) {
> +		/* not found */
> +		size = 0;
> +		write_or_die(&size, 4);
> +		goto out;
> +	}
> +	size = get_size(path);
> +	write_or_die(&size, 4);
> +	check_size = copy_file(path);
> +	if (size != check_size)
> +		die("error in size of file '%s'", path);
> +out:
> +	put_tracing_file(path);
> +}
> +
> +static struct tracepoint_path *
> +get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
> +{
> +	struct tracepoint_path path, *ppath = &path;
> +	int i, nr_tracepoints = 0;
> +
> +	for (i = 0; i < nb_events; i++) {
> +		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
> +			continue;
> +		++nr_tracepoints;
> +		ppath->next = tracepoint_id_to_path(pattrs[i].config);
> +		if (!ppath->next)
> +			die("%s\n", "No memory to alloc tracepoints list");
> +		ppath = ppath->next;
> +	}
> +
> +	return nr_tracepoints > 0 ? path.next : NULL;
> +}
> +
> +bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
> +{
> +	int i;
> +
> +	for (i = 0; i < nb_events; i++)
> +		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
> +			return true;
> +
> +	return false;
> +}
> +
> +int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
> +{
> +	char buf[BUFSIZ];
> +	struct tracepoint_path *tps = get_tracepoints_path(pattrs, nb_events);
> +
> +	/*
> +	 * What? No tracepoints? No sense writing anything here, bail out.
> +	 */
> +	if (tps == NULL)
> +		return -1;
> +
> +	output_fd = fd;
> +
> +	buf[0] = 23;
> +	buf[1] = 8;
> +	buf[2] = 68;
> +	memcpy(buf + 3, "tracing", 7);
> +
> +	write_or_die(buf, 10);
> +
> +	write_or_die(VERSION, strlen(VERSION) + 1);
> +
> +	/* save endian */
> +	if (bigendian())
> +		buf[0] = 1;
> +	else
> +		buf[0] = 0;
> +
> +	write_or_die(buf, 1);
> +
> +	/* save size of long */
> +	buf[0] = sizeof(long);
> +	write_or_die(buf, 1);
> +
> +	/* save page_size */
> +	page_size = sysconf(_SC_PAGESIZE);
> +	write_or_die(&page_size, 4);
> +
> +	read_header_files();
> +	read_ftrace_files(tps);
> +	read_event_files(tps);
> +	read_proc_kallsyms();
> +	read_ftrace_printk();
> +
> +	return 0;
> +}
> +
> +ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
> +			       int nb_events)
> +{
> +	ssize_t size;
> +	int err = 0;
> +
> +	calc_data_size = 1;
> +	err = read_tracing_data(fd, pattrs, nb_events);
> +	size = calc_data_size - 1;
> +	calc_data_size = 0;
> +
> +	if (err < 0)
> +		return err;
> +
> +	return size;
> +}
> diff --git a/tools/lib/trace/trace-event-parse.c b/tools/lib/trace/trace-event-parse.c
> new file mode 100644
> index 0000000..d76c350
> --- /dev/null
> +++ b/tools/lib/trace/trace-event-parse.c
> @@ -0,0 +1,3233 @@
> +/*
> + * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License (not later!)
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  The parts for function graph printing was taken and modified from the
> + *  Linux Kernel that were written by Frederic Weisbecker.
> + */
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <ctype.h>
> +#include <errno.h>
> +
> +#undef _GNU_SOURCE
> +#include <perf.h>
> +#include <lk/util.h>
> +#include <util/trace-event.h>
> +
> +int header_page_ts_offset;
> +int header_page_ts_size;
> +int header_page_size_offset;
> +int header_page_size_size;
> +int header_page_overwrite_offset;
> +int header_page_overwrite_size;
> +int header_page_data_offset;
> +int header_page_data_size;
> +
> +bool latency_format;
> +
> +static char *input_buf;
> +static unsigned long long input_buf_ptr;
> +static unsigned long long input_buf_siz;
> +
> +static int cpus;
> +static int long_size;
> +static int is_flag_field;
> +static int is_symbolic_field;
> +
> +static struct format_field *
> +find_any_field(struct event *event, const char *name);
> +
> +static void init_input_buf(char *buf, unsigned long long size)
> +{
> +	input_buf = buf;
> +	input_buf_siz = size;
> +	input_buf_ptr = 0;
> +}
> +
> +struct cmdline {
> +	char *comm;
> +	int pid;
> +};
> +
> +static struct cmdline *cmdlines;
> +static int cmdline_count;
> +
> +static int cmdline_cmp(const void *a, const void *b)
> +{
> +	const struct cmdline *ca = a;
> +	const struct cmdline *cb = b;
> +
> +	if (ca->pid < cb->pid)
> +		return -1;
> +	if (ca->pid > cb->pid)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +void parse_cmdlines(char *file, int size __unused)
> +{
> +	struct cmdline_list {
> +		struct cmdline_list	*next;
> +		char			*comm;
> +		int			pid;
> +	} *list = NULL, *item;
> +	char *line;
> +	char *next = NULL;
> +	int i;
> +
> +	line = strtok_r(file, "\n", &next);
> +	while (line) {
> +		item = malloc_or_die(sizeof(*item));
> +		sscanf(line, "%d %as", &item->pid,
> +		       (float *)(void *)&item->comm); /* workaround gcc warning */
> +		item->next = list;
> +		list = item;
> +		line = strtok_r(NULL, "\n", &next);
> +		cmdline_count++;
> +	}
> +
> +	cmdlines = malloc_or_die(sizeof(*cmdlines) * cmdline_count);
> +
> +	i = 0;
> +	while (list) {
> +		cmdlines[i].pid = list->pid;
> +		cmdlines[i].comm = list->comm;
> +		i++;
> +		item = list;
> +		list = list->next;
> +		free(item);
> +	}
> +
> +	qsort(cmdlines, cmdline_count, sizeof(*cmdlines), cmdline_cmp);
> +}
> +
> +static struct func_map {
> +	unsigned long long		addr;
> +	char				*func;
> +	char				*mod;
> +} *func_list;
> +static unsigned int func_count;
> +
> +static int func_cmp(const void *a, const void *b)
> +{
> +	const struct func_map *fa = a;
> +	const struct func_map *fb = b;
> +
> +	if (fa->addr < fb->addr)
> +		return -1;
> +	if (fa->addr > fb->addr)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +void parse_proc_kallsyms(char *file, unsigned int size __unused)
> +{
> +	struct func_list {
> +		struct func_list	*next;
> +		unsigned long long	addr;
> +		char			*func;
> +		char			*mod;
> +	} *list = NULL, *item;
> +	char *line;
> +	char *next = NULL;
> +	char *addr_str;
> +	char ch;
> +	int ret;
> +	int i;
> +
> +	line = strtok_r(file, "\n", &next);
> +	while (line) {
> +		item = malloc_or_die(sizeof(*item));
> +		item->mod = NULL;
> +		ret = sscanf(line, "%as %c %as\t[%as",
> +			     (float *)(void *)&addr_str, /* workaround gcc warning */
> +			     &ch,
> +			     (float *)(void *)&item->func,
> +			     (float *)(void *)&item->mod);
> +		item->addr = strtoull(addr_str, NULL, 16);
> +		free(addr_str);
> +
> +		/* truncate the extra ']' */
> +		if (item->mod)
> +			item->mod[strlen(item->mod) - 1] = 0;
> +
> +
> +		item->next = list;
> +		list = item;
> +		line = strtok_r(NULL, "\n", &next);
> +		func_count++;
> +	}
> +
> +	func_list = malloc_or_die(sizeof(*func_list) * (func_count + 1));
> +
> +	i = 0;
> +	while (list) {
> +		func_list[i].func = list->func;
> +		func_list[i].addr = list->addr;
> +		func_list[i].mod = list->mod;
> +		i++;
> +		item = list;
> +		list = list->next;
> +		free(item);
> +	}
> +
> +	qsort(func_list, func_count, sizeof(*func_list), func_cmp);
> +
> +	/*
> +	 * Add a special record at the end.
> +	 */
> +	func_list[func_count].func = NULL;
> +	func_list[func_count].addr = 0;
> +	func_list[func_count].mod = NULL;
> +}
> +
> +/*
> + * We are searching for a record in between, not an exact
> + * match.
> + */
> +static int func_bcmp(const void *a, const void *b)
> +{
> +	const struct func_map *fa = a;
> +	const struct func_map *fb = b;
> +
> +	if ((fa->addr == fb->addr) ||
> +
> +	    (fa->addr > fb->addr &&
> +	     fa->addr < (fb+1)->addr))
> +		return 0;
> +
> +	if (fa->addr < fb->addr)
> +		return -1;
> +
> +	return 1;
> +}
> +
> +static struct func_map *find_func(unsigned long long addr)
> +{
> +	struct func_map *func;
> +	struct func_map key;
> +
> +	key.addr = addr;
> +
> +	func = bsearch(&key, func_list, func_count, sizeof(*func_list),
> +		       func_bcmp);
> +
> +	return func;
> +}
> +
> +void print_funcs(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < (int)func_count; i++) {
> +		printf("%016llx %s",
> +		       func_list[i].addr,
> +		       func_list[i].func);
> +		if (func_list[i].mod)
> +			printf(" [%s]\n", func_list[i].mod);
> +		else
> +			printf("\n");
> +	}
> +}
> +
> +static struct printk_map {
> +	unsigned long long		addr;
> +	char				*printk;
> +} *printk_list;
> +static unsigned int printk_count;
> +
> +static int printk_cmp(const void *a, const void *b)
> +{
> +	const struct func_map *fa = a;
> +	const struct func_map *fb = b;
> +
> +	if (fa->addr < fb->addr)
> +		return -1;
> +	if (fa->addr > fb->addr)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static struct printk_map *find_printk(unsigned long long addr)
> +{
> +	struct printk_map *printk;
> +	struct printk_map key;
> +
> +	key.addr = addr;
> +
> +	printk = bsearch(&key, printk_list, printk_count, sizeof(*printk_list),
> +			 printk_cmp);
> +
> +	return printk;
> +}
> +
> +void parse_ftrace_printk(char *file, unsigned int size __unused)
> +{
> +	struct printk_list {
> +		struct printk_list	*next;
> +		unsigned long long	addr;
> +		char			*printk;
> +	} *list = NULL, *item;
> +	char *line;
> +	char *next = NULL;
> +	char *addr_str;
> +	int i;
> +
> +	line = strtok_r(file, "\n", &next);
> +	while (line) {
> +		addr_str = strsep(&line, ":");
> +		if (!line) {
> +			warning("error parsing print strings");
> +			break;
> +		}
> +		item = malloc_or_die(sizeof(*item));
> +		item->addr = strtoull(addr_str, NULL, 16);
> +		/* fmt still has a space, skip it */
> +		item->printk = strdup(line+1);
> +		item->next = list;
> +		list = item;
> +		line = strtok_r(NULL, "\n", &next);
> +		printk_count++;
> +	}
> +
> +	printk_list = malloc_or_die(sizeof(*printk_list) * printk_count + 1);
> +
> +	i = 0;
> +	while (list) {
> +		printk_list[i].printk = list->printk;
> +		printk_list[i].addr = list->addr;
> +		i++;
> +		item = list;
> +		list = list->next;
> +		free(item);
> +	}
> +
> +	qsort(printk_list, printk_count, sizeof(*printk_list), printk_cmp);
> +}
> +
> +void print_printk(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < (int)printk_count; i++) {
> +		printf("%016llx %s\n",
> +		       printk_list[i].addr,
> +		       printk_list[i].printk);
> +	}
> +}
> +
> +static struct event *alloc_event(void)
> +{
> +	struct event *event;
> +
> +	event = malloc_or_die(sizeof(*event));
> +	memset(event, 0, sizeof(*event));
> +
> +	return event;
> +}
> +
> +enum event_type {
> +	EVENT_ERROR,
> +	EVENT_NONE,
> +	EVENT_SPACE,
> +	EVENT_NEWLINE,
> +	EVENT_OP,
> +	EVENT_DELIM,
> +	EVENT_ITEM,
> +	EVENT_DQUOTE,
> +	EVENT_SQUOTE,
> +};
> +
> +static struct event *event_list;
> +
> +static void add_event(struct event *event)
> +{
> +	event->next = event_list;
> +	event_list = event;
> +}
> +
> +static int event_item_type(enum event_type type)
> +{
> +	switch (type) {
> +	case EVENT_ITEM ... EVENT_SQUOTE:
> +		return 1;
> +	case EVENT_ERROR ... EVENT_DELIM:
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static void free_arg(struct print_arg *arg)
> +{
> +	if (!arg)
> +		return;
> +
> +	switch (arg->type) {
> +	case PRINT_ATOM:
> +		if (arg->atom.atom)
> +			free(arg->atom.atom);
> +		break;
> +	case PRINT_NULL:
> +	case PRINT_FIELD ... PRINT_OP:
> +	default:
> +		/* todo */
> +		break;
> +	}
> +
> +	free(arg);
> +}
> +
> +static enum event_type get_type(int ch)
> +{
> +	if (ch == '\n')
> +		return EVENT_NEWLINE;
> +	if (isspace(ch))
> +		return EVENT_SPACE;
> +	if (isalnum(ch) || ch == '_')
> +		return EVENT_ITEM;
> +	if (ch == '\'')
> +		return EVENT_SQUOTE;
> +	if (ch == '"')
> +		return EVENT_DQUOTE;
> +	if (!isprint(ch))
> +		return EVENT_NONE;
> +	if (ch == '(' || ch == ')' || ch == ',')
> +		return EVENT_DELIM;
> +
> +	return EVENT_OP;
> +}
> +
> +static int __read_char(void)
> +{
> +	if (input_buf_ptr >= input_buf_siz)
> +		return -1;
> +
> +	return input_buf[input_buf_ptr++];
> +}
> +
> +static int __peek_char(void)
> +{
> +	if (input_buf_ptr >= input_buf_siz)
> +		return -1;
> +
> +	return input_buf[input_buf_ptr];
> +}
> +
> +static enum event_type __read_token(char **tok)
> +{
> +	char buf[BUFSIZ];
> +	int ch, last_ch, quote_ch, next_ch;
> +	int i = 0;
> +	int tok_size = 0;
> +	enum event_type type;
> +
> +	*tok = NULL;
> +
> +
> +	ch = __read_char();
> +	if (ch < 0)
> +		return EVENT_NONE;
> +
> +	type = get_type(ch);
> +	if (type == EVENT_NONE)
> +		return type;
> +
> +	buf[i++] = ch;
> +
> +	switch (type) {
> +	case EVENT_NEWLINE:
> +	case EVENT_DELIM:
> +		*tok = malloc_or_die(2);
> +		(*tok)[0] = ch;
> +		(*tok)[1] = 0;
> +		return type;
> +
> +	case EVENT_OP:
> +		switch (ch) {
> +		case '-':
> +			next_ch = __peek_char();
> +			if (next_ch == '>') {
> +				buf[i++] = __read_char();
> +				break;
> +			}
> +			/* fall through */
> +		case '+':
> +		case '|':
> +		case '&':
> +		case '>':
> +		case '<':
> +			last_ch = ch;
> +			ch = __peek_char();
> +			if (ch != last_ch)
> +				goto test_equal;
> +			buf[i++] = __read_char();
> +			switch (last_ch) {
> +			case '>':
> +			case '<':
> +				goto test_equal;
> +			default:
> +				break;
> +			}
> +			break;
> +		case '!':
> +		case '=':
> +			goto test_equal;
> +		default: /* what should we do instead? */
> +			break;
> +		}
> +		buf[i] = 0;
> +		*tok = strdup(buf);
> +		return type;
> +
> + test_equal:
> +		ch = __peek_char();
> +		if (ch == '=')
> +			buf[i++] = __read_char();
> +		break;
> +
> +	case EVENT_DQUOTE:
> +	case EVENT_SQUOTE:
> +		/* don't keep quotes */
> +		i--;
> +		quote_ch = ch;
> +		last_ch = 0;
> +		do {
> +			if (i == (BUFSIZ - 1)) {
> +				buf[i] = 0;
> +				if (*tok) {
> +					*tok = realloc(*tok, tok_size + BUFSIZ);
> +					if (!*tok)
> +						return EVENT_NONE;
> +					strcat(*tok, buf);
> +				} else
> +					*tok = strdup(buf);
> +
> +				if (!*tok)
> +					return EVENT_NONE;
> +				tok_size += BUFSIZ;
> +				i = 0;
> +			}
> +			last_ch = ch;
> +			ch = __read_char();
> +			buf[i++] = ch;
> +			/* the '\' '\' will cancel itself */
> +			if (ch == '\\' && last_ch == '\\')
> +				last_ch = 0;
> +		} while (ch != quote_ch || last_ch == '\\');
> +		/* remove the last quote */
> +		i--;
> +		goto out;
> +
> +	case EVENT_ERROR ... EVENT_SPACE:
> +	case EVENT_ITEM:
> +	default:
> +		break;
> +	}
> +
> +	while (get_type(__peek_char()) == type) {
> +		if (i == (BUFSIZ - 1)) {
> +			buf[i] = 0;
> +			if (*tok) {
> +				*tok = realloc(*tok, tok_size + BUFSIZ);
> +				if (!*tok)
> +					return EVENT_NONE;
> +				strcat(*tok, buf);
> +			} else
> +				*tok = strdup(buf);
> +
> +			if (!*tok)
> +				return EVENT_NONE;
> +			tok_size += BUFSIZ;
> +			i = 0;
> +		}
> +		ch = __read_char();
> +		buf[i++] = ch;
> +	}
> +
> + out:
> +	buf[i] = 0;
> +	if (*tok) {
> +		*tok = realloc(*tok, tok_size + i);
> +		if (!*tok)
> +			return EVENT_NONE;
> +		strcat(*tok, buf);
> +	} else
> +		*tok = strdup(buf);
> +	if (!*tok)
> +		return EVENT_NONE;
> +
> +	return type;
> +}
> +
> +static void free_token(char *tok)
> +{
> +	if (tok)
> +		free(tok);
> +}
> +
> +static enum event_type read_token(char **tok)
> +{
> +	enum event_type type;
> +
> +	for (;;) {
> +		type = __read_token(tok);
> +		if (type != EVENT_SPACE)
> +			return type;
> +
> +		free_token(*tok);
> +	}
> +
> +	/* not reached */
> +	return EVENT_NONE;
> +}
> +
> +/* no newline */
> +static enum event_type read_token_item(char **tok)
> +{
> +	enum event_type type;
> +
> +	for (;;) {
> +		type = __read_token(tok);
> +		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
> +			return type;
> +
> +		free_token(*tok);
> +	}
> +
> +	/* not reached */
> +	return EVENT_NONE;
> +}
> +
> +static int test_type(enum event_type type, enum event_type expect)
> +{
> +	if (type != expect) {
> +		warning("Error: expected type %d but read %d",
> +		    expect, type);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static int __test_type_token(enum event_type type, char *token,
> +			     enum event_type expect, const char *expect_tok,
> +			     bool warn)
> +{
> +	if (type != expect) {
> +		if (warn)
> +			warning("Error: expected type %d but read %d",
> +				expect, type);
> +		return -1;
> +	}
> +
> +	if (strcmp(token, expect_tok) != 0) {
> +		if (warn)
> +			warning("Error: expected '%s' but read '%s'",
> +				expect_tok, token);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static int test_type_token(enum event_type type, char *token,
> +			   enum event_type expect, const char *expect_tok)
> +{
> +	return __test_type_token(type, token, expect, expect_tok, true);
> +}
> +
> +static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
> +{
> +	enum event_type type;
> +
> +	if (newline_ok)
> +		type = read_token(tok);
> +	else
> +		type = read_token_item(tok);
> +	return test_type(type, expect);
> +}
> +
> +static int read_expect_type(enum event_type expect, char **tok)
> +{
> +	return __read_expect_type(expect, tok, 1);
> +}
> +
> +static int __read_expected(enum event_type expect, const char *str,
> +			   int newline_ok, bool warn)
> +{
> +	enum event_type type;
> +	char *token;
> +	int ret;
> +
> +	if (newline_ok)
> +		type = read_token(&token);
> +	else
> +		type = read_token_item(&token);
> +
> +	ret = __test_type_token(type, token, expect, str, warn);
> +
> +	free_token(token);
> +
> +	return ret;
> +}
> +
> +static int read_expected(enum event_type expect, const char *str)
> +{
> +	return __read_expected(expect, str, 1, true);
> +}
> +
> +static int read_expected_item(enum event_type expect, const char *str)
> +{
> +	return __read_expected(expect, str, 0, true);
> +}
> +
> +static char *event_read_name(void)
> +{
> +	char *token;
> +
> +	if (read_expected(EVENT_ITEM, "name") < 0)
> +		return NULL;
> +
> +	if (read_expected(EVENT_OP, ":") < 0)
> +		return NULL;
> +
> +	if (read_expect_type(EVENT_ITEM, &token) < 0)
> +		goto fail;
> +
> +	return token;
> +
> + fail:
> +	free_token(token);
> +	return NULL;
> +}
> +
> +static int event_read_id(void)
> +{
> +	char *token;
> +	int id;
> +
> +	if (read_expected_item(EVENT_ITEM, "ID") < 0)
> +		return -1;
> +
> +	if (read_expected(EVENT_OP, ":") < 0)
> +		return -1;
> +
> +	if (read_expect_type(EVENT_ITEM, &token) < 0)
> +		goto fail;
> +
> +	id = strtoul(token, NULL, 0);
> +	free_token(token);
> +	return id;
> +
> + fail:
> +	free_token(token);
> +	return -1;
> +}
> +
> +static int field_is_string(struct format_field *field)
> +{
> +	if ((field->flags & FIELD_IS_ARRAY) &&
> +	    (!strstr(field->type, "char") || !strstr(field->type, "u8") ||
> +	     !strstr(field->type, "s8")))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int field_is_dynamic(struct format_field *field)
> +{
> +	if (!strncmp(field->type, "__data_loc", 10))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int event_read_fields(struct event *event, struct format_field **fields)
> +{
> +	struct format_field *field = NULL;
> +	enum event_type type;
> +	char *token;
> +	char *last_token;
> +	int count = 0;
> +
> +	do {
> +		type = read_token(&token);
> +		if (type == EVENT_NEWLINE) {
> +			free_token(token);
> +			return count;
> +		}
> +
> +		count++;
> +
> +		if (test_type_token(type, token, EVENT_ITEM, "field"))
> +			goto fail;
> +		free_token(token);
> +
> +		type = read_token(&token);
> +		/*
> +		 * The ftrace fields may still use the "special" name.
> +		 * Just ignore it.
> +		 */
> +		if (event->flags & EVENT_FL_ISFTRACE &&
> +		    type == EVENT_ITEM && strcmp(token, "special") == 0) {
> +			free_token(token);
> +			type = read_token(&token);
> +		}
> +
> +		if (test_type_token(type, token, EVENT_OP, ":") < 0)
> +			return -1;
> +
> +		if (read_expect_type(EVENT_ITEM, &token) < 0)
> +			goto fail;
> +
> +		last_token = token;
> +
> +		field = malloc_or_die(sizeof(*field));
> +		memset(field, 0, sizeof(*field));
> +
> +		/* read the rest of the type */
> +		for (;;) {
> +			type = read_token(&token);
> +			if (type == EVENT_ITEM ||
> +			    (type == EVENT_OP && strcmp(token, "*") == 0) ||
> +			    /*
> +			     * Some of the ftrace fields are broken and have
> +			     * an illegal "." in them.
> +			     */
> +			    (event->flags & EVENT_FL_ISFTRACE &&
> +			     type == EVENT_OP && strcmp(token, ".") == 0)) {
> +
> +				if (strcmp(token, "*") == 0)
> +					field->flags |= FIELD_IS_POINTER;
> +
> +				if (field->type) {
> +					field->type = realloc(field->type,
> +							      strlen(field->type) +
> +							      strlen(last_token) + 2);
> +					strcat(field->type, " ");
> +					strcat(field->type, last_token);
> +				} else
> +					field->type = last_token;
> +				last_token = token;
> +				continue;
> +			}
> +
> +			break;
> +		}
> +
> +		if (!field->type) {
> +			die("no type found");
> +			goto fail;
> +		}
> +		field->name = last_token;
> +
> +		if (test_type(type, EVENT_OP))
> +			goto fail;
> +
> +		if (strcmp(token, "[") == 0) {
> +			enum event_type last_type = type;
> +			char *brackets = token;
> +			int len;
> +
> +			field->flags |= FIELD_IS_ARRAY;
> +
> +			type = read_token(&token);
> +		        while (strcmp(token, "]") != 0) {
> +				if (last_type == EVENT_ITEM &&
> +				    type == EVENT_ITEM)
> +					len = 2;
> +				else
> +					len = 1;
> +				last_type = type;
> +
> +				brackets = realloc(brackets,
> +						   strlen(brackets) +
> +						   strlen(token) + len);
> +				if (len == 2)
> +					strcat(brackets, " ");
> +				strcat(brackets, token);
> +				free_token(token);
> +				type = read_token(&token);
> +				if (type == EVENT_NONE) {
> +					die("failed to find token");
> +					goto fail;
> +				}
> +			}
> +
> +			free_token(token);
> +
> +			brackets = realloc(brackets, strlen(brackets) + 2);
> +			strcat(brackets, "]");
> +
> +			/* add brackets to type */
> +
> +			type = read_token(&token);
> +			/*
> +			 * If the next token is not an OP, then it is of
> +			 * the format: type [] item;
> +			 */
> +			if (type == EVENT_ITEM) {
> +				field->type = realloc(field->type,
> +						      strlen(field->type) +
> +						      strlen(field->name) +
> +						      strlen(brackets) + 2);
> +				strcat(field->type, " ");
> +				strcat(field->type, field->name);
> +				free_token(field->name);
> +				strcat(field->type, brackets);
> +				field->name = token;
> +				type = read_token(&token);
> +			} else {
> +				field->type = realloc(field->type,
> +						      strlen(field->type) +
> +						      strlen(brackets) + 1);
> +				strcat(field->type, brackets);
> +			}
> +			free(brackets);
> +		}
> +
> +		if (field_is_string(field)) {
> +			field->flags |= FIELD_IS_STRING;
> +			if (field_is_dynamic(field))
> +				field->flags |= FIELD_IS_DYNAMIC;
> +		}
> +
> +		if (test_type_token(type, token,  EVENT_OP, ";"))
> +			goto fail;
> +		free_token(token);
> +
> +		if (read_expected(EVENT_ITEM, "offset") < 0)
> +			goto fail_expect;
> +
> +		if (read_expected(EVENT_OP, ":") < 0)
> +			goto fail_expect;
> +
> +		if (read_expect_type(EVENT_ITEM, &token))
> +			goto fail;
> +		field->offset = strtoul(token, NULL, 0);
> +		free_token(token);
> +
> +		if (read_expected(EVENT_OP, ";") < 0)
> +			goto fail_expect;
> +
> +		if (read_expected(EVENT_ITEM, "size") < 0)
> +			goto fail_expect;
> +
> +		if (read_expected(EVENT_OP, ":") < 0)
> +			goto fail_expect;
> +
> +		if (read_expect_type(EVENT_ITEM, &token))
> +			goto fail;
> +		field->size = strtoul(token, NULL, 0);
> +		free_token(token);
> +
> +		if (read_expected(EVENT_OP, ";") < 0)
> +			goto fail_expect;
> +
> +		type = read_token(&token);
> +		if (type != EVENT_NEWLINE) {
> +			/* newer versions of the kernel have a "signed" type */
> +			if (test_type_token(type, token, EVENT_ITEM, "signed"))
> +				goto fail;
> +
> +			free_token(token);
> +
> +			if (read_expected(EVENT_OP, ":") < 0)
> +				goto fail_expect;
> +
> +			if (read_expect_type(EVENT_ITEM, &token))
> +				goto fail;
> +
> +			if (strtoul(token, NULL, 0))
> +				field->flags |= FIELD_IS_SIGNED;
> +
> +			free_token(token);
> +			if (read_expected(EVENT_OP, ";") < 0)
> +				goto fail_expect;
> +
> +			if (read_expect_type(EVENT_NEWLINE, &token))
> +				goto fail;
> +		}
> +
> +		free_token(token);
> +
> +		*fields = field;
> +		fields = &field->next;
> +
> +	} while (1);
> +
> +	return 0;
> +
> +fail:
> +	free_token(token);
> +fail_expect:
> +	if (field)
> +		free(field);
> +	return -1;
> +}
> +
> +static int event_read_format(struct event *event)
> +{
> +	char *token;
> +	int ret;
> +
> +	if (read_expected_item(EVENT_ITEM, "format") < 0)
> +		return -1;
> +
> +	if (read_expected(EVENT_OP, ":") < 0)
> +		return -1;
> +
> +	if (read_expect_type(EVENT_NEWLINE, &token))
> +		goto fail;
> +	free_token(token);
> +
> +	ret = event_read_fields(event, &event->format.common_fields);
> +	if (ret < 0)
> +		return ret;
> +	event->format.nr_common = ret;
> +
> +	ret = event_read_fields(event, &event->format.fields);
> +	if (ret < 0)
> +		return ret;
> +	event->format.nr_fields = ret;
> +
> +	return 0;
> +
> + fail:
> +	free_token(token);
> +	return -1;
> +}
> +
> +enum event_type
> +process_arg_token(struct event *event, struct print_arg *arg,
> +		  char **tok, enum event_type type);
> +
> +static enum event_type
> +process_arg(struct event *event, struct print_arg *arg, char **tok)
> +{
> +	enum event_type type;
> +	char *token;
> +
> +	type = read_token(&token);
> +	*tok = token;
> +
> +	return process_arg_token(event, arg, tok, type);
> +}
> +
> +static enum event_type
> +process_cond(struct event *event, struct print_arg *top, char **tok)
> +{
> +	struct print_arg *arg, *left, *right;
> +	enum event_type type;
> +	char *token = NULL;
> +
> +	arg = malloc_or_die(sizeof(*arg));
> +	memset(arg, 0, sizeof(*arg));
> +
> +	left = malloc_or_die(sizeof(*left));
> +
> +	right = malloc_or_die(sizeof(*right));
> +
> +	arg->type = PRINT_OP;
> +	arg->op.left = left;
> +	arg->op.right = right;
> +
> +	*tok = NULL;
> +	type = process_arg(event, left, &token);
> +	if (test_type_token(type, token, EVENT_OP, ":"))
> +		goto out_free;
> +
> +	arg->op.op = token;
> +
> +	type = process_arg(event, right, &token);
> +
> +	top->op.right = arg;
> +
> +	*tok = token;
> +	return type;
> +
> +out_free:
> +	free_token(*tok);
> +	free(right);
> +	free(left);
> +	free_arg(arg);
> +	return EVENT_ERROR;
> +}
> +
> +static enum event_type
> +process_array(struct event *event, struct print_arg *top, char **tok)
> +{
> +	struct print_arg *arg;
> +	enum event_type type;
> +	char *token = NULL;
> +
> +	arg = malloc_or_die(sizeof(*arg));
> +	memset(arg, 0, sizeof(*arg));
> +
> +	*tok = NULL;
> +	type = process_arg(event, arg, &token);
> +	if (test_type_token(type, token, EVENT_OP, "]"))
> +		goto out_free;
> +
> +	top->op.right = arg;
> +
> +	free_token(token);
> +	type = read_token_item(&token);
> +	*tok = token;
> +
> +	return type;
> +
> +out_free:
> +	free_token(*tok);
> +	free_arg(arg);
> +	return EVENT_ERROR;
> +}
> +
> +static int get_op_prio(char *op)
> +{
> +	if (!op[1]) {
> +		switch (op[0]) {
> +		case '*':
> +		case '/':
> +		case '%':
> +			return 6;
> +		case '+':
> +		case '-':
> +			return 7;
> +			/* '>>' and '<<' are 8 */
> +		case '<':
> +		case '>':
> +			return 9;
> +			/* '==' and '!=' are 10 */
> +		case '&':
> +			return 11;
> +		case '^':
> +			return 12;
> +		case '|':
> +			return 13;
> +		case '?':
> +			return 16;
> +		default:
> +			die("unknown op '%c'", op[0]);
> +			return -1;
> +		}
> +	} else {
> +		if (strcmp(op, "++") == 0 ||
> +		    strcmp(op, "--") == 0) {
> +			return 3;
> +		} else if (strcmp(op, ">>") == 0 ||
> +			   strcmp(op, "<<") == 0) {
> +			return 8;
> +		} else if (strcmp(op, ">=") == 0 ||
> +			   strcmp(op, "<=") == 0) {
> +			return 9;
> +		} else if (strcmp(op, "==") == 0 ||
> +			   strcmp(op, "!=") == 0) {
> +			return 10;
> +		} else if (strcmp(op, "&&") == 0) {
> +			return 14;
> +		} else if (strcmp(op, "||") == 0) {
> +			return 15;
> +		} else {
> +			die("unknown op '%s'", op);
> +			return -1;
> +		}
> +	}
> +}
> +
> +static void set_op_prio(struct print_arg *arg)
> +{
> +
> +	/* single ops are the greatest */
> +	if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
> +		arg->op.prio = 0;
> +		return;
> +	}
> +
> +	arg->op.prio = get_op_prio(arg->op.op);
> +}
> +
> +static enum event_type
> +process_op(struct event *event, struct print_arg *arg, char **tok)
> +{
> +	struct print_arg *left, *right = NULL;
> +	enum event_type type;
> +	char *token;
> +
> +	/* the op is passed in via tok */
> +	token = *tok;
> +
> +	if (arg->type == PRINT_OP && !arg->op.left) {
> +		/* handle single op */
> +		if (token[1]) {
> +			die("bad op token %s", token);
> +			return EVENT_ERROR;
> +		}
> +		switch (token[0]) {
> +		case '!':
> +		case '+':
> +		case '-':
> +			break;
> +		default:
> +			die("bad op token %s", token);
> +			return EVENT_ERROR;
> +		}
> +
> +		/* make an empty left */
> +		left = malloc_or_die(sizeof(*left));
> +		left->type = PRINT_NULL;
> +		arg->op.left = left;
> +
> +		right = malloc_or_die(sizeof(*right));
> +		arg->op.right = right;
> +
> +		type = process_arg(event, right, tok);
> +
> +	} else if (strcmp(token, "?") == 0) {
> +
> +		left = malloc_or_die(sizeof(*left));
> +		/* copy the top arg to the left */
> +		*left = *arg;
> +
> +		arg->type = PRINT_OP;
> +		arg->op.op = token;
> +		arg->op.left = left;
> +		arg->op.prio = 0;
> +
> +		type = process_cond(event, arg, tok);
> +
> +	} else if (strcmp(token, ">>") == 0 ||
> +		   strcmp(token, "<<") == 0 ||
> +		   strcmp(token, "&") == 0 ||
> +		   strcmp(token, "|") == 0 ||
> +		   strcmp(token, "&&") == 0 ||
> +		   strcmp(token, "||") == 0 ||
> +		   strcmp(token, "-") == 0 ||
> +		   strcmp(token, "+") == 0 ||
> +		   strcmp(token, "*") == 0 ||
> +		   strcmp(token, "^") == 0 ||
> +		   strcmp(token, "/") == 0 ||
> +		   strcmp(token, "<") == 0 ||
> +		   strcmp(token, ">") == 0 ||
> +		   strcmp(token, "==") == 0 ||
> +		   strcmp(token, "!=") == 0) {
> +
> +		left = malloc_or_die(sizeof(*left));
> +
> +		/* copy the top arg to the left */
> +		*left = *arg;
> +
> +		arg->type = PRINT_OP;
> +		arg->op.op = token;
> +		arg->op.left = left;
> +
> +		set_op_prio(arg);
> +
> +		right = malloc_or_die(sizeof(*right));
> +
> +		type = read_token_item(&token);
> +		*tok = token;
> +
> +		/* could just be a type pointer */
> +		if ((strcmp(arg->op.op, "*") == 0) &&
> +		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
> +			if (left->type != PRINT_ATOM)
> +				die("bad pointer type");
> +			left->atom.atom = realloc(left->atom.atom,
> +					    sizeof(left->atom.atom) + 3);
> +			strcat(left->atom.atom, " *");
> +			*arg = *left;
> +			free(arg);
> +
> +			return type;
> +		}
> +
> +		type = process_arg_token(event, right, tok, type);
> +
> +		arg->op.right = right;
> +
> +	} else if (strcmp(token, "[") == 0) {
> +
> +		left = malloc_or_die(sizeof(*left));
> +		*left = *arg;
> +
> +		arg->type = PRINT_OP;
> +		arg->op.op = token;
> +		arg->op.left = left;
> +
> +		arg->op.prio = 0;
> +		type = process_array(event, arg, tok);
> +
> +	} else {
> +		warning("unknown op '%s'", token);
> +		event->flags |= EVENT_FL_FAILED;
> +		/* the arg is now the left side */
> +		return EVENT_NONE;
> +	}
> +
> +	if (type == EVENT_OP) {
> +		int prio;
> +
> +		/* higher prios need to be closer to the root */
> +		prio = get_op_prio(*tok);
> +
> +		if (prio > arg->op.prio)
> +			return process_op(event, arg, tok);
> +
> +		return process_op(event, right, tok);
> +	}
> +
> +	return type;
> +}
> +
> +static enum event_type
> +process_entry(struct event *event __unused, struct print_arg *arg,
> +	      char **tok)
> +{
> +	enum event_type type;
> +	char *field;
> +	char *token;
> +
> +	if (read_expected(EVENT_OP, "->") < 0)
> +		return EVENT_ERROR;
> +
> +	if (read_expect_type(EVENT_ITEM, &token) < 0)
> +		goto fail;
> +	field = token;
> +
> +	arg->type = PRINT_FIELD;
> +	arg->field.name = field;
> +
> +	if (is_flag_field) {
> +		arg->field.field = find_any_field(event, arg->field.name);
> +		arg->field.field->flags |= FIELD_IS_FLAG;
> +		is_flag_field = 0;
> +	} else if (is_symbolic_field) {
> +		arg->field.field = find_any_field(event, arg->field.name);
> +		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
> +		is_symbolic_field = 0;
> +	}
> +
> +	type = read_token(&token);
> +	*tok = token;
> +
> +	return type;
> +
> +fail:
> +	free_token(token);
> +	return EVENT_ERROR;
> +}
> +
> +static char *arg_eval (struct print_arg *arg);
> +
> +static long long arg_num_eval(struct print_arg *arg)
> +{
> +	long long left, right;
> +	long long val = 0;
> +
> +	switch (arg->type) {
> +	case PRINT_ATOM:
> +		val = strtoll(arg->atom.atom, NULL, 0);
> +		break;
> +	case PRINT_TYPE:
> +		val = arg_num_eval(arg->typecast.item);
> +		break;
> +	case PRINT_OP:
> +		switch (arg->op.op[0]) {
> +		case '|':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +			if (arg->op.op[1])
> +				val = left || right;
> +			else
> +				val = left | right;
> +			break;
> +		case '&':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +			if (arg->op.op[1])
> +				val = left && right;
> +			else
> +				val = left & right;
> +			break;
> +		case '<':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +			switch (arg->op.op[1]) {
> +			case 0:
> +				val = left < right;
> +				break;
> +			case '<':
> +				val = left << right;
> +				break;
> +			case '=':
> +				val = left <= right;
> +				break;
> +			default:
> +				die("unknown op '%s'", arg->op.op);
> +			}
> +			break;
> +		case '>':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +			switch (arg->op.op[1]) {
> +			case 0:
> +				val = left > right;
> +				break;
> +			case '>':
> +				val = left >> right;
> +				break;
> +			case '=':
> +				val = left >= right;
> +				break;
> +			default:
> +				die("unknown op '%s'", arg->op.op);
> +			}
> +			break;
> +		case '=':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +
> +			if (arg->op.op[1] != '=')
> +				die("unknown op '%s'", arg->op.op);
> +
> +			val = left == right;
> +			break;
> +		case '!':
> +			left = arg_num_eval(arg->op.left);
> +			right = arg_num_eval(arg->op.right);
> +
> +			switch (arg->op.op[1]) {
> +			case '=':
> +				val = left != right;
> +				break;
> +			default:
> +				die("unknown op '%s'", arg->op.op);
> +			}
> +			break;
> +		default:
> +			die("unknown op '%s'", arg->op.op);
> +		}
> +		break;
> +
> +	case PRINT_NULL:
> +	case PRINT_FIELD ... PRINT_SYMBOL:
> +	case PRINT_STRING:
> +	default:
> +		die("invalid eval type %d", arg->type);
> +
> +	}
> +	return val;
> +}
> +
> +static char *arg_eval (struct print_arg *arg)
> +{
> +	long long val;
> +	static char buf[20];
> +
> +	switch (arg->type) {
> +	case PRINT_ATOM:
> +		return arg->atom.atom;
> +	case PRINT_TYPE:
> +		return arg_eval(arg->typecast.item);
> +	case PRINT_OP:
> +		val = arg_num_eval(arg);
> +		sprintf(buf, "%lld", val);
> +		return buf;
> +
> +	case PRINT_NULL:
> +	case PRINT_FIELD ... PRINT_SYMBOL:
> +	case PRINT_STRING:
> +	default:
> +		die("invalid eval type %d", arg->type);
> +		break;
> +	}
> +
> +	return NULL;
> +}
> +
> +static enum event_type
> +process_fields(struct event *event, struct print_flag_sym **list, char **tok)
> +{
> +	enum event_type type;
> +	struct print_arg *arg = NULL;
> +	struct print_flag_sym *field;
> +	char *token = NULL;
> +	char *value;
> +
> +	do {
> +		free_token(token);
> +		type = read_token_item(&token);
> +		if (test_type_token(type, token, EVENT_OP, "{"))
> +			break;
> +
> +		arg = malloc_or_die(sizeof(*arg));
> +
> +		free_token(token);
> +		type = process_arg(event, arg, &token);
> +		if (test_type_token(type, token, EVENT_DELIM, ","))
> +			goto out_free;
> +
> +		field = malloc_or_die(sizeof(*field));
> +		memset(field, 0, sizeof(*field));
> +
> +		value = arg_eval(arg);
> +		field->value = strdup(value);
> +
> +		free_token(token);
> +		type = process_arg(event, arg, &token);
> +		if (test_type_token(type, token, EVENT_OP, "}"))
> +			goto out_free;
> +
> +		value = arg_eval(arg);
> +		field->str = strdup(value);
> +		free_arg(arg);
> +		arg = NULL;
> +
> +		*list = field;
> +		list = &field->next;
> +
> +		free_token(token);
> +		type = read_token_item(&token);
> +	} while (type == EVENT_DELIM && strcmp(token, ",") == 0);
> +
> +	*tok = token;
> +	return type;
> +
> +out_free:
> +	free_arg(arg);
> +	free_token(token);
> +
> +	return EVENT_ERROR;
> +}
> +
> +static enum event_type
> +process_flags(struct event *event, struct print_arg *arg, char **tok)
> +{
> +	struct print_arg *field;
> +	enum event_type type;
> +	char *token;
> +
> +	memset(arg, 0, sizeof(*arg));
> +	arg->type = PRINT_FLAGS;
> +
> +	if (read_expected_item(EVENT_DELIM, "(") < 0)
> +		return EVENT_ERROR;
> +
> +	field = malloc_or_die(sizeof(*field));
> +
> +	type = process_arg(event, field, &token);
> +	if (test_type_token(type, token, EVENT_DELIM, ","))
> +		goto out_free;
> +
> +	arg->flags.field = field;
> +
> +	type = read_token_item(&token);
> +	if (event_item_type(type)) {
> +		arg->flags.delim = token;
> +		type = read_token_item(&token);
> +	}
> +
> +	if (test_type_token(type, token, EVENT_DELIM, ","))
> +		goto out_free;
> +
> +	type = process_fields(event, &arg->flags.flags, &token);
> +	if (test_type_token(type, token, EVENT_DELIM, ")"))
> +		goto out_free;
> +
> +	free_token(token);
> +	type = read_token_item(tok);
> +	return type;
> +
> +out_free:
> +	free_token(token);
> +	return EVENT_ERROR;
> +}
> +
> +static enum event_type
> +process_symbols(struct event *event, struct print_arg *arg, char **tok)
> +{
> +	struct print_arg *field;
> +	enum event_type type;
> +	char *token;
> +
> +	memset(arg, 0, sizeof(*arg));
> +	arg->type = PRINT_SYMBOL;
> +
> +	if (read_expected_item(EVENT_DELIM, "(") < 0)
> +		return EVENT_ERROR;
> +
> +	field = malloc_or_die(sizeof(*field));
> +
> +	type = process_arg(event, field, &token);
> +	if (test_type_token(type, token, EVENT_DELIM, ","))
> +		goto out_free;
> +
> +	arg->symbol.field = field;
> +
> +	type = process_fields(event, &arg->symbol.symbols, &token);
> +	if (test_type_token(type, token, EVENT_DELIM, ")"))
> +		goto out_free;
> +
> +	free_token(token);
> +	type = read_token_item(tok);
> +	return type;
> +
> +out_free:
> +	free_token(token);
> +	return EVENT_ERROR;
> +}
> +
> +static enum event_type
> +process_paren(struct event *event, struct print_arg *arg, char **tok)
> +{
> +	struct print_arg *item_arg;
> +	enum event_type type;
> +	char *token;
> +
> +	type = process_arg(event, arg, &token);
> +
> +	if (type == EVENT_ERROR)
> +		return EVENT_ERROR;
> +
> +	if (type == EVENT_OP)
> +		type = process_op(event, arg, &token);
> +
> +	if (type == EVENT_ERROR)
> +		return EVENT_ERROR;
> +
> +	if (test_type_token(type, token, EVENT_DELIM, ")")) {
> +		free_token(token);
> +		return EVENT_ERROR;
> +	}
> +
> +	free_token(token);
> +	type = read_token_item(&token);
> +
> +	/*
> +	 * If the next token is an item or another open paren, then
> +	 * this was a typecast.
> +	 */
> +	if (event_item_type(type) ||
> +	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
> +
> +		/* make this a typecast and contine */
> +
> +		/* prevous must be an atom */
> +		if (arg->type != PRINT_ATOM)
> +			die("previous needed to be PRINT_ATOM");
> +
> +		item_arg = malloc_or_die(sizeof(*item_arg));
> +
> +		arg->type = PRINT_TYPE;
> +		arg->typecast.type = arg->atom.atom;
> +		arg->typecast.item = item_arg;
> +		type = process_arg_token(event, item_arg, &token, type);
> +
> +	}
> +
> +	*tok = token;
> +	return type;
> +}
> +
> +
> +static enum event_type
> +process_str(struct event *event __unused, struct print_arg *arg, char **tok)
> +{
> +	enum event_type type;
> +	char *token;
> +
> +	if (read_expected(EVENT_DELIM, "(") < 0)
> +		return EVENT_ERROR;
> +
> +	if (read_expect_type(EVENT_ITEM, &token) < 0)
> +		goto fail;
> +
> +	arg->type = PRINT_STRING;
> +	arg->string.string = token;
> +	arg->string.offset = -1;
> +
> +	if (read_expected(EVENT_DELIM, ")") < 0)
> +		return EVENT_ERROR;
> +
> +	type = read_token(&token);
> +	*tok = token;
> +
> +	return type;
> +fail:
> +	free_token(token);
> +	return EVENT_ERROR;
> +}
> +
> +enum event_type
> +process_arg_token(struct event *event, struct print_arg *arg,
> +		  char **tok, enum event_type type)
> +{
> +	char *token;
> +	char *atom;
> +
> +	token = *tok;
> +
> +	switch (type) {
> +	case EVENT_ITEM:
> +		if (strcmp(token, "REC") == 0) {
> +			free_token(token);
> +			type = process_entry(event, arg, &token);
> +		} else if (strcmp(token, "__print_flags") == 0) {
> +			free_token(token);
> +			is_flag_field = 1;
> +			type = process_flags(event, arg, &token);
> +		} else if (strcmp(token, "__print_symbolic") == 0) {
> +			free_token(token);
> +			is_symbolic_field = 1;
> +			type = process_symbols(event, arg, &token);
> +		} else if (strcmp(token, "__get_str") == 0) {
> +			free_token(token);
> +			type = process_str(event, arg, &token);
> +		} else {
> +			atom = token;
> +			/* test the next token */
> +			type = read_token_item(&token);
> +
> +			/* atoms can be more than one token long */
> +			while (type == EVENT_ITEM) {
> +				atom = realloc(atom, strlen(atom) + strlen(token) + 2);
> +				strcat(atom, " ");
> +				strcat(atom, token);
> +				free_token(token);
> +				type = read_token_item(&token);
> +			}
> +
> +			/* todo, test for function */
> +
> +			arg->type = PRINT_ATOM;
> +			arg->atom.atom = atom;
> +		}
> +		break;
> +	case EVENT_DQUOTE:
> +	case EVENT_SQUOTE:
> +		arg->type = PRINT_ATOM;
> +		arg->atom.atom = token;
> +		type = read_token_item(&token);
> +		break;
> +	case EVENT_DELIM:
> +		if (strcmp(token, "(") == 0) {
> +			free_token(token);
> +			type = process_paren(event, arg, &token);
> +			break;
> +		}
> +	case EVENT_OP:
> +		/* handle single ops */
> +		arg->type = PRINT_OP;
> +		arg->op.op = token;
> +		arg->op.left = NULL;
> +		type = process_op(event, arg, &token);
> +
> +		break;
> +
> +	case EVENT_ERROR ... EVENT_NEWLINE:
> +	default:
> +		die("unexpected type %d", type);
> +	}
> +	*tok = token;
> +
> +	return type;
> +}
> +
> +static int event_read_print_args(struct event *event, struct print_arg **list)
> +{
> +	enum event_type type = EVENT_ERROR;
> +	struct print_arg *arg;
> +	char *token;
> +	int args = 0;
> +
> +	do {
> +		if (type == EVENT_NEWLINE) {
> +			free_token(token);
> +			type = read_token_item(&token);
> +			continue;
> +		}
> +
> +		arg = malloc_or_die(sizeof(*arg));
> +		memset(arg, 0, sizeof(*arg));
> +
> +		type = process_arg(event, arg, &token);
> +
> +		if (type == EVENT_ERROR) {
> +			free_arg(arg);
> +			return -1;
> +		}
> +
> +		*list = arg;
> +		args++;
> +
> +		if (type == EVENT_OP) {
> +			type = process_op(event, arg, &token);
> +			list = &arg->next;
> +			continue;
> +		}
> +
> +		if (type == EVENT_DELIM && strcmp(token, ",") == 0) {
> +			free_token(token);
> +			*list = arg;
> +			list = &arg->next;
> +			continue;
> +		}
> +		break;
> +	} while (type != EVENT_NONE);
> +
> +	if (type != EVENT_NONE)
> +		free_token(token);
> +
> +	return args;
> +}
> +
> +static int event_read_print(struct event *event)
> +{
> +	enum event_type type;
> +	char *token;
> +	int ret;
> +
> +	if (read_expected_item(EVENT_ITEM, "print") < 0)
> +		return -1;
> +
> +	if (read_expected(EVENT_ITEM, "fmt") < 0)
> +		return -1;
> +
> +	if (read_expected(EVENT_OP, ":") < 0)
> +		return -1;
> +
> +	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
> +		goto fail;
> +
> + concat:
> +	event->print_fmt.format = token;
> +	event->print_fmt.args = NULL;
> +
> +	/* ok to have no arg */
> +	type = read_token_item(&token);
> +
> +	if (type == EVENT_NONE)
> +		return 0;
> +
> +	/* Handle concatination of print lines */
> +	if (type == EVENT_DQUOTE) {
> +		char *cat;
> +
> +		cat = malloc_or_die(strlen(event->print_fmt.format) +
> +				    strlen(token) + 1);
> +		strcpy(cat, event->print_fmt.format);
> +		strcat(cat, token);
> +		free_token(token);
> +		free_token(event->print_fmt.format);
> +		event->print_fmt.format = NULL;
> +		token = cat;
> +		goto concat;
> +	}
> +
> +	if (test_type_token(type, token, EVENT_DELIM, ","))
> +		goto fail;
> +
> +	free_token(token);
> +
> +	ret = event_read_print_args(event, &event->print_fmt.args);
> +	if (ret < 0)
> +		return -1;
> +
> +	return ret;
> +
> + fail:
> +	free_token(token);
> +	return -1;
> +}
> +
> +static struct format_field *
> +find_common_field(struct event *event, const char *name)
> +{
> +	struct format_field *format;
> +
> +	for (format = event->format.common_fields;
> +	     format; format = format->next) {
> +		if (strcmp(format->name, name) == 0)
> +			break;
> +	}
> +
> +	return format;
> +}
> +
> +static struct format_field *
> +find_field(struct event *event, const char *name)
> +{
> +	struct format_field *format;
> +
> +	for (format = event->format.fields;
> +	     format; format = format->next) {
> +		if (strcmp(format->name, name) == 0)
> +			break;
> +	}
> +
> +	return format;
> +}
> +
> +static struct format_field *
> +find_any_field(struct event *event, const char *name)
> +{
> +	struct format_field *format;
> +
> +	format = find_common_field(event, name);
> +	if (format)
> +		return format;
> +	return find_field(event, name);
> +}
> +
> +unsigned long long read_size(void *ptr, int size)
> +{
> +	switch (size) {
> +	case 1:
> +		return *(unsigned char *)ptr;
> +	case 2:
> +		return data2host2(ptr);
> +	case 4:
> +		return data2host4(ptr);
> +	case 8:
> +		return data2host8(ptr);
> +	default:
> +		/* BUG! */
> +		return 0;
> +	}
> +}
> +
> +unsigned long long
> +raw_field_value(struct event *event, const char *name, void *data)
> +{
> +	struct format_field *field;
> +
> +	field = find_any_field(event, name);
> +	if (!field)
> +		return 0ULL;
> +
> +	return read_size(data + field->offset, field->size);
> +}
> +
> +void *raw_field_ptr(struct event *event, const char *name, void *data)
> +{
> +	struct format_field *field;
> +
> +	field = find_any_field(event, name);
> +	if (!field)
> +		return NULL;
> +
> +	if (field->flags & FIELD_IS_DYNAMIC) {
> +		int offset;
> +
> +		offset = *(int *)(data + field->offset);
> +		offset &= 0xffff;
> +
> +		return data + offset;
> +	}
> +
> +	return data + field->offset;
> +}
> +
> +static int get_common_info(const char *type, int *offset, int *size)
> +{
> +	struct event *event;
> +	struct format_field *field;
> +
> +	/*
> +	 * All events should have the same common elements.
> +	 * Pick any event to find where the type is;
> +	 */
> +	if (!event_list)
> +		die("no event_list!");
> +
> +	event = event_list;
> +	field = find_common_field(event, type);
> +	if (!field)
> +		die("field '%s' not found", type);
> +
> +	*offset = field->offset;
> +	*size = field->size;
> +
> +	return 0;
> +}
> +
> +static int __parse_common(void *data, int *size, int *offset,
> +			  const char *name)
> +{
> +	int ret;
> +
> +	if (!*size) {
> +		ret = get_common_info(name, offset, size);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return read_size(data + *offset, *size);
> +}
> +
> +int trace_parse_common_type(void *data)
> +{
> +	static int type_offset;
> +	static int type_size;
> +
> +	return __parse_common(data, &type_size, &type_offset,
> +			      "common_type");
> +}
> +
> +int trace_parse_common_pid(void *data)
> +{
> +	static int pid_offset;
> +	static int pid_size;
> +
> +	return __parse_common(data, &pid_size, &pid_offset,
> +			      "common_pid");
> +}
> +
> +int parse_common_pc(void *data)
> +{
> +	static int pc_offset;
> +	static int pc_size;
> +
> +	return __parse_common(data, &pc_size, &pc_offset,
> +			      "common_preempt_count");
> +}
> +
> +int parse_common_flags(void *data)
> +{
> +	static int flags_offset;
> +	static int flags_size;
> +
> +	return __parse_common(data, &flags_size, &flags_offset,
> +			      "common_flags");
> +}
> +
> +int parse_common_lock_depth(void *data)
> +{
> +	static int ld_offset;
> +	static int ld_size;
> +	int ret;
> +
> +	ret = __parse_common(data, &ld_size, &ld_offset,
> +			     "common_lock_depth");
> +	if (ret < 0)
> +		return -1;
> +
> +	return ret;
> +}
> +
> +struct event *trace_find_event(int id)
> +{
> +	struct event *event;
> +
> +	for (event = event_list; event; event = event->next) {
> +		if (event->id == id)
> +			break;
> +	}
> +	return event;
> +}
> +
> +struct event *trace_find_next_event(struct event *event)
> +{
> +	if (!event)
> +		return event_list;
> +
> +	return event->next;
> +}
> +
> +static unsigned long long eval_num_arg(void *data, int size,
> +				   struct event *event, struct print_arg *arg)
> +{
> +	unsigned long long val = 0;
> +	unsigned long long left, right;
> +	struct print_arg *larg;
> +
> +	switch (arg->type) {
> +	case PRINT_NULL:
> +		/* ?? */
> +		return 0;
> +	case PRINT_ATOM:
> +		return strtoull(arg->atom.atom, NULL, 0);
> +	case PRINT_FIELD:
> +		if (!arg->field.field) {
> +			arg->field.field = find_any_field(event, arg->field.name);
> +			if (!arg->field.field)
> +				die("field %s not found", arg->field.name);
> +		}
> +		/* must be a number */
> +		val = read_size(data + arg->field.field->offset,
> +				arg->field.field->size);
> +		break;
> +	case PRINT_FLAGS:
> +	case PRINT_SYMBOL:
> +		break;
> +	case PRINT_TYPE:
> +		return eval_num_arg(data, size, event, arg->typecast.item);
> +	case PRINT_STRING:
> +		return 0;
> +		break;
> +	case PRINT_OP:
> +		if (strcmp(arg->op.op, "[") == 0) {
> +			/*
> +			 * Arrays are special, since we don't want
> +			 * to read the arg as is.
> +			 */
> +			if (arg->op.left->type != PRINT_FIELD)
> +				goto default_op; /* oops, all bets off */
> +			larg = arg->op.left;
> +			if (!larg->field.field) {
> +				larg->field.field =
> +					find_any_field(event, larg->field.name);
> +				if (!larg->field.field)
> +					die("field %s not found", larg->field.name);
> +			}
> +			right = eval_num_arg(data, size, event, arg->op.right);
> +			val = read_size(data + larg->field.field->offset +
> +					right * long_size, long_size);
> +			break;
> +		}
> + default_op:
> +		left = eval_num_arg(data, size, event, arg->op.left);
> +		right = eval_num_arg(data, size, event, arg->op.right);
> +		switch (arg->op.op[0]) {
> +		case '|':
> +			if (arg->op.op[1])
> +				val = left || right;
> +			else
> +				val = left | right;
> +			break;
> +		case '&':
> +			if (arg->op.op[1])
> +				val = left && right;
> +			else
> +				val = left & right;
> +			break;
> +		case '<':
> +			switch (arg->op.op[1]) {
> +			case 0:
> +				val = left < right;
> +				break;
> +			case '<':
> +				val = left << right;
> +				break;
> +			case '=':
> +				val = left <= right;
> +				break;
> +			default:
> +				die("unknown op '%s'", arg->op.op);
> +			}
> +			break;
> +		case '>':
> +			switch (arg->op.op[1]) {
> +			case 0:
> +				val = left > right;
> +				break;
> +			case '>':
> +				val = left >> right;
> +				break;
> +			case '=':
> +				val = left >= right;
> +				break;
> +			default:
> +				die("unknown op '%s'", arg->op.op);
> +			}
> +			break;
> +		case '=':
> +			if (arg->op.op[1] != '=')
> +				die("unknown op '%s'", arg->op.op);
> +			val = left == right;
> +			break;
> +		case '-':
> +			val = left - right;
> +			break;
> +		case '+':
> +			val = left + right;
> +			break;
> +		default:
> +			die("unknown op '%s'", arg->op.op);
> +		}
> +		break;
> +	default: /* not sure what to do there */
> +		return 0;
> +	}
> +	return val;
> +}
> +
> +struct flag {
> +	const char *name;
> +	unsigned long long value;
> +};
> +
> +static const struct flag flags[] = {
> +	{ "HI_SOFTIRQ", 0 },
> +	{ "TIMER_SOFTIRQ", 1 },
> +	{ "NET_TX_SOFTIRQ", 2 },
> +	{ "NET_RX_SOFTIRQ", 3 },
> +	{ "BLOCK_SOFTIRQ", 4 },
> +	{ "BLOCK_IOPOLL_SOFTIRQ", 5 },
> +	{ "TASKLET_SOFTIRQ", 6 },
> +	{ "SCHED_SOFTIRQ", 7 },
> +	{ "HRTIMER_SOFTIRQ", 8 },
> +	{ "RCU_SOFTIRQ", 9 },
> +
> +	{ "HRTIMER_NORESTART", 0 },
> +	{ "HRTIMER_RESTART", 1 },
> +};
> +
> +unsigned long long eval_flag(const char *flag)
> +{
> +	int i;
> +
> +	/*
> +	 * Some flags in the format files do not get converted.
> +	 * If the flag is not numeric, see if it is something that
> +	 * we already know about.
> +	 */
> +	if (isdigit(flag[0]))
> +		return strtoull(flag, NULL, 0);
> +
> +	for (i = 0; i < (int)(sizeof(flags)/sizeof(flags[0])); i++)
> +		if (strcmp(flags[i].name, flag) == 0)
> +			return flags[i].value;
> +
> +	return 0;
> +}
> +
> +static void print_str_arg(void *data, int size,
> +			  struct event *event, struct print_arg *arg)
> +{
> +	struct print_flag_sym *flag;
> +	unsigned long long val, fval;
> +	char *str;
> +	int print;
> +
> +	switch (arg->type) {
> +	case PRINT_NULL:
> +		/* ?? */
> +		return;
> +	case PRINT_ATOM:
> +		printf("%s", arg->atom.atom);
> +		return;
> +	case PRINT_FIELD:
> +		if (!arg->field.field) {
> +			arg->field.field = find_any_field(event, arg->field.name);
> +			if (!arg->field.field)
> +				die("field %s not found", arg->field.name);
> +		}
> +		str = malloc_or_die(arg->field.field->size + 1);
> +		memcpy(str, data + arg->field.field->offset,
> +		       arg->field.field->size);
> +		str[arg->field.field->size] = 0;
> +		printf("%s", str);
> +		free(str);
> +		break;
> +	case PRINT_FLAGS:
> +		val = eval_num_arg(data, size, event, arg->flags.field);
> +		print = 0;
> +		for (flag = arg->flags.flags; flag; flag = flag->next) {
> +			fval = eval_flag(flag->value);
> +			if (!val && !fval) {
> +				printf("%s", flag->str);
> +				break;
> +			}
> +			if (fval && (val & fval) == fval) {
> +				if (print && arg->flags.delim)
> +					printf("%s", arg->flags.delim);
> +				printf("%s", flag->str);
> +				print = 1;
> +				val &= ~fval;
> +			}
> +		}
> +		break;
> +	case PRINT_SYMBOL:
> +		val = eval_num_arg(data, size, event, arg->symbol.field);
> +		for (flag = arg->symbol.symbols; flag; flag = flag->next) {
> +			fval = eval_flag(flag->value);
> +			if (val == fval) {
> +				printf("%s", flag->str);
> +				break;
> +			}
> +		}
> +		break;
> +
> +	case PRINT_TYPE:
> +		break;
> +	case PRINT_STRING: {
> +		int str_offset;
> +
> +		if (arg->string.offset == -1) {
> +			struct format_field *f;
> +
> +			f = find_any_field(event, arg->string.string);
> +			arg->string.offset = f->offset;
> +		}
> +		str_offset = *(int *)(data + arg->string.offset);
> +		str_offset &= 0xffff;
> +		printf("%s", ((char *)data) + str_offset);
> +		break;
> +	}
> +	case PRINT_OP:
> +		/*
> +		 * The only op for string should be ? :
> +		 */
> +		if (arg->op.op[0] != '?')
> +			return;
> +		val = eval_num_arg(data, size, event, arg->op.left);
> +		if (val)
> +			print_str_arg(data, size, event, arg->op.right->op.left);
> +		else
> +			print_str_arg(data, size, event, arg->op.right->op.right);
> +		break;
> +	default:
> +		/* well... */
> +		break;
> +	}
> +}
> +
> +static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event *event)
> +{
> +	static struct format_field *field, *ip_field;
> +	struct print_arg *args, *arg, **next;
> +	unsigned long long ip, val;
> +	char *ptr;
> +	void *bptr;
> +
> +	if (!field) {
> +		field = find_field(event, "buf");
> +		if (!field)
> +			die("can't find buffer field for binary printk");
> +		ip_field = find_field(event, "ip");
> +		if (!ip_field)
> +			die("can't find ip field for binary printk");
> +	}
> +
> +	ip = read_size(data + ip_field->offset, ip_field->size);
> +
> +	/*
> +	 * The first arg is the IP pointer.
> +	 */
> +	args = malloc_or_die(sizeof(*args));
> +	arg = args;
> +	arg->next = NULL;
> +	next = &arg->next;
> +
> +	arg->type = PRINT_ATOM;
> +	arg->atom.atom = malloc_or_die(32);
> +	sprintf(arg->atom.atom, "%lld", ip);
> +
> +	/* skip the first "%pf : " */
> +	for (ptr = fmt + 6, bptr = data + field->offset;
> +	     bptr < data + size && *ptr; ptr++) {
> +		int ls = 0;
> +
> +		if (*ptr == '%') {
> + process_again:
> +			ptr++;
> +			switch (*ptr) {
> +			case '%':
> +				break;
> +			case 'l':
> +				ls++;
> +				goto process_again;
> +			case 'L':
> +				ls = 2;
> +				goto process_again;
> +			case '0' ... '9':
> +				goto process_again;
> +			case 'p':
> +				ls = 1;
> +				/* fall through */
> +			case 'd':
> +			case 'u':
> +			case 'x':
> +			case 'i':
> +				/* the pointers are always 4 bytes aligned */
> +				bptr = (void *)(((unsigned long)bptr + 3) &
> +						~3);
> +				switch (ls) {
> +				case 0:
> +				case 1:
> +					ls = long_size;
> +					break;
> +				case 2:
> +					ls = 8;
> +				default:
> +					break;
> +				}
> +				val = read_size(bptr, ls);
> +				bptr += ls;
> +				arg = malloc_or_die(sizeof(*arg));
> +				arg->next = NULL;
> +				arg->type = PRINT_ATOM;
> +				arg->atom.atom = malloc_or_die(32);
> +				sprintf(arg->atom.atom, "%lld", val);
> +				*next = arg;
> +				next = &arg->next;
> +				break;
> +			case 's':
> +				arg = malloc_or_die(sizeof(*arg));
> +				arg->next = NULL;
> +				arg->type = PRINT_STRING;
> +				arg->string.string = strdup(bptr);
> +				bptr += strlen(bptr) + 1;
> +				*next = arg;
> +				next = &arg->next;
> +			default:
> +				break;
> +			}
> +		}
> +	}
> +
> +	return args;
> +}
> +
> +static void free_args(struct print_arg *args)
> +{
> +	struct print_arg *next;
> +
> +	while (args) {
> +		next = args->next;
> +
> +		if (args->type == PRINT_ATOM)
> +			free(args->atom.atom);
> +		else
> +			free(args->string.string);
> +		free(args);
> +		args = next;
> +	}
> +}
> +
> +static char *get_bprint_format(void *data, int size __unused, struct event *event)
> +{
> +	unsigned long long addr;
> +	static struct format_field *field;
> +	struct printk_map *printk;
> +	char *format;
> +	char *p;
> +
> +	if (!field) {
> +		field = find_field(event, "fmt");
> +		if (!field)
> +			die("can't find format field for binary printk");
> +		printf("field->offset = %d size=%d\n", field->offset, field->size);
> +	}
> +
> +	addr = read_size(data + field->offset, field->size);
> +
> +	printk = find_printk(addr);
> +	if (!printk) {
> +		format = malloc_or_die(45);
> +		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
> +			addr);
> +		return format;
> +	}
> +
> +	p = printk->printk;
> +	/* Remove any quotes. */
> +	if (*p == '"')
> +		p++;
> +	format = malloc_or_die(strlen(p) + 10);
> +	sprintf(format, "%s : %s", "%pf", p);
> +	/* remove ending quotes and new line since we will add one too */
> +	p = format + strlen(format) - 1;
> +	if (*p == '"')
> +		*p = 0;
> +
> +	p -= 2;
> +	if (strcmp(p, "\\n") == 0)
> +		*p = 0;
> +
> +	return format;
> +}
> +
> +static void pretty_print(void *data, int size, struct event *event)
> +{
> +	struct print_fmt *print_fmt = &event->print_fmt;
> +	struct print_arg *arg = print_fmt->args;
> +	struct print_arg *args = NULL;
> +	const char *ptr = print_fmt->format;
> +	unsigned long long val;
> +	struct func_map *func;
> +	const char *saveptr;
> +	char *bprint_fmt = NULL;
> +	char format[32];
> +	int show_func;
> +	int len;
> +	int ls;
> +
> +	if (event->flags & EVENT_FL_ISFUNC)
> +		ptr = " %pF <-- %pF";
> +
> +	if (event->flags & EVENT_FL_ISBPRINT) {
> +		bprint_fmt = get_bprint_format(data, size, event);
> +		args = make_bprint_args(bprint_fmt, data, size, event);
> +		arg = args;
> +		ptr = bprint_fmt;
> +	}
> +
> +	for (; *ptr; ptr++) {
> +		ls = 0;
> +		if (*ptr == '\\') {
> +			ptr++;
> +			switch (*ptr) {
> +			case 'n':
> +				printf("\n");
> +				break;
> +			case 't':
> +				printf("\t");
> +				break;
> +			case 'r':
> +				printf("\r");
> +				break;
> +			case '\\':
> +				printf("\\");
> +				break;
> +			default:
> +				printf("%c", *ptr);
> +				break;
> +			}
> +
> +		} else if (*ptr == '%') {
> +			saveptr = ptr;
> +			show_func = 0;
> + cont_process:
> +			ptr++;
> +			switch (*ptr) {
> +			case '%':
> +				printf("%%");
> +				break;
> +			case 'l':
> +				ls++;
> +				goto cont_process;
> +			case 'L':
> +				ls = 2;
> +				goto cont_process;
> +			case 'z':
> +			case 'Z':
> +			case '0' ... '9':
> +				goto cont_process;
> +			case 'p':
> +				if (long_size == 4)
> +					ls = 1;
> +				else
> +					ls = 2;
> +
> +				if (*(ptr+1) == 'F' ||
> +				    *(ptr+1) == 'f') {
> +					ptr++;
> +					show_func = *ptr;
> +				}
> +
> +				/* fall through */
> +			case 'd':
> +			case 'i':
> +			case 'x':
> +			case 'X':
> +			case 'u':
> +				if (!arg)
> +					die("no argument match");
> +
> +				len = ((unsigned long)ptr + 1) -
> +					(unsigned long)saveptr;
> +
> +				/* should never happen */
> +				if (len > 32)
> +					die("bad format!");
> +
> +				memcpy(format, saveptr, len);
> +				format[len] = 0;
> +
> +				val = eval_num_arg(data, size, event, arg);
> +				arg = arg->next;
> +
> +				if (show_func) {
> +					func = find_func(val);
> +					if (func) {
> +						printf("%s", func->func);
> +						if (show_func == 'F')
> +							printf("+0x%llx",
> +							       val - func->addr);
> +						break;
> +					}
> +				}
> +				switch (ls) {
> +				case 0:
> +					printf(format, (int)val);
> +					break;
> +				case 1:
> +					printf(format, (long)val);
> +					break;
> +				case 2:
> +					printf(format, (long long)val);
> +					break;
> +				default:
> +					die("bad count (%d)", ls);
> +				}
> +				break;
> +			case 's':
> +				if (!arg)
> +					die("no matching argument");
> +
> +				print_str_arg(data, size, event, arg);
> +				arg = arg->next;
> +				break;
> +			default:
> +				printf(">%c<", *ptr);
> +
> +			}
> +		} else
> +			printf("%c", *ptr);
> +	}
> +
> +	if (args) {
> +		free_args(args);
> +		free(bprint_fmt);
> +	}
> +}
> +
> +static inline int log10_cpu(int nb)
> +{
> +	if (nb / 100)
> +		return 3;
> +	if (nb / 10)
> +		return 2;
> +	return 1;
> +}
> +
> +static void print_lat_fmt(void *data, int size __unused)
> +{
> +	unsigned int lat_flags;
> +	unsigned int pc;
> +	int lock_depth;
> +	int hardirq;
> +	int softirq;
> +
> +	lat_flags = parse_common_flags(data);
> +	pc = parse_common_pc(data);
> +	lock_depth = parse_common_lock_depth(data);
> +
> +	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
> +	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
> +
> +	printf("%c%c%c",
> +	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
> +	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
> +	       'X' : '.',
> +	       (lat_flags & TRACE_FLAG_NEED_RESCHED) ?
> +	       'N' : '.',
> +	       (hardirq && softirq) ? 'H' :
> +	       hardirq ? 'h' : softirq ? 's' : '.');
> +
> +	if (pc)
> +		printf("%x", pc);
> +	else
> +		printf(".");
> +
> +	if (lock_depth < 0)
> +		printf(".");
> +	else
> +		printf("%d", lock_depth);
> +}
> +
> +/* taken from Linux, written by Frederic Weisbecker */
> +static void print_graph_cpu(int cpu)
> +{
> +	int i;
> +	int log10_this = log10_cpu(cpu);
> +	int log10_all = log10_cpu(cpus);
> +
> +
> +	/*
> +	 * Start with a space character - to make it stand out
> +	 * to the right a bit when trace output is pasted into
> +	 * email:
> +	 */
> +	printf(" ");
> +
> +	/*
> +	 * Tricky - we space the CPU field according to the max
> +	 * number of online CPUs. On a 2-cpu system it would take
> +	 * a maximum of 1 digit - on a 128 cpu system it would
> +	 * take up to 3 digits:
> +	 */
> +	for (i = 0; i < log10_all - log10_this; i++)
> +		printf(" ");
> +
> +	printf("%d) ", cpu);
> +}
> +
> +#define TRACE_GRAPH_PROCINFO_LENGTH	14
> +#define TRACE_GRAPH_INDENT	2
> +
> +static void print_graph_proc(int pid, const char *comm)
> +{
> +	/* sign + log10(MAX_INT) + '\0' */
> +	char pid_str[11];
> +	int spaces = 0;
> +	int len;
> +	int i;
> +
> +	sprintf(pid_str, "%d", pid);
> +
> +	/* 1 stands for the "-" character */
> +	len = strlen(comm) + strlen(pid_str) + 1;
> +
> +	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
> +		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
> +
> +	/* First spaces to align center */
> +	for (i = 0; i < spaces / 2; i++)
> +		printf(" ");
> +
> +	printf("%s-%s", comm, pid_str);
> +
> +	/* Last spaces to align center */
> +	for (i = 0; i < spaces - (spaces / 2); i++)
> +		printf(" ");
> +}
> +
> +static struct record *
> +get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
> +		    struct record *next)
> +{
> +	struct format_field *field;
> +	struct event *event;
> +	unsigned long val;
> +	int type;
> +	int pid;
> +
> +	type = trace_parse_common_type(next->data);
> +	event = trace_find_event(type);
> +	if (!event)
> +		return NULL;
> +
> +	if (!(event->flags & EVENT_FL_ISFUNCRET))
> +		return NULL;
> +
> +	pid = trace_parse_common_pid(next->data);
> +	field = find_field(event, "func");
> +	if (!field)
> +		die("function return does not have field func");
> +
> +	val = read_size(next->data + field->offset, field->size);
> +
> +	if (cur_pid != pid || cur_func != val)
> +		return NULL;
> +
> +	/* this is a leaf, now advance the iterator */
> +	return trace_read_data(cpu);
> +}
> +
> +/* Signal a overhead of time execution to the output */
> +static void print_graph_overhead(unsigned long long duration)
> +{
> +	/* Non nested entry or return */
> +	if (duration == ~0ULL)
> +		return (void)printf("  ");
> +
> +	/* Duration exceeded 100 msecs */
> +	if (duration > 100000ULL)
> +		return (void)printf("! ");
> +
> +	/* Duration exceeded 10 msecs */
> +	if (duration > 10000ULL)
> +		return (void)printf("+ ");
> +
> +	printf("  ");
> +}
> +
> +static void print_graph_duration(unsigned long long duration)
> +{
> +	unsigned long usecs = duration / 1000;
> +	unsigned long nsecs_rem = duration % 1000;
> +	/* log10(ULONG_MAX) + '\0' */
> +	char msecs_str[21];
> +	char nsecs_str[5];
> +	int len;
> +	int i;
> +
> +	sprintf(msecs_str, "%lu", usecs);
> +
> +	/* Print msecs */
> +	len = printf("%lu", usecs);
> +
> +	/* Print nsecs (we don't want to exceed 7 numbers) */
> +	if (len < 7) {
> +		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
> +		len += printf(".%s", nsecs_str);
> +	}
> +
> +	printf(" us ");
> +
> +	/* Print remaining spaces to fit the row's width */
> +	for (i = len; i < 7; i++)
> +		printf(" ");
> +
> +	printf("|  ");
> +}
> +
> +static void
> +print_graph_entry_leaf(struct event *event, void *data, struct record *ret_rec)
> +{
> +	unsigned long long rettime, calltime;
> +	unsigned long long duration, depth;
> +	unsigned long long val;
> +	struct format_field *field;
> +	struct func_map *func;
> +	struct event *ret_event;
> +	int type;
> +	int i;
> +
> +	type = trace_parse_common_type(ret_rec->data);
> +	ret_event = trace_find_event(type);
> +
> +	field = find_field(ret_event, "rettime");
> +	if (!field)
> +		die("can't find rettime in return graph");
> +	rettime = read_size(ret_rec->data + field->offset, field->size);
> +
> +	field = find_field(ret_event, "calltime");
> +	if (!field)
> +		die("can't find rettime in return graph");
> +	calltime = read_size(ret_rec->data + field->offset, field->size);
> +
> +	duration = rettime - calltime;
> +
> +	/* Overhead */
> +	print_graph_overhead(duration);
> +
> +	/* Duration */
> +	print_graph_duration(duration);
> +
> +	field = find_field(event, "depth");
> +	if (!field)
> +		die("can't find depth in entry graph");
> +	depth = read_size(data + field->offset, field->size);
> +
> +	/* Function */
> +	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
> +		printf(" ");
> +
> +	field = find_field(event, "func");
> +	if (!field)
> +		die("can't find func in entry graph");
> +	val = read_size(data + field->offset, field->size);
> +	func = find_func(val);
> +
> +	if (func)
> +		printf("%s();", func->func);
> +	else
> +		printf("%llx();", val);
> +}
> +
> +static void print_graph_nested(struct event *event, void *data)
> +{
> +	struct format_field *field;
> +	unsigned long long depth;
> +	unsigned long long val;
> +	struct func_map *func;
> +	int i;
> +
> +	/* No overhead */
> +	print_graph_overhead(-1);
> +
> +	/* No time */
> +	printf("           |  ");
> +
> +	field = find_field(event, "depth");
> +	if (!field)
> +		die("can't find depth in entry graph");
> +	depth = read_size(data + field->offset, field->size);
> +
> +	/* Function */
> +	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
> +		printf(" ");
> +
> +	field = find_field(event, "func");
> +	if (!field)
> +		die("can't find func in entry graph");
> +	val = read_size(data + field->offset, field->size);
> +	func = find_func(val);
> +
> +	if (func)
> +		printf("%s() {", func->func);
> +	else
> +		printf("%llx() {", val);
> +}
> +
> +static void
> +pretty_print_func_ent(void *data, int size, struct event *event,
> +		      int cpu, int pid, const char *comm,
> +		      unsigned long secs, unsigned long usecs)
> +{
> +	struct format_field *field;
> +	struct record *rec;
> +	void *copy_data;
> +	unsigned long val;
> +
> +	printf("%5lu.%06lu |  ", secs, usecs);
> +
> +	print_graph_cpu(cpu);
> +	print_graph_proc(pid, comm);
> +
> +	printf(" | ");
> +
> +	if (latency_format) {
> +		print_lat_fmt(data, size);
> +		printf(" | ");
> +	}
> +
> +	field = find_field(event, "func");
> +	if (!field)
> +		die("function entry does not have func field");
> +
> +	val = read_size(data + field->offset, field->size);
> +
> +	/*
> +	 * peek_data may unmap the data pointer. Copy it first.
> +	 */
> +	copy_data = malloc_or_die(size);
> +	memcpy(copy_data, data, size);
> +	data = copy_data;
> +
> +	rec = trace_peek_data(cpu);
> +	if (rec) {
> +		rec = get_return_for_leaf(cpu, pid, val, rec);
> +		if (rec) {
> +			print_graph_entry_leaf(event, data, rec);
> +			goto out_free;
> +		}
> +	}
> +	print_graph_nested(event, data);
> +out_free:
> +	free(data);
> +}
> +
> +static void
> +pretty_print_func_ret(void *data, int size __unused, struct event *event,
> +		      int cpu, int pid, const char *comm,
> +		      unsigned long secs, unsigned long usecs)
> +{
> +	unsigned long long rettime, calltime;
> +	unsigned long long duration, depth;
> +	struct format_field *field;
> +	int i;
> +
> +	printf("%5lu.%06lu |  ", secs, usecs);
> +
> +	print_graph_cpu(cpu);
> +	print_graph_proc(pid, comm);
> +
> +	printf(" | ");
> +
> +	if (latency_format) {
> +		print_lat_fmt(data, size);
> +		printf(" | ");
> +	}
> +
> +	field = find_field(event, "rettime");
> +	if (!field)
> +		die("can't find rettime in return graph");
> +	rettime = read_size(data + field->offset, field->size);
> +
> +	field = find_field(event, "calltime");
> +	if (!field)
> +		die("can't find calltime in return graph");
> +	calltime = read_size(data + field->offset, field->size);
> +
> +	duration = rettime - calltime;
> +
> +	/* Overhead */
> +	print_graph_overhead(duration);
> +
> +	/* Duration */
> +	print_graph_duration(duration);
> +
> +	field = find_field(event, "depth");
> +	if (!field)
> +		die("can't find depth in entry graph");
> +	depth = read_size(data + field->offset, field->size);
> +
> +	/* Function */
> +	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
> +		printf(" ");
> +
> +	printf("}");
> +}
> +
> +static void
> +pretty_print_func_graph(void *data, int size, struct event *event,
> +			int cpu, int pid, const char *comm,
> +			unsigned long secs, unsigned long usecs)
> +{
> +	if (event->flags & EVENT_FL_ISFUNCENT)
> +		pretty_print_func_ent(data, size, event,
> +				      cpu, pid, comm, secs, usecs);
> +	else if (event->flags & EVENT_FL_ISFUNCRET)
> +		pretty_print_func_ret(data, size, event,
> +				      cpu, pid, comm, secs, usecs);
> +	printf("\n");
> +}
> +
> +void print_event(int cpu, void *data, int size, unsigned long long nsecs,
> +		  char *comm)
> +{
> +	struct event *event;
> +	unsigned long secs;
> +	unsigned long usecs;
> +	int type;
> +	int pid;
> +
> +	secs = nsecs / NSECS_PER_SEC;
> +	nsecs -= secs * NSECS_PER_SEC;
> +	usecs = nsecs / NSECS_PER_USEC;
> +
> +	type = trace_parse_common_type(data);
> +
> +	event = trace_find_event(type);
> +	if (!event) {
> +		warning("ug! no event found for type %d", type);
> +		return;
> +	}
> +
> +	pid = trace_parse_common_pid(data);
> +
> +	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
> +		return pretty_print_func_graph(data, size, event, cpu,
> +					       pid, comm, secs, usecs);
> +
> +	if (latency_format) {
> +		printf("%8.8s-%-5d %3d",
> +		       comm, pid, cpu);
> +		print_lat_fmt(data, size);
> +	} else
> +		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
> +
> +	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
> +
> +	if (event->flags & EVENT_FL_FAILED) {
> +		printf("EVENT '%s' FAILED TO PARSE\n",
> +		       event->name);
> +		return;
> +	}
> +
> +	pretty_print(data, size, event);
> +	printf("\n");
> +}
> +
> +static void print_fields(struct print_flag_sym *field)
> +{
> +	printf("{ %s, %s }", field->value, field->str);
> +	if (field->next) {
> +		printf(", ");
> +		print_fields(field->next);
> +	}
> +}
> +
> +static void print_args(struct print_arg *args)
> +{
> +	int print_paren = 1;
> +
> +	switch (args->type) {
> +	case PRINT_NULL:
> +		printf("null");
> +		break;
> +	case PRINT_ATOM:
> +		printf("%s", args->atom.atom);
> +		break;
> +	case PRINT_FIELD:
> +		printf("REC->%s", args->field.name);
> +		break;
> +	case PRINT_FLAGS:
> +		printf("__print_flags(");
> +		print_args(args->flags.field);
> +		printf(", %s, ", args->flags.delim);
> +		print_fields(args->flags.flags);
> +		printf(")");
> +		break;
> +	case PRINT_SYMBOL:
> +		printf("__print_symbolic(");
> +		print_args(args->symbol.field);
> +		printf(", ");
> +		print_fields(args->symbol.symbols);
> +		printf(")");
> +		break;
> +	case PRINT_STRING:
> +		printf("__get_str(%s)", args->string.string);
> +		break;
> +	case PRINT_TYPE:
> +		printf("(%s)", args->typecast.type);
> +		print_args(args->typecast.item);
> +		break;
> +	case PRINT_OP:
> +		if (strcmp(args->op.op, ":") == 0)
> +			print_paren = 0;
> +		if (print_paren)
> +			printf("(");
> +		print_args(args->op.left);
> +		printf(" %s ", args->op.op);
> +		print_args(args->op.right);
> +		if (print_paren)
> +			printf(")");
> +		break;
> +	default:
> +		/* we should warn... */
> +		return;
> +	}
> +	if (args->next) {
> +		printf("\n");
> +		print_args(args->next);
> +	}
> +}
> +
> +int parse_ftrace_file(char *buf, unsigned long size)
> +{
> +	struct format_field *field;
> +	struct print_arg *arg, **list;
> +	struct event *event;
> +	int ret;
> +
> +	init_input_buf(buf, size);
> +
> +	event = alloc_event();
> +	if (!event)
> +		return -ENOMEM;
> +
> +	event->flags |= EVENT_FL_ISFTRACE;
> +
> +	event->name = event_read_name();
> +	if (!event->name)
> +		die("failed to read ftrace event name");
> +
> +	if (strcmp(event->name, "function") == 0)
> +		event->flags |= EVENT_FL_ISFUNC;
> +
> +	else if (strcmp(event->name, "funcgraph_entry") == 0)
> +		event->flags |= EVENT_FL_ISFUNCENT;
> +
> +	else if (strcmp(event->name, "funcgraph_exit") == 0)
> +		event->flags |= EVENT_FL_ISFUNCRET;
> +
> +	else if (strcmp(event->name, "bprint") == 0)
> +		event->flags |= EVENT_FL_ISBPRINT;
> +
> +	event->id = event_read_id();
> +	if (event->id < 0)
> +		die("failed to read ftrace event id");
> +
> +	add_event(event);
> +
> +	ret = event_read_format(event);
> +	if (ret < 0)
> +		die("failed to read ftrace event format");
> +
> +	ret = event_read_print(event);
> +	if (ret < 0)
> +		die("failed to read ftrace event print fmt");
> +
> +	/* New ftrace handles args */
> +	if (ret > 0)
> +		return 0;
> +	/*
> +	 * The arguments for ftrace files are parsed by the fields.
> +	 * Set up the fields as their arguments.
> +	 */
> +	list = &event->print_fmt.args;
> +	for (field = event->format.fields; field; field = field->next) {
> +		arg = malloc_or_die(sizeof(*arg));
> +		memset(arg, 0, sizeof(*arg));
> +		*list = arg;
> +		list = &arg->next;
> +		arg->type = PRINT_FIELD;
> +		arg->field.name = field->name;
> +		arg->field.field = field;
> +	}
> +	return 0;
> +}
> +
> +int parse_event_file(char *buf, unsigned long size, char *sys)
> +{
> +	struct event *event;
> +	int ret;
> +
> +	init_input_buf(buf, size);
> +
> +	event = alloc_event();
> +	if (!event)
> +		return -ENOMEM;
> +
> +	event->name = event_read_name();
> +	if (!event->name)
> +		die("failed to read event name");
> +
> +	event->id = event_read_id();
> +	if (event->id < 0)
> +		die("failed to read event id");
> +
> +	ret = event_read_format(event);
> +	if (ret < 0) {
> +		warning("failed to read event format for %s", event->name);
> +		goto event_failed;
> +	}
> +
> +	ret = event_read_print(event);
> +	if (ret < 0) {
> +		warning("failed to read event print fmt for %s", event->name);
> +		goto event_failed;
> +	}
> +
> +	event->system = strdup(sys);
> +
> +#define PRINT_ARGS 0
> +	if (PRINT_ARGS && event->print_fmt.args)
> +		print_args(event->print_fmt.args);
> +
> +	add_event(event);
> +	return 0;
> +
> + event_failed:
> +	event->flags |= EVENT_FL_FAILED;
> +	/* still add it even if it failed */
> +	add_event(event);
> +	return -1;
> +}
> +
> +void parse_set_info(int nr_cpus, int long_sz)
> +{
> +	cpus = nr_cpus;
> +	long_size = long_sz;
> +}
> +
> +int common_pc(struct scripting_context *context)
> +{
> +	return parse_common_pc(context->event_data);
> +}
> +
> +int common_flags(struct scripting_context *context)
> +{
> +	return parse_common_flags(context->event_data);
> +}
> +
> +int common_lock_depth(struct scripting_context *context)
> +{
> +	return parse_common_lock_depth(context->event_data);
> +}
> diff --git a/tools/lib/trace/trace-event-read.c b/tools/lib/trace/trace-event-read.c
> new file mode 100644
> index 0000000..d7d8ceb
> --- /dev/null
> +++ b/tools/lib/trace/trace-event-read.c
> @@ -0,0 +1,539 @@
> +/*
> + * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License (not later!)
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +#define _FILE_OFFSET_BITS 64
> +
> +#include <dirent.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <getopt.h>
> +#include <stdarg.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/wait.h>
> +#include <sys/mman.h>
> +#include <pthread.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <ctype.h>
> +#include <errno.h>
> +
> +#include <perf.h>
> +#include <lk/util.h>
> +#include <util/trace-event.h>
> +
> +static int input_fd;
> +
> +static int read_page;
> +
> +int file_bigendian;
> +int host_bigendian;
> +static int long_size;
> +
> +static unsigned long	page_size;
> +
> +static ssize_t calc_data_size;
> +static bool repipe;
> +
> +static int do_read(int fd, void *buf, int size)
> +{
> +	int rsize = size;
> +
> +	while (size) {
> +		int ret = read(fd, buf, size);
> +
> +		if (ret <= 0)
> +			return -1;
> +
> +		if (repipe) {
> +			int retw = write(STDOUT_FILENO, buf, ret);
> +
> +			if (retw <= 0 || retw != ret)
> +				die("repiping input file");
> +		}
> +
> +		size -= ret;
> +		buf += ret;
> +	}
> +
> +	return rsize;
> +}
> +
> +static int read_or_die(void *data, int size)
> +{
> +	int r;
> +
> +	r = do_read(input_fd, data, size);
> +	if (r <= 0)
> +		die("reading input file (size expected=%d received=%d)",
> +		    size, r);
> +
> +	if (calc_data_size)
> +		calc_data_size += r;
> +
> +	return r;
> +}
> +
> +/* If it fails, the next read will report it */
> +static void skip(int size)
> +{
> +	char buf[BUFSIZ];
> +	int r;
> +
> +	while (size) {
> +		r = size > BUFSIZ ? BUFSIZ : size;
> +		read_or_die(buf, r);
> +		size -= r;
> +	};
> +}
> +
> +static unsigned int read4(void)
> +{
> +	unsigned int data;
> +
> +	read_or_die(&data, 4);
> +	return __data2host4(data);
> +}
> +
> +static unsigned long long read8(void)
> +{
> +	unsigned long long data;
> +
> +	read_or_die(&data, 8);
> +	return __data2host8(data);
> +}
> +
> +static char *read_string(void)
> +{
> +	char buf[BUFSIZ];
> +	char *str = NULL;
> +	int size = 0;
> +	off_t r;
> +	char c;
> +
> +	for (;;) {
> +		r = read(input_fd, &c, 1);
> +		if (r < 0)
> +			die("reading input file");
> +
> +		if (!r)
> +			die("no data");
> +
> +		if (repipe) {
> +			int retw = write(STDOUT_FILENO, &c, 1);
> +
> +			if (retw <= 0 || retw != r)
> +				die("repiping input file string");
> +		}
> +
> +		buf[size++] = c;
> +
> +		if (!c)
> +			break;
> +	}
> +
> +	if (calc_data_size)
> +		calc_data_size += size;
> +
> +	str = malloc_or_die(size);
> +	memcpy(str, buf, size);
> +
> +	return str;
> +}
> +
> +static void read_proc_kallsyms(void)
> +{
> +	unsigned int size;
> +	char *buf;
> +
> +	size = read4();
> +	if (!size)
> +		return;
> +
> +	buf = malloc_or_die(size + 1);
> +	read_or_die(buf, size);
> +	buf[size] = '\0';
> +
> +	parse_proc_kallsyms(buf, size);
> +
> +	free(buf);
> +}
> +
> +static void read_ftrace_printk(void)
> +{
> +	unsigned int size;
> +	char *buf;
> +
> +	size = read4();
> +	if (!size)
> +		return;
> +
> +	buf = malloc_or_die(size);
> +	read_or_die(buf, size);
> +
> +	parse_ftrace_printk(buf, size);
> +
> +	free(buf);
> +}
> +
> +static void read_header_files(void)
> +{
> +	unsigned long long size;
> +	char *header_event;
> +	char buf[BUFSIZ];
> +
> +	read_or_die(buf, 12);
> +
> +	if (memcmp(buf, "header_page", 12) != 0)
> +		die("did not read header page");
> +
> +	size = read8();
> +	skip(size);
> +
> +	/*
> +	 * The size field in the page is of type long,
> +	 * use that instead, since it represents the kernel.
> +	 */
> +	long_size = header_page_size_size;
> +
> +	read_or_die(buf, 13);
> +	if (memcmp(buf, "header_event", 13) != 0)
> +		die("did not read header event");
> +
> +	size = read8();
> +	header_event = malloc_or_die(size);
> +	read_or_die(header_event, size);
> +	free(header_event);
> +}
> +
> +static void read_ftrace_file(unsigned long long size)
> +{
> +	char *buf;
> +
> +	buf = malloc_or_die(size);
> +	read_or_die(buf, size);
> +	parse_ftrace_file(buf, size);
> +	free(buf);
> +}
> +
> +static void read_event_file(char *sys, unsigned long long size)
> +{
> +	char *buf;
> +
> +	buf = malloc_or_die(size);
> +	read_or_die(buf, size);
> +	parse_event_file(buf, size, sys);
> +	free(buf);
> +}
> +
> +static void read_ftrace_files(void)
> +{
> +	unsigned long long size;
> +	int count;
> +	int i;
> +
> +	count = read4();
> +
> +	for (i = 0; i < count; i++) {
> +		size = read8();
> +		read_ftrace_file(size);
> +	}
> +}
> +
> +static void read_event_files(void)
> +{
> +	unsigned long long size;
> +	char *sys;
> +	int systems;
> +	int count;
> +	int i,x;
> +
> +	systems = read4();
> +
> +	for (i = 0; i < systems; i++) {
> +		sys = read_string();
> +
> +		count = read4();
> +		for (x=0; x < count; x++) {
> +			size = read8();
> +			read_event_file(sys, size);
> +		}
> +	}
> +}
> +
> +struct cpu_data {
> +	unsigned long long	offset;
> +	unsigned long long	size;
> +	unsigned long long	timestamp;
> +	struct record		*next;
> +	char			*page;
> +	int			cpu;
> +	int			index;
> +	int			page_size;
> +};
> +
> +static struct cpu_data *cpu_data;
> +
> +static void update_cpu_data_index(int cpu)
> +{
> +	cpu_data[cpu].offset += page_size;
> +	cpu_data[cpu].size -= page_size;
> +	cpu_data[cpu].index = 0;
> +}
> +
> +static void get_next_page(int cpu)
> +{
> +	off_t save_seek;
> +	off_t ret;
> +
> +	if (!cpu_data[cpu].page)
> +		return;
> +
> +	if (read_page) {
> +		if (cpu_data[cpu].size <= page_size) {
> +			free(cpu_data[cpu].page);
> +			cpu_data[cpu].page = NULL;
> +			return;
> +		}
> +
> +		update_cpu_data_index(cpu);
> +
> +		/* other parts of the code may expect the pointer to not move */
> +		save_seek = lseek(input_fd, 0, SEEK_CUR);
> +
> +		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
> +		if (ret == (off_t)-1)
> +			die("failed to lseek");
> +		ret = read(input_fd, cpu_data[cpu].page, page_size);
> +		if (ret < 0)
> +			die("failed to read page");
> +
> +		/* reset the file pointer back */
> +		lseek(input_fd, save_seek, SEEK_SET);
> +
> +		return;
> +	}
> +
> +	munmap(cpu_data[cpu].page, page_size);
> +	cpu_data[cpu].page = NULL;
> +
> +	if (cpu_data[cpu].size <= page_size)
> +		return;
> +
> +	update_cpu_data_index(cpu);
> +
> +	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
> +				  input_fd, cpu_data[cpu].offset);
> +	if (cpu_data[cpu].page == MAP_FAILED)
> +		die("failed to mmap cpu %d at offset 0x%llx",
> +		    cpu, cpu_data[cpu].offset);
> +}
> +
> +static unsigned int type_len4host(unsigned int type_len_ts)
> +{
> +	if (file_bigendian)
> +		return (type_len_ts >> 27) & ((1 << 5) - 1);
> +	else
> +		return type_len_ts & ((1 << 5) - 1);
> +}
> +
> +static unsigned int ts4host(unsigned int type_len_ts)
> +{
> +	if (file_bigendian)
> +		return type_len_ts & ((1 << 27) - 1);
> +	else
> +		return type_len_ts >> 5;
> +}
> +
> +static int calc_index(void *ptr, int cpu)
> +{
> +	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
> +}
> +
> +struct record *trace_peek_data(int cpu)
> +{
> +	struct record *data;
> +	void *page = cpu_data[cpu].page;
> +	int idx = cpu_data[cpu].index;
> +	void *ptr = page + idx;
> +	unsigned long long extend;
> +	unsigned int type_len_ts;
> +	unsigned int type_len;
> +	unsigned int delta;
> +	unsigned int length = 0;
> +
> +	if (cpu_data[cpu].next)
> +		return cpu_data[cpu].next;
> +
> +	if (!page)
> +		return NULL;
> +
> +	if (!idx) {
> +		/* FIXME: handle header page */
> +		if (header_page_ts_size != 8)
> +			die("expected a long long type for timestamp");
> +		cpu_data[cpu].timestamp = data2host8(ptr);
> +		ptr += 8;
> +		switch (header_page_size_size) {
> +		case 4:
> +			cpu_data[cpu].page_size = data2host4(ptr);
> +			ptr += 4;
> +			break;
> +		case 8:
> +			cpu_data[cpu].page_size = data2host8(ptr);
> +			ptr += 8;
> +			break;
> +		default:
> +			die("bad long size");
> +		}
> +		ptr = cpu_data[cpu].page + header_page_data_offset;
> +	}
> +
> +read_again:
> +	idx = calc_index(ptr, cpu);
> +
> +	if (idx >= cpu_data[cpu].page_size) {
> +		get_next_page(cpu);
> +		return trace_peek_data(cpu);
> +	}
> +
> +	type_len_ts = data2host4(ptr);
> +	ptr += 4;
> +
> +	type_len = type_len4host(type_len_ts);
> +	delta = ts4host(type_len_ts);
> +
> +	switch (type_len) {
> +	case RINGBUF_TYPE_PADDING:
> +		if (!delta)
> +			die("error, hit unexpected end of page");
> +		length = data2host4(ptr);
> +		ptr += 4;
> +		length *= 4;
> +		ptr += length;
> +		goto read_again;
> +
> +	case RINGBUF_TYPE_TIME_EXTEND:
> +		extend = data2host4(ptr);
> +		ptr += 4;
> +		extend <<= TS_SHIFT;
> +		extend += delta;
> +		cpu_data[cpu].timestamp += extend;
> +		goto read_again;
> +
> +	case RINGBUF_TYPE_TIME_STAMP:
> +		ptr += 12;
> +		break;
> +	case 0:
> +		length = data2host4(ptr);
> +		ptr += 4;
> +		die("here! length=%d", length);
> +		break;
> +	default:
> +		length = type_len * 4;
> +		break;
> +	}
> +
> +	cpu_data[cpu].timestamp += delta;
> +
> +	data = malloc_or_die(sizeof(*data));
> +	memset(data, 0, sizeof(*data));
> +
> +	data->ts = cpu_data[cpu].timestamp;
> +	data->size = length;
> +	data->data = ptr;
> +	ptr += length;
> +
> +	cpu_data[cpu].index = calc_index(ptr, cpu);
> +	cpu_data[cpu].next = data;
> +
> +	return data;
> +}
> +
> +struct record *trace_read_data(int cpu)
> +{
> +	struct record *data;
> +
> +	data = trace_peek_data(cpu);
> +	cpu_data[cpu].next = NULL;
> +
> +	return data;
> +}
> +
> +ssize_t trace_report(int fd, bool __repipe)
> +{
> +	char buf[BUFSIZ];
> +	char test[] = { 23, 8, 68 };
> +	char *version;
> +	int show_version = 0;
> +	int show_funcs = 0;
> +	int show_printk = 0;
> +	ssize_t size;
> +
> +	calc_data_size = 1;
> +	repipe = __repipe;
> +
> +	input_fd = fd;
> +
> +	read_or_die(buf, 3);
> +	if (memcmp(buf, test, 3) != 0)
> +		die("no trace data in the file");
> +
> +	read_or_die(buf, 7);
> +	if (memcmp(buf, "tracing", 7) != 0)
> +		die("not a trace file (missing 'tracing' tag)");
> +
> +	version = read_string();
> +	if (show_version)
> +		printf("version = %s\n", version);
> +	free(version);
> +
> +	read_or_die(buf, 1);
> +	file_bigendian = buf[0];
> +	host_bigendian = bigendian();
> +
> +	read_or_die(buf, 1);
> +	long_size = buf[0];
> +
> +	page_size = read4();
> +
> +	read_header_files();
> +
> +	read_ftrace_files();
> +	read_event_files();
> +	read_proc_kallsyms();
> +	read_ftrace_printk();
> +
> +	size = calc_data_size - 1;
> +	calc_data_size = 0;
> +	repipe = false;
> +
> +	if (show_funcs) {
> +		print_funcs();
> +		return size;
> +	}
> +	if (show_printk) {
> +		print_printk();
> +		return size;
> +	}
> +
> +	return size;
> +}
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 001831e..590c8f6 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -383,9 +383,6 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
>  LIB_OBJS += $(OUTPUT)util/pager.o
>  LIB_OBJS += $(OUTPUT)util/callchain.o
>  LIB_OBJS += $(OUTPUT)util/values.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-read.o
> -LIB_OBJS += $(OUTPUT)util/trace-event-info.o
>  LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
>  LIB_OBJS += $(OUTPUT)util/svghelper.o
>  LIB_OBJS += $(OUTPUT)util/probe-event.o
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> deleted file mode 100644
> index 0918a63..0000000
> --- a/tools/perf/util/trace-event-info.c
> +++ /dev/null
> @@ -1,563 +0,0 @@
> -/*
> - * Copyright (C) 2008,2009, Steven Rostedt <srostedt@redhat.com>
> - *
> - * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; version 2 of the License (not later!)
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - *
> - * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> - */
> -#define _GNU_SOURCE
> -#include <dirent.h>
> -#include <mntent.h>
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <string.h>
> -#include <stdarg.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <sys/wait.h>
> -#include <pthread.h>
> -#include <fcntl.h>
> -#include <unistd.h>
> -#include <ctype.h>
> -#include <errno.h>
> -#include <stdbool.h>
> -#include <linux/kernel.h>
> -
> -#include "../perf.h"
> -#include "trace-event.h"
> -#include <lk/debugfs.h>
> -
> -#define VERSION "0.5"
> -
> -#define _STR(x) #x
> -#define STR(x) _STR(x)
> -#define MAX_PATH 256
> -
> -#define TRACE_CTRL	"tracing_on"
> -#define TRACE		"trace"
> -#define AVAILABLE	"available_tracers"
> -#define CURRENT		"current_tracer"
> -#define ITER_CTRL	"trace_options"
> -#define MAX_LATENCY	"tracing_max_latency"
> -
> -unsigned int page_size;
> -
> -static const char *output_file = "trace.info";
> -static int output_fd;
> -
> -struct event_list {
> -	struct event_list *next;
> -	const char *event;
> -};
> -
> -struct events {
> -	struct events *sibling;
> -	struct events *children;
> -	struct events *next;
> -	char *name;
> -};
> -
> -
> -
> -static void die(const char *fmt, ...)
> -{
> -	va_list ap;
> -	int ret = errno;
> -
> -	if (errno)
> -		perror("trace-cmd");
> -	else
> -		ret = -1;
> -
> -	va_start(ap, fmt);
> -	fprintf(stderr, "  ");
> -	vfprintf(stderr, fmt, ap);
> -	va_end(ap);
> -
> -	fprintf(stderr, "\n");
> -	exit(ret);
> -}
> -
> -void *malloc_or_die(unsigned int size)
> -{
> -	void *data;
> -
> -	data = malloc(size);
> -	if (!data)
> -		die("malloc");
> -	return data;
> -}
> -
> -static const char *find_debugfs(void)
> -{
> -	const char *path = debugfs_mount(NULL);
> -
> -	if (!path)
> -		die("Your kernel not support debugfs filesystem");
> -
> -	return path;
> -}
> -
> -/*
> - * Finds the path to the debugfs/tracing
> - * Allocates the string and stores it.
> - */
> -static const char *find_tracing_dir(void)
> -{
> -	static char *tracing;
> -	static int tracing_found;
> -	const char *debugfs;
> -
> -	if (tracing_found)
> -		return tracing;
> -
> -	debugfs = find_debugfs();
> -
> -	tracing = malloc_or_die(strlen(debugfs) + 9);
> -
> -	sprintf(tracing, "%s/tracing", debugfs);
> -
> -	tracing_found = 1;
> -	return tracing;
> -}
> -
> -static char *get_tracing_file(const char *name)
> -{
> -	const char *tracing;
> -	char *file;
> -
> -	tracing = find_tracing_dir();
> -	if (!tracing)
> -		return NULL;
> -
> -	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
> -
> -	sprintf(file, "%s/%s", tracing, name);
> -	return file;
> -}
> -
> -static void put_tracing_file(char *file)
> -{
> -	free(file);
> -}
> -
> -static ssize_t calc_data_size;
> -
> -static ssize_t write_or_die(const void *buf, size_t len)
> -{
> -	int ret;
> -
> -	if (calc_data_size) {
> -		calc_data_size += len;
> -		return len;
> -	}
> -
> -	ret = write(output_fd, buf, len);
> -	if (ret < 0)
> -		die("writing to '%s'", output_file);
> -
> -	return ret;
> -}
> -
> -int bigendian(void)
> -{
> -	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
> -	unsigned int *ptr;
> -
> -	ptr = (unsigned int *)(void *)str;
> -	return *ptr == 0x01020304;
> -}
> -
> -static unsigned long long copy_file_fd(int fd)
> -{
> -	unsigned long long size = 0;
> -	char buf[BUFSIZ];
> -	int r;
> -
> -	do {
> -		r = read(fd, buf, BUFSIZ);
> -		if (r > 0) {
> -			size += r;
> -			write_or_die(buf, r);
> -		}
> -	} while (r > 0);
> -
> -	return size;
> -}
> -
> -static unsigned long long copy_file(const char *file)
> -{
> -	unsigned long long size = 0;
> -	int fd;
> -
> -	fd = open(file, O_RDONLY);
> -	if (fd < 0)
> -		die("Can't read '%s'", file);
> -	size = copy_file_fd(fd);
> -	close(fd);
> -
> -	return size;
> -}
> -
> -static unsigned long get_size_fd(int fd)
> -{
> -	unsigned long long size = 0;
> -	char buf[BUFSIZ];
> -	int r;
> -
> -	do {
> -		r = read(fd, buf, BUFSIZ);
> -		if (r > 0)
> -			size += r;
> -	} while (r > 0);
> -
> -	lseek(fd, 0, SEEK_SET);
> -
> -	return size;
> -}
> -
> -static unsigned long get_size(const char *file)
> -{
> -	unsigned long long size = 0;
> -	int fd;
> -
> -	fd = open(file, O_RDONLY);
> -	if (fd < 0)
> -		die("Can't read '%s'", file);
> -	size = get_size_fd(fd);
> -	close(fd);
> -
> -	return size;
> -}
> -
> -static void read_header_files(void)
> -{
> -	unsigned long long size, check_size;
> -	char *path;
> -	int fd;
> -
> -	path = get_tracing_file("events/header_page");
> -	fd = open(path, O_RDONLY);
> -	if (fd < 0)
> -		die("can't read '%s'", path);
> -
> -	/* unfortunately, you can not stat debugfs files for size */
> -	size = get_size_fd(fd);
> -
> -	write_or_die("header_page", 12);
> -	write_or_die(&size, 8);
> -	check_size = copy_file_fd(fd);
> -	close(fd);
> -
> -	if (size != check_size)
> -		die("wrong size for '%s' size=%lld read=%lld",
> -		    path, size, check_size);
> -	put_tracing_file(path);
> -
> -	path = get_tracing_file("events/header_event");
> -	fd = open(path, O_RDONLY);
> -	if (fd < 0)
> -		die("can't read '%s'", path);
> -
> -	size = get_size_fd(fd);
> -
> -	write_or_die("header_event", 13);
> -	write_or_die(&size, 8);
> -	check_size = copy_file_fd(fd);
> -	if (size != check_size)
> -		die("wrong size for '%s'", path);
> -	put_tracing_file(path);
> -	close(fd);
> -}
> -
> -static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
> -{
> -	while (tps) {
> -		if (!strcmp(sys, tps->name))
> -			return true;
> -		tps = tps->next;
> -	}
> -
> -	return false;
> -}
> -
> -static void copy_event_system(const char *sys, struct tracepoint_path *tps)
> -{
> -	unsigned long long size, check_size;
> -	struct dirent *dent;
> -	struct stat st;
> -	char *format;
> -	DIR *dir;
> -	int count = 0;
> -	int ret;
> -
> -	dir = opendir(sys);
> -	if (!dir)
> -		die("can't read directory '%s'", sys);
> -
> -	while ((dent = readdir(dir))) {
> -		if (dent->d_type != DT_DIR ||
> -		    strcmp(dent->d_name, ".") == 0 ||
> -		    strcmp(dent->d_name, "..") == 0 ||
> -		    !name_in_tp_list(dent->d_name, tps))
> -			continue;
> -		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
> -		sprintf(format, "%s/%s/format", sys, dent->d_name);
> -		ret = stat(format, &st);
> -		free(format);
> -		if (ret < 0)
> -			continue;
> -		count++;
> -	}
> -
> -	write_or_die(&count, 4);
> -
> -	rewinddir(dir);
> -	while ((dent = readdir(dir))) {
> -		if (dent->d_type != DT_DIR ||
> -		    strcmp(dent->d_name, ".") == 0 ||
> -		    strcmp(dent->d_name, "..") == 0 ||
> -		    !name_in_tp_list(dent->d_name, tps))
> -			continue;
> -		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
> -		sprintf(format, "%s/%s/format", sys, dent->d_name);
> -		ret = stat(format, &st);
> -
> -		if (ret >= 0) {
> -			/* unfortunately, you can not stat debugfs files for size */
> -			size = get_size(format);
> -			write_or_die(&size, 8);
> -			check_size = copy_file(format);
> -			if (size != check_size)
> -				die("error in size of file '%s'", format);
> -		}
> -
> -		free(format);
> -	}
> -	closedir(dir);
> -}
> -
> -static void read_ftrace_files(struct tracepoint_path *tps)
> -{
> -	char *path;
> -
> -	path = get_tracing_file("events/ftrace");
> -
> -	copy_event_system(path, tps);
> -
> -	put_tracing_file(path);
> -}
> -
> -static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
> -{
> -	while (tps) {
> -		if (!strcmp(sys, tps->system))
> -			return true;
> -		tps = tps->next;
> -	}
> -
> -	return false;
> -}
> -
> -static void read_event_files(struct tracepoint_path *tps)
> -{
> -	struct dirent *dent;
> -	struct stat st;
> -	char *path;
> -	char *sys;
> -	DIR *dir;
> -	int count = 0;
> -	int ret;
> -
> -	path = get_tracing_file("events");
> -
> -	dir = opendir(path);
> -	if (!dir)
> -		die("can't read directory '%s'", path);
> -
> -	while ((dent = readdir(dir))) {
> -		if (dent->d_type != DT_DIR ||
> -		    strcmp(dent->d_name, ".") == 0 ||
> -		    strcmp(dent->d_name, "..") == 0 ||
> -		    strcmp(dent->d_name, "ftrace") == 0 ||
> -		    !system_in_tp_list(dent->d_name, tps))
> -			continue;
> -		count++;
> -	}
> -
> -	write_or_die(&count, 4);
> -
> -	rewinddir(dir);
> -	while ((dent = readdir(dir))) {
> -		if (dent->d_type != DT_DIR ||
> -		    strcmp(dent->d_name, ".") == 0 ||
> -		    strcmp(dent->d_name, "..") == 0 ||
> -		    strcmp(dent->d_name, "ftrace") == 0 ||
> -		    !system_in_tp_list(dent->d_name, tps))
> -			continue;
> -		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
> -		sprintf(sys, "%s/%s", path, dent->d_name);
> -		ret = stat(sys, &st);
> -		if (ret >= 0) {
> -			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
> -			copy_event_system(sys, tps);
> -		}
> -		free(sys);
> -	}
> -
> -	closedir(dir);
> -	put_tracing_file(path);
> -}
> -
> -static void read_proc_kallsyms(void)
> -{
> -	unsigned int size, check_size;
> -	const char *path = "/proc/kallsyms";
> -	struct stat st;
> -	int ret;
> -
> -	ret = stat(path, &st);
> -	if (ret < 0) {
> -		/* not found */
> -		size = 0;
> -		write_or_die(&size, 4);
> -		return;
> -	}
> -	size = get_size(path);
> -	write_or_die(&size, 4);
> -	check_size = copy_file(path);
> -	if (size != check_size)
> -		die("error in size of file '%s'", path);
> -
> -}
> -
> -static void read_ftrace_printk(void)
> -{
> -	unsigned int size, check_size;
> -	char *path;
> -	struct stat st;
> -	int ret;
> -
> -	path = get_tracing_file("printk_formats");
> -	ret = stat(path, &st);
> -	if (ret < 0) {
> -		/* not found */
> -		size = 0;
> -		write_or_die(&size, 4);
> -		goto out;
> -	}
> -	size = get_size(path);
> -	write_or_die(&size, 4);
> -	check_size = copy_file(path);
> -	if (size != check_size)
> -		die("error in size of file '%s'", path);
> -out:
> -	put_tracing_file(path);
> -}
> -
> -static struct tracepoint_path *
> -get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
> -{
> -	struct tracepoint_path path, *ppath = &path;
> -	int i, nr_tracepoints = 0;
> -
> -	for (i = 0; i < nb_events; i++) {
> -		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
> -			continue;
> -		++nr_tracepoints;
> -		ppath->next = tracepoint_id_to_path(pattrs[i].config);
> -		if (!ppath->next)
> -			die("%s\n", "No memory to alloc tracepoints list");
> -		ppath = ppath->next;
> -	}
> -
> -	return nr_tracepoints > 0 ? path.next : NULL;
> -}
> -
> -bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
> -{
> -	int i;
> -
> -	for (i = 0; i < nb_events; i++)
> -		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
> -			return true;
> -
> -	return false;
> -}
> -
> -int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
> -{
> -	char buf[BUFSIZ];
> -	struct tracepoint_path *tps = get_tracepoints_path(pattrs, nb_events);
> -
> -	/*
> -	 * What? No tracepoints? No sense writing anything here, bail out.
> -	 */
> -	if (tps == NULL)
> -		return -1;
> -
> -	output_fd = fd;
> -
> -	buf[0] = 23;
> -	buf[1] = 8;
> -	buf[2] = 68;
> -	memcpy(buf + 3, "tracing", 7);
> -
> -	write_or_die(buf, 10);
> -
> -	write_or_die(VERSION, strlen(VERSION) + 1);
> -
> -	/* save endian */
> -	if (bigendian())
> -		buf[0] = 1;
> -	else
> -		buf[0] = 0;
> -
> -	write_or_die(buf, 1);
> -
> -	/* save size of long */
> -	buf[0] = sizeof(long);
> -	write_or_die(buf, 1);
> -
> -	/* save page_size */
> -	page_size = sysconf(_SC_PAGESIZE);
> -	write_or_die(&page_size, 4);
> -
> -	read_header_files();
> -	read_ftrace_files(tps);
> -	read_event_files(tps);
> -	read_proc_kallsyms();
> -	read_ftrace_printk();
> -
> -	return 0;
> -}
> -
> -ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
> -			       int nb_events)
> -{
> -	ssize_t size;
> -	int err = 0;
> -
> -	calc_data_size = 1;
> -	err = read_tracing_data(fd, pattrs, nb_events);
> -	size = calc_data_size - 1;
> -	calc_data_size = 0;
> -
> -	if (err < 0)
> -		return err;
> -
> -	return size;
> -}
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> deleted file mode 100644
> index 9a46fa1..0000000
> --- a/tools/perf/util/trace-event-parse.c
> +++ /dev/null
> @@ -1,3233 +0,0 @@
> -/*
> - * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
> - *
> - * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; version 2 of the License (not later!)
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - *
> - * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> - *
> - *  The parts for function graph printing was taken and modified from the
> - *  Linux Kernel that were written by Frederic Weisbecker.
> - */
> -#define _GNU_SOURCE
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <string.h>
> -#include <ctype.h>
> -#include <errno.h>
> -
> -#undef _GNU_SOURCE
> -#include "../perf.h"
> -#include <lk/util.h>
> -#include "trace-event.h"
> -
> -int header_page_ts_offset;
> -int header_page_ts_size;
> -int header_page_size_offset;
> -int header_page_size_size;
> -int header_page_overwrite_offset;
> -int header_page_overwrite_size;
> -int header_page_data_offset;
> -int header_page_data_size;
> -
> -bool latency_format;
> -
> -static char *input_buf;
> -static unsigned long long input_buf_ptr;
> -static unsigned long long input_buf_siz;
> -
> -static int cpus;
> -static int long_size;
> -static int is_flag_field;
> -static int is_symbolic_field;
> -
> -static struct format_field *
> -find_any_field(struct event *event, const char *name);
> -
> -static void init_input_buf(char *buf, unsigned long long size)
> -{
> -	input_buf = buf;
> -	input_buf_siz = size;
> -	input_buf_ptr = 0;
> -}
> -
> -struct cmdline {
> -	char *comm;
> -	int pid;
> -};
> -
> -static struct cmdline *cmdlines;
> -static int cmdline_count;
> -
> -static int cmdline_cmp(const void *a, const void *b)
> -{
> -	const struct cmdline *ca = a;
> -	const struct cmdline *cb = b;
> -
> -	if (ca->pid < cb->pid)
> -		return -1;
> -	if (ca->pid > cb->pid)
> -		return 1;
> -
> -	return 0;
> -}
> -
> -void parse_cmdlines(char *file, int size __unused)
> -{
> -	struct cmdline_list {
> -		struct cmdline_list	*next;
> -		char			*comm;
> -		int			pid;
> -	} *list = NULL, *item;
> -	char *line;
> -	char *next = NULL;
> -	int i;
> -
> -	line = strtok_r(file, "\n", &next);
> -	while (line) {
> -		item = malloc_or_die(sizeof(*item));
> -		sscanf(line, "%d %as", &item->pid,
> -		       (float *)(void *)&item->comm); /* workaround gcc warning */
> -		item->next = list;
> -		list = item;
> -		line = strtok_r(NULL, "\n", &next);
> -		cmdline_count++;
> -	}
> -
> -	cmdlines = malloc_or_die(sizeof(*cmdlines) * cmdline_count);
> -
> -	i = 0;
> -	while (list) {
> -		cmdlines[i].pid = list->pid;
> -		cmdlines[i].comm = list->comm;
> -		i++;
> -		item = list;
> -		list = list->next;
> -		free(item);
> -	}
> -
> -	qsort(cmdlines, cmdline_count, sizeof(*cmdlines), cmdline_cmp);
> -}
> -
> -static struct func_map {
> -	unsigned long long		addr;
> -	char				*func;
> -	char				*mod;
> -} *func_list;
> -static unsigned int func_count;
> -
> -static int func_cmp(const void *a, const void *b)
> -{
> -	const struct func_map *fa = a;
> -	const struct func_map *fb = b;
> -
> -	if (fa->addr < fb->addr)
> -		return -1;
> -	if (fa->addr > fb->addr)
> -		return 1;
> -
> -	return 0;
> -}
> -
> -void parse_proc_kallsyms(char *file, unsigned int size __unused)
> -{
> -	struct func_list {
> -		struct func_list	*next;
> -		unsigned long long	addr;
> -		char			*func;
> -		char			*mod;
> -	} *list = NULL, *item;
> -	char *line;
> -	char *next = NULL;
> -	char *addr_str;
> -	char ch;
> -	int ret;
> -	int i;
> -
> -	line = strtok_r(file, "\n", &next);
> -	while (line) {
> -		item = malloc_or_die(sizeof(*item));
> -		item->mod = NULL;
> -		ret = sscanf(line, "%as %c %as\t[%as",
> -			     (float *)(void *)&addr_str, /* workaround gcc warning */
> -			     &ch,
> -			     (float *)(void *)&item->func,
> -			     (float *)(void *)&item->mod);
> -		item->addr = strtoull(addr_str, NULL, 16);
> -		free(addr_str);
> -
> -		/* truncate the extra ']' */
> -		if (item->mod)
> -			item->mod[strlen(item->mod) - 1] = 0;
> -
> -
> -		item->next = list;
> -		list = item;
> -		line = strtok_r(NULL, "\n", &next);
> -		func_count++;
> -	}
> -
> -	func_list = malloc_or_die(sizeof(*func_list) * (func_count + 1));
> -
> -	i = 0;
> -	while (list) {
> -		func_list[i].func = list->func;
> -		func_list[i].addr = list->addr;
> -		func_list[i].mod = list->mod;
> -		i++;
> -		item = list;
> -		list = list->next;
> -		free(item);
> -	}
> -
> -	qsort(func_list, func_count, sizeof(*func_list), func_cmp);
> -
> -	/*
> -	 * Add a special record at the end.
> -	 */
> -	func_list[func_count].func = NULL;
> -	func_list[func_count].addr = 0;
> -	func_list[func_count].mod = NULL;
> -}
> -
> -/*
> - * We are searching for a record in between, not an exact
> - * match.
> - */
> -static int func_bcmp(const void *a, const void *b)
> -{
> -	const struct func_map *fa = a;
> -	const struct func_map *fb = b;
> -
> -	if ((fa->addr == fb->addr) ||
> -
> -	    (fa->addr > fb->addr &&
> -	     fa->addr < (fb+1)->addr))
> -		return 0;
> -
> -	if (fa->addr < fb->addr)
> -		return -1;
> -
> -	return 1;
> -}
> -
> -static struct func_map *find_func(unsigned long long addr)
> -{
> -	struct func_map *func;
> -	struct func_map key;
> -
> -	key.addr = addr;
> -
> -	func = bsearch(&key, func_list, func_count, sizeof(*func_list),
> -		       func_bcmp);
> -
> -	return func;
> -}
> -
> -void print_funcs(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < (int)func_count; i++) {
> -		printf("%016llx %s",
> -		       func_list[i].addr,
> -		       func_list[i].func);
> -		if (func_list[i].mod)
> -			printf(" [%s]\n", func_list[i].mod);
> -		else
> -			printf("\n");
> -	}
> -}
> -
> -static struct printk_map {
> -	unsigned long long		addr;
> -	char				*printk;
> -} *printk_list;
> -static unsigned int printk_count;
> -
> -static int printk_cmp(const void *a, const void *b)
> -{
> -	const struct func_map *fa = a;
> -	const struct func_map *fb = b;
> -
> -	if (fa->addr < fb->addr)
> -		return -1;
> -	if (fa->addr > fb->addr)
> -		return 1;
> -
> -	return 0;
> -}
> -
> -static struct printk_map *find_printk(unsigned long long addr)
> -{
> -	struct printk_map *printk;
> -	struct printk_map key;
> -
> -	key.addr = addr;
> -
> -	printk = bsearch(&key, printk_list, printk_count, sizeof(*printk_list),
> -			 printk_cmp);
> -
> -	return printk;
> -}
> -
> -void parse_ftrace_printk(char *file, unsigned int size __unused)
> -{
> -	struct printk_list {
> -		struct printk_list	*next;
> -		unsigned long long	addr;
> -		char			*printk;
> -	} *list = NULL, *item;
> -	char *line;
> -	char *next = NULL;
> -	char *addr_str;
> -	int i;
> -
> -	line = strtok_r(file, "\n", &next);
> -	while (line) {
> -		addr_str = strsep(&line, ":");
> -		if (!line) {
> -			warning("error parsing print strings");
> -			break;
> -		}
> -		item = malloc_or_die(sizeof(*item));
> -		item->addr = strtoull(addr_str, NULL, 16);
> -		/* fmt still has a space, skip it */
> -		item->printk = strdup(line+1);
> -		item->next = list;
> -		list = item;
> -		line = strtok_r(NULL, "\n", &next);
> -		printk_count++;
> -	}
> -
> -	printk_list = malloc_or_die(sizeof(*printk_list) * printk_count + 1);
> -
> -	i = 0;
> -	while (list) {
> -		printk_list[i].printk = list->printk;
> -		printk_list[i].addr = list->addr;
> -		i++;
> -		item = list;
> -		list = list->next;
> -		free(item);
> -	}
> -
> -	qsort(printk_list, printk_count, sizeof(*printk_list), printk_cmp);
> -}
> -
> -void print_printk(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < (int)printk_count; i++) {
> -		printf("%016llx %s\n",
> -		       printk_list[i].addr,
> -		       printk_list[i].printk);
> -	}
> -}
> -
> -static struct event *alloc_event(void)
> -{
> -	struct event *event;
> -
> -	event = malloc_or_die(sizeof(*event));
> -	memset(event, 0, sizeof(*event));
> -
> -	return event;
> -}
> -
> -enum event_type {
> -	EVENT_ERROR,
> -	EVENT_NONE,
> -	EVENT_SPACE,
> -	EVENT_NEWLINE,
> -	EVENT_OP,
> -	EVENT_DELIM,
> -	EVENT_ITEM,
> -	EVENT_DQUOTE,
> -	EVENT_SQUOTE,
> -};
> -
> -static struct event *event_list;
> -
> -static void add_event(struct event *event)
> -{
> -	event->next = event_list;
> -	event_list = event;
> -}
> -
> -static int event_item_type(enum event_type type)
> -{
> -	switch (type) {
> -	case EVENT_ITEM ... EVENT_SQUOTE:
> -		return 1;
> -	case EVENT_ERROR ... EVENT_DELIM:
> -	default:
> -		return 0;
> -	}
> -}
> -
> -static void free_arg(struct print_arg *arg)
> -{
> -	if (!arg)
> -		return;
> -
> -	switch (arg->type) {
> -	case PRINT_ATOM:
> -		if (arg->atom.atom)
> -			free(arg->atom.atom);
> -		break;
> -	case PRINT_NULL:
> -	case PRINT_FIELD ... PRINT_OP:
> -	default:
> -		/* todo */
> -		break;
> -	}
> -
> -	free(arg);
> -}
> -
> -static enum event_type get_type(int ch)
> -{
> -	if (ch == '\n')
> -		return EVENT_NEWLINE;
> -	if (isspace(ch))
> -		return EVENT_SPACE;
> -	if (isalnum(ch) || ch == '_')
> -		return EVENT_ITEM;
> -	if (ch == '\'')
> -		return EVENT_SQUOTE;
> -	if (ch == '"')
> -		return EVENT_DQUOTE;
> -	if (!isprint(ch))
> -		return EVENT_NONE;
> -	if (ch == '(' || ch == ')' || ch == ',')
> -		return EVENT_DELIM;
> -
> -	return EVENT_OP;
> -}
> -
> -static int __read_char(void)
> -{
> -	if (input_buf_ptr >= input_buf_siz)
> -		return -1;
> -
> -	return input_buf[input_buf_ptr++];
> -}
> -
> -static int __peek_char(void)
> -{
> -	if (input_buf_ptr >= input_buf_siz)
> -		return -1;
> -
> -	return input_buf[input_buf_ptr];
> -}
> -
> -static enum event_type __read_token(char **tok)
> -{
> -	char buf[BUFSIZ];
> -	int ch, last_ch, quote_ch, next_ch;
> -	int i = 0;
> -	int tok_size = 0;
> -	enum event_type type;
> -
> -	*tok = NULL;
> -
> -
> -	ch = __read_char();
> -	if (ch < 0)
> -		return EVENT_NONE;
> -
> -	type = get_type(ch);
> -	if (type == EVENT_NONE)
> -		return type;
> -
> -	buf[i++] = ch;
> -
> -	switch (type) {
> -	case EVENT_NEWLINE:
> -	case EVENT_DELIM:
> -		*tok = malloc_or_die(2);
> -		(*tok)[0] = ch;
> -		(*tok)[1] = 0;
> -		return type;
> -
> -	case EVENT_OP:
> -		switch (ch) {
> -		case '-':
> -			next_ch = __peek_char();
> -			if (next_ch == '>') {
> -				buf[i++] = __read_char();
> -				break;
> -			}
> -			/* fall through */
> -		case '+':
> -		case '|':
> -		case '&':
> -		case '>':
> -		case '<':
> -			last_ch = ch;
> -			ch = __peek_char();
> -			if (ch != last_ch)
> -				goto test_equal;
> -			buf[i++] = __read_char();
> -			switch (last_ch) {
> -			case '>':
> -			case '<':
> -				goto test_equal;
> -			default:
> -				break;
> -			}
> -			break;
> -		case '!':
> -		case '=':
> -			goto test_equal;
> -		default: /* what should we do instead? */
> -			break;
> -		}
> -		buf[i] = 0;
> -		*tok = strdup(buf);
> -		return type;
> -
> - test_equal:
> -		ch = __peek_char();
> -		if (ch == '=')
> -			buf[i++] = __read_char();
> -		break;
> -
> -	case EVENT_DQUOTE:
> -	case EVENT_SQUOTE:
> -		/* don't keep quotes */
> -		i--;
> -		quote_ch = ch;
> -		last_ch = 0;
> -		do {
> -			if (i == (BUFSIZ - 1)) {
> -				buf[i] = 0;
> -				if (*tok) {
> -					*tok = realloc(*tok, tok_size + BUFSIZ);
> -					if (!*tok)
> -						return EVENT_NONE;
> -					strcat(*tok, buf);
> -				} else
> -					*tok = strdup(buf);
> -
> -				if (!*tok)
> -					return EVENT_NONE;
> -				tok_size += BUFSIZ;
> -				i = 0;
> -			}
> -			last_ch = ch;
> -			ch = __read_char();
> -			buf[i++] = ch;
> -			/* the '\' '\' will cancel itself */
> -			if (ch == '\\' && last_ch == '\\')
> -				last_ch = 0;
> -		} while (ch != quote_ch || last_ch == '\\');
> -		/* remove the last quote */
> -		i--;
> -		goto out;
> -
> -	case EVENT_ERROR ... EVENT_SPACE:
> -	case EVENT_ITEM:
> -	default:
> -		break;
> -	}
> -
> -	while (get_type(__peek_char()) == type) {
> -		if (i == (BUFSIZ - 1)) {
> -			buf[i] = 0;
> -			if (*tok) {
> -				*tok = realloc(*tok, tok_size + BUFSIZ);
> -				if (!*tok)
> -					return EVENT_NONE;
> -				strcat(*tok, buf);
> -			} else
> -				*tok = strdup(buf);
> -
> -			if (!*tok)
> -				return EVENT_NONE;
> -			tok_size += BUFSIZ;
> -			i = 0;
> -		}
> -		ch = __read_char();
> -		buf[i++] = ch;
> -	}
> -
> - out:
> -	buf[i] = 0;
> -	if (*tok) {
> -		*tok = realloc(*tok, tok_size + i);
> -		if (!*tok)
> -			return EVENT_NONE;
> -		strcat(*tok, buf);
> -	} else
> -		*tok = strdup(buf);
> -	if (!*tok)
> -		return EVENT_NONE;
> -
> -	return type;
> -}
> -
> -static void free_token(char *tok)
> -{
> -	if (tok)
> -		free(tok);
> -}
> -
> -static enum event_type read_token(char **tok)
> -{
> -	enum event_type type;
> -
> -	for (;;) {
> -		type = __read_token(tok);
> -		if (type != EVENT_SPACE)
> -			return type;
> -
> -		free_token(*tok);
> -	}
> -
> -	/* not reached */
> -	return EVENT_NONE;
> -}
> -
> -/* no newline */
> -static enum event_type read_token_item(char **tok)
> -{
> -	enum event_type type;
> -
> -	for (;;) {
> -		type = __read_token(tok);
> -		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
> -			return type;
> -
> -		free_token(*tok);
> -	}
> -
> -	/* not reached */
> -	return EVENT_NONE;
> -}
> -
> -static int test_type(enum event_type type, enum event_type expect)
> -{
> -	if (type != expect) {
> -		warning("Error: expected type %d but read %d",
> -		    expect, type);
> -		return -1;
> -	}
> -	return 0;
> -}
> -
> -static int __test_type_token(enum event_type type, char *token,
> -			     enum event_type expect, const char *expect_tok,
> -			     bool warn)
> -{
> -	if (type != expect) {
> -		if (warn)
> -			warning("Error: expected type %d but read %d",
> -				expect, type);
> -		return -1;
> -	}
> -
> -	if (strcmp(token, expect_tok) != 0) {
> -		if (warn)
> -			warning("Error: expected '%s' but read '%s'",
> -				expect_tok, token);
> -		return -1;
> -	}
> -	return 0;
> -}
> -
> -static int test_type_token(enum event_type type, char *token,
> -			   enum event_type expect, const char *expect_tok)
> -{
> -	return __test_type_token(type, token, expect, expect_tok, true);
> -}
> -
> -static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
> -{
> -	enum event_type type;
> -
> -	if (newline_ok)
> -		type = read_token(tok);
> -	else
> -		type = read_token_item(tok);
> -	return test_type(type, expect);
> -}
> -
> -static int read_expect_type(enum event_type expect, char **tok)
> -{
> -	return __read_expect_type(expect, tok, 1);
> -}
> -
> -static int __read_expected(enum event_type expect, const char *str,
> -			   int newline_ok, bool warn)
> -{
> -	enum event_type type;
> -	char *token;
> -	int ret;
> -
> -	if (newline_ok)
> -		type = read_token(&token);
> -	else
> -		type = read_token_item(&token);
> -
> -	ret = __test_type_token(type, token, expect, str, warn);
> -
> -	free_token(token);
> -
> -	return ret;
> -}
> -
> -static int read_expected(enum event_type expect, const char *str)
> -{
> -	return __read_expected(expect, str, 1, true);
> -}
> -
> -static int read_expected_item(enum event_type expect, const char *str)
> -{
> -	return __read_expected(expect, str, 0, true);
> -}
> -
> -static char *event_read_name(void)
> -{
> -	char *token;
> -
> -	if (read_expected(EVENT_ITEM, "name") < 0)
> -		return NULL;
> -
> -	if (read_expected(EVENT_OP, ":") < 0)
> -		return NULL;
> -
> -	if (read_expect_type(EVENT_ITEM, &token) < 0)
> -		goto fail;
> -
> -	return token;
> -
> - fail:
> -	free_token(token);
> -	return NULL;
> -}
> -
> -static int event_read_id(void)
> -{
> -	char *token;
> -	int id;
> -
> -	if (read_expected_item(EVENT_ITEM, "ID") < 0)
> -		return -1;
> -
> -	if (read_expected(EVENT_OP, ":") < 0)
> -		return -1;
> -
> -	if (read_expect_type(EVENT_ITEM, &token) < 0)
> -		goto fail;
> -
> -	id = strtoul(token, NULL, 0);
> -	free_token(token);
> -	return id;
> -
> - fail:
> -	free_token(token);
> -	return -1;
> -}
> -
> -static int field_is_string(struct format_field *field)
> -{
> -	if ((field->flags & FIELD_IS_ARRAY) &&
> -	    (!strstr(field->type, "char") || !strstr(field->type, "u8") ||
> -	     !strstr(field->type, "s8")))
> -		return 1;
> -
> -	return 0;
> -}
> -
> -static int field_is_dynamic(struct format_field *field)
> -{
> -	if (!strncmp(field->type, "__data_loc", 10))
> -		return 1;
> -
> -	return 0;
> -}
> -
> -static int event_read_fields(struct event *event, struct format_field **fields)
> -{
> -	struct format_field *field = NULL;
> -	enum event_type type;
> -	char *token;
> -	char *last_token;
> -	int count = 0;
> -
> -	do {
> -		type = read_token(&token);
> -		if (type == EVENT_NEWLINE) {
> -			free_token(token);
> -			return count;
> -		}
> -
> -		count++;
> -
> -		if (test_type_token(type, token, EVENT_ITEM, "field"))
> -			goto fail;
> -		free_token(token);
> -
> -		type = read_token(&token);
> -		/*
> -		 * The ftrace fields may still use the "special" name.
> -		 * Just ignore it.
> -		 */
> -		if (event->flags & EVENT_FL_ISFTRACE &&
> -		    type == EVENT_ITEM && strcmp(token, "special") == 0) {
> -			free_token(token);
> -			type = read_token(&token);
> -		}
> -
> -		if (test_type_token(type, token, EVENT_OP, ":") < 0)
> -			return -1;
> -
> -		if (read_expect_type(EVENT_ITEM, &token) < 0)
> -			goto fail;
> -
> -		last_token = token;
> -
> -		field = malloc_or_die(sizeof(*field));
> -		memset(field, 0, sizeof(*field));
> -
> -		/* read the rest of the type */
> -		for (;;) {
> -			type = read_token(&token);
> -			if (type == EVENT_ITEM ||
> -			    (type == EVENT_OP && strcmp(token, "*") == 0) ||
> -			    /*
> -			     * Some of the ftrace fields are broken and have
> -			     * an illegal "." in them.
> -			     */
> -			    (event->flags & EVENT_FL_ISFTRACE &&
> -			     type == EVENT_OP && strcmp(token, ".") == 0)) {
> -
> -				if (strcmp(token, "*") == 0)
> -					field->flags |= FIELD_IS_POINTER;
> -
> -				if (field->type) {
> -					field->type = realloc(field->type,
> -							      strlen(field->type) +
> -							      strlen(last_token) + 2);
> -					strcat(field->type, " ");
> -					strcat(field->type, last_token);
> -				} else
> -					field->type = last_token;
> -				last_token = token;
> -				continue;
> -			}
> -
> -			break;
> -		}
> -
> -		if (!field->type) {
> -			die("no type found");
> -			goto fail;
> -		}
> -		field->name = last_token;
> -
> -		if (test_type(type, EVENT_OP))
> -			goto fail;
> -
> -		if (strcmp(token, "[") == 0) {
> -			enum event_type last_type = type;
> -			char *brackets = token;
> -			int len;
> -
> -			field->flags |= FIELD_IS_ARRAY;
> -
> -			type = read_token(&token);
> -		        while (strcmp(token, "]") != 0) {
> -				if (last_type == EVENT_ITEM &&
> -				    type == EVENT_ITEM)
> -					len = 2;
> -				else
> -					len = 1;
> -				last_type = type;
> -
> -				brackets = realloc(brackets,
> -						   strlen(brackets) +
> -						   strlen(token) + len);
> -				if (len == 2)
> -					strcat(brackets, " ");
> -				strcat(brackets, token);
> -				free_token(token);
> -				type = read_token(&token);
> -				if (type == EVENT_NONE) {
> -					die("failed to find token");
> -					goto fail;
> -				}
> -			}
> -
> -			free_token(token);
> -
> -			brackets = realloc(brackets, strlen(brackets) + 2);
> -			strcat(brackets, "]");
> -
> -			/* add brackets to type */
> -
> -			type = read_token(&token);
> -			/*
> -			 * If the next token is not an OP, then it is of
> -			 * the format: type [] item;
> -			 */
> -			if (type == EVENT_ITEM) {
> -				field->type = realloc(field->type,
> -						      strlen(field->type) +
> -						      strlen(field->name) +
> -						      strlen(brackets) + 2);
> -				strcat(field->type, " ");
> -				strcat(field->type, field->name);
> -				free_token(field->name);
> -				strcat(field->type, brackets);
> -				field->name = token;
> -				type = read_token(&token);
> -			} else {
> -				field->type = realloc(field->type,
> -						      strlen(field->type) +
> -						      strlen(brackets) + 1);
> -				strcat(field->type, brackets);
> -			}
> -			free(brackets);
> -		}
> -
> -		if (field_is_string(field)) {
> -			field->flags |= FIELD_IS_STRING;
> -			if (field_is_dynamic(field))
> -				field->flags |= FIELD_IS_DYNAMIC;
> -		}
> -
> -		if (test_type_token(type, token,  EVENT_OP, ";"))
> -			goto fail;
> -		free_token(token);
> -
> -		if (read_expected(EVENT_ITEM, "offset") < 0)
> -			goto fail_expect;
> -
> -		if (read_expected(EVENT_OP, ":") < 0)
> -			goto fail_expect;
> -
> -		if (read_expect_type(EVENT_ITEM, &token))
> -			goto fail;
> -		field->offset = strtoul(token, NULL, 0);
> -		free_token(token);
> -
> -		if (read_expected(EVENT_OP, ";") < 0)
> -			goto fail_expect;
> -
> -		if (read_expected(EVENT_ITEM, "size") < 0)
> -			goto fail_expect;
> -
> -		if (read_expected(EVENT_OP, ":") < 0)
> -			goto fail_expect;
> -
> -		if (read_expect_type(EVENT_ITEM, &token))
> -			goto fail;
> -		field->size = strtoul(token, NULL, 0);
> -		free_token(token);
> -
> -		if (read_expected(EVENT_OP, ";") < 0)
> -			goto fail_expect;
> -
> -		type = read_token(&token);
> -		if (type != EVENT_NEWLINE) {
> -			/* newer versions of the kernel have a "signed" type */
> -			if (test_type_token(type, token, EVENT_ITEM, "signed"))
> -				goto fail;
> -
> -			free_token(token);
> -
> -			if (read_expected(EVENT_OP, ":") < 0)
> -				goto fail_expect;
> -
> -			if (read_expect_type(EVENT_ITEM, &token))
> -				goto fail;
> -
> -			if (strtoul(token, NULL, 0))
> -				field->flags |= FIELD_IS_SIGNED;
> -
> -			free_token(token);
> -			if (read_expected(EVENT_OP, ";") < 0)
> -				goto fail_expect;
> -
> -			if (read_expect_type(EVENT_NEWLINE, &token))
> -				goto fail;
> -		}
> -
> -		free_token(token);
> -
> -		*fields = field;
> -		fields = &field->next;
> -
> -	} while (1);
> -
> -	return 0;
> -
> -fail:
> -	free_token(token);
> -fail_expect:
> -	if (field)
> -		free(field);
> -	return -1;
> -}
> -
> -static int event_read_format(struct event *event)
> -{
> -	char *token;
> -	int ret;
> -
> -	if (read_expected_item(EVENT_ITEM, "format") < 0)
> -		return -1;
> -
> -	if (read_expected(EVENT_OP, ":") < 0)
> -		return -1;
> -
> -	if (read_expect_type(EVENT_NEWLINE, &token))
> -		goto fail;
> -	free_token(token);
> -
> -	ret = event_read_fields(event, &event->format.common_fields);
> -	if (ret < 0)
> -		return ret;
> -	event->format.nr_common = ret;
> -
> -	ret = event_read_fields(event, &event->format.fields);
> -	if (ret < 0)
> -		return ret;
> -	event->format.nr_fields = ret;
> -
> -	return 0;
> -
> - fail:
> -	free_token(token);
> -	return -1;
> -}
> -
> -enum event_type
> -process_arg_token(struct event *event, struct print_arg *arg,
> -		  char **tok, enum event_type type);
> -
> -static enum event_type
> -process_arg(struct event *event, struct print_arg *arg, char **tok)
> -{
> -	enum event_type type;
> -	char *token;
> -
> -	type = read_token(&token);
> -	*tok = token;
> -
> -	return process_arg_token(event, arg, tok, type);
> -}
> -
> -static enum event_type
> -process_cond(struct event *event, struct print_arg *top, char **tok)
> -{
> -	struct print_arg *arg, *left, *right;
> -	enum event_type type;
> -	char *token = NULL;
> -
> -	arg = malloc_or_die(sizeof(*arg));
> -	memset(arg, 0, sizeof(*arg));
> -
> -	left = malloc_or_die(sizeof(*left));
> -
> -	right = malloc_or_die(sizeof(*right));
> -
> -	arg->type = PRINT_OP;
> -	arg->op.left = left;
> -	arg->op.right = right;
> -
> -	*tok = NULL;
> -	type = process_arg(event, left, &token);
> -	if (test_type_token(type, token, EVENT_OP, ":"))
> -		goto out_free;
> -
> -	arg->op.op = token;
> -
> -	type = process_arg(event, right, &token);
> -
> -	top->op.right = arg;
> -
> -	*tok = token;
> -	return type;
> -
> -out_free:
> -	free_token(*tok);
> -	free(right);
> -	free(left);
> -	free_arg(arg);
> -	return EVENT_ERROR;
> -}
> -
> -static enum event_type
> -process_array(struct event *event, struct print_arg *top, char **tok)
> -{
> -	struct print_arg *arg;
> -	enum event_type type;
> -	char *token = NULL;
> -
> -	arg = malloc_or_die(sizeof(*arg));
> -	memset(arg, 0, sizeof(*arg));
> -
> -	*tok = NULL;
> -	type = process_arg(event, arg, &token);
> -	if (test_type_token(type, token, EVENT_OP, "]"))
> -		goto out_free;
> -
> -	top->op.right = arg;
> -
> -	free_token(token);
> -	type = read_token_item(&token);
> -	*tok = token;
> -
> -	return type;
> -
> -out_free:
> -	free_token(*tok);
> -	free_arg(arg);
> -	return EVENT_ERROR;
> -}
> -
> -static int get_op_prio(char *op)
> -{
> -	if (!op[1]) {
> -		switch (op[0]) {
> -		case '*':
> -		case '/':
> -		case '%':
> -			return 6;
> -		case '+':
> -		case '-':
> -			return 7;
> -			/* '>>' and '<<' are 8 */
> -		case '<':
> -		case '>':
> -			return 9;
> -			/* '==' and '!=' are 10 */
> -		case '&':
> -			return 11;
> -		case '^':
> -			return 12;
> -		case '|':
> -			return 13;
> -		case '?':
> -			return 16;
> -		default:
> -			die("unknown op '%c'", op[0]);
> -			return -1;
> -		}
> -	} else {
> -		if (strcmp(op, "++") == 0 ||
> -		    strcmp(op, "--") == 0) {
> -			return 3;
> -		} else if (strcmp(op, ">>") == 0 ||
> -			   strcmp(op, "<<") == 0) {
> -			return 8;
> -		} else if (strcmp(op, ">=") == 0 ||
> -			   strcmp(op, "<=") == 0) {
> -			return 9;
> -		} else if (strcmp(op, "==") == 0 ||
> -			   strcmp(op, "!=") == 0) {
> -			return 10;
> -		} else if (strcmp(op, "&&") == 0) {
> -			return 14;
> -		} else if (strcmp(op, "||") == 0) {
> -			return 15;
> -		} else {
> -			die("unknown op '%s'", op);
> -			return -1;
> -		}
> -	}
> -}
> -
> -static void set_op_prio(struct print_arg *arg)
> -{
> -
> -	/* single ops are the greatest */
> -	if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
> -		arg->op.prio = 0;
> -		return;
> -	}
> -
> -	arg->op.prio = get_op_prio(arg->op.op);
> -}
> -
> -static enum event_type
> -process_op(struct event *event, struct print_arg *arg, char **tok)
> -{
> -	struct print_arg *left, *right = NULL;
> -	enum event_type type;
> -	char *token;
> -
> -	/* the op is passed in via tok */
> -	token = *tok;
> -
> -	if (arg->type == PRINT_OP && !arg->op.left) {
> -		/* handle single op */
> -		if (token[1]) {
> -			die("bad op token %s", token);
> -			return EVENT_ERROR;
> -		}
> -		switch (token[0]) {
> -		case '!':
> -		case '+':
> -		case '-':
> -			break;
> -		default:
> -			die("bad op token %s", token);
> -			return EVENT_ERROR;
> -		}
> -
> -		/* make an empty left */
> -		left = malloc_or_die(sizeof(*left));
> -		left->type = PRINT_NULL;
> -		arg->op.left = left;
> -
> -		right = malloc_or_die(sizeof(*right));
> -		arg->op.right = right;
> -
> -		type = process_arg(event, right, tok);
> -
> -	} else if (strcmp(token, "?") == 0) {
> -
> -		left = malloc_or_die(sizeof(*left));
> -		/* copy the top arg to the left */
> -		*left = *arg;
> -
> -		arg->type = PRINT_OP;
> -		arg->op.op = token;
> -		arg->op.left = left;
> -		arg->op.prio = 0;
> -
> -		type = process_cond(event, arg, tok);
> -
> -	} else if (strcmp(token, ">>") == 0 ||
> -		   strcmp(token, "<<") == 0 ||
> -		   strcmp(token, "&") == 0 ||
> -		   strcmp(token, "|") == 0 ||
> -		   strcmp(token, "&&") == 0 ||
> -		   strcmp(token, "||") == 0 ||
> -		   strcmp(token, "-") == 0 ||
> -		   strcmp(token, "+") == 0 ||
> -		   strcmp(token, "*") == 0 ||
> -		   strcmp(token, "^") == 0 ||
> -		   strcmp(token, "/") == 0 ||
> -		   strcmp(token, "<") == 0 ||
> -		   strcmp(token, ">") == 0 ||
> -		   strcmp(token, "==") == 0 ||
> -		   strcmp(token, "!=") == 0) {
> -
> -		left = malloc_or_die(sizeof(*left));
> -
> -		/* copy the top arg to the left */
> -		*left = *arg;
> -
> -		arg->type = PRINT_OP;
> -		arg->op.op = token;
> -		arg->op.left = left;
> -
> -		set_op_prio(arg);
> -
> -		right = malloc_or_die(sizeof(*right));
> -
> -		type = read_token_item(&token);
> -		*tok = token;
> -
> -		/* could just be a type pointer */
> -		if ((strcmp(arg->op.op, "*") == 0) &&
> -		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
> -			if (left->type != PRINT_ATOM)
> -				die("bad pointer type");
> -			left->atom.atom = realloc(left->atom.atom,
> -					    sizeof(left->atom.atom) + 3);
> -			strcat(left->atom.atom, " *");
> -			*arg = *left;
> -			free(arg);
> -
> -			return type;
> -		}
> -
> -		type = process_arg_token(event, right, tok, type);
> -
> -		arg->op.right = right;
> -
> -	} else if (strcmp(token, "[") == 0) {
> -
> -		left = malloc_or_die(sizeof(*left));
> -		*left = *arg;
> -
> -		arg->type = PRINT_OP;
> -		arg->op.op = token;
> -		arg->op.left = left;
> -
> -		arg->op.prio = 0;
> -		type = process_array(event, arg, tok);
> -
> -	} else {
> -		warning("unknown op '%s'", token);
> -		event->flags |= EVENT_FL_FAILED;
> -		/* the arg is now the left side */
> -		return EVENT_NONE;
> -	}
> -
> -	if (type == EVENT_OP) {
> -		int prio;
> -
> -		/* higher prios need to be closer to the root */
> -		prio = get_op_prio(*tok);
> -
> -		if (prio > arg->op.prio)
> -			return process_op(event, arg, tok);
> -
> -		return process_op(event, right, tok);
> -	}
> -
> -	return type;
> -}
> -
> -static enum event_type
> -process_entry(struct event *event __unused, struct print_arg *arg,
> -	      char **tok)
> -{
> -	enum event_type type;
> -	char *field;
> -	char *token;
> -
> -	if (read_expected(EVENT_OP, "->") < 0)
> -		return EVENT_ERROR;
> -
> -	if (read_expect_type(EVENT_ITEM, &token) < 0)
> -		goto fail;
> -	field = token;
> -
> -	arg->type = PRINT_FIELD;
> -	arg->field.name = field;
> -
> -	if (is_flag_field) {
> -		arg->field.field = find_any_field(event, arg->field.name);
> -		arg->field.field->flags |= FIELD_IS_FLAG;
> -		is_flag_field = 0;
> -	} else if (is_symbolic_field) {
> -		arg->field.field = find_any_field(event, arg->field.name);
> -		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
> -		is_symbolic_field = 0;
> -	}
> -
> -	type = read_token(&token);
> -	*tok = token;
> -
> -	return type;
> -
> -fail:
> -	free_token(token);
> -	return EVENT_ERROR;
> -}
> -
> -static char *arg_eval (struct print_arg *arg);
> -
> -static long long arg_num_eval(struct print_arg *arg)
> -{
> -	long long left, right;
> -	long long val = 0;
> -
> -	switch (arg->type) {
> -	case PRINT_ATOM:
> -		val = strtoll(arg->atom.atom, NULL, 0);
> -		break;
> -	case PRINT_TYPE:
> -		val = arg_num_eval(arg->typecast.item);
> -		break;
> -	case PRINT_OP:
> -		switch (arg->op.op[0]) {
> -		case '|':
> -			left = arg_num_eval(arg->op.left);
> -			right = arg_num_eval(arg->op.right);
> -			if (arg->op.op[1])
> -				val = left || right;
> -			else
> -				val = left | right;
> -			break;
> -		case '&':
> -			left = arg_num_eval(arg->op.left);
> -			right = arg_num_eval(arg->op.right);
> -			if (arg->op.op[1])
> -				val = left && right;
> -			else
> -				val = left & right;
> -			break;
> -		case '<':
> -			left = arg_num_eval(arg->op.left);
> -			right = arg_num_eval(arg->op.right);
> -			switch (arg->op.op[1]) {
> -			case 0:
> -				val = left < right;
> -				break;
> -			case '<':
> -				val = left << right;
> -				break;
> -			case '=':
> -				val = left <= right;
> -				break;
> -			default:
> -				die("unknown op '%s'", arg->op.op);
> -			}
> -			break;
> -		case '>':
> -			left = arg_num_eval(arg->op.left);
> -			right = arg_num_eval(arg->op.right);
> -			switch (arg->op.op[1]) {
> -			case 0:
> -				val = left > right;
> -				break;
> -			case '>':
> -				val = left >> right;
> -				break;
> -			case '=':
> -				val = left >= right;
> -				break;
> -			default:
> -				die("unknown op '%s'", arg->op.op);
> -			}
> -			break;
> -		case '=':
> -			left = arg_num_eval(arg->op.left);
> -			right = arg_num_eval(arg->op.right);
> -
> -			if (arg->op.op[1] != '=')
> -				die("unknown op '%s'", arg->op.op);
> -
> -			val = left == right;
> -			break;
> -		case '!':
> -			left = arg_num_eval(arg->op.left);
> -			right = arg_num_eval(arg->op.right);
> -
> -			switch (arg->op.op[1]) {
> -			case '=':
> -				val = left != right;
> -				break;
> -			default:
> -				die("unknown op '%s'", arg->op.op);
> -			}
> -			break;
> -		default:
> -			die("unknown op '%s'", arg->op.op);
> -		}
> -		break;
> -
> -	case PRINT_NULL:
> -	case PRINT_FIELD ... PRINT_SYMBOL:
> -	case PRINT_STRING:
> -	default:
> -		die("invalid eval type %d", arg->type);
> -
> -	}
> -	return val;
> -}
> -
> -static char *arg_eval (struct print_arg *arg)
> -{
> -	long long val;
> -	static char buf[20];
> -
> -	switch (arg->type) {
> -	case PRINT_ATOM:
> -		return arg->atom.atom;
> -	case PRINT_TYPE:
> -		return arg_eval(arg->typecast.item);
> -	case PRINT_OP:
> -		val = arg_num_eval(arg);
> -		sprintf(buf, "%lld", val);
> -		return buf;
> -
> -	case PRINT_NULL:
> -	case PRINT_FIELD ... PRINT_SYMBOL:
> -	case PRINT_STRING:
> -	default:
> -		die("invalid eval type %d", arg->type);
> -		break;
> -	}
> -
> -	return NULL;
> -}
> -
> -static enum event_type
> -process_fields(struct event *event, struct print_flag_sym **list, char **tok)
> -{
> -	enum event_type type;
> -	struct print_arg *arg = NULL;
> -	struct print_flag_sym *field;
> -	char *token = NULL;
> -	char *value;
> -
> -	do {
> -		free_token(token);
> -		type = read_token_item(&token);
> -		if (test_type_token(type, token, EVENT_OP, "{"))
> -			break;
> -
> -		arg = malloc_or_die(sizeof(*arg));
> -
> -		free_token(token);
> -		type = process_arg(event, arg, &token);
> -		if (test_type_token(type, token, EVENT_DELIM, ","))
> -			goto out_free;
> -
> -		field = malloc_or_die(sizeof(*field));
> -		memset(field, 0, sizeof(*field));
> -
> -		value = arg_eval(arg);
> -		field->value = strdup(value);
> -
> -		free_token(token);
> -		type = process_arg(event, arg, &token);
> -		if (test_type_token(type, token, EVENT_OP, "}"))
> -			goto out_free;
> -
> -		value = arg_eval(arg);
> -		field->str = strdup(value);
> -		free_arg(arg);
> -		arg = NULL;
> -
> -		*list = field;
> -		list = &field->next;
> -
> -		free_token(token);
> -		type = read_token_item(&token);
> -	} while (type == EVENT_DELIM && strcmp(token, ",") == 0);
> -
> -	*tok = token;
> -	return type;
> -
> -out_free:
> -	free_arg(arg);
> -	free_token(token);
> -
> -	return EVENT_ERROR;
> -}
> -
> -static enum event_type
> -process_flags(struct event *event, struct print_arg *arg, char **tok)
> -{
> -	struct print_arg *field;
> -	enum event_type type;
> -	char *token;
> -
> -	memset(arg, 0, sizeof(*arg));
> -	arg->type = PRINT_FLAGS;
> -
> -	if (read_expected_item(EVENT_DELIM, "(") < 0)
> -		return EVENT_ERROR;
> -
> -	field = malloc_or_die(sizeof(*field));
> -
> -	type = process_arg(event, field, &token);
> -	if (test_type_token(type, token, EVENT_DELIM, ","))
> -		goto out_free;
> -
> -	arg->flags.field = field;
> -
> -	type = read_token_item(&token);
> -	if (event_item_type(type)) {
> -		arg->flags.delim = token;
> -		type = read_token_item(&token);
> -	}
> -
> -	if (test_type_token(type, token, EVENT_DELIM, ","))
> -		goto out_free;
> -
> -	type = process_fields(event, &arg->flags.flags, &token);
> -	if (test_type_token(type, token, EVENT_DELIM, ")"))
> -		goto out_free;
> -
> -	free_token(token);
> -	type = read_token_item(tok);
> -	return type;
> -
> -out_free:
> -	free_token(token);
> -	return EVENT_ERROR;
> -}
> -
> -static enum event_type
> -process_symbols(struct event *event, struct print_arg *arg, char **tok)
> -{
> -	struct print_arg *field;
> -	enum event_type type;
> -	char *token;
> -
> -	memset(arg, 0, sizeof(*arg));
> -	arg->type = PRINT_SYMBOL;
> -
> -	if (read_expected_item(EVENT_DELIM, "(") < 0)
> -		return EVENT_ERROR;
> -
> -	field = malloc_or_die(sizeof(*field));
> -
> -	type = process_arg(event, field, &token);
> -	if (test_type_token(type, token, EVENT_DELIM, ","))
> -		goto out_free;
> -
> -	arg->symbol.field = field;
> -
> -	type = process_fields(event, &arg->symbol.symbols, &token);
> -	if (test_type_token(type, token, EVENT_DELIM, ")"))
> -		goto out_free;
> -
> -	free_token(token);
> -	type = read_token_item(tok);
> -	return type;
> -
> -out_free:
> -	free_token(token);
> -	return EVENT_ERROR;
> -}
> -
> -static enum event_type
> -process_paren(struct event *event, struct print_arg *arg, char **tok)
> -{
> -	struct print_arg *item_arg;
> -	enum event_type type;
> -	char *token;
> -
> -	type = process_arg(event, arg, &token);
> -
> -	if (type == EVENT_ERROR)
> -		return EVENT_ERROR;
> -
> -	if (type == EVENT_OP)
> -		type = process_op(event, arg, &token);
> -
> -	if (type == EVENT_ERROR)
> -		return EVENT_ERROR;
> -
> -	if (test_type_token(type, token, EVENT_DELIM, ")")) {
> -		free_token(token);
> -		return EVENT_ERROR;
> -	}
> -
> -	free_token(token);
> -	type = read_token_item(&token);
> -
> -	/*
> -	 * If the next token is an item or another open paren, then
> -	 * this was a typecast.
> -	 */
> -	if (event_item_type(type) ||
> -	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
> -
> -		/* make this a typecast and contine */
> -
> -		/* prevous must be an atom */
> -		if (arg->type != PRINT_ATOM)
> -			die("previous needed to be PRINT_ATOM");
> -
> -		item_arg = malloc_or_die(sizeof(*item_arg));
> -
> -		arg->type = PRINT_TYPE;
> -		arg->typecast.type = arg->atom.atom;
> -		arg->typecast.item = item_arg;
> -		type = process_arg_token(event, item_arg, &token, type);
> -
> -	}
> -
> -	*tok = token;
> -	return type;
> -}
> -
> -
> -static enum event_type
> -process_str(struct event *event __unused, struct print_arg *arg, char **tok)
> -{
> -	enum event_type type;
> -	char *token;
> -
> -	if (read_expected(EVENT_DELIM, "(") < 0)
> -		return EVENT_ERROR;
> -
> -	if (read_expect_type(EVENT_ITEM, &token) < 0)
> -		goto fail;
> -
> -	arg->type = PRINT_STRING;
> -	arg->string.string = token;
> -	arg->string.offset = -1;
> -
> -	if (read_expected(EVENT_DELIM, ")") < 0)
> -		return EVENT_ERROR;
> -
> -	type = read_token(&token);
> -	*tok = token;
> -
> -	return type;
> -fail:
> -	free_token(token);
> -	return EVENT_ERROR;
> -}
> -
> -enum event_type
> -process_arg_token(struct event *event, struct print_arg *arg,
> -		  char **tok, enum event_type type)
> -{
> -	char *token;
> -	char *atom;
> -
> -	token = *tok;
> -
> -	switch (type) {
> -	case EVENT_ITEM:
> -		if (strcmp(token, "REC") == 0) {
> -			free_token(token);
> -			type = process_entry(event, arg, &token);
> -		} else if (strcmp(token, "__print_flags") == 0) {
> -			free_token(token);
> -			is_flag_field = 1;
> -			type = process_flags(event, arg, &token);
> -		} else if (strcmp(token, "__print_symbolic") == 0) {
> -			free_token(token);
> -			is_symbolic_field = 1;
> -			type = process_symbols(event, arg, &token);
> -		} else if (strcmp(token, "__get_str") == 0) {
> -			free_token(token);
> -			type = process_str(event, arg, &token);
> -		} else {
> -			atom = token;
> -			/* test the next token */
> -			type = read_token_item(&token);
> -
> -			/* atoms can be more than one token long */
> -			while (type == EVENT_ITEM) {
> -				atom = realloc(atom, strlen(atom) + strlen(token) + 2);
> -				strcat(atom, " ");
> -				strcat(atom, token);
> -				free_token(token);
> -				type = read_token_item(&token);
> -			}
> -
> -			/* todo, test for function */
> -
> -			arg->type = PRINT_ATOM;
> -			arg->atom.atom = atom;
> -		}
> -		break;
> -	case EVENT_DQUOTE:
> -	case EVENT_SQUOTE:
> -		arg->type = PRINT_ATOM;
> -		arg->atom.atom = token;
> -		type = read_token_item(&token);
> -		break;
> -	case EVENT_DELIM:
> -		if (strcmp(token, "(") == 0) {
> -			free_token(token);
> -			type = process_paren(event, arg, &token);
> -			break;
> -		}
> -	case EVENT_OP:
> -		/* handle single ops */
> -		arg->type = PRINT_OP;
> -		arg->op.op = token;
> -		arg->op.left = NULL;
> -		type = process_op(event, arg, &token);
> -
> -		break;
> -
> -	case EVENT_ERROR ... EVENT_NEWLINE:
> -	default:
> -		die("unexpected type %d", type);
> -	}
> -	*tok = token;
> -
> -	return type;
> -}
> -
> -static int event_read_print_args(struct event *event, struct print_arg **list)
> -{
> -	enum event_type type = EVENT_ERROR;
> -	struct print_arg *arg;
> -	char *token;
> -	int args = 0;
> -
> -	do {
> -		if (type == EVENT_NEWLINE) {
> -			free_token(token);
> -			type = read_token_item(&token);
> -			continue;
> -		}
> -
> -		arg = malloc_or_die(sizeof(*arg));
> -		memset(arg, 0, sizeof(*arg));
> -
> -		type = process_arg(event, arg, &token);
> -
> -		if (type == EVENT_ERROR) {
> -			free_arg(arg);
> -			return -1;
> -		}
> -
> -		*list = arg;
> -		args++;
> -
> -		if (type == EVENT_OP) {
> -			type = process_op(event, arg, &token);
> -			list = &arg->next;
> -			continue;
> -		}
> -
> -		if (type == EVENT_DELIM && strcmp(token, ",") == 0) {
> -			free_token(token);
> -			*list = arg;
> -			list = &arg->next;
> -			continue;
> -		}
> -		break;
> -	} while (type != EVENT_NONE);
> -
> -	if (type != EVENT_NONE)
> -		free_token(token);
> -
> -	return args;
> -}
> -
> -static int event_read_print(struct event *event)
> -{
> -	enum event_type type;
> -	char *token;
> -	int ret;
> -
> -	if (read_expected_item(EVENT_ITEM, "print") < 0)
> -		return -1;
> -
> -	if (read_expected(EVENT_ITEM, "fmt") < 0)
> -		return -1;
> -
> -	if (read_expected(EVENT_OP, ":") < 0)
> -		return -1;
> -
> -	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
> -		goto fail;
> -
> - concat:
> -	event->print_fmt.format = token;
> -	event->print_fmt.args = NULL;
> -
> -	/* ok to have no arg */
> -	type = read_token_item(&token);
> -
> -	if (type == EVENT_NONE)
> -		return 0;
> -
> -	/* Handle concatination of print lines */
> -	if (type == EVENT_DQUOTE) {
> -		char *cat;
> -
> -		cat = malloc_or_die(strlen(event->print_fmt.format) +
> -				    strlen(token) + 1);
> -		strcpy(cat, event->print_fmt.format);
> -		strcat(cat, token);
> -		free_token(token);
> -		free_token(event->print_fmt.format);
> -		event->print_fmt.format = NULL;
> -		token = cat;
> -		goto concat;
> -	}
> -
> -	if (test_type_token(type, token, EVENT_DELIM, ","))
> -		goto fail;
> -
> -	free_token(token);
> -
> -	ret = event_read_print_args(event, &event->print_fmt.args);
> -	if (ret < 0)
> -		return -1;
> -
> -	return ret;
> -
> - fail:
> -	free_token(token);
> -	return -1;
> -}
> -
> -static struct format_field *
> -find_common_field(struct event *event, const char *name)
> -{
> -	struct format_field *format;
> -
> -	for (format = event->format.common_fields;
> -	     format; format = format->next) {
> -		if (strcmp(format->name, name) == 0)
> -			break;
> -	}
> -
> -	return format;
> -}
> -
> -static struct format_field *
> -find_field(struct event *event, const char *name)
> -{
> -	struct format_field *format;
> -
> -	for (format = event->format.fields;
> -	     format; format = format->next) {
> -		if (strcmp(format->name, name) == 0)
> -			break;
> -	}
> -
> -	return format;
> -}
> -
> -static struct format_field *
> -find_any_field(struct event *event, const char *name)
> -{
> -	struct format_field *format;
> -
> -	format = find_common_field(event, name);
> -	if (format)
> -		return format;
> -	return find_field(event, name);
> -}
> -
> -unsigned long long read_size(void *ptr, int size)
> -{
> -	switch (size) {
> -	case 1:
> -		return *(unsigned char *)ptr;
> -	case 2:
> -		return data2host2(ptr);
> -	case 4:
> -		return data2host4(ptr);
> -	case 8:
> -		return data2host8(ptr);
> -	default:
> -		/* BUG! */
> -		return 0;
> -	}
> -}
> -
> -unsigned long long
> -raw_field_value(struct event *event, const char *name, void *data)
> -{
> -	struct format_field *field;
> -
> -	field = find_any_field(event, name);
> -	if (!field)
> -		return 0ULL;
> -
> -	return read_size(data + field->offset, field->size);
> -}
> -
> -void *raw_field_ptr(struct event *event, const char *name, void *data)
> -{
> -	struct format_field *field;
> -
> -	field = find_any_field(event, name);
> -	if (!field)
> -		return NULL;
> -
> -	if (field->flags & FIELD_IS_DYNAMIC) {
> -		int offset;
> -
> -		offset = *(int *)(data + field->offset);
> -		offset &= 0xffff;
> -
> -		return data + offset;
> -	}
> -
> -	return data + field->offset;
> -}
> -
> -static int get_common_info(const char *type, int *offset, int *size)
> -{
> -	struct event *event;
> -	struct format_field *field;
> -
> -	/*
> -	 * All events should have the same common elements.
> -	 * Pick any event to find where the type is;
> -	 */
> -	if (!event_list)
> -		die("no event_list!");
> -
> -	event = event_list;
> -	field = find_common_field(event, type);
> -	if (!field)
> -		die("field '%s' not found", type);
> -
> -	*offset = field->offset;
> -	*size = field->size;
> -
> -	return 0;
> -}
> -
> -static int __parse_common(void *data, int *size, int *offset,
> -			  const char *name)
> -{
> -	int ret;
> -
> -	if (!*size) {
> -		ret = get_common_info(name, offset, size);
> -		if (ret < 0)
> -			return ret;
> -	}
> -	return read_size(data + *offset, *size);
> -}
> -
> -int trace_parse_common_type(void *data)
> -{
> -	static int type_offset;
> -	static int type_size;
> -
> -	return __parse_common(data, &type_size, &type_offset,
> -			      "common_type");
> -}
> -
> -int trace_parse_common_pid(void *data)
> -{
> -	static int pid_offset;
> -	static int pid_size;
> -
> -	return __parse_common(data, &pid_size, &pid_offset,
> -			      "common_pid");
> -}
> -
> -int parse_common_pc(void *data)
> -{
> -	static int pc_offset;
> -	static int pc_size;
> -
> -	return __parse_common(data, &pc_size, &pc_offset,
> -			      "common_preempt_count");
> -}
> -
> -int parse_common_flags(void *data)
> -{
> -	static int flags_offset;
> -	static int flags_size;
> -
> -	return __parse_common(data, &flags_size, &flags_offset,
> -			      "common_flags");
> -}
> -
> -int parse_common_lock_depth(void *data)
> -{
> -	static int ld_offset;
> -	static int ld_size;
> -	int ret;
> -
> -	ret = __parse_common(data, &ld_size, &ld_offset,
> -			     "common_lock_depth");
> -	if (ret < 0)
> -		return -1;
> -
> -	return ret;
> -}
> -
> -struct event *trace_find_event(int id)
> -{
> -	struct event *event;
> -
> -	for (event = event_list; event; event = event->next) {
> -		if (event->id == id)
> -			break;
> -	}
> -	return event;
> -}
> -
> -struct event *trace_find_next_event(struct event *event)
> -{
> -	if (!event)
> -		return event_list;
> -
> -	return event->next;
> -}
> -
> -static unsigned long long eval_num_arg(void *data, int size,
> -				   struct event *event, struct print_arg *arg)
> -{
> -	unsigned long long val = 0;
> -	unsigned long long left, right;
> -	struct print_arg *larg;
> -
> -	switch (arg->type) {
> -	case PRINT_NULL:
> -		/* ?? */
> -		return 0;
> -	case PRINT_ATOM:
> -		return strtoull(arg->atom.atom, NULL, 0);
> -	case PRINT_FIELD:
> -		if (!arg->field.field) {
> -			arg->field.field = find_any_field(event, arg->field.name);
> -			if (!arg->field.field)
> -				die("field %s not found", arg->field.name);
> -		}
> -		/* must be a number */
> -		val = read_size(data + arg->field.field->offset,
> -				arg->field.field->size);
> -		break;
> -	case PRINT_FLAGS:
> -	case PRINT_SYMBOL:
> -		break;
> -	case PRINT_TYPE:
> -		return eval_num_arg(data, size, event, arg->typecast.item);
> -	case PRINT_STRING:
> -		return 0;
> -		break;
> -	case PRINT_OP:
> -		if (strcmp(arg->op.op, "[") == 0) {
> -			/*
> -			 * Arrays are special, since we don't want
> -			 * to read the arg as is.
> -			 */
> -			if (arg->op.left->type != PRINT_FIELD)
> -				goto default_op; /* oops, all bets off */
> -			larg = arg->op.left;
> -			if (!larg->field.field) {
> -				larg->field.field =
> -					find_any_field(event, larg->field.name);
> -				if (!larg->field.field)
> -					die("field %s not found", larg->field.name);
> -			}
> -			right = eval_num_arg(data, size, event, arg->op.right);
> -			val = read_size(data + larg->field.field->offset +
> -					right * long_size, long_size);
> -			break;
> -		}
> - default_op:
> -		left = eval_num_arg(data, size, event, arg->op.left);
> -		right = eval_num_arg(data, size, event, arg->op.right);
> -		switch (arg->op.op[0]) {
> -		case '|':
> -			if (arg->op.op[1])
> -				val = left || right;
> -			else
> -				val = left | right;
> -			break;
> -		case '&':
> -			if (arg->op.op[1])
> -				val = left && right;
> -			else
> -				val = left & right;
> -			break;
> -		case '<':
> -			switch (arg->op.op[1]) {
> -			case 0:
> -				val = left < right;
> -				break;
> -			case '<':
> -				val = left << right;
> -				break;
> -			case '=':
> -				val = left <= right;
> -				break;
> -			default:
> -				die("unknown op '%s'", arg->op.op);
> -			}
> -			break;
> -		case '>':
> -			switch (arg->op.op[1]) {
> -			case 0:
> -				val = left > right;
> -				break;
> -			case '>':
> -				val = left >> right;
> -				break;
> -			case '=':
> -				val = left >= right;
> -				break;
> -			default:
> -				die("unknown op '%s'", arg->op.op);
> -			}
> -			break;
> -		case '=':
> -			if (arg->op.op[1] != '=')
> -				die("unknown op '%s'", arg->op.op);
> -			val = left == right;
> -			break;
> -		case '-':
> -			val = left - right;
> -			break;
> -		case '+':
> -			val = left + right;
> -			break;
> -		default:
> -			die("unknown op '%s'", arg->op.op);
> -		}
> -		break;
> -	default: /* not sure what to do there */
> -		return 0;
> -	}
> -	return val;
> -}
> -
> -struct flag {
> -	const char *name;
> -	unsigned long long value;
> -};
> -
> -static const struct flag flags[] = {
> -	{ "HI_SOFTIRQ", 0 },
> -	{ "TIMER_SOFTIRQ", 1 },
> -	{ "NET_TX_SOFTIRQ", 2 },
> -	{ "NET_RX_SOFTIRQ", 3 },
> -	{ "BLOCK_SOFTIRQ", 4 },
> -	{ "BLOCK_IOPOLL_SOFTIRQ", 5 },
> -	{ "TASKLET_SOFTIRQ", 6 },
> -	{ "SCHED_SOFTIRQ", 7 },
> -	{ "HRTIMER_SOFTIRQ", 8 },
> -	{ "RCU_SOFTIRQ", 9 },
> -
> -	{ "HRTIMER_NORESTART", 0 },
> -	{ "HRTIMER_RESTART", 1 },
> -};
> -
> -unsigned long long eval_flag(const char *flag)
> -{
> -	int i;
> -
> -	/*
> -	 * Some flags in the format files do not get converted.
> -	 * If the flag is not numeric, see if it is something that
> -	 * we already know about.
> -	 */
> -	if (isdigit(flag[0]))
> -		return strtoull(flag, NULL, 0);
> -
> -	for (i = 0; i < (int)(sizeof(flags)/sizeof(flags[0])); i++)
> -		if (strcmp(flags[i].name, flag) == 0)
> -			return flags[i].value;
> -
> -	return 0;
> -}
> -
> -static void print_str_arg(void *data, int size,
> -			  struct event *event, struct print_arg *arg)
> -{
> -	struct print_flag_sym *flag;
> -	unsigned long long val, fval;
> -	char *str;
> -	int print;
> -
> -	switch (arg->type) {
> -	case PRINT_NULL:
> -		/* ?? */
> -		return;
> -	case PRINT_ATOM:
> -		printf("%s", arg->atom.atom);
> -		return;
> -	case PRINT_FIELD:
> -		if (!arg->field.field) {
> -			arg->field.field = find_any_field(event, arg->field.name);
> -			if (!arg->field.field)
> -				die("field %s not found", arg->field.name);
> -		}
> -		str = malloc_or_die(arg->field.field->size + 1);
> -		memcpy(str, data + arg->field.field->offset,
> -		       arg->field.field->size);
> -		str[arg->field.field->size] = 0;
> -		printf("%s", str);
> -		free(str);
> -		break;
> -	case PRINT_FLAGS:
> -		val = eval_num_arg(data, size, event, arg->flags.field);
> -		print = 0;
> -		for (flag = arg->flags.flags; flag; flag = flag->next) {
> -			fval = eval_flag(flag->value);
> -			if (!val && !fval) {
> -				printf("%s", flag->str);
> -				break;
> -			}
> -			if (fval && (val & fval) == fval) {
> -				if (print && arg->flags.delim)
> -					printf("%s", arg->flags.delim);
> -				printf("%s", flag->str);
> -				print = 1;
> -				val &= ~fval;
> -			}
> -		}
> -		break;
> -	case PRINT_SYMBOL:
> -		val = eval_num_arg(data, size, event, arg->symbol.field);
> -		for (flag = arg->symbol.symbols; flag; flag = flag->next) {
> -			fval = eval_flag(flag->value);
> -			if (val == fval) {
> -				printf("%s", flag->str);
> -				break;
> -			}
> -		}
> -		break;
> -
> -	case PRINT_TYPE:
> -		break;
> -	case PRINT_STRING: {
> -		int str_offset;
> -
> -		if (arg->string.offset == -1) {
> -			struct format_field *f;
> -
> -			f = find_any_field(event, arg->string.string);
> -			arg->string.offset = f->offset;
> -		}
> -		str_offset = *(int *)(data + arg->string.offset);
> -		str_offset &= 0xffff;
> -		printf("%s", ((char *)data) + str_offset);
> -		break;
> -	}
> -	case PRINT_OP:
> -		/*
> -		 * The only op for string should be ? :
> -		 */
> -		if (arg->op.op[0] != '?')
> -			return;
> -		val = eval_num_arg(data, size, event, arg->op.left);
> -		if (val)
> -			print_str_arg(data, size, event, arg->op.right->op.left);
> -		else
> -			print_str_arg(data, size, event, arg->op.right->op.right);
> -		break;
> -	default:
> -		/* well... */
> -		break;
> -	}
> -}
> -
> -static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event *event)
> -{
> -	static struct format_field *field, *ip_field;
> -	struct print_arg *args, *arg, **next;
> -	unsigned long long ip, val;
> -	char *ptr;
> -	void *bptr;
> -
> -	if (!field) {
> -		field = find_field(event, "buf");
> -		if (!field)
> -			die("can't find buffer field for binary printk");
> -		ip_field = find_field(event, "ip");
> -		if (!ip_field)
> -			die("can't find ip field for binary printk");
> -	}
> -
> -	ip = read_size(data + ip_field->offset, ip_field->size);
> -
> -	/*
> -	 * The first arg is the IP pointer.
> -	 */
> -	args = malloc_or_die(sizeof(*args));
> -	arg = args;
> -	arg->next = NULL;
> -	next = &arg->next;
> -
> -	arg->type = PRINT_ATOM;
> -	arg->atom.atom = malloc_or_die(32);
> -	sprintf(arg->atom.atom, "%lld", ip);
> -
> -	/* skip the first "%pf : " */
> -	for (ptr = fmt + 6, bptr = data + field->offset;
> -	     bptr < data + size && *ptr; ptr++) {
> -		int ls = 0;
> -
> -		if (*ptr == '%') {
> - process_again:
> -			ptr++;
> -			switch (*ptr) {
> -			case '%':
> -				break;
> -			case 'l':
> -				ls++;
> -				goto process_again;
> -			case 'L':
> -				ls = 2;
> -				goto process_again;
> -			case '0' ... '9':
> -				goto process_again;
> -			case 'p':
> -				ls = 1;
> -				/* fall through */
> -			case 'd':
> -			case 'u':
> -			case 'x':
> -			case 'i':
> -				/* the pointers are always 4 bytes aligned */
> -				bptr = (void *)(((unsigned long)bptr + 3) &
> -						~3);
> -				switch (ls) {
> -				case 0:
> -				case 1:
> -					ls = long_size;
> -					break;
> -				case 2:
> -					ls = 8;
> -				default:
> -					break;
> -				}
> -				val = read_size(bptr, ls);
> -				bptr += ls;
> -				arg = malloc_or_die(sizeof(*arg));
> -				arg->next = NULL;
> -				arg->type = PRINT_ATOM;
> -				arg->atom.atom = malloc_or_die(32);
> -				sprintf(arg->atom.atom, "%lld", val);
> -				*next = arg;
> -				next = &arg->next;
> -				break;
> -			case 's':
> -				arg = malloc_or_die(sizeof(*arg));
> -				arg->next = NULL;
> -				arg->type = PRINT_STRING;
> -				arg->string.string = strdup(bptr);
> -				bptr += strlen(bptr) + 1;
> -				*next = arg;
> -				next = &arg->next;
> -			default:
> -				break;
> -			}
> -		}
> -	}
> -
> -	return args;
> -}
> -
> -static void free_args(struct print_arg *args)
> -{
> -	struct print_arg *next;
> -
> -	while (args) {
> -		next = args->next;
> -
> -		if (args->type == PRINT_ATOM)
> -			free(args->atom.atom);
> -		else
> -			free(args->string.string);
> -		free(args);
> -		args = next;
> -	}
> -}
> -
> -static char *get_bprint_format(void *data, int size __unused, struct event *event)
> -{
> -	unsigned long long addr;
> -	static struct format_field *field;
> -	struct printk_map *printk;
> -	char *format;
> -	char *p;
> -
> -	if (!field) {
> -		field = find_field(event, "fmt");
> -		if (!field)
> -			die("can't find format field for binary printk");
> -		printf("field->offset = %d size=%d\n", field->offset, field->size);
> -	}
> -
> -	addr = read_size(data + field->offset, field->size);
> -
> -	printk = find_printk(addr);
> -	if (!printk) {
> -		format = malloc_or_die(45);
> -		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
> -			addr);
> -		return format;
> -	}
> -
> -	p = printk->printk;
> -	/* Remove any quotes. */
> -	if (*p == '"')
> -		p++;
> -	format = malloc_or_die(strlen(p) + 10);
> -	sprintf(format, "%s : %s", "%pf", p);
> -	/* remove ending quotes and new line since we will add one too */
> -	p = format + strlen(format) - 1;
> -	if (*p == '"')
> -		*p = 0;
> -
> -	p -= 2;
> -	if (strcmp(p, "\\n") == 0)
> -		*p = 0;
> -
> -	return format;
> -}
> -
> -static void pretty_print(void *data, int size, struct event *event)
> -{
> -	struct print_fmt *print_fmt = &event->print_fmt;
> -	struct print_arg *arg = print_fmt->args;
> -	struct print_arg *args = NULL;
> -	const char *ptr = print_fmt->format;
> -	unsigned long long val;
> -	struct func_map *func;
> -	const char *saveptr;
> -	char *bprint_fmt = NULL;
> -	char format[32];
> -	int show_func;
> -	int len;
> -	int ls;
> -
> -	if (event->flags & EVENT_FL_ISFUNC)
> -		ptr = " %pF <-- %pF";
> -
> -	if (event->flags & EVENT_FL_ISBPRINT) {
> -		bprint_fmt = get_bprint_format(data, size, event);
> -		args = make_bprint_args(bprint_fmt, data, size, event);
> -		arg = args;
> -		ptr = bprint_fmt;
> -	}
> -
> -	for (; *ptr; ptr++) {
> -		ls = 0;
> -		if (*ptr == '\\') {
> -			ptr++;
> -			switch (*ptr) {
> -			case 'n':
> -				printf("\n");
> -				break;
> -			case 't':
> -				printf("\t");
> -				break;
> -			case 'r':
> -				printf("\r");
> -				break;
> -			case '\\':
> -				printf("\\");
> -				break;
> -			default:
> -				printf("%c", *ptr);
> -				break;
> -			}
> -
> -		} else if (*ptr == '%') {
> -			saveptr = ptr;
> -			show_func = 0;
> - cont_process:
> -			ptr++;
> -			switch (*ptr) {
> -			case '%':
> -				printf("%%");
> -				break;
> -			case 'l':
> -				ls++;
> -				goto cont_process;
> -			case 'L':
> -				ls = 2;
> -				goto cont_process;
> -			case 'z':
> -			case 'Z':
> -			case '0' ... '9':
> -				goto cont_process;
> -			case 'p':
> -				if (long_size == 4)
> -					ls = 1;
> -				else
> -					ls = 2;
> -
> -				if (*(ptr+1) == 'F' ||
> -				    *(ptr+1) == 'f') {
> -					ptr++;
> -					show_func = *ptr;
> -				}
> -
> -				/* fall through */
> -			case 'd':
> -			case 'i':
> -			case 'x':
> -			case 'X':
> -			case 'u':
> -				if (!arg)
> -					die("no argument match");
> -
> -				len = ((unsigned long)ptr + 1) -
> -					(unsigned long)saveptr;
> -
> -				/* should never happen */
> -				if (len > 32)
> -					die("bad format!");
> -
> -				memcpy(format, saveptr, len);
> -				format[len] = 0;
> -
> -				val = eval_num_arg(data, size, event, arg);
> -				arg = arg->next;
> -
> -				if (show_func) {
> -					func = find_func(val);
> -					if (func) {
> -						printf("%s", func->func);
> -						if (show_func == 'F')
> -							printf("+0x%llx",
> -							       val - func->addr);
> -						break;
> -					}
> -				}
> -				switch (ls) {
> -				case 0:
> -					printf(format, (int)val);
> -					break;
> -				case 1:
> -					printf(format, (long)val);
> -					break;
> -				case 2:
> -					printf(format, (long long)val);
> -					break;
> -				default:
> -					die("bad count (%d)", ls);
> -				}
> -				break;
> -			case 's':
> -				if (!arg)
> -					die("no matching argument");
> -
> -				print_str_arg(data, size, event, arg);
> -				arg = arg->next;
> -				break;
> -			default:
> -				printf(">%c<", *ptr);
> -
> -			}
> -		} else
> -			printf("%c", *ptr);
> -	}
> -
> -	if (args) {
> -		free_args(args);
> -		free(bprint_fmt);
> -	}
> -}
> -
> -static inline int log10_cpu(int nb)
> -{
> -	if (nb / 100)
> -		return 3;
> -	if (nb / 10)
> -		return 2;
> -	return 1;
> -}
> -
> -static void print_lat_fmt(void *data, int size __unused)
> -{
> -	unsigned int lat_flags;
> -	unsigned int pc;
> -	int lock_depth;
> -	int hardirq;
> -	int softirq;
> -
> -	lat_flags = parse_common_flags(data);
> -	pc = parse_common_pc(data);
> -	lock_depth = parse_common_lock_depth(data);
> -
> -	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
> -	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
> -
> -	printf("%c%c%c",
> -	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
> -	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
> -	       'X' : '.',
> -	       (lat_flags & TRACE_FLAG_NEED_RESCHED) ?
> -	       'N' : '.',
> -	       (hardirq && softirq) ? 'H' :
> -	       hardirq ? 'h' : softirq ? 's' : '.');
> -
> -	if (pc)
> -		printf("%x", pc);
> -	else
> -		printf(".");
> -
> -	if (lock_depth < 0)
> -		printf(".");
> -	else
> -		printf("%d", lock_depth);
> -}
> -
> -/* taken from Linux, written by Frederic Weisbecker */
> -static void print_graph_cpu(int cpu)
> -{
> -	int i;
> -	int log10_this = log10_cpu(cpu);
> -	int log10_all = log10_cpu(cpus);
> -
> -
> -	/*
> -	 * Start with a space character - to make it stand out
> -	 * to the right a bit when trace output is pasted into
> -	 * email:
> -	 */
> -	printf(" ");
> -
> -	/*
> -	 * Tricky - we space the CPU field according to the max
> -	 * number of online CPUs. On a 2-cpu system it would take
> -	 * a maximum of 1 digit - on a 128 cpu system it would
> -	 * take up to 3 digits:
> -	 */
> -	for (i = 0; i < log10_all - log10_this; i++)
> -		printf(" ");
> -
> -	printf("%d) ", cpu);
> -}
> -
> -#define TRACE_GRAPH_PROCINFO_LENGTH	14
> -#define TRACE_GRAPH_INDENT	2
> -
> -static void print_graph_proc(int pid, const char *comm)
> -{
> -	/* sign + log10(MAX_INT) + '\0' */
> -	char pid_str[11];
> -	int spaces = 0;
> -	int len;
> -	int i;
> -
> -	sprintf(pid_str, "%d", pid);
> -
> -	/* 1 stands for the "-" character */
> -	len = strlen(comm) + strlen(pid_str) + 1;
> -
> -	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
> -		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
> -
> -	/* First spaces to align center */
> -	for (i = 0; i < spaces / 2; i++)
> -		printf(" ");
> -
> -	printf("%s-%s", comm, pid_str);
> -
> -	/* Last spaces to align center */
> -	for (i = 0; i < spaces - (spaces / 2); i++)
> -		printf(" ");
> -}
> -
> -static struct record *
> -get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
> -		    struct record *next)
> -{
> -	struct format_field *field;
> -	struct event *event;
> -	unsigned long val;
> -	int type;
> -	int pid;
> -
> -	type = trace_parse_common_type(next->data);
> -	event = trace_find_event(type);
> -	if (!event)
> -		return NULL;
> -
> -	if (!(event->flags & EVENT_FL_ISFUNCRET))
> -		return NULL;
> -
> -	pid = trace_parse_common_pid(next->data);
> -	field = find_field(event, "func");
> -	if (!field)
> -		die("function return does not have field func");
> -
> -	val = read_size(next->data + field->offset, field->size);
> -
> -	if (cur_pid != pid || cur_func != val)
> -		return NULL;
> -
> -	/* this is a leaf, now advance the iterator */
> -	return trace_read_data(cpu);
> -}
> -
> -/* Signal a overhead of time execution to the output */
> -static void print_graph_overhead(unsigned long long duration)
> -{
> -	/* Non nested entry or return */
> -	if (duration == ~0ULL)
> -		return (void)printf("  ");
> -
> -	/* Duration exceeded 100 msecs */
> -	if (duration > 100000ULL)
> -		return (void)printf("! ");
> -
> -	/* Duration exceeded 10 msecs */
> -	if (duration > 10000ULL)
> -		return (void)printf("+ ");
> -
> -	printf("  ");
> -}
> -
> -static void print_graph_duration(unsigned long long duration)
> -{
> -	unsigned long usecs = duration / 1000;
> -	unsigned long nsecs_rem = duration % 1000;
> -	/* log10(ULONG_MAX) + '\0' */
> -	char msecs_str[21];
> -	char nsecs_str[5];
> -	int len;
> -	int i;
> -
> -	sprintf(msecs_str, "%lu", usecs);
> -
> -	/* Print msecs */
> -	len = printf("%lu", usecs);
> -
> -	/* Print nsecs (we don't want to exceed 7 numbers) */
> -	if (len < 7) {
> -		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
> -		len += printf(".%s", nsecs_str);
> -	}
> -
> -	printf(" us ");
> -
> -	/* Print remaining spaces to fit the row's width */
> -	for (i = len; i < 7; i++)
> -		printf(" ");
> -
> -	printf("|  ");
> -}
> -
> -static void
> -print_graph_entry_leaf(struct event *event, void *data, struct record *ret_rec)
> -{
> -	unsigned long long rettime, calltime;
> -	unsigned long long duration, depth;
> -	unsigned long long val;
> -	struct format_field *field;
> -	struct func_map *func;
> -	struct event *ret_event;
> -	int type;
> -	int i;
> -
> -	type = trace_parse_common_type(ret_rec->data);
> -	ret_event = trace_find_event(type);
> -
> -	field = find_field(ret_event, "rettime");
> -	if (!field)
> -		die("can't find rettime in return graph");
> -	rettime = read_size(ret_rec->data + field->offset, field->size);
> -
> -	field = find_field(ret_event, "calltime");
> -	if (!field)
> -		die("can't find rettime in return graph");
> -	calltime = read_size(ret_rec->data + field->offset, field->size);
> -
> -	duration = rettime - calltime;
> -
> -	/* Overhead */
> -	print_graph_overhead(duration);
> -
> -	/* Duration */
> -	print_graph_duration(duration);
> -
> -	field = find_field(event, "depth");
> -	if (!field)
> -		die("can't find depth in entry graph");
> -	depth = read_size(data + field->offset, field->size);
> -
> -	/* Function */
> -	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
> -		printf(" ");
> -
> -	field = find_field(event, "func");
> -	if (!field)
> -		die("can't find func in entry graph");
> -	val = read_size(data + field->offset, field->size);
> -	func = find_func(val);
> -
> -	if (func)
> -		printf("%s();", func->func);
> -	else
> -		printf("%llx();", val);
> -}
> -
> -static void print_graph_nested(struct event *event, void *data)
> -{
> -	struct format_field *field;
> -	unsigned long long depth;
> -	unsigned long long val;
> -	struct func_map *func;
> -	int i;
> -
> -	/* No overhead */
> -	print_graph_overhead(-1);
> -
> -	/* No time */
> -	printf("           |  ");
> -
> -	field = find_field(event, "depth");
> -	if (!field)
> -		die("can't find depth in entry graph");
> -	depth = read_size(data + field->offset, field->size);
> -
> -	/* Function */
> -	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
> -		printf(" ");
> -
> -	field = find_field(event, "func");
> -	if (!field)
> -		die("can't find func in entry graph");
> -	val = read_size(data + field->offset, field->size);
> -	func = find_func(val);
> -
> -	if (func)
> -		printf("%s() {", func->func);
> -	else
> -		printf("%llx() {", val);
> -}
> -
> -static void
> -pretty_print_func_ent(void *data, int size, struct event *event,
> -		      int cpu, int pid, const char *comm,
> -		      unsigned long secs, unsigned long usecs)
> -{
> -	struct format_field *field;
> -	struct record *rec;
> -	void *copy_data;
> -	unsigned long val;
> -
> -	printf("%5lu.%06lu |  ", secs, usecs);
> -
> -	print_graph_cpu(cpu);
> -	print_graph_proc(pid, comm);
> -
> -	printf(" | ");
> -
> -	if (latency_format) {
> -		print_lat_fmt(data, size);
> -		printf(" | ");
> -	}
> -
> -	field = find_field(event, "func");
> -	if (!field)
> -		die("function entry does not have func field");
> -
> -	val = read_size(data + field->offset, field->size);
> -
> -	/*
> -	 * peek_data may unmap the data pointer. Copy it first.
> -	 */
> -	copy_data = malloc_or_die(size);
> -	memcpy(copy_data, data, size);
> -	data = copy_data;
> -
> -	rec = trace_peek_data(cpu);
> -	if (rec) {
> -		rec = get_return_for_leaf(cpu, pid, val, rec);
> -		if (rec) {
> -			print_graph_entry_leaf(event, data, rec);
> -			goto out_free;
> -		}
> -	}
> -	print_graph_nested(event, data);
> -out_free:
> -	free(data);
> -}
> -
> -static void
> -pretty_print_func_ret(void *data, int size __unused, struct event *event,
> -		      int cpu, int pid, const char *comm,
> -		      unsigned long secs, unsigned long usecs)
> -{
> -	unsigned long long rettime, calltime;
> -	unsigned long long duration, depth;
> -	struct format_field *field;
> -	int i;
> -
> -	printf("%5lu.%06lu |  ", secs, usecs);
> -
> -	print_graph_cpu(cpu);
> -	print_graph_proc(pid, comm);
> -
> -	printf(" | ");
> -
> -	if (latency_format) {
> -		print_lat_fmt(data, size);
> -		printf(" | ");
> -	}
> -
> -	field = find_field(event, "rettime");
> -	if (!field)
> -		die("can't find rettime in return graph");
> -	rettime = read_size(data + field->offset, field->size);
> -
> -	field = find_field(event, "calltime");
> -	if (!field)
> -		die("can't find calltime in return graph");
> -	calltime = read_size(data + field->offset, field->size);
> -
> -	duration = rettime - calltime;
> -
> -	/* Overhead */
> -	print_graph_overhead(duration);
> -
> -	/* Duration */
> -	print_graph_duration(duration);
> -
> -	field = find_field(event, "depth");
> -	if (!field)
> -		die("can't find depth in entry graph");
> -	depth = read_size(data + field->offset, field->size);
> -
> -	/* Function */
> -	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
> -		printf(" ");
> -
> -	printf("}");
> -}
> -
> -static void
> -pretty_print_func_graph(void *data, int size, struct event *event,
> -			int cpu, int pid, const char *comm,
> -			unsigned long secs, unsigned long usecs)
> -{
> -	if (event->flags & EVENT_FL_ISFUNCENT)
> -		pretty_print_func_ent(data, size, event,
> -				      cpu, pid, comm, secs, usecs);
> -	else if (event->flags & EVENT_FL_ISFUNCRET)
> -		pretty_print_func_ret(data, size, event,
> -				      cpu, pid, comm, secs, usecs);
> -	printf("\n");
> -}
> -
> -void print_event(int cpu, void *data, int size, unsigned long long nsecs,
> -		  char *comm)
> -{
> -	struct event *event;
> -	unsigned long secs;
> -	unsigned long usecs;
> -	int type;
> -	int pid;
> -
> -	secs = nsecs / NSECS_PER_SEC;
> -	nsecs -= secs * NSECS_PER_SEC;
> -	usecs = nsecs / NSECS_PER_USEC;
> -
> -	type = trace_parse_common_type(data);
> -
> -	event = trace_find_event(type);
> -	if (!event) {
> -		warning("ug! no event found for type %d", type);
> -		return;
> -	}
> -
> -	pid = trace_parse_common_pid(data);
> -
> -	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
> -		return pretty_print_func_graph(data, size, event, cpu,
> -					       pid, comm, secs, usecs);
> -
> -	if (latency_format) {
> -		printf("%8.8s-%-5d %3d",
> -		       comm, pid, cpu);
> -		print_lat_fmt(data, size);
> -	} else
> -		printf("%16s-%-5d [%03d]", comm, pid,  cpu);
> -
> -	printf(" %5lu.%06lu: %s: ", secs, usecs, event->name);
> -
> -	if (event->flags & EVENT_FL_FAILED) {
> -		printf("EVENT '%s' FAILED TO PARSE\n",
> -		       event->name);
> -		return;
> -	}
> -
> -	pretty_print(data, size, event);
> -	printf("\n");
> -}
> -
> -static void print_fields(struct print_flag_sym *field)
> -{
> -	printf("{ %s, %s }", field->value, field->str);
> -	if (field->next) {
> -		printf(", ");
> -		print_fields(field->next);
> -	}
> -}
> -
> -static void print_args(struct print_arg *args)
> -{
> -	int print_paren = 1;
> -
> -	switch (args->type) {
> -	case PRINT_NULL:
> -		printf("null");
> -		break;
> -	case PRINT_ATOM:
> -		printf("%s", args->atom.atom);
> -		break;
> -	case PRINT_FIELD:
> -		printf("REC->%s", args->field.name);
> -		break;
> -	case PRINT_FLAGS:
> -		printf("__print_flags(");
> -		print_args(args->flags.field);
> -		printf(", %s, ", args->flags.delim);
> -		print_fields(args->flags.flags);
> -		printf(")");
> -		break;
> -	case PRINT_SYMBOL:
> -		printf("__print_symbolic(");
> -		print_args(args->symbol.field);
> -		printf(", ");
> -		print_fields(args->symbol.symbols);
> -		printf(")");
> -		break;
> -	case PRINT_STRING:
> -		printf("__get_str(%s)", args->string.string);
> -		break;
> -	case PRINT_TYPE:
> -		printf("(%s)", args->typecast.type);
> -		print_args(args->typecast.item);
> -		break;
> -	case PRINT_OP:
> -		if (strcmp(args->op.op, ":") == 0)
> -			print_paren = 0;
> -		if (print_paren)
> -			printf("(");
> -		print_args(args->op.left);
> -		printf(" %s ", args->op.op);
> -		print_args(args->op.right);
> -		if (print_paren)
> -			printf(")");
> -		break;
> -	default:
> -		/* we should warn... */
> -		return;
> -	}
> -	if (args->next) {
> -		printf("\n");
> -		print_args(args->next);
> -	}
> -}
> -
> -int parse_ftrace_file(char *buf, unsigned long size)
> -{
> -	struct format_field *field;
> -	struct print_arg *arg, **list;
> -	struct event *event;
> -	int ret;
> -
> -	init_input_buf(buf, size);
> -
> -	event = alloc_event();
> -	if (!event)
> -		return -ENOMEM;
> -
> -	event->flags |= EVENT_FL_ISFTRACE;
> -
> -	event->name = event_read_name();
> -	if (!event->name)
> -		die("failed to read ftrace event name");
> -
> -	if (strcmp(event->name, "function") == 0)
> -		event->flags |= EVENT_FL_ISFUNC;
> -
> -	else if (strcmp(event->name, "funcgraph_entry") == 0)
> -		event->flags |= EVENT_FL_ISFUNCENT;
> -
> -	else if (strcmp(event->name, "funcgraph_exit") == 0)
> -		event->flags |= EVENT_FL_ISFUNCRET;
> -
> -	else if (strcmp(event->name, "bprint") == 0)
> -		event->flags |= EVENT_FL_ISBPRINT;
> -
> -	event->id = event_read_id();
> -	if (event->id < 0)
> -		die("failed to read ftrace event id");
> -
> -	add_event(event);
> -
> -	ret = event_read_format(event);
> -	if (ret < 0)
> -		die("failed to read ftrace event format");
> -
> -	ret = event_read_print(event);
> -	if (ret < 0)
> -		die("failed to read ftrace event print fmt");
> -
> -	/* New ftrace handles args */
> -	if (ret > 0)
> -		return 0;
> -	/*
> -	 * The arguments for ftrace files are parsed by the fields.
> -	 * Set up the fields as their arguments.
> -	 */
> -	list = &event->print_fmt.args;
> -	for (field = event->format.fields; field; field = field->next) {
> -		arg = malloc_or_die(sizeof(*arg));
> -		memset(arg, 0, sizeof(*arg));
> -		*list = arg;
> -		list = &arg->next;
> -		arg->type = PRINT_FIELD;
> -		arg->field.name = field->name;
> -		arg->field.field = field;
> -	}
> -	return 0;
> -}
> -
> -int parse_event_file(char *buf, unsigned long size, char *sys)
> -{
> -	struct event *event;
> -	int ret;
> -
> -	init_input_buf(buf, size);
> -
> -	event = alloc_event();
> -	if (!event)
> -		return -ENOMEM;
> -
> -	event->name = event_read_name();
> -	if (!event->name)
> -		die("failed to read event name");
> -
> -	event->id = event_read_id();
> -	if (event->id < 0)
> -		die("failed to read event id");
> -
> -	ret = event_read_format(event);
> -	if (ret < 0) {
> -		warning("failed to read event format for %s", event->name);
> -		goto event_failed;
> -	}
> -
> -	ret = event_read_print(event);
> -	if (ret < 0) {
> -		warning("failed to read event print fmt for %s", event->name);
> -		goto event_failed;
> -	}
> -
> -	event->system = strdup(sys);
> -
> -#define PRINT_ARGS 0
> -	if (PRINT_ARGS && event->print_fmt.args)
> -		print_args(event->print_fmt.args);
> -
> -	add_event(event);
> -	return 0;
> -
> - event_failed:
> -	event->flags |= EVENT_FL_FAILED;
> -	/* still add it even if it failed */
> -	add_event(event);
> -	return -1;
> -}
> -
> -void parse_set_info(int nr_cpus, int long_sz)
> -{
> -	cpus = nr_cpus;
> -	long_size = long_sz;
> -}
> -
> -int common_pc(struct scripting_context *context)
> -{
> -	return parse_common_pc(context->event_data);
> -}
> -
> -int common_flags(struct scripting_context *context)
> -{
> -	return parse_common_flags(context->event_data);
> -}
> -
> -int common_lock_depth(struct scripting_context *context)
> -{
> -	return parse_common_lock_depth(context->event_data);
> -}
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> deleted file mode 100644
> index 2583227..0000000
> --- a/tools/perf/util/trace-event-read.c
> +++ /dev/null
> @@ -1,539 +0,0 @@
> -/*
> - * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
> - *
> - * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; version 2 of the License (not later!)
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - *
> - * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> - */
> -#define _FILE_OFFSET_BITS 64
> -
> -#include <dirent.h>
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <string.h>
> -#include <getopt.h>
> -#include <stdarg.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <sys/wait.h>
> -#include <sys/mman.h>
> -#include <pthread.h>
> -#include <fcntl.h>
> -#include <unistd.h>
> -#include <ctype.h>
> -#include <errno.h>
> -
> -#include "../perf.h"
> -#include <lk/util.h>
> -#include "trace-event.h"
> -
> -static int input_fd;
> -
> -static int read_page;
> -
> -int file_bigendian;
> -int host_bigendian;
> -static int long_size;
> -
> -static unsigned long	page_size;
> -
> -static ssize_t calc_data_size;
> -static bool repipe;
> -
> -static int do_read(int fd, void *buf, int size)
> -{
> -	int rsize = size;
> -
> -	while (size) {
> -		int ret = read(fd, buf, size);
> -
> -		if (ret <= 0)
> -			return -1;
> -
> -		if (repipe) {
> -			int retw = write(STDOUT_FILENO, buf, ret);
> -
> -			if (retw <= 0 || retw != ret)
> -				die("repiping input file");
> -		}
> -
> -		size -= ret;
> -		buf += ret;
> -	}
> -
> -	return rsize;
> -}
> -
> -static int read_or_die(void *data, int size)
> -{
> -	int r;
> -
> -	r = do_read(input_fd, data, size);
> -	if (r <= 0)
> -		die("reading input file (size expected=%d received=%d)",
> -		    size, r);
> -
> -	if (calc_data_size)
> -		calc_data_size += r;
> -
> -	return r;
> -}
> -
> -/* If it fails, the next read will report it */
> -static void skip(int size)
> -{
> -	char buf[BUFSIZ];
> -	int r;
> -
> -	while (size) {
> -		r = size > BUFSIZ ? BUFSIZ : size;
> -		read_or_die(buf, r);
> -		size -= r;
> -	};
> -}
> -
> -static unsigned int read4(void)
> -{
> -	unsigned int data;
> -
> -	read_or_die(&data, 4);
> -	return __data2host4(data);
> -}
> -
> -static unsigned long long read8(void)
> -{
> -	unsigned long long data;
> -
> -	read_or_die(&data, 8);
> -	return __data2host8(data);
> -}
> -
> -static char *read_string(void)
> -{
> -	char buf[BUFSIZ];
> -	char *str = NULL;
> -	int size = 0;
> -	off_t r;
> -	char c;
> -
> -	for (;;) {
> -		r = read(input_fd, &c, 1);
> -		if (r < 0)
> -			die("reading input file");
> -
> -		if (!r)
> -			die("no data");
> -
> -		if (repipe) {
> -			int retw = write(STDOUT_FILENO, &c, 1);
> -
> -			if (retw <= 0 || retw != r)
> -				die("repiping input file string");
> -		}
> -
> -		buf[size++] = c;
> -
> -		if (!c)
> -			break;
> -	}
> -
> -	if (calc_data_size)
> -		calc_data_size += size;
> -
> -	str = malloc_or_die(size);
> -	memcpy(str, buf, size);
> -
> -	return str;
> -}
> -
> -static void read_proc_kallsyms(void)
> -{
> -	unsigned int size;
> -	char *buf;
> -
> -	size = read4();
> -	if (!size)
> -		return;
> -
> -	buf = malloc_or_die(size + 1);
> -	read_or_die(buf, size);
> -	buf[size] = '\0';
> -
> -	parse_proc_kallsyms(buf, size);
> -
> -	free(buf);
> -}
> -
> -static void read_ftrace_printk(void)
> -{
> -	unsigned int size;
> -	char *buf;
> -
> -	size = read4();
> -	if (!size)
> -		return;
> -
> -	buf = malloc_or_die(size);
> -	read_or_die(buf, size);
> -
> -	parse_ftrace_printk(buf, size);
> -
> -	free(buf);
> -}
> -
> -static void read_header_files(void)
> -{
> -	unsigned long long size;
> -	char *header_event;
> -	char buf[BUFSIZ];
> -
> -	read_or_die(buf, 12);
> -
> -	if (memcmp(buf, "header_page", 12) != 0)
> -		die("did not read header page");
> -
> -	size = read8();
> -	skip(size);
> -
> -	/*
> -	 * The size field in the page is of type long,
> -	 * use that instead, since it represents the kernel.
> -	 */
> -	long_size = header_page_size_size;
> -
> -	read_or_die(buf, 13);
> -	if (memcmp(buf, "header_event", 13) != 0)
> -		die("did not read header event");
> -
> -	size = read8();
> -	header_event = malloc_or_die(size);
> -	read_or_die(header_event, size);
> -	free(header_event);
> -}
> -
> -static void read_ftrace_file(unsigned long long size)
> -{
> -	char *buf;
> -
> -	buf = malloc_or_die(size);
> -	read_or_die(buf, size);
> -	parse_ftrace_file(buf, size);
> -	free(buf);
> -}
> -
> -static void read_event_file(char *sys, unsigned long long size)
> -{
> -	char *buf;
> -
> -	buf = malloc_or_die(size);
> -	read_or_die(buf, size);
> -	parse_event_file(buf, size, sys);
> -	free(buf);
> -}
> -
> -static void read_ftrace_files(void)
> -{
> -	unsigned long long size;
> -	int count;
> -	int i;
> -
> -	count = read4();
> -
> -	for (i = 0; i < count; i++) {
> -		size = read8();
> -		read_ftrace_file(size);
> -	}
> -}
> -
> -static void read_event_files(void)
> -{
> -	unsigned long long size;
> -	char *sys;
> -	int systems;
> -	int count;
> -	int i,x;
> -
> -	systems = read4();
> -
> -	for (i = 0; i < systems; i++) {
> -		sys = read_string();
> -
> -		count = read4();
> -		for (x=0; x < count; x++) {
> -			size = read8();
> -			read_event_file(sys, size);
> -		}
> -	}
> -}
> -
> -struct cpu_data {
> -	unsigned long long	offset;
> -	unsigned long long	size;
> -	unsigned long long	timestamp;
> -	struct record		*next;
> -	char			*page;
> -	int			cpu;
> -	int			index;
> -	int			page_size;
> -};
> -
> -static struct cpu_data *cpu_data;
> -
> -static void update_cpu_data_index(int cpu)
> -{
> -	cpu_data[cpu].offset += page_size;
> -	cpu_data[cpu].size -= page_size;
> -	cpu_data[cpu].index = 0;
> -}
> -
> -static void get_next_page(int cpu)
> -{
> -	off_t save_seek;
> -	off_t ret;
> -
> -	if (!cpu_data[cpu].page)
> -		return;
> -
> -	if (read_page) {
> -		if (cpu_data[cpu].size <= page_size) {
> -			free(cpu_data[cpu].page);
> -			cpu_data[cpu].page = NULL;
> -			return;
> -		}
> -
> -		update_cpu_data_index(cpu);
> -
> -		/* other parts of the code may expect the pointer to not move */
> -		save_seek = lseek(input_fd, 0, SEEK_CUR);
> -
> -		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
> -		if (ret == (off_t)-1)
> -			die("failed to lseek");
> -		ret = read(input_fd, cpu_data[cpu].page, page_size);
> -		if (ret < 0)
> -			die("failed to read page");
> -
> -		/* reset the file pointer back */
> -		lseek(input_fd, save_seek, SEEK_SET);
> -
> -		return;
> -	}
> -
> -	munmap(cpu_data[cpu].page, page_size);
> -	cpu_data[cpu].page = NULL;
> -
> -	if (cpu_data[cpu].size <= page_size)
> -		return;
> -
> -	update_cpu_data_index(cpu);
> -
> -	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
> -				  input_fd, cpu_data[cpu].offset);
> -	if (cpu_data[cpu].page == MAP_FAILED)
> -		die("failed to mmap cpu %d at offset 0x%llx",
> -		    cpu, cpu_data[cpu].offset);
> -}
> -
> -static unsigned int type_len4host(unsigned int type_len_ts)
> -{
> -	if (file_bigendian)
> -		return (type_len_ts >> 27) & ((1 << 5) - 1);
> -	else
> -		return type_len_ts & ((1 << 5) - 1);
> -}
> -
> -static unsigned int ts4host(unsigned int type_len_ts)
> -{
> -	if (file_bigendian)
> -		return type_len_ts & ((1 << 27) - 1);
> -	else
> -		return type_len_ts >> 5;
> -}
> -
> -static int calc_index(void *ptr, int cpu)
> -{
> -	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
> -}
> -
> -struct record *trace_peek_data(int cpu)
> -{
> -	struct record *data;
> -	void *page = cpu_data[cpu].page;
> -	int idx = cpu_data[cpu].index;
> -	void *ptr = page + idx;
> -	unsigned long long extend;
> -	unsigned int type_len_ts;
> -	unsigned int type_len;
> -	unsigned int delta;
> -	unsigned int length = 0;
> -
> -	if (cpu_data[cpu].next)
> -		return cpu_data[cpu].next;
> -
> -	if (!page)
> -		return NULL;
> -
> -	if (!idx) {
> -		/* FIXME: handle header page */
> -		if (header_page_ts_size != 8)
> -			die("expected a long long type for timestamp");
> -		cpu_data[cpu].timestamp = data2host8(ptr);
> -		ptr += 8;
> -		switch (header_page_size_size) {
> -		case 4:
> -			cpu_data[cpu].page_size = data2host4(ptr);
> -			ptr += 4;
> -			break;
> -		case 8:
> -			cpu_data[cpu].page_size = data2host8(ptr);
> -			ptr += 8;
> -			break;
> -		default:
> -			die("bad long size");
> -		}
> -		ptr = cpu_data[cpu].page + header_page_data_offset;
> -	}
> -
> -read_again:
> -	idx = calc_index(ptr, cpu);
> -
> -	if (idx >= cpu_data[cpu].page_size) {
> -		get_next_page(cpu);
> -		return trace_peek_data(cpu);
> -	}
> -
> -	type_len_ts = data2host4(ptr);
> -	ptr += 4;
> -
> -	type_len = type_len4host(type_len_ts);
> -	delta = ts4host(type_len_ts);
> -
> -	switch (type_len) {
> -	case RINGBUF_TYPE_PADDING:
> -		if (!delta)
> -			die("error, hit unexpected end of page");
> -		length = data2host4(ptr);
> -		ptr += 4;
> -		length *= 4;
> -		ptr += length;
> -		goto read_again;
> -
> -	case RINGBUF_TYPE_TIME_EXTEND:
> -		extend = data2host4(ptr);
> -		ptr += 4;
> -		extend <<= TS_SHIFT;
> -		extend += delta;
> -		cpu_data[cpu].timestamp += extend;
> -		goto read_again;
> -
> -	case RINGBUF_TYPE_TIME_STAMP:
> -		ptr += 12;
> -		break;
> -	case 0:
> -		length = data2host4(ptr);
> -		ptr += 4;
> -		die("here! length=%d", length);
> -		break;
> -	default:
> -		length = type_len * 4;
> -		break;
> -	}
> -
> -	cpu_data[cpu].timestamp += delta;
> -
> -	data = malloc_or_die(sizeof(*data));
> -	memset(data, 0, sizeof(*data));
> -
> -	data->ts = cpu_data[cpu].timestamp;
> -	data->size = length;
> -	data->data = ptr;
> -	ptr += length;
> -
> -	cpu_data[cpu].index = calc_index(ptr, cpu);
> -	cpu_data[cpu].next = data;
> -
> -	return data;
> -}
> -
> -struct record *trace_read_data(int cpu)
> -{
> -	struct record *data;
> -
> -	data = trace_peek_data(cpu);
> -	cpu_data[cpu].next = NULL;
> -
> -	return data;
> -}
> -
> -ssize_t trace_report(int fd, bool __repipe)
> -{
> -	char buf[BUFSIZ];
> -	char test[] = { 23, 8, 68 };
> -	char *version;
> -	int show_version = 0;
> -	int show_funcs = 0;
> -	int show_printk = 0;
> -	ssize_t size;
> -
> -	calc_data_size = 1;
> -	repipe = __repipe;
> -
> -	input_fd = fd;
> -
> -	read_or_die(buf, 3);
> -	if (memcmp(buf, test, 3) != 0)
> -		die("no trace data in the file");
> -
> -	read_or_die(buf, 7);
> -	if (memcmp(buf, "tracing", 7) != 0)
> -		die("not a trace file (missing 'tracing' tag)");
> -
> -	version = read_string();
> -	if (show_version)
> -		printf("version = %s\n", version);
> -	free(version);
> -
> -	read_or_die(buf, 1);
> -	file_bigendian = buf[0];
> -	host_bigendian = bigendian();
> -
> -	read_or_die(buf, 1);
> -	long_size = buf[0];
> -
> -	page_size = read4();
> -
> -	read_header_files();
> -
> -	read_ftrace_files();
> -	read_event_files();
> -	read_proc_kallsyms();
> -	read_ftrace_printk();
> -
> -	size = calc_data_size - 1;
> -	calc_data_size = 0;
> -	repipe = false;
> -
> -	if (show_funcs) {
> -		print_funcs();
> -		return size;
> -	}
> -	if (show_printk) {
> -		print_printk();
> -		return size;
> -	}
> -
> -	return size;
> -}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


