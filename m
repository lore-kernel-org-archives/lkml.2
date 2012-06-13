Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2FMJUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:20:52 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39880 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2FMJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:20:51 -0400
MIME-Version: 1.0
Date: Wed, 13 Jun 2012 12:20:48 +0300
Message-ID: <CAHn8xck=gL34Ht7nngiRJwOvRPz_pMCc5ySGYb_eCG073kzVpw@mail.gmail.com>
Subject: fanotify hangs with multi-threaded programs
From: Jussi Maki <joamaki@gmail.com>
To: LinoSanfilippo@gmx.de, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ran into a hang in open with a fanotify event listener which delegated the
processing via unix socket to a multi-threaded program that was opening
files from several threads. A patch for fixing this was posted in december
(http://marc.info/?l=linux-kernel&m=131822913806350&w=2), but it
wasn't merged.

Are there any plans for fixing this? This is a show stopper here as we can't
really use fanotify in production if there's a chance that multi-threaded
programs might hang any time they use open.

Here's test programs to reproduce this.

First one marks mount "/" for open perm events and returns
allow for everything and the second spawns 5 threads
which all loop opening a temporary file. If the first program
is running threads in the second will hang in
fanotify_get_response_from_access.

----
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

#include <linux/fanotify.h>

#define xperror(args...) { perror(args); exit(1); }

int main()
{
        int fd = fanotify_init(FAN_CLASS_CONTENT, O_RDONLY);
        if (fd < 0) {
                xperror("init");
        }

        int ret = fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_MOUNT,
                                             FAN_OPEN_PERM, AT_FDCWD, "/");
        if (ret < 0) {
                xperror("mark");
        }

        for(;;) {
                struct fanotify_event_metadata event;
                if (read(fd, &event, sizeof(event)) < 0) {
                        xperror("read");
                }

                struct fanotify_response resp = {
                        .fd = event.fd,
                        .response = FAN_ALLOW,
                };

                if (write(fd, &resp, sizeof(resp)) < 0) {
                        xperror("write");
                }

                close(event.fd);
        }
}

----

#include <errno.h>
#include <time.h>
#include <unistd.h>
#include <pthread.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

static char *testfile;

void *thread(void *ctx)
{
	char buf[512];
	int fd;
	for(;;) {
		fd = open(testfile, O_RDONLY);
		if (fd < 0) abort();
		close(fd);
	}
}

int main(int argc, char **argv)
{
	int i = 0;
	testfile = strdup("/tmp/fantest.XXXXXX");
	int fd = mkstemp(testfile);
	close(fd);

	for(i = 0; i < 5; i++) {
		pthread_t tid;
		pthread_create(&tid, NULL, thread, NULL);
	}
	sleep(5);
	unlink(testfile);
}

----

 -- Jussi
