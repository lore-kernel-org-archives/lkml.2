Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1DUKlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1DUKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:41:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 0/3] trace,perf: enabling ftrace/function tracepoint
Date: Thu, 21 Apr 2011 12:40:55 +0200
Message-Id: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

this is just RFC patch with patche series showing the
direction I'm taking.. _RFC_ ;)

I was discussing with Frederic the possibility to have function trace
available for perf processing, and the possibility to have it used
as starting/stopping events, and probably more.

The 1st 2 patches adding the registration function for the
ftrace/function tracepoint to be usable by both trace and perf
via tracepoint interface.

The 3rd patch is the biggest hack and is trying to add filtering
support.  I'm currently looking on the filtering code to come up
with some better idea of hooking this type of filtering in.

attached patches:
1/3 - add support for enabling ftrace/function tracepoint event
2/3 - add support for registering ftrace/function tracepoint event via perf
3/3 - add filter support for ftrace/function tracepoint event

I could read perf counts from ftrace/function tracepoint using
attached program.

Any thoughts/ideas about this direction or projecting some other
would be just great :)


thanks a lot,
jirka
---
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/perf_event.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>

static int trace_event__id(const char *evname)
{
	char *filename;
	int err = -1, fd;

	if (asprintf(&filename,
		     "/debug/tracing/events/ftrace/%s/id",
		     evname) < 0)
		return -1;

	fd = open(filename, O_RDONLY);
	if (fd >= 0) {
		char id[16];
		if (read(fd, id, sizeof(id)) > 0)
			err = atoi(id);
		close(fd);
	}

	free(filename);
	return err;
}

static inline int
sys_perf_event_open(struct perf_event_attr *attr,
		pid_t pid, int cpu, int group_fd, 
		unsigned long flags)
{       
	attr->size = sizeof(*attr);
	return syscall(__NR_perf_event_open, attr, pid, cpu,
		group_fd, flags);
}

int main(int argc, char **argv)
{
	struct perf_event_attr attr;
	int fd;
	pid_t pid;
	int status;
	long count;
	int ret;
	int id = trace_event__id("function");
	int child_ready_pipe[2];

	if (id < 0) {
		printf("is debugfs mounted on /sys/kernel/debug?\n");
		return -1;
	}

        if (pipe(child_ready_pipe) < 0) {
		perror("pipe failed");
		return -1;
	}

	memset(&attr, 0, sizeof(attr));
	attr.type = PERF_TYPE_TRACEPOINT;
	attr.config = id;
	attr.enable_on_exec = 1;

	pid = fork();
	if (!pid) {
		char buf;
		char *cmd = "/bin/sleep";
		char *newargv[] = { cmd, "2", NULL };
		char *newenviron[] = { NULL };

		/* wait for parent to setup the counter */
		close(child_ready_pipe[1]);
		if (read(child_ready_pipe[0], &buf, 1) == -1) {
			perror("unable to read pipe");
			return -1;
		}
		close(child_ready_pipe[0]);

		execve(cmd, newargv, newenviron);
		perror("execve failed");
		return -1;
	}


	fd = sys_perf_event_open(&attr, pid, -1, -1, 0);
	if (fd < 0) {
		perror("sys_perf_event_open failed");
		return -1;
	}

	if (ioctl(fd, PERF_EVENT_IOC_SET_FILTER, "ip == sys_close", 0)) {
		perror("ioctl failed");
		return -1;
	}

	/* tell the child it can go nuts */
	close(child_ready_pipe[1]);
	close(child_ready_pipe[0]);

	waitpid(pid, &status, 0);

	ret = read(fd, &count, sizeof(count));
	if (ret <= 0) {
		perror("read failed");
		return -1;
	}

	printf("count = %ld\n", count);
	return 0;
}
