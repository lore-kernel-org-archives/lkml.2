Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1JWDbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 23:31:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab1JWDbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 23:31:41 -0400
Date: Sun, 23 Oct 2011 14:31:37 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
Message-ID: <20111023143137.78c1f9c4@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110221223480.20346-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org>
	<Pine.LNX.4.44L0.1110221223480.20346-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IrW6S87nCoOww5.25HhhxXN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IrW6S87nCoOww5.25HhhxXN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Oct 2011 12:31:58 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Fri, 21 Oct 2011, Alan Stern wrote:
>=20
> > > Maybe we could do something with futexes...
> >=20
> > Not easily -- as far as I can tell, futexes enjoy relatively little=20
> > support.  In any case, they provide the same service as a mutex, which=
=20
> > means you'd have to build a shared lock on top of them.
>=20
> It occurred to me that we could create a new type of special file, one
> intended to help with interprocess synchronization.  It would support
> locking (shared or exclusive, blocking or non-blocking) and the poll
> system call -- the file would appear to be ready for reading whenever a
> shared lock wouldn't block and ready for writing whenever an exclusive
> lock wouldn't block.  Actual reads and writes wouldn't have to do=20
> anything, although maybe someone could suggest a use for them.
>=20
> Alan Stern

Tempting...  We would need a good case to get something included, but not to
just experiment.

The approach that I would take would probably be to extent flock() with a n=
ew
flag, e.g. LOCK_POLL.
then
  flock(fd, LOCK_EX | LOCK_POLL)

would try to get a non-blocking exclusive lock on 'fd'.  If that didn't
succeed it would insert a 'block' anyway [locks_insert_block()] and arrange
so that when the lock might succeeds, fd gets marked to say that 'lock' mig=
ht
succeed.
Then POLLPRI becomes enabled and select will trigger if the fd is listed in
the 'exceptfds'.

I would then extend that so that lease breaking and dnotify notifications
could come through select/poll rather than as signals...

But this is probably going somewhat off-topic.

NeilBrown

--Sig_/IrW6S87nCoOww5.25HhhxXN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqOKmTnsnt1WYoG5AQIGjA//cK8AOYVbdsexjcYCtrcKlvzZccRUV+7R
9NACSwDZLTYT7aZR0LGyJjZ+XxrBXEVgo8cFf3KWwig5AZKohc+u5NsbMTa1go6p
tssnru0TkkFchUHojNHADWOgnDGhfoPFd46LYzLVOrTpcHVa2gWUTtAlOeuOVvu6
WgosB/HG4mqhdz1P281hEIa3nBjrC9dNrTQbod+QVq6G6YvaC7dcyU6Lx3gM8Ioi
BqO0467ab4Sqgv2dyDUEiq3povi0jcKsWAoEf+71EnbksHb3ySGKdbF748I3I8/v
RjrklCrd+ZasGox5kSsIztSVy7u+DEwKGI7siyi6LdV4QAEQw7GiaCZdbaTh/g1/
+pUQA0aD87gpsS4qn1kFdoRT8tls6MH3BfAw80DYzasexf5+/efRBbyLhpn6SjYN
UGgif32TlUMa+QUMo36LpZB4xyEuOFjbqckyej+qOej1/IPiFnaAI8yw7Iab6/Sh
5MjsuE6D1S7Qiiu5RJesoCKHoKuljj+FMv3SA3+gUI+B0hB2nCNQD0eIr0RaFUTa
hiZIeEFBfFlGmTwkDbqu8Eoo3ZTqsCzZYh4qBVxrA9tMB7mHmQPIOwplH5uvtVPf
QDR1WAU29EiDOiTCaz72u1VI6uUh4FCZmnL/tQEdX2jmkuNsqzAJLEgTEQn2cthE
wlipMQXOaww=
=evr0
-----END PGP SIGNATURE-----

--Sig_/IrW6S87nCoOww5.25HhhxXN--
