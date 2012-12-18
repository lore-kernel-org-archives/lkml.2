Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2LRUoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:44:44 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:60351 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964Ab2LRUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:44:40 -0500
Message-ID: <50D0D5B5.5080506@ilyx.ru>
Date: Wed, 19 Dec 2012 00:44:37 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Sasha Levin <levinsasha928@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/11] tty: Fix buffer work access-after-free
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>  <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com> <1355849302.26487.15.camel@thor.lan>
In-Reply-To: <1355849302.26487.15.camel@thor.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stress test for tty. :)
You can use this program for debug new tty changes.
Use with caution.

In any case(with/without Peter's patches) I have BUG():

BUG: unable to handle kernel NULL pointer dereference at 000000000000004c
IP: [<ffffffff81116650>] devpts_pty_kill+0x17/0x81
PGD 48696067 PUD a79c5067 PMD 0 
Oops: 0000 [#1] SMP 
Pid: 7877, comm: a.out Tainted: P           O 3.7.0-next-20121214-tty.1+ #9 System manufacturer P5K Premium/P5K Premium
RIP: 0010:[<ffffffff81116650>]  [<ffffffff81116650>] devpts_pty_kill+0x17/0x81
RSP: 0018:ffff8800484a3aa8  EFLAGS: 00010292
RAX: ffff88012f0385a0 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000282 RDI: 0000000000000000
RBP: ffff8800484a3ac8 R08: 0000000000000000 R09: ffff880046f26d40
R10: ffffffff81426ec8 R11: 0000000000000246 R12: ffff8800486a6c00
R13: ffff8800484c7180 R14: ffff880046ec4890 R15: 00000000fffffffb
FS:  00007f9a64345700(0000) GS:ffff88012fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000004c CR3: 00000000a7a01000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 7877, threadinfo ffff8800484a2000, task ffff88007576d220)
Stack:
 ffff880000000001 ffff88004854a400 ffff8800486a6c00 ffff8800484c7180
 ffff8800484a3ae8 ffffffff811e0c1b ffff8800484c7180 ffff88004854a400
 ffff8800484a3bd8 ffffffff811d83aa ffff880046f26d78 0000000000000009
Call Trace:
 [<ffffffff811e0c1b>] pty_close+0x123/0x14f
 [<ffffffff811d83aa>] tty_release+0x17a/0x53d
 [<ffffffff812e7442>] ? __mutex_unlock_slowpath+0x15/0x39
 [<ffffffff811e1003>] ptmx_open+0x12c/0x161
 [<ffffffff810c6d4b>] chrdev_open+0x12a/0x14b
 [<ffffffff810c6c21>] ? cdev_put+0x23/0x23
 [<ffffffff810c27a9>] do_dentry_open+0x170/0x217
 [<ffffffff810c2933>] finish_open+0x34/0x40
 [<ffffffff810ce069>] do_last+0x8c4/0xa72
 [<ffffffff810ce2ed>] ? path_init+0xd6/0x2fe
 [<ffffffff810ceaf4>] path_openat+0xcb/0x363
 [<ffffffff81051033>] ? __dequeue_entity+0x2e/0x33
 [<ffffffff810cee91>] do_filp_open+0x38/0x84
 [<ffffffff810d9846>] ? __alloc_fd+0x51/0x110
 [<ffffffff810c24ed>] do_sys_open+0x6d/0xff
 [<ffffffff810c25ac>] sys_open+0x1c/0x1e
 [<ffffffff812ee652>] system_call_fastpath+0x16/0x1b
Code: 08 02 00 00 48 89 c7 e8 6c f3 fb ff 5b 4c 89 e0 41 5c c9 c3 55 48 89 e5 41 55 41 54 53 48 89 fb 48 83 ec 08 48 8b 05 80 43 71 00 <81> 7f 4c 02 00 50 00 48 8b 40 08 4c 8b 60 60 75 04 0f 0b eb fe 
RIP  [<ffffffff81116650>] devpts_pty_kill+0x17/0x81
 RSP <ffff8800484a3aa8>
CR2: 000000000000004c


Without Peter's patches I have WARN():

7388:Dec 18 22:43:12 bm kernel: [ 2484.054010] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x52/0x1b2()
7389-Dec 18 22:43:12 bm kernel: [ 2484.054011] Hardware name: P5K Premium
7390-Dec 18 22:43:12 bm kernel: [ 2484.054012] tty is NULL
7392-Dec 18 22:43:12 bm kernel: [ 2484.054042] Pid: 3030, comm: kworker/0:0 Tainted: P        W  O 3.7.0-next-20121214-tty.1 #8
7393-Dec 18 22:43:12 bm kernel: [ 2484.054044] Call Trace:
7394-Dec 18 22:43:12 bm kernel: [ 2484.054047]  [<ffffffff8102ce58>] warn_slowpath_common+0x80/0x98
7395-Dec 18 22:43:12 bm kernel: [ 2484.054049]  [<ffffffff8102cf04>] warn_slowpath_fmt+0x41/0x43
7396-Dec 18 22:43:12 bm kernel: [ 2484.054051]  [<ffffffff811df175>] flush_to_ldisc+0x52/0x1b2
7397-Dec 18 22:43:12 bm kernel: [ 2484.054053]  [<ffffffff812e81a9>] ? __schedule+0x5d1/0x613
7398-Dec 18 22:43:12 bm kernel: [ 2484.054056]  [<ffffffff8103ee42>] process_one_work+0x1c1/0x279
7399-Dec 18 22:43:12 bm kernel: [ 2484.054058]  [<ffffffff811df123>] ? tty_buffer_free_all+0x4d/0x4d
7400-Dec 18 22:43:12 bm kernel: [ 2484.054060]  [<ffffffff81040d47>] worker_thread+0x154/0x24e
7401-Dec 18 22:43:12 bm kernel: [ 2484.054062]  [<ffffffff81040bf3>] ? manage_workers+0x26c/0x26c
7402-Dec 18 22:43:12 bm kernel: [ 2484.054064]  [<ffffffff810443eb>] kthread+0xb0/0xb8
7403-Dec 18 22:43:12 bm kernel: [ 2484.054066]  [<ffffffff8104433b>] ? kthread_parkme+0x1f/0x1f
7404-Dec 18 22:43:12 bm kernel: [ 2484.054068]  [<ffffffff812ee46c>] ret_from_fork+0x7c/0xb0
7405-Dec 18 22:43:12 bm kernel: [ 2484.054070]  [<ffffffff8104433b>] ? kthread_parkme+0x1f/0x1f


With Peter's patches I have WARN():

WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xe7/0xf8()
Hardware name: P5K Premium
scheduling buffer work for halted ldisc
Pid: 3127, comm: a.out Tainted: P        W  O 3.7.0-next-20121214-tty.1+ #9
Call Trace:
 [<ffffffff8102ce58>] warn_slowpath_common+0x80/0x98
 [<ffffffff8102cf04>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff811dae01>] n_tty_set_room+0xe7/0xf8
 [<ffffffff811db2cf>] reset_buffer_flags+0xad/0xb6
 [<ffffffff811dd01b>] n_tty_open+0xca/0x11f
 [<ffffffff811de4c9>] tty_ldisc_open+0x4e/0x5f
 [<ffffffff811ded14>] tty_ldisc_hangup+0x1f5/0x292
 [<ffffffff810d0289>] ? fasync_helper+0x22/0x6c
 [<ffffffff811d7a03>] __tty_hangup+0x102/0x30e
 [<ffffffff810d52ad>] ? d_delete+0x12d/0x136
 [<ffffffff811d7c2a>] tty_vhangup+0x9/0xb
 [<ffffffff811e0c3b>] pty_close+0x143/0x14f
 [<ffffffff811d83aa>] tty_release+0x17a/0x53d
 [<ffffffff8104b9f7>] ? __wake_up+0x3f/0x48
 [<ffffffff810efb55>] ? fsnotify+0x21d/0x244
 [<ffffffff810c4bc5>] __fput+0xf9/0x1bd
 [<ffffffff810c4ccf>] ____fput+0x9/0xb
 [<ffffffff81041cd4>] task_work_run+0x80/0x98
 [<ffffffff810025bd>] do_notify_resume+0x58/0x69
 [<ffffffff812ee8da>] int_signal+0x12/0x17


---
/*
 *  stress_test_tty.c
 *
 *  Created on: Dec, 2012
 *  Copyright (C) 2012  Ilya Zykov
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <stdlib.h>
#include <pthread.h>
#include <signal.h>

#define BUF_SIZE 2
#define ERROR_EXIT_CODE 1
#define parent child_id

static int
mfd=-1, sfd=-1, parent=1;

static pthread_t
pth_id;

static char
pty_name[24], buf[]={ '1', '\n' };


static void
pty_exit(int ret, char * exit_message){
	if (sfd >= 0) close(sfd);
	if (mfd >= 0) close(mfd);
	printf("%s %s %s exit. \n",exit_message?exit_message:"",
		ret?"Error":"Normal", parent?"parent":"child");
	exit(ret);
}

static void
pty_init(void){
	int ptn;
	if( (mfd=open("/dev/ptmx", O_RDWR )) < 0 )
		pty_exit(ERROR_EXIT_CODE,"Couldn't open /dev/ptmx. \n");
	if (ioctl(mfd, TIOCGPTN, &ptn) < 0 )
		pty_exit(ERROR_EXIT_CODE,"Couldn't get pty number. \n");
	snprintf(pty_name, sizeof(pty_name), "/dev/pts/%d", ptn);
	//printf("Slave pty name = %s.\n",pty_name);
	ptn=0;
	if (ioctl(mfd, TIOCSPTLCK, &ptn) < 0 )
		pty_exit(ERROR_EXIT_CODE,"Couldn't unlock pty slave. \n");
	if ( (sfd=open(pty_name, O_RDWR )) < 0 )
		pty_exit(ERROR_EXIT_CODE, "Couldn't open pty slave. \n");
}

static void *
pty_thread_open(void * arg) {
	static char ret[]="Thread open has been created.\n";
	printf(ret);
	do {
		close(open(pty_name, O_RDWR ));
	} while(1);
	return ret;
}

static void *
pty_thread_read(void * arg) {
	static char ret[]="Thread read has been created.\n";
	printf(ret);
	do {
		read(sfd, buf, BUF_SIZE);
	} while(1);
	return ret;
}

static void *
pty_thread_write(void * arg) {
	static char ret[]="Thread write has been created.\n";
	printf(ret);
	do {
		write(mfd, buf, BUF_SIZE);
	} while(1);
	return ret;
}
int main(int argc,char *argv[]) {
	pty_init();
	child_id=fork();
	if(parent) {
		sleep(100);
		kill(child_id, SIGINT);
		pty_exit(0,"Parent normal exit\n");
	}
	pthread_create(&pth_id, NULL, &pty_thread_open, 0);
/*	For WARNINGS.
	pthread_create(&pth_id, NULL, &pty_thread_write, 0);
	pthread_create(&pth_id, NULL, &pty_thread_read, 0);
*/
	do {
		close(sfd);
		close(mfd);
		pty_init();
	} while(1);
	return 0;
}

