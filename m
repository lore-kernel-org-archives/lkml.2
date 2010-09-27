Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab0I0Rht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:37:49 -0400
Received: from claw.goop.org ([74.207.240.146]:42409 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab0I0Rhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:37:48 -0400
Message-ID: <4CA0D660.3010804@goop.org>
Date: Mon, 27 Sep 2010 10:37:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Powertop shows events/0 waking at high rate due to ptys
Content-Type: multipart/mixed;
 boundary="------------050009020700020303030809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050009020700020303030809
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

 Hi,

I noticed on one of my systems that powertop was showing events/0 waking
at a high rate (~2000 times/sec, HZ=1000).  After a lot of tracing I
found it was due to writes pending to ptys which hadn't been read.

Specifically, in flush_to_ldisc(), these lines seem to be causing the
repeated wakeups:

			if (!tty->receive_room) {
				schedule_delayed_work(&tty->buf.work, 1);
				break;
			}

After reading the pending writes the system settles down and wakeups
drops to a normal low level.

The program provoking this was Xen's xenconsoled, which manages running
domains' consoles; the unread output was various domains console
output.  This doesn't seem to be related to Xen at all: Ian Jackson put
together a small standalone program (attached) which reproduces the
problem; he reports that this wakeup behaviour is a regression compared
to a 2.6.16 Debian kernel.

Compile ptypolling with: gcc -o ptypolling ptypolling.c -g -lutil

After running ptypolling, powertop shows events/0 waking at a high
rate.  ptypolling itself is blocked in a select() and is idle.

Thanks,
    J


--------------050009020700020303030809
Content-Type: text/x-csrc;
 name="ptypolling.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ptypolling.c"

/* demonstrate polling wakeup */

#include <unistd.h>
#include <pty.h>
#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

static int master, slave;

int main(void) {
  int r;

  r = openpty(&master,&slave,0,0,0);
  fprintf(stdout,"openpty=%d master=%d slave=%d\n", r, master, slave);
  assert(!r);
  
  r = fcntl(master, F_GETFL);  assert(r>=0);
  r = fcntl(master, F_SETFL, r | O_NONBLOCK);

  char buf[400];
  int i;
  for (i=0; i<sizeof(buf)-2; i+=2)
    sprintf(buf+i, "%02x", i);
  buf[sizeof(buf)-2]= '\r';
  buf[sizeof(buf)-1]= '\n';
  
  fd_set writefds;
  for (;;) {
    FD_ZERO(&writefds);
    FD_SET(master, &writefds);
    fprintf(stdout,"select\n");
    r= select(master+1, 0,&writefds,0, 0);
    if (r==-1) {
      fprintf(stdout,"select-fail %s\n", strerror(errno));
      continue;
    }
    assert(r==1);
    assert(FD_ISSET(master, &writefds));

    fprintf(stdout,"write\n");
    r= write(master,buf,sizeof(buf));
    if (r==-1) {
      fprintf(stdout,"write-fail %s\n", strerror(errno));
      continue;
    }
    assert(r>=0 && r<=sizeof(buf));
    fprintf(stdout,"wrote %d\n",r);
  }
}

--------------050009020700020303030809--
