Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab2EXSlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:41:05 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:54276 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab2EXSlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:41:02 -0400
Date: Thu, 24 May 2012 11:41:01 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kirill Korotaev <dev@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Ulrich Drepper <drepper@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: setreuid() results in unreadable /proc/self/fdinfo/
Message-ID: <20120524184101.GA6750@hexapodia.org>
References: <20120523205857.GA22643@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523205857.GA22643@hexapodia.org>
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CCs of reviewers of 8948e11f4

On Wed, May 23, 2012 at 01:58:57PM -0700, Andy Isaacson wrote:
> The enclosed testcase shows that after using setreuid to permanently
> give up root privs, the process loses its ability to open
> /proc/self/fdinfo (as well as some but not all other entries in
> /proc/self/).
> 
> This seems to fail only with threads -- a singlethreaded program does
> not show the same failure.  The failure is the same if the setreuid is
> done in the parent thread (before pthread_create) or in the child
> thread.

There are two separate issues here.

First, the hack in 8948e11f4 for setuid /proc/self/fd doesn't work for
multithreaded processes that setuid(), even if the setuid happens before
the first thread is forked.  It looks to me like
proc_fd_permission's task_pid(current)==proc_pid(inode) test is
incorrect for multithreaded tasks.

Second, why the heck is there a special case for setuid tasks, at all?
The semantics I would expect is that after a task setuid()s to give up
all root permissions, the /proc/self/ entries should belong to the new
user.

Obviously there's a more complicated case if the task is using seteuid()
to do per-uid permission testing or whatever, especially if different
threads are seteuid()ing to different users, but I'm not talking about
that case -- I want a single task that has permanently given up perms
and is not going to exec() anything to have a functional /proc/self.

The enclosed test program (updated) gives the following results on 3.4:

              file in /proc/self/
threaded    environ  fd      fdinfo
--------    -------  --      ------
no          EACCES   ok      EACCES
yes         EACCES   EACCES  EACCES


Thanks,
-andy

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdarg.h>

#include <unistd.h>
#include <fcntl.h>

#include <pthread.h>

void die(char *fmt, ...)
    __attribute__((noreturn))
    __attribute__((format(printf, 1, 2)));

void die(char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    exit(1);
}

int o_delay = 0;
int o_environ = 0;
int o_fdinfo = 0;
int o_runinthread = 1;
int o_setuidinmain = 0;

void *do_child(void *arg)
{
    int fd;
    int flags = O_RDONLY|O_DIRECTORY;
    char *fname = "/proc/self/fd";

    if (o_fdinfo)
	fname = "/proc/self/fdinfo";
    if (o_environ) {
	fname = "/proc/self/environ";
	flags = O_RDONLY;
    }

    if (!o_setuidinmain) {
	printf("uid = %d euid = %d\n", (int)getuid(), (int)geteuid());
	setreuid(1000,1000);
	printf("uid = %d euid = %d\n", (int)getuid(), (int)geteuid());
    }

    printf("opening %s\n", fname);
    if((fd = open(fname, flags)) == -1) {
	fprintf(stderr, "%s: %s\n", fname, strerror(errno));
	if (o_delay) {
	    fprintf(stderr, "delaying 100 seconds.\n");
	    sleep(100);
	}
	exit(1);
    }

    printf("fd = %d\n", fd);
    fflush(stdout);

    return 0;
}

int main(int argc, char **argv)
{
    pthread_t t;
    int c;

    while ((c = getopt(argc, argv, "deint")) != EOF) {
	switch (c) {
	case 'd':
	    o_delay = 1;
	    break;
	case 'e':
	    o_environ = 1;
	    break;
	case 'i':
	    o_fdinfo = 1;
	    break;
	case 'n':
	    o_runinthread = 0;
	    break;
	case 't':
	    o_setuidinmain = 1;
	    break;
	default:
	    die("Usage: %s -[deint]\n"
		"  -d: delay after failure (for manual /proc inspection)\n"
	        "  -e: open /proc/self/environ\n"
	        "  -i: open /proc/self/fdinfo\n"
		"  -n: no threads (run test directly from main())\n"
		"  -t: setreuid() before pthread_create (rather than in thread)\n",
		argv[0]);
	}
    }

    if (o_runinthread) {
	if (o_setuidinmain) {
	    printf("uid = %d euid = %d\n", (int)getuid(), (int)geteuid());
	    setreuid(1000,1000);
	    printf("uid = %d euid = %d\n", (int)getuid(), (int)geteuid());
	}

	pthread_create(&t, 0, do_child, 0);

	printf("main created thread, waiting.\n");

	pthread_join(t, 0);
    } else {
	printf("main calling do_child directly\n");
	do_child(0);
    }

    if (o_delay) {
	fprintf(stderr, "delaying 100 seconds.\n");
	sleep(100);
    }

    printf("main exiting.\n");
    return 0;
}
