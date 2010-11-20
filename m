Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0KTAV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:21:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40057 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751340Ab0KTAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:21:55 -0500
Date: Fri, 19 Nov 2010 19:21:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC] lttngtrace available to non-root
Message-ID: <20101120002152.GA12529@Krystal>
References: <20101119222112.GA32294@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119222112.GA32294@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:17:18 up 58 days,  4:19,  3 users,  load average: 0.30, 0.18,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an updated version taking care of /tmp file creation races. Thanks to
Frank Ch. Eigler for pointing this out.

A small note: pending a large change in LTTng that will allow arming tracepoints
on a per-session basis, the current version of the script cannot be run in
multiple instances concurrently (interaction between the multiple
ltt-armall/ltt-disarmall). I'm also thinking to use mktemp for the next version
to create a temporary file rather than the hardcoded file I'm using now. I could
save the information about the last file name used in the user's home directory.

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

	ret = recunlink("/tmp/autotrace1");
	if (ret)
		return ret;
	ret = unlink("/tmp/autotrace1-pid");
	if (ret)
		return ret;

	/*
	 * Create the directory in /tmp to deal with races (refuse if fail).
	 * Only allow user and group to read the trace data (to limit
	 * information disclosure).
	 */
	ret = mkdir("/tmp/autotrace1", S_IRWXU|S_IRWXG);
	if (ret) {
		perror("Trace directory creation race");
		return ret;
	}
	ret = system("ltt-armall > /dev/null");
	if (ret)
		return ret;
	ret = system("lttctl -C -w /tmp/autotrace1 autotrace1 > /dev/null");
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
	printf("uid: %d egid %d\n", uid, egid);
	ret = chown("/tmp/autotrace1", uid, egid);
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
	fd = open("/tmp/autotrace1-pid", O_WRONLY | O_CREAT | O_EXCL | O_TRUNC,
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
	ret = chown("/tmp/autotrace1-pid", uid, gid);
	if (ret)
		perror("chown error");
	return ret;
}

int main(int argc, char *argv[])
{
	uid_t euid, uid;
	gid_t egid, gid;
	pid_t pid;
	int gret = 0, ret = 0;

	if (argc < 2)
		return -ENOENT;

	euid = geteuid();
	uid = getuid();
	egid = getegid();
	gid = geteuid();

	if (euid != 0) {
		printf("%s must be setuid root\n", argv[0]);
		return -EPERM;
	}

	printf_dbg("euid: %d\n", euid);
	printf_dbg("uid: %d\n", uid);
	printf_dbg("egid: %d\n", egid);
	printf_dbg("gid: %d\n", gid);

	ret = start_tracing();
	gret = (gret == 0) ? ret : gret;

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
		ret = execvp(argv[1], &argv[1]);
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
