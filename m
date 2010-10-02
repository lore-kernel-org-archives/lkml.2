Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0JBDVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 23:21:08 -0400
Received: from heily.com ([69.56.173.59]:38412 "EHLO heily.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab0JBDVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 23:21:07 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2010 23:21:07 EDT
Message-ID: <4CA6A2E3.2060306@heily.com>
Date: Fri, 01 Oct 2010 23:11:31 -0400
From: Mark Heily <mark@heily.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: setgroups(2) does not update all threads in a process
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The setgroups(2) system call does not update the credentials for all threads 
in a process. Instead, it only updates the credentials for the currently 
executing thread. Any threads that were created before setgroups() was 
called are not affected.

This is not the expected behavior according to the manpage, which states:

     "setgroups()  sets  the supplementary group IDs for the calling process."

See below for a small test case that demonstrates the problem. This program 
runs successfully on FreeBSD 8 and Solaris 10, but fails on Linux 2.6.32.

I'm not subscribed to LKML, so please CC: all replies to my personal email 
address (mark@heily.com).

Cheers,

  - Mark


/*
  * Copyright (c) 2010 Mark Heily <mark@heily.com>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
  *
  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */

/*

    Test if setgroups(3) has process or thread scope.

    Example usage:

       gcc -Wall check_setgroups.c -lpthread && sudo ./a.out

  */

#include <err.h>
#include <errno.h>
#include <grp.h>
#include <pthread.h>
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;

void print_cred(void);
void drop_privs(void);

void drop_privs(void) {
     gid_t gid = 1;

     if (setgid(1) != 0) err(1, "setgid");
     if (setgroups(1, &gid) != 0) err(1, "setgroups");
     if (setuid(1) != 0) err(1, "setuid");
     printf("dropped privileges: ");
     print_cred();
}

void cmp_privs(uid_t uid, gid_t gid, gid_t groups) {
     gid_t buf;

     if (getgid() != gid) errx(1, "wrong gid");
     if (getuid() != uid) errx(1, "wrong uid");
     if (getgroups(1, &buf) != 1) err(1, "getgroups");
     if (buf != groups)
         errx(1, "ERROR: getgroups() returned %d but expected %d\n", buf, 
groups);
}

void print_cred(void) {
     gid_t groups[100];
     int   i, ngroups;

     ngroups = getgroups(100, groups);
     if (ngroups < 0)
         err(1, "getgroups");
     printf("uid=%d gid=%d groups=", getuid(), getgid());
     for (i = 0; i <ngroups; i++) {
         printf("%d ", groups[i]);
     }
     printf("\n");
}

void * thread_main(void *unused) {
     pthread_mutex_lock(&mtx);
     cmp_privs(1,1,1);
     return (NULL);
}

int main() {
     pthread_t tid;
     pthread_attr_t attr;

     if (getuid() != 0)
         errx(1, "ERROR: this must be run as root");

     pthread_mutex_lock(&mtx);
     pthread_attr_init(&attr);
     pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
     pthread_create(&tid, &attr, thread_main, NULL);

     drop_privs();
     cmp_privs(1,1,1);
     pthread_mutex_unlock(&mtx);
     pthread_join(tid, NULL);

     puts("+OK");
     exit(0);
}
