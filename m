Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2LDTVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:21:38 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53328 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab2LDTVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:21:35 -0500
Message-ID: <50BE4D3D.1070409@ilyx.ru>
Date: Tue, 04 Dec 2012 23:21:33 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Sasha Levin <levinsasha928@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-serial@vger.kernel.org
Subject: Re: flush_to_ldisc accesses tty after free (was: [PATCH 21/21] TTY:
 move tty buffers to tty_port)
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>   <1350592007-9216-22-git-send-email-jslaby@suse.cz>   <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz>   <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>   <5091448D.3@suse.cz>   <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com>   <5093EC1B.2050800@suse.cz>   <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>   <5093F262.6000301@suse.cz> <50947B7B.8080601@gmail.com>   <50953E8D.9000504@suse.cz> <5095A384.5080205@gmail.com>   <5095BC6E.2010505@gmail.com> <1354046255.2444.10.camel@thor>  <50B946A9.9070306@gmail.com> <1354373995.2531.48.camel@thor>
In-Reply-To: <1354373995.2531.48.camel@thor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 18:59, Peter Hurley wrote:
> (cc'ing Ilya Zykov <ilya@ilyx.ru> because the test jig below is based on
> his test program from https://lkml.org/lkml/2012/11/29/368 -- just want
> to give credit where credit is due)
> 
> On Fri, 2012-11-30 at 18:52 -0500, Sasha Levin wrote:
>>
>> Still reproducible, I'm still seeing this with the patch above applied:
>>
>> [ 1315.419759] ------------[ cut here ]------------
>> [ 1315.420611] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x60/0x200()
>> [ 1315.423098] tty is NULL
> 
> Thanks for sticking with this Sasha. Finally me too.
> 
> ---
> [   88.331234] WARNING: at /home/peter/src/kernels/next/drivers/tty/tty_buffer.c:435 flush_to_ldisc+0x194/0x1d0()
> [   88.334505] Hardware name: Bochs
> [   88.335618] tty is bad=-1
> [   88.335703] Modules linked in: netconsole configfs bnep rfcomm bluetooth snd_hda_intel snd_hda_codec snd_hwdep
> parport_pc ppdev snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device mac_hid
> psmouse snd i2c_piix4 soundcore snd_page_alloc microcode serio_raw virtio_balloon lp parport floppy 8139too 8139cp
> [   88.345272] Pid: 39, comm: kworker/1:1 Tainted: G        W    3.7.0-next-20121129+ttydebug-xeon #20121129+ttydebug
> [   88.347736] Call Trace:
> [   88.349024]  [<ffffffff81058aff>] warn_slowpath_common+0x7f/0xc0
> [   88.350383]  [<ffffffff81058bf6>] warn_slowpath_fmt+0x46/0x50
> [   88.351745]  [<ffffffff81432bd4>] flush_to_ldisc+0x194/0x1d0
> [   88.353047]  [<ffffffff816f7fe1>] ? _raw_spin_unlock_irq+0x21/0x50
> [   88.354190]  [<ffffffff8108a809>] ? finish_task_switch+0x49/0xe0
> [   88.355436]  [<ffffffff81077ad1>] process_one_work+0x121/0x490
> [   88.357674]  [<ffffffff81432a40>] ? __tty_buffer_flush+0x90/0x90
> [   88.358954]  [<ffffffff81078c84>] worker_thread+0x164/0x3e0
> [   88.360247]  [<ffffffff81078b20>] ? manage_workers+0x120/0x120
> [   88.361282]  [<ffffffff8107e230>] kthread+0xc0/0xd0
> [   88.362284]  [<ffffffff816f0000>] ? cmos_do_probe+0x2eb/0x3bf
> [   88.363391]  [<ffffffff8107e170>] ? flush_kthread_worker+0xb0/0xb0
> [   88.364797]  [<ffffffff816fff6c>] ret_from_fork+0x7c/0xb0
> [   88.366087]  [<ffffffff8107e170>] ? flush_kthread_worker+0xb0/0xb0
> [   88.367266] ---[ end trace 453a7c9f38fbfec0 ]---
> 
> 
> I figured out how to make this reproduce easily. The test jig at the end
> of this email will generate this multiple times a second.
> 
> The test creates a pty pair and spawns a child which writes to the slave
> pts, while the parent waits for the first write and then abruptly closes
> the master ptm and kills the child. (Just in case, I'd only run the jig
> in a disposable vm. Obviously, the vm needs multiple cores and extra pty
> serial devices ;)
> 
>>From instrumenting the tty_release() path, it's clear that tty_buffer
> work is still scheduled even after tty_release_ldisc() has run. For
> example, with this patch I get the warning below it.
> 
> [Further analysis to follow in subsequent mail...]
> 
> --- >% ---
> [PATCH -next] tty: WARN if buffer work racing with tty free
> 
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 1ce50ec..9d53aec 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1511,6 +1511,8 @@ static void queue_release_one_tty(struct kref *kref)
>  {
>  	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
>  
> +	WARN_ON(work_pending(&tty->port->buf.work));
> +
>  	/* The hangup queue is now free so we can reuse it rather than
>  	   waste a chunk of memory for each port */
>  	INIT_WORK(&tty->hangup_work, release_one_tty);
> 
> /*
>  * pty_thrash.c
>  *
>  * Based on original test jig by Ilya Zykov <ilya@ilyx.ru>
>  */

Yes, ok with me.
Signed-off-by: Ilya Zykov <ilya@ilyx.ru>

> 
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <termios.h>
> #include <stdlib.h>
> #include <errno.h>
> #include <string.h>
> #include <stdarg.h>
> #include <signal.h>
> 
> #define parent child_id
> 
> static int fd;
> 
> static void error_exit(char *f, ...)
> {
> 	va_list va;
> 
> 	va_start(va, f);
> 	vprintf(f, va);
> 	printf(": %s\n", strerror(errno));
> 	va_end(va);
> 
> 	if (fd >= 0)
> 		close(fd);
> 
> 	exit(EXIT_FAILURE);
> }
> 
> int main(int argc, char *argv[]) {
> 	int parent;
> 	char pts_name[24];
> 	int ptn, unlock;
> 
>         while (1) {
> 
> 		fd = open("/dev/ptmx", O_RDWR);
> 		if (fd < 0)
> 			error_exit("opening pty master");
> 		unlock = 0;
> 		if (ioctl(fd, TIOCSPTLCK, &unlock) < 0)
> 			error_exit("unlocking pty pair");
> 		if (ioctl(fd, TIOCGPTN, &ptn) < 0)
> 			error_exit("getting pty #");
> 		snprintf(pts_name, sizeof(pts_name), "/dev/pts/%d", ptn);
> 
> 		child_id = fork();
> 		if (child_id == -1)
> 			error_exit("forking child");
> 
> 		if (parent) {
> 			int err, id, status;
> 			char buf[128];
> 			int n;
> 
> 			n = read(fd, buf, sizeof(buf));
> 			if (n < 0)
> 				error_exit("master reading");
> 			printf("%.*s\n", n-1, buf);
> 
> 			close(fd);
> 
> 			err = kill(child_id, SIGKILL);
> 			if (err < 0)
> 				error_exit("killing child");
> 			id = waitpid(child_id, &status, 0);
> 			if (id < 0 || id != child_id)
> 				error_exit("waiting for child");
> 
> 		} else { /* Child */
> 
> 			close(fd);
> 			printf("Test cycle on slave pty %s\n", pts_name);
> 			fd = open(pts_name, O_RDWR);
> 			if (fd < 0)
> 				error_exit("opening pty slave");
> 
> 			while (1) {
> 				char pattern[] = "test\n";
> 				if (write(fd, pattern, strlen(pattern)) < 0)
> 					error_exit("slave writing");
> 			}
> 
> 		}
> 	}
> 
> 	/* never gets here */
> 	return 0;
> }
> 

Always Welcome.
Ilya.

