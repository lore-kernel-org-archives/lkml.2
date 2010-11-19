Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab0KSWVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:21:37 -0500
Received: from mail.openrapids.net ([64.15.138.104]:58309 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757900Ab0KSWVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:21:15 -0500
Date: Fri, 19 Nov 2010 17:21:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RFC] lttngtrace available to non-root
Message-ID: <20101119222112.GA32294@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:15:49 up 58 days,  2:18,  1 user,  load average: 0.04, 0.08,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I just coded a lttngtrace.c program that can spawn a thread from a non-root
user. The idea is to have "lttngtrace" setuid root, executable only by the
"tracing" group. Within lttngtrace, I set the euid and egid back to the original
caller user before executing the command.

I plan to integrate this with the UST userspace tracer as soon as Nils comes
back from vacation and release a new version.

Comments are welcome,

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
 */

#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <dirent.h>

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

	ret = system("ltt-armall > /dev/null");
	if (ret)
		return ret;
	ret = system("lttctl -C -w /tmp/autotrace1 autotrace1 > /dev/null");
	if (ret)
		return ret;
}

int stop_tracing(void)
{
	int ret;

	ret = system("lttctl -D autotrace1 > /dev/null");
	if (ret)
		return ret;
	ret = system("ltt-disarmall > /dev/null");
	if (ret)
		return ret;
}

int write_child_pid(pid_t pid)
{
	FILE *fp;

	fp = fopen("/tmp/autotrace1-pid", "w");
	if (!fp) {
		perror("Error writing child pid");
		return -errno;
	}
	
	fprintf(fp, "%u", (unsigned int) pid);
	return fclose(fp);
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

		ret = stop_tracing();
		gret = (gret == 0) ? ret : gret;
		ret = write_child_pid(pid);
		gret = (gret == 0) ? ret : gret;
	} else if (pid == 0) {	/* child */
		seteuid(uid);
		setegid(gid);
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
