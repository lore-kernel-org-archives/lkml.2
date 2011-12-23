Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1LWPFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:05:47 -0500
Received: from mx2.compro.net ([12.186.155.4]:62788 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab1LWPFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:05:44 -0500
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Dec 2011 10:05:44 EST
X-IronPort-AV: E=Sophos;i="4.71,399,1320642000"; 
   d="scan'208";a="7421546"
Message-ID: <4EF49579.9040907@compro.net>
Date: Fri, 23 Dec 2011 09:51:37 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: tty  TTY_HUPPED anomaly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an application that has seemingly been stable for many years and 
even using the 3.1.1 kernel all is fine. I'm using the openSuSE 
distribution. All is good with the openSuSE-11.4 dist and the 3.1.1 
kernel. We recently started testing this application on openSuSE-12.1 
using the same  vanilla 3.1.1 kernel and now we have problems with just 
about all out tty/serial related devices that we use. I thought the 
problem maybe an openSuSE glibc problem so I built and ran the 
openSuSE-12.1 version of glibc on the openSuSE-11.4 dist but the 
application worked just fine. So I started looking at the kernel and one 
of our serial devices that fails. I choose the Synclink GT because its 
driver is "in kernel".

In our application with this particular card, the following TIOCSETD 
ioctl is this code snippet  fails most of the time.

     int32_t hdlc_disc = N_HDLC;

     Q->fd = open(Q->FileName, (O_RDWR | O_NONBLOCK), 0);

     if (Q->fd < 0)
            return (FALSE);

     Q->File = fdopen(Q->fd, "rw");

     fcntl(Q->fd, F_SETFL, fcntl(S->fd,F_GETFL) & ~O_NONBLOCK);

     if (ioctl(Q->fd, TIOCSETD, &hdlc_disc) < 0) {
         perror("SCM_open_port: TIOCSETD failed: ");
         return (FALSE);
     }


The kernel code that results in the above code snippet failure is the 
following section of the tty_set_ldisc function in tty_io.c.

         if (test_bit(TTY_HUPPED, &tty->flags)) {
                 /* We were raced by the hangup method. It will have stomped
                    the ldisc data and closed the ldisc down */
                 clear_bit(TTY_LDISC_CHANGING, &tty->flags);
                 mutex_unlock(&tty->ldisc_mutex);
                 tty_ldisc_put(new_ldisc);
                 tty_unlock();
                 return -EIO;
         }

I do not really understand what TTY_HUPPED is or how it could be getting 
set. I look at it when the tty_set_ldisc function is entered and it is 
not set. Some where between entrance of the tty_set_ldisc and getting to 
the above code TTY_HUPPED gets set causing the -EIO return.

I see nothing in my code that should cause this to happen. At start up 
time a thread for each port used does this then goes to sleep. Again, I 
can't understand why now with openSuSE-12.1 this starts happening. Can 
someone help me understand why this might happen. I don't know if it is 
me, the dist, or the kernel. Frequently it all works at startup and will 
eventually fail during operation.

Other serial cards that I also have similar problems with (different 
ioctls) are various Digi serial cards. I haven't look into the kernel to 
see what is happening with those as yet but am sure the problem is 
related. Sometimes they work, most of the time they do not.

Many thanks in advance
Mark
