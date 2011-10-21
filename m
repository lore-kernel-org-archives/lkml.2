Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1JUFXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 01:23:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1JUFXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 01:23:47 -0400
Date: Fri, 21 Oct 2011 16:23:40 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: lsusd - The Linux SUSpend Daemon
Message-ID: <20111021162340.669742c0@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
References: <20111020111743.13b40558@notabene.brown>
	<Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0obj_EPRIqBGQAkwP2xDo.x"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0obj_EPRIqBGQAkwP2xDo.x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi,

I wasn't going to do this... but then I did.  I think that sometimes coding=
 is
a bit like chocolate.

At:
    git://neil.brown.name/lsusd
or
    http://neil.brown.name/git/lsusd

you can find a bunch of proof-of-concept sample code that implements a
"Linux SUSpend Daemon" with client support library and test programs.

I haven't actually tested it as root and had it actually suspend and resume
and definitely haven't had it even close to a race condition, but the
various bits seem to work with each other properly when I run them under
strace and watch.

It didn't turn out quite the way I imagined, but then cold harsh reality has
a way of destroying our dreams, doesn't it :-)


Below is the README file.  Comment welcome as always.
I'm happy for patches too, but I'm equally happy for someone to re-write it
completely and make something really useful and maintainable.

NeilBrown

-----------------------------------------------------------------

This directory contains a prototype proof-of-concept system
for managing suspend in Linux.
Thus the Linux SUSpend Daemon.

It contains:

 lsusd:
    The main daemon.  It is written to run a tight loop and blocks as
     required.  It obeys the wakeup_count protocol to get race-free
     suspend and allows clients to register to find out about
     suspend and to block it either briefly or longer term.
    It uses files in /var/run/suspend for all communication.

    File are:

      disabled:  This file always exists.  If any process holds a
        shared flock(), suspend will not happen.
      immediate:  If this file exists, lsusd will try to suspend whenever
        possible.
      request:  If this is created, then lsusd will try to suspend
        once, and will remove the file when suspend completes or aborts.
      watching:  This is normally empty.  Any process wanting to know
        about suspend should take a shared flock and check the file is
        still empty, and should watch for modification.
        When suspend is imminent, lsusd creates 'watching-next', writes
         a byte to 'watching' and waits for an exclusive lock on 'watching'.
        Clients should move their lock to 'watching-next' when ready for
        suspend.
        When suspend completes, another byte (or 2) is written to
        'watching', and 'watching-next' is renamed over it.  Clients can
        use either of these to know that resume has happened.

      watching-next: The file that will be 'watching' in the next awake cyc=
le.

    lsusd does not try to be event-loop based because:
      - /sys/power/wakeup_count is not pollable.  This could probably be
        'fixed' but I want code to work with today's kernel.  It will proba=
bly
        only block 100msec at most, but that might be too long???
      - I cannot get an event notification when a lock is removed from a
        file. :-(  And I think locks are an excellent light-weight
        mechanism for blocking suspend.

  lsused:
      This is an event-loop based daemon that can therefore easily handle
      socket connections and client protocols which need prompt
      response.  It communicates with lsusd and provides extra
      services to client.

      lsused (which needs a better name) listens on the socket
            /var/run/suspend/registration
      A client may connect and send a list of file descriptors.
      When a suspend is immanent, if any file descriptor is readable,
      lsused will send a 'S' message to the client and await an 'R' reply
      (S =3D=3D suspend, R =3D=3D ready).  When all replies are in, lsused =
will
      allow the suspend to complete.  When it does (or aborts), it will send
      'A' (awake) to those clients to which it sent 'S'.

      This allows a client to get a chance to handle any wakeup events,
      but not to be woken unnecessarily on every suspend.

   wakealarmd:
      This allows clients to register on the socket.
             /var/run/suspend/wakealarm
      They write a timestamp in seconds since epoch, and will receive
      a 'Now' message when that time arrives.
      Between the time the connection is made and the time a "seconds"
      number is written, suspend will be blocked.
      Also between the time that "Now" is sent and when the socket is
      closed, suspend is also blocked.

   request_suspend:
      A simple tool to create the 'request' file and then wait for it
      to be removed.

   libsus.a:  A library of client-side interfaces.
      suspend_open, suspend_block, suspend_allow, suspend_close:
           easy interface to blocking suspend
      suspend_watch, suspend_unwatch:
           For use in libevent program to get notifications of
           suspend and resume via the 'watching' file.
      wake_set, wake_destory:
           create a libevent event for an fd which is protected from
           suspend. Whenever it is readable, suspend will not be entered.
      wakealarm_set, wakealarm_destroy:
           create a libevent event for a particular time which will
           trigger even if system is suspend, and will protect against
           suspend while event is happening.


   block_test watch_test event_test alarm_test
        simple test programs for the above interfaces.


    suspend.py  dnotify.py:
       Sample code for detecting suspend/resume from python
    block.sh test_block.sh:
       Sample code for disabling suspend from shell.

All code is available under GPLv2+.  However if you ask for a different
license I am unlikely to refuse (at least with the early prototype).

Patches and comment are welcome, but please also feel free to include
any of this in some more complete framework.

--Sig_/0obj_EPRIqBGQAkwP2xDo.x
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqEB3Dnsnt1WYoG5AQKJ6A//bS1W/hzdQVRnlGrAakr2do1GCdsxlGI9
tAKDvMN6UeAfj/SOdtkx9hk8ffO+mH7rBhubY501KozMRTp3URhcJV/6HCi4A5lq
G9CjvjqqqhuaGqHJgh5wYySqHFvmpZnJDaCrpN8HFXEi8AE2zgg50euVyBmMT4F+
lnRlFZzAtL7MU6gTsyaDxEhryo8kDHbpM0aAa7+iN6ulMaM/pH9EMGci/ZPZCLfQ
u3OjDr0CNZAKaD9rmGS9o2srxqVH55VsZC66vTbLPdjERgkAnpGz1Mb39GSMHAMP
7yGCZjVHbW0xxrmAVTpVzhnZGqzxbpC7eriINK7cCOklaWD2wZLGgh1gReCNseet
s8N1gWra/sl358ofcBUibYEWmdo2QHecYaBCUpu90wOHIy+fQTqCyCQR+cj4VLae
pf7ik0NNfrmv/kErvSrh13sngSh8gKJWrwYi72KEJjdM5yL9eguhskByAbLXjkyj
40GdtAPiNgVG0Dt9XRV3X3j//5xqOx6HQxmsSbdq9sYS/ZoDMgpbP8yoNrT+j40X
w/hT1m/6/bOcFhw8yCg9++58zG0MKceodRuYFQKFmc3e6T6fI2uFygq1iwPAK18v
8vGhwqS7sDpEcc1lG39H5uf89PHjCnAUm7dNr1Qvy2zD7xYEHxuUo8+eaKF7We3o
yxb0ZGYl1Mc=
=XNXd
-----END PGP SIGNATURE-----

--Sig_/0obj_EPRIqBGQAkwP2xDo.x--
