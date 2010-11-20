Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0KTOYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 09:24:00 -0500
Received: from mail.openrapids.net ([64.15.138.104]:50247 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751781Ab0KTOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 09:23:59 -0500
Date: Sat, 20 Nov 2010 09:23:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC] lttngtrace available to non-root (-o option)
Message-ID: <20101120142354.GA16996@Krystal>
References: <20101119222112.GA32294@Krystal> <20101120002152.GA12529@Krystal> <20101120002823.GA22308@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120002823.GA22308@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:21:05 up 58 days, 18:23,  3 users,  load average: 0.26, 0.21,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Due to popular demand, I added a "-o" option to let the user specify the trace
file name. If the directory/file specified with -o already exist, it just fails
without unlinking. Now I put the "pid" file under the trace directory.

Thanks,

Mathieu

/*
 * lttngtrace.c
 *
 * lttngtrace starts/stop system wide tracing around program execution.
 *
 * Copyright (c) 2010 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * This file should be setuid root, and belong to a "tracing" group. Only users
 * part of the tracing group can trace and view the traces gathered.
 *
 * TODO: LTTng should support per-session tracepoint activation.
 * TODO: use mkstemp() and save last trace name in user's home directory.
 */

#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <dirent.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/types.h>

#if DEBUG
#define printf_dbg(fmt, args...)	printf(fmt, args)
#else
#define printf_dbg(fmt, ...)
#endif

static char *trace_path;
static char trace_path_pid[PATH_MAX];
static int autotrace;	/*
			 * Is the trace_path automatically chosen in /tmp ? Can
			 * we unlink if needed ?
			 */

int recunlink(const char *dirname)
{
	DIR *dir;
	struct dirent *entry;
	char path[PATH_MAX];

	dir = opendir(dirname);
	if (dir == NULL) {
		if (errno == ENOENT)
			return 0;
		perror("Error opendir()");
		return -errno;
	}

	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") && strcmp(entry->d_name, "..")) {
			snprintf(path, (size_t) PATH_MAX, "%s/%s", dirname,
				 entry->d_name);
			if (entry->d_type == DT_DIR)
				recunlink(path);
			else
				unlink(path);
		}
	}
	closedir(dir);
	rmdir(dirname);

	return 0;
}

int start_tracing(void)
{
	int ret;
	char command[PATH_MAX];

	if (autotrace) {
		ret = recunlink(trace_path);
		if (ret)
			return ret;
	}

	/*
	 * Create the directory in /tmp to deal with races (refuse if fail).
	 * Only allow user and group to read the trace data (to limit
	 * information disclosure).
	 */
	ret = mkdir(trace_path, S_IRWXU|S_IRWXG);
	if (ret) {
		perror("Trace directory creation error");
		return ret;
	}
	ret = system("ltt-armall > /dev/null");
	if (ret)
		return ret;

	ret = snprintf(command, PATH_MAX - 1,
		       "lttctl -C -w %s autotrace1 > /dev/null",
		       trace_path);
	ret = ret < 0 ? ret : 0;
	if (ret)
		return ret;
	ret = system(command);
	if (ret)
		return ret;
}

int stop_tracing(uid_t uid, gid_t egid)
{
	int ret;

	ret = system("lttctl -D autotrace1 > /dev/null");
	if (ret)
		return ret;
	ret = system("ltt-disarmall > /dev/null");
	if (ret)
		return ret;
	/* Hand the trace back to the user after tracing is over */
	ret = chown(trace_path, uid, egid);
	if (ret) {
		perror("chown error");
		return ret;
	}
}

int write_child_pid(pid_t pid, uid_t uid, gid_t gid)
{
	int fd;
	FILE *fp;
	int ret;

	/* Create the file as exclusive to deal with /tmp file creation races */
	fd = open(trace_path_pid, O_WRONLY | O_CREAT | O_EXCL | O_TRUNC,
		  S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
	fp = fdopen(fd, "w");
	if (!fp) {
		perror("Error writing child pid");
		return -errno;
	}
	
	fprintf(fp, "%u", (unsigned int) pid);
	ret = fclose(fp);
	if (ret)
		perror("Error in fclose");
	/* Hand pid information file back to user */
	ret = chown(trace_path_pid, uid, gid);
	if (ret)
		perror("chown error");
	return ret;
}

int parse_options(int argc, char *argv[], int *arg)
{
	int ret = 0;

	for (;;) {
		if (*arg >= argc
		    || argv[*arg][0] != '-'
		    || argv[*arg][0] == '\0'
		    || argv[*arg][1] == '\0'
		    || !strcmp(argv[*arg], "--"))
			break;
		switch (argv[*arg][1]) {
		case 'o':	if (*arg + 1 >= argc) {
					printf("Missing -o trace name\n");
					ret = -EINVAL;
					break;
				}
				trace_path = argv[*arg + 1];
				(*arg) += 2;
				break;
		default:	printf("Unknown option -%c\n", argv[*arg][1]);
				ret = -EINVAL;
				return ret;
		}
	}
	return ret;
}

int set_trace_path(void)
{
	int ret;

	if (!trace_path) {
		trace_path = "/tmp/autotrace1";
		autotrace = 1;
	}
	ret = snprintf(trace_path_pid, PATH_MAX - 1, "%s/%s",
		       trace_path, "pid");
	ret = ret < 0 ? ret : 0;
	return ret;
}

int main(int argc, char *argv[])
{
	uid_t euid, uid;
	gid_t egid, gid;
	pid_t pid;
	int gret = 0, ret = 0;
	int arg = 1;

	if (argc < 2)
		return -ENOENT;

	euid = geteuid();
	uid = getuid();
	egid = getegid();
	gid = geteuid();

	if (euid != 0 && uid != 0) {
		printf("%s must be setuid root\n", argv[0]);
		return -EPERM;
	}

	printf_dbg("euid: %d\n", euid);
	printf_dbg("uid: %d\n", uid);
	printf_dbg("egid: %d\n", egid);
	printf_dbg("gid: %d\n", gid);

	if (arg < argc) {
		ret = parse_options(argc, argv, &arg);
		if (ret)
			return ret;
	}

	ret = set_trace_path();
	gret = (gret == 0) ? ret : gret;

	ret = start_tracing();
	if (ret)
		return ret;

	pid = fork();
	if (pid > 0) {		/* parent */
		int status;

		pid = wait(&status);
		if (pid == -1)
			gret = (gret == 0) ? -errno : gret;

		ret = stop_tracing(uid, egid);
		gret = (gret == 0) ? ret : gret;
		ret = write_child_pid(pid, uid, egid);
		gret = (gret == 0) ? ret : gret;
	} else if (pid == 0) {	/* child */
		/* Drop root euid before executing child program */
		seteuid(uid);
		ret = execvp(argv[arg], &argv[arg]);
		if (ret)
			perror("Execution error");
		return ret;
	} else {		/* error */
		perror("Error in fork");
		return -errno;
	}
	return ret;
}

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
