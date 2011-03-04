Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab1CDOcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:32:19 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:52283 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562Ab1CDOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:32:17 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 09:32:17 EST
Date: Fri, 4 Mar 2011 15:23:48 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ken Mills <ken.k.mills@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Usage of the n_gsm line discipline
Message-ID: <20110304152348.5d03c8ef@surf>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(Sorry for posting on LKML, but there doesn't seem to be any specific
list for TTY stuff, according to MAINTAINERS).

I have followed with interest the development of the n_gsm line
discipline to multiplex a serial GSM modem. I have a Telit GE865 QUAD
GPRS modem [1], for which the datasheet [2] says that it supports 3GPP
TS 27.010 for multiplexing.

Therefore, I wanted to use the n_gsm line discipline in order to be
able to make data connections and do SMS emission/reception
concurrently.

My GSM modem is on /dev/ttyS2 and works fine :

===================================================================
# picocom -e b -b 115200 /dev/ttyS2 
picocom v1.6

port is        : /dev/ttyS2
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
[...]

Terminal ready
AT
OK
===================================================================

I am able to send SMS with AT commands and make GPRS data connections
using pppd, so the modem seems to be working fine.

As the n_gsm line discipline doesn't seem to have a documentation, I
started with the following C program to set the n_gsm line discipline
on my modem :

===================================================================
#define N_GSM0710       21      /* GSM 0710 Mux */

int main(void)
{
	int fd, ret;
	struct termios t;
	int ldisc = N_GSM0710;

	fd = open("/dev/ttyS2", O_RDWR);
	assert(fd >= 0);

	tcgetattr(fd, &t);
	cfsetispeed(&t, B115200);
	cfsetospeed(&t, B115200);
	t.c_iflag &= ~(IXON | IXOFF);
	t.c_lflag &= ~CRTSCTS;
	ret = tcsetattr(fd, TCSANOW, &t);
	assert(ret == 0);

	ret = ioctl(fd, TIOCSETD, & ldisc);
	if (ret) {
		printf("Error occured: %s\n", strerror(errno));
		return -1;
	}

	while(1)
		sleep(10);

	return 0;
}
===================================================================

I start this program, with the n_gsm module loaded. Then I create a
device node for gsmtty1 :

	mknod /dev/gsmtty1 c 252 1

where 252 is the major of n_gsm :

	# cat /proc/devices | grep gsmtty
	252 gsmtty

(from the code, I understood that gsmtty0 is the control channel, that
the multiplexer uses to communicate with the modem, so that gsmtty1 is
the first available channel).

Then I start picocom on /dev/gsmtty1, and I expect to be able to send
normal AT commands to the modem. Unfortunately, picocom doesn't
recognize it as a valid tty :

===================================================================
# picocom -e b -b 115200 /dev/gsmtty1 
picocom v1.6

port is        : /dev/gsmtty1
flowcontrol    : none
baudrate is    : 115200
parity is      : none
databits are   : 8
[...]

FATAL: term closed
term_exitfunc: reset failed for dev UNKNOWN: Input/output error
===================================================================

strace shows which ioctl() is failing:

===================================================================
open("/dev/gsmtty1", O_RDWR|O_NONBLOCK) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or TCSETSF, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_CONTINUE or TCSETSF, {B38400 -opost -isig -icanon -echo ...}) = 0
[...]
ioctl(3, TCFLSH, 0x2)                   = -1 EIO (Input/output error)
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbec9773c) = -1 EIO (Input/output error)
write(2, "term_exitfunc: reset failed for "..., 64term_exitfunc: reset failed for dev UNKNOWN: Input/output error
) = 64
===================================================================

So, maybe I misconfigured n_gsm, or I didn't understand how to use it.
Would it be possible to have a few details on how it is supposed to be
used ? I haven't been able to find any userspace code that currently
makes use of n_gsm. Is it available somewhere ?

If I can get it to work, I am willing to contribute a
Documentation/n_gsm.txt document.

Finally, I'm using current git, i.e I have all the latest n_gsm changes
that are upstream. I'm at b65a0e0c84cf489bfa00d6aa6c48abc5a237100f.

Thanks a lot,

Thomas Petazzoni

[1] http://www.telit.com/en/products/gsm-gprs.php?p_ac=show&p=47
[2] http://www.telit.com/module/infopool/download.php?id=1484
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
