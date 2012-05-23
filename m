Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823Ab2EWVG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:06:29 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:48420 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2EWVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:06:27 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2012 17:06:27 EDT
Date: Wed, 23 May 2012 13:58:57 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Subject: setreuid() results in unreadable /proc/self/fdinfo/
Message-ID: <20120523205857.GA22643@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enclosed testcase shows that after using setreuid to permanently
give up root privs, the process loses its ability to open
/proc/self/fdinfo (as well as some but not all other entries in
/proc/self/).

This seems to fail only with threads -- a singlethreaded program does
not show the same failure.  The failure is the same if the setreuid is
done in the parent thread (before pthread_create) or in the child
thread.

This testcase shows the same behavior on RHEL5 and on
3.4.0-rc4-00095-g95f7147.

This was originally found in Java code using the jsvc project.

A similar discussion happened 3.5 years ago (!) in
http://lkml.indiana.edu/hypermail/linux/kernel/0808.0/3350.html
(CCing Alexey.)

% cc -O2 -Wall setuid-proc-self-fd.c -o setuid-proc-self-fd -lpthread
% sudo ./setuid-proc-self-fd
uid = 0 euid = 0
uid = 1000 euid = 1000
main created thread, waiting.
/proc/self/fdinfo: Permission denied
delaying 100 seconds.
...
% sudo ls -ld /proc/`pidof setuid-proc-self-fd`{,/task/*}{,/fdinfo}
dr-xr-xr-x 7 andy root 0 May 23 13:43 /proc/31640
dr-x------ 2 root root 0 May 23 13:43 /proc/31640/fdinfo
dr-xr-xr-x 5 andy root 0 May 23 13:44 /proc/31640/task/31640
dr-x------ 2 root root 0 May 23 13:44 /proc/31640/task/31640/fdinfo
dr-xr-xr-x 5 andy root 0 May 23 13:44 /proc/31640/task/31641
dr-x------ 2 root root 0 May 23 13:44 /proc/31640/task/31641/fdinfo


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

void *do_child(void *arg)
{
    int fd;

    if((fd = open("/proc/self/fdinfo", O_RDONLY|O_DIRECTORY)) == -1) {
	fprintf(stderr, "/proc/self/fdinfo: %s\n", strerror(errno));
	fprintf(stderr, "delaying 100 seconds.\n");
	sleep(100);
    }

    printf("fd = %d\n", fd);
    fflush(stdout);

    return 0;
}

int main(int argc, char **argv)
{
    pthread_t t;

    printf("uid = %d euid = %d\n", (int)getuid(), (int)geteuid());
    setreuid(1000,1000);
    printf("uid = %d euid = %d\n", (int)getuid(), (int)geteuid());

    pthread_create(&t, 0, do_child, 0);

    printf("main created thread, waiting.\n");

    pthread_join(t, 0);

    printf("main exiting.\n");

    return 0;
}

-andy
