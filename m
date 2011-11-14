Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1KNMqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 07:46:53 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:51079 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab1KNMqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 07:46:52 -0500
Message-ID: <4EC10DB9.1050906@ilyx.ru>
Date: Mon, 14 Nov 2011 16:46:49 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111108 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ilya Zykov <ilya@ilyx.ru>
Subject: [PATCH v3 1/2] TTY: tty flip buffer optimisation.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, free flip buffer (tty->buf.free) reserve memory for further used,
only if driver send to ldisc less 257 bytes in one time.
If driver send more, flip buffer reserve(kmalloc()) and then
free(kfree()) every chunk more 256 bytes every time.

For testing I use little program that write in loop, argv[1] bytes from one side pty and read on the other.
I get follow results:

ilya@serh:~/src/pty$ time ./bench_pty_buf 253
chunk = 253. loop = 3952569.
real	0m22.398s
user	0m0.604s
sys	0m19.545s

ilya@serh:~/src/pty$ time ./bench_pty_buf 255
chunk = 255. loop = 3921568.
real	0m20.437s
user	0m0.532s
sys	0m16.621s

ilya@serh:~/src/pty$ time ./bench_pty_buf 257
chunk = 257. loop = 3891050.
real	0m26.367s
user	0m0.552s
sys	0m28.010s

We can see that on 257 size chunk we loose ~20-30% performance.
The time's real was expected ~20-19 sek. 

Program bench_pty_buf.c:
---
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>


#define WRITE_SIZE 1000000000

int main(int argc,char *argv[]) {
	char pty_name[24];
	int mfd, sfd, ptn, chunk, loop;
	if(argc != 2)
		goto error_exit;
	if((chunk = atoi(argv[1])) <= 0)
		goto error_exit;
	loop = WRITE_SIZE/chunk;
	printf("chunk = %d. loop = %d.\n",chunk, loop);
	mfd = -1;
	sfd = -1;
	mfd = open("/dev/ptmx", O_RDWR);
	if (mfd < 0) {
		printf("Couldn't open /dev/ptmx %m");
		goto error_exit;
	}
	if (ioctl(mfd, TIOCGPTN, &ptn) < 0) {
		printf("Couldn't get pty number %m");
		goto error_exit;
	}
	snprintf(pty_name, sizeof(pty_name), "/dev/pts/%d", ptn);
	ptn = 0;
	if (ioctl(mfd, TIOCSPTLCK, &ptn) < 0) {
		printf("Couldn't unlock pty slave %s: %m", pty_name);
		goto error_exit;
	}
	if ((sfd = open(pty_name, O_RDWR | O_NOCTTY)) < 0) {
		printf("Couldn't open pty slave %s: %m", pty_name);
		goto error_exit;
	}
	struct termios tios;
	cfmakeraw(&tios);
	if(tcsetattr(sfd, TCSAFLUSH, &tios) < 0) {
		printf("Can't set raw mode pty slave %s.\n", pty_name);
		goto error_exit;
	}
	char buf[] = {	[0 ... 65535] = '1' };
	int child;
	int count;
	int ret, fillcount;
	/* Fill buffers without blocked "flip free = 65536" and "N_TTY_BUF_SIZE = 4096" */
	for(count = 0; count < 270; count++) {
		ret = write(sfd,buf,256);
		if(ret < 0) {
			printf("Couldn't fill pty master %s count = %d: %m", pty_name, count);
			goto error_exit;
		}
		fillcount += ret;
	}
	if ( !(child=fork()) ) {
// Child
	for(count = 0; count < loop*chunk + fillcount; count += ret) {
		if((ret = read(mfd,buf,chunk)) < 0) {
			printf("Read: Count = %d, chunk = %d, error = %m \n",count,chunk);
			goto error_exit;
		}
	}
	goto normal_exit;
	}
// Parent
	if (child < 0)
		goto error_exit;
	for(count = 0; count < loop*chunk; count += ret) {
		if((ret = write(sfd, buf, chunk)) < 0) {
			printf("Write: Count = %d, chunk = %d, error = %m \n",count,chunk);
			goto error_exit;
		}
	}
	int status;
	waitpid(child,&status,0);
	if(status)
		goto error_exit;
normal_exit:
	if (sfd >= 0) close(sfd);
	if (mfd >= 0) close(mfd);
	return 0;
error_exit:
	if (sfd >= 0) close(sfd);
	if (mfd >= 0) close(mfd);
	return -1;
}


