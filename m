Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab1IIN0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:26:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55125 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab1IIN0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:26:11 -0400
MIME-Version: 1.0
From: Maciek Borzecki <maciek.borzecki@gmail.com>
Date: Fri, 9 Sep 2011 15:25:50 +0200
Message-ID: <CALGyLaiXhtceaJxni9ttjMfzx6K326_CVccJiifAhXfNszdgsg@mail.gmail.com>
Subject: pselect semantics - no EINTR with pending signals
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running a deamon application, which listens on a number of
sockets, and occasionally spawns gzip to compress some data. It does
happen so, that pselect is used for mutliplexing IO. It also doest
happen so that on one of the fds there is always data to be read (just
a peculiarity of the application, a lot of clients are constantly
writing to a datagram socket and once the daemon is started there is
always data to be read).
That's more less how the code goes:
int main(..)
{
    sigset_t blockset;
    sigset_t oldset;
    ...
    signal(SIGCHLD, ...);
    sigemptyset(&blockset);
    sigaddset(&blockset, SIGCHLD);
    sigprocmask(SIG_SETMASK, &blockset, &oldset);
    ...

    while (1)
    {
        int ret = pselect(maxfd, fdset, NULL, NULL, NULL, &oldset);
        /* ret is always > 0 */

        {
            sigset_t pendset;
            sigpending(&pendset);
            /* apparenty SIGCHLD is present in pending set */
        }
    }
}

What happens is that once a child is spawned, and exists emitting a
SIGCHLD, the signal remains in the pending set. It can only be
determined that the signal was raised by looking at the pending mask.
It is also the case, that SIGCHLD is present in pending set before
entering pselect at some point. However none of the signal handlers
are called.
I looked 2.6.39 do_pselect and it seems that the signal handlers would
only be delivered once core_sys_select returns ERESTARTNOHAND, however
since there is always something to be read on the fds, core_sys_select
always returns value > 0. In that case set_restore_sigmask is never
called, and TIF_SIGPENDING is never set.
So it seems that there is no chance of having the signals delivered
unless pselect blocks waiting for I/O

Now, I'm not sure about the semantics of pselect. I'm not saying that
the current version is right or wrong, but raising a question if this
is really expected (and it did happen to be quite unexpected for me).

--
Maciek Borzecki
