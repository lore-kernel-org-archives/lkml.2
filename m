Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1BPXY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:24:58 -0500
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:46202 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1BPXYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:24:55 -0500
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Feb 2011 18:24:54 EST
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net: fix multithreaded signal handling in unix recv routines
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Date: Wed, 16 Feb 2011 23:13:00 +0000
Message-ID: <874o83bmkj.fsf@sapphire.mobileactivedefense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mobileactivedefense.com>

The unix_dgram_recvmsg and unix_stream_recvmsg routines in
net/af_unix.c utilize mutex_lock(&u->readlock) calls in order to
serialize read operations of multiple threads on a single socket. This
implies that, if all n threads of a process block in an AF_UNIX recv
call trying to read data from the same socket, one of these threads
will be sleeping in state TASK_INTERRUPTIBLE and all others in state
TASK_UNINTERRUPTIBLE. Provided that a particular signal is supposed to
be handled by a signal handler defined by the process and that none of
this threads is blocking the signal, the complete_signal routine in
kernel/signal.c will select the 'first' such thread it happens to
encounter when deciding which thread to notify that a signal is
supposed to be handled and if this is one of the TASK_UNINTERRUPTIBLE
threads, the signal won't be handled until the one thread not blocking
on the u->readlock mutex is woken up because some data to process has
arrived (if this ever happens). The included patch fixes this by
changing mutex_lock to mutex_lock_interruptible and handling possible
error returns in the same way interruptions are handled by the actual
receive-code.

Signed-off-by: Rainer Weikusat <rweikusat@mobileactivedefense.com>

---
I noticed this because the termination cleanup code of some program I
wrote on behalf of my employer didn't work anymore once the program
was run in 'production mode' (reading from an AF_UNIX SOCK_SEQPACKET
socket) as opposed to 'testing mode' (with input from a terminal). The
program included below demonstrates this effect: For the 'usual' case,
the second thread will block in the actual receive routine and the
first will block on the mutex and consequently, terminating the
program with C-c after the 'interrupt me if you can' message was
printed won't work.

/*
  demonstrate 'signal not being handled'
  problem
*/

#include <errno.h>
#include <pthread.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

static int fd;

static void create_socket(void)
{
    struct sockaddr_un sun;
    int rc;

    fd = socket(AF_UNIX, SOCK_DGRAM, 0);
    if (fd == -1) {
	perror("socket");
	exit(1);
    }

    sun.sun_family = AF_UNIX;
    strncpy(sun.sun_path, "sk", sizeof(sun.sun_path));
    /*
      'blind idempotence measure' -- don't run in directories where
      files named 'sk' whose content happens to be 'valuable' reside.
    */    
    unlink("sk");		
    rc = bind(fd, (struct sockaddr *)&sun, sizeof(sun));
    if (rc == -1) {
	perror("bind");
	exit(1);
    }
}

static void sigint_handler(int unused)
{
    exit(0);
}

static void setup_sighandler(void)
{
    struct sigaction sa;

    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sa.sa_handler = sigint_handler;
    sigaction(SIGINT, &sa, NULL);
}

static void *block_in_read(void *unused)
{
    char buf[16];
    ssize_t rc;

    rc = read(fd, buf, sizeof(buf));
    if (rc == -1) {
	perror("read");
	exit(1);
    }

    return NULL;
}

int main(void)
{
    pthread_t tid;
    int rc;
    
    create_socket();
    setup_sighandler();
    
    rc = pthread_create(&tid, NULL, block_in_read, NULL);
    if (rc) {
	errno = rc;
	perror("pthread_create");
	exit(1);
    }

    /*
      The complete_signal routine in kernel/signal.c will chose the
      'initial thread' when deciding which thread should be woken up
      because of new signal if possible.  The sleep below makes it
      very probable that the second thread will sleep interruptibly in
      unix_dgram_recvmsg by the time this thread calls
      mutex_lock(&u->readlock) and consequently, the state of the
      initial thread will most likely be TASK_UNINTERRUPTIBLE by the
      time the signal occurs.
    */
    sleep(3);
    fputs("Now interrupt me if you can!\n", stderr);
    block_in_read(NULL);

    return 0;
}

diff -urp net-2.6/net/unix/af_unix.c net-2.6-patched//net/unix/af_unix.c
--- net-2.6/net/unix/af_unix.c	2011-02-16 22:19:43.338358559 +0000
+++ net-2.6-patched//net/unix/af_unix.c	2011-02-16 22:38:39.483543598 +0000
@@ -1724,7 +1724,11 @@ static int unix_dgram_recvmsg(struct kio
 
 	msg->msg_namelen = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err) {
+		err = sock_intr_errno(sock_rcvtimeo(sk, noblock));
+		goto out;
+	}
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
@@ -1864,7 +1868,11 @@ static int unix_stream_recvmsg(struct ki
 		memset(&tmp_scm, 0, sizeof(tmp_scm));
 	}
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err) {
+		err = sock_intr_errno(timeo);
+		goto out;
+	}
 
 	do {
 		int chunk;
@@ -1895,11 +1903,12 @@ static int unix_stream_recvmsg(struct ki
 
 			timeo = unix_stream_data_wait(sk, timeo);
 
-			if (signal_pending(current)) {
+			if (signal_pending(current)
+			    ||  mutex_lock_interruptible(&u->readlock)) {
 				err = sock_intr_errno(timeo);
 				goto out;
 			}
-			mutex_lock(&u->readlock);
+
 			continue;
  unlock:
 			unix_state_unlock(sk);
