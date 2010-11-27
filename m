Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0K0JoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 04:44:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57410 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0K0Jn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 04:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=PEakkukle7B9B8NgpYU1VNmSNttO8TlCjQvUAC6ldsk2t5zWx9qDDl8tK+ymoMv1ES
         jyZfUJSwxJ2DhX4xXW7Jon3TV4CpY9uLXg2DCnfo7jo7+iOwbnU3dWjtR6znd6+CdxWA
         kz2/unPjCs6iLECGSmuT4WD0INeUiGFscq3go=
Message-ID: <4CF0D2DA.20105@suse.cz>
Date: Sat, 27 Nov 2010 10:43:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
CC: Kyle McMartin <kyle@mcmartin.ca>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
References: <4CEE93FF.3040507@suse.cz> <1290705383-6608-1-git-send-email-jslaby@suse.cz> <20101126002840.GL22651@bombadil.infradead.org> <4CEF65CA.9020403@suse.cz> <20101127025954.GA15818@bombadil.infradead.org> <4CF0C65E.2010104@suse.cz>
In-Reply-To: <4CF0C65E.2010104@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------090109060409090309000704"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090109060409090309000704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/27/2010 09:50 AM, Jiri Slaby wrote:
> On 11/27/2010 03:59 AM, Kyle McMartin wrote:
>> I'm poking around to see, I think maybe something might be dropping
>> locks in the callchain that gives us a window where this might be
>> possible...
> 
> Of course, that's the case:
>         clear_bit(TTY_LDISC, &tty->flags);
>         tty_unlock();
>         cancel_delayed_work_sync(&tty->buf.work);
>         mutex_unlock(&tty->ldisc_mutex);
> 
>         tty_lock();
>         mutex_lock(&tty->ldisc_mutex);
> 
> in tty_ldisc_hangup. Hence my point 1) from previous posts doesn't hold too:
> 1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
> section tty_lock is held.
> 
> I will check, how to fix this.

Reproducible with 2 running processes from the attachment.

regards,
-- 
js
suse labs

--------------090109060409090309000704
Content-Type: text/x-csrc;
 name="tty_reopen.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tty_reopen.c"

#include <err.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

static void do_work(const char *tty)
{
	char buf[256];
	unsigned int cnt = 0;
	unsigned int errc = 0;
	int fd, con;

	if (signal(SIGHUP, SIG_IGN) == SIG_ERR)
		err(1, "signal(SIGHUP)");

	setsid();

	con = open("/tmp/aaa", O_WRONLY|O_NOCTTY|O_CREAT);
	if (con < 0)
		err(2, "open cons");

	while (1) {
		if (!(cnt++ % 10000)) {
			int len = sprintf(buf, "err=%x\n", errc);
			write(con, buf, len);
			errc = 0;
		}
		fd = open(tty, O_RDWR|O_NOCTTY);
		if (fd < 0) {
			errc |= 1;
			continue;
		}
		if (ioctl(fd, TIOCSCTTY)) {
			errc |= 2;
			continue;
		}

		if (vhangup()) {
			errc |= 4;
			continue;
		}
		close(fd);
	}
	close(con);
	exit(errc);
}

int main(int argc, char **argv)
{
	pid_t pid;

	switch (pid = fork()) {
	case 0:
		do_work(argv[1]);
		break;
	case -1:
		err(1, "fork");
		break;
	default:
	{
		int stat;
		waitpid(pid, &stat, 0);
		if (stat) {
			fprintf(stderr, "exited with: %d sig=%d signr=%u\n",
					WEXITSTATUS(stat), WIFSIGNALED(stat),
					WTERMSIG(stat));
		}
		break;
	}
	}

	return 0;
}

--------------090109060409090309000704--
