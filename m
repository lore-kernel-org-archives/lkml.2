Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2FSOAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:00:47 -0400
Received: from kontorsmtp2.one.com ([195.47.247.17]:57689 "EHLO
	kontorsmtp2.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSOAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:00:46 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2012 10:00:45 EDT
Message-ID: <4FE083CE.20908@one.com>
Date: Tue, 19 Jun 2012 15:51:10 +0200
From: Emil Renner Berthing <erb@one.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
CC: linux-kernel@vger.kernel.org, Jesper Dahl Nyerup <nyerup@one.com>,
        Anders Saaby <as@one.com>
Subject: Inotify scalability issue
Content-Type: multipart/mixed;
 boundary="------------070903080507040309090705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070903080507040309090705
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

We're running Dovecot mailservers and are experiencing problems similar 
to what is described here:
http://old.nabble.com/Very-High-Load-on-Dovecot-2-and-Errors-in-mail.err.-tt33856207.html#a33856207

I've written two small programs to expose the problem.

watcher.c:
This program reads a filename from the commandline, creates a new 
inotify handle and sets it up to watch IN_CLOSE_WRITE and IN_DELETE on 
the file. It then writes a 'z' to stdout, and does a blocking read from 
inotify. After receiving an event from inotify the program prints an 'x' 
to stdout, closes the inotify handle and then prints a '.' to stdout 
before exiting.

test.c:
This program creates 20 files and spawns 20 watchers to watch each of 
them. For each watcher it waits between 1 and 2 seconds before touching 
the file they watch (which should cause it to wake up and exit), and 
then spawns a new watcher on the file, again waiting between 1 and 2 
seconds before touching the file again etc.

On my dualcore workstation running the test program behaves as you'd 
expect. That is it prints
zzzzzzzzzzzzzzzzzzzzx.zx.zx.zx.zx.zx.zx.zx.zx.zx.zx.zx.zx (etc.)

However on a 16-core server it behaves very differently:
zzzzzzzzzzzzzzzzzzzzxzxzxzxz.xzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxzxz......................................................................................................xzxzxzxzxz.xxzzxzxzxzxzxzxzxzxzxzxzxz.................xzxz.xz

(sorry about the long line)
That is watchers are spawned to watch their files, they're woken up by 
inotify as they should be, but then they pile up in D-state waiting for 
the close call to finish. Only at irregular intervals do they all return.

They seem to be sleeping on the syncronize_srcu() call in 
fsnotify_destroy_group() of fs/notify/group.c.

We've tested this on various machines running kernels from 3.0 and up, 
and the trend very clear: The more processors the worse it gets.
However, I also tried it on one 48-core server running an old 2.6.32 
debian kernels, and here the processes don't pile up.

/Emil

--------------070903080507040309090705
Content-Type: text/x-c;
 name="watcher.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="watcher.c"

#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/inotify.h>
#include <limits.h>

#define log(...) fprintf(stderr, __VA_ARGS__)

static void
put(int c)
{
	putchar(c);
	fflush(stdout);
}

int
main(int argc, char *argv[])
{
	int ifd = -1;
	int wd;
	char buf[sizeof(struct inotify_event) + NAME_MAX + 1];

	if (argc != 2) {
		log("I need a file..\n");
		goto error;
	}

	ifd = inotify_init();
	if (ifd < 0) {
		if (errno == EMFILE)
			put('!');
		else
			log("Error initializing inotify: %s\n",
				strerror(errno));
		goto error;
	}

	wd = inotify_add_watch(ifd, argv[1], IN_CLOSE_WRITE | IN_DELETE);
	if (wd < 0) {
		log("Error adding watch on '%s': %s\n",
				argv[1], strerror(errno));
		goto error;
	}

	put('z');
	if (read(ifd, buf, sizeof(buf)) < 0) {
		log("Error reading inotify event: %s\n",
				strerror(errno));
		goto error;
	}

	put('x');
	if (close(ifd)) {
		log("Error closing inotify: %s\n",
				strerror(errno));
		ifd = -1;
		goto error;
	}
	put('.');
	return EXIT_SUCCESS;

error:
	if (ifd > 0)
		close(ifd);
	return EXIT_FAILURE;
}

--------------070903080507040309090705
Content-Type: text/x-c;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test.c"

#include <stdint.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <signal.h>

#define log(...) fprintf(stderr, __VA_ARGS__)
#define WATCHER "watcher"

static struct proc {
	uint64_t deadline;
	char filename[32 - sizeof(uint64_t)];
} procs[NPROC];

static pid_t
spawn_watcher(char *filename)
{
	char *argv[3] = { WATCHER, filename, NULL };
	pid_t pid;

	pid = fork();
	if (pid == 0) {
		if (execv(WATCHER, argv)) {
			log("Error spawning '%s': %s\n",
					WATCHER, strerror(errno));
			exit(EXIT_FAILURE);
		}
	}

	if (pid < 0)
		log("Error forking: %s\n", strerror(errno));
	
	return pid;
}

static int
touch(char *filename, int flags)
{
	int fd = open(filename, flags, 0644);
	if (fd < 0 || close(fd)) {
		log("Error touching '%s': %s\n",
				filename, strerror(errno));
		return -1;
	}
	return 0;
}

static uint64_t 
now(void)
{
	struct timeval tv;
	(void)gettimeofday(&tv, NULL);
	return ((uint64_t)tv.tv_sec * 1000000) + (uint64_t)tv.tv_usec;
}

static uint64_t
random_delay(void)
{
	return (uint64_t)DELAY_MIN + (random() / (RAND_MAX/(DELAY_MAX - DELAY_MIN)));
}

int
main()
{
	unsigned int i;
	struct proc *next;

	if (signal(SIGCHLD, SIG_IGN)) {
		log("Error setting SIGCHLD handler: %s\n",
				strerror(errno));
		return EXIT_FAILURE;
	}

	for (i = 0; i < NPROC; i++) {
		(void)sprintf(procs[i].filename, "%03u.tmp", i);
		if (touch(procs[i].filename, O_WRONLY | O_CREAT)) {
			log("Error creating file '%s': %s\n",
					procs[i].filename, strerror(errno));
			return EXIT_FAILURE;
		}
	}

	next = &procs[0];
	for (i = 0; i < NPROC; i++) {
		if (spawn_watcher(procs[i].filename) < 0)
			goto error;

		procs[i].deadline = now() + random_delay();
		if (procs[i].deadline < next->deadline)
			next = &procs[i];
	}

	while (1) {
		uint64_t n = now();

		if (next->deadline > n) {
			usleep(next->deadline - n);
			continue;
		}

		if (touch(next->filename, O_WRONLY))
			goto error;

		if (spawn_watcher(next->filename) < 0)
			goto error;

		next->deadline = now() + random_delay();
		for (i = 0; i < NPROC; i++) {
			if (procs[i].deadline < next->deadline)
				next = &procs[i];
		}
	}

error:
	for (i = 0; i < NPROC; i++)
		(void)touch(procs[i].filename, O_WRONLY);

	return EXIT_FAILURE;
}

--------------070903080507040309090705
Content-Type: text/plain; charset=UTF-8;
 name="Makefile"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Makefile"

TlBST0MgICAgID0gMjAKREVMQVlfTUlOID0gMTAwMDAwMApERUxBWV9NQVggPSAyMDAwMDAw
CgpDQyA9IGdjYwpDRkxBR1MgPz0gLU8yIC1waXBlIC1nCkNGTEFHUyArPSAtc3RkPWdudTk5
IC1XYWxsIC1XZXh0cmEgLXBlZGFudGljCgphbGw6IHRlc3Qgd2F0Y2hlcgoKdGVzdDogdGVz
dC5jCgkkKENDKSAkKENGTEFHUykgLUROUFJPQz0kKE5QUk9DKSAtRERFTEFZX01JTj0kKERF
TEFZX01JTikgLURERUxBWV9NQVg9JChERUxBWV9NQVgpICQoTERGTEFHUykgJDwgLW8gJEAK
CndhdGNoZXI6IHdhdGNoZXIuYwoJJChDQykgJChDRkxBR1MpICQoTERGTEFHUykgJDwgLW8g
JEAKCmNsZWFuOgoJcm0gLXJmIHRlc3Qgd2F0Y2hlciAqLnRtcAo=
--------------070903080507040309090705--
