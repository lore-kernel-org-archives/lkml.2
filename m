Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1JQWuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:50:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab1JQWt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:49:59 -0400
Date: Tue, 18 Oct 2011 09:49:50 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111018094950.22d282a3@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110171030440.2430-100000@iolanthe.rowland.org>
References: <20111017093401.21cd4461@notabene.brown>
	<Pine.LNX.4.44L0.1110171030440.2430-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4HuwDH/g.IbJP/Z/KdoaY7Z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4HuwDH/g.IbJP/Z/KdoaY7Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 10:45:59 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Mon, 17 Oct 2011, NeilBrown wrote:
>=20
> > > The more I think about this, the better it seems.  In essence, it=20
> > > amounts to "virtualizing" the existing PM interface.
> >=20
> > While "virtualizing" does sound attractive in some way, I think it woul=
d be
> > the wrong thing to do.
> > In practice there is only one process at a time that is likely to suspe=
nd
> > the system.  I've just been exploring how that works.
> >=20
> > gnome-power-manager talks to upowerd over dbus to ask for a suspend.
> > upowerd then runs /usr/sbin/pm-suspend.
> > pm-suspend then runs all the script in /usr/lib/pm-utils/sleep.d/
> > and the calls "do_suspend" which is defined in /usr/lib/pm-utils/pm-fun=
ctions
> >=20
> > Ugghh.. That is a very deep stack that is doing things the "wrong" way.
> > i.e. it is structured about request to suspend rather than requests to =
stay
> > awake.
> >=20
> > Nonetheless, we only really need to worry about the bottom of the stack.
> > Rather than virtualize /sys/power/state, just modify pm-function, which
> > you can probably do by putting appropriate content
> > into /usr/lib/pm-utils/defaults.
> > Get that to define a do_suspend which interacts with the new suspend-da=
emon
> > to say "now would be a good time to suspend" - if nothing else is block=
ing
> > suspend, it does.
> >=20
> > Put it another way:  power-management has always been "virtualized" via=
 lots
> > of shell scripts in pm-utils (and various daemons stacked on top of tha=
t).
> > We just need to plug in to that virtualisation.
> >=20
> > This is all based on gnome.  kde might be different, but I suspect that=
 it
> > only at the top levels.  I would be surprised if kde and the other desk=
tops
> > don't all end up going through pm-utils.
>=20
> Okay, good; that allows us to avoid the virtualization issue.  The only
> reason for having it in the first place was to be certain of working
> with userspace environments that don't use a standard, structured
> method for initiating system sleeps.  If you don't care about those=20
> environments then there's no need for it.
>=20
> Do we agree about the best way to make this work?  I'm suggesting that
> when the PM daemon is started up with a "legacy" option, it should
> assume the existence of a predefined client that always wants to keep
> the system awake, except for brief periods whenever a sleep request is
> received from a new pm-utils program.  Maybe this new program could
> pass the PM daemon a time limit (such as 3000 ms), with the requirement
> that if the daemon can't put the system to sleep within that time limit
> then it should give up and fail the sleep request.
>=20
> Alan Stern

We do seem to be approaching some sort of agreement ... well I am at least,
I cannot speak for others :-)

Yes it should start in a 'legacy' mode except that I think 'legacy' isn't
quite the right word as this is a mode that will always be needed to avoid
start-up races.

I don't see a real value in the 3000ms (though I don't really care one way =
or
the other).
I think there are - on a current desk top - two sorts of 'suspend now'
requests.
One comes from the desktop power manager (g-p-m?) and means "things have be=
en
idle for a while, lets go to sleep". If the suspend daemon notices that
thinks aren't idle right *now*, it probably doesn't want to go to sleep.
The other comes from an explicit button press (whether a hard button or a
soft on-screen button) and mean "Must go to sleep now - master putting us in
a padded bag and we must stay cool".
In that case we could possibly delay a couple of seconds, but really do want
to go to sleep and what is more, we don't want to wake up again except by a
button press/lid opening.
Such a request should possibly disable timers and make sure the wifi is off
and not responding to wake-on-wlan.  I haven't really thought that issue
through yet so it isn't included in the following/.

However for the bits that I feel I do understand, this is what I (currently)
think it should (or could) look like.


1/ There is a suspend-management daemon that starts very early and is the o=
nly
   process that is allowed to initiate suspend or hibernate.  Any other
   process which tries to do this is a BUG.

2/ The daemon has two modes:
   A/ on-demand.  In this mode it will only enter suspend when requested to,
      and then only if there is nothing else blocking the suspend.
   B/ immediate.  In this mode it will enter suspend whenever nothing is
      blocking the suspend.  The daemon is free to add a small delay
      proportional to the resume latency if so configured.
   The daemon is in on-demand mode at start up.

3/ The daemon can handle 5 sorts of interactions with clients.

   i/ Change mode - a request to switch between on-demand and immediate mod=
e.
  ii/ suspend now - a request to suspend which is only honoured if no client
      has blocked suspend, and if the kernel is not blocking suspend.
      Thus it is meaningless in immediate mode.
 iii/ be-awake-after - this request carries a timestamp and is stateful - it
      must be explicitly cancelled.  It requests that the system be fully
      active from that time onwards.
  iv/ notify - this establishes a 'session' between client and server.
      Server will call-back and await respond before entering suspend and
      again after resuming (no response needed for resume).
      The client is explicitly permitted to make a be-awake-after request
      during the suspend call-back.
   v/ notify-fd.  This is a special form of 'notify' which carries a file
      descriptor.  The server is not required to (and not expected to)
      initiate the 'suspend' callback unless the fd is reporting POLL_IN or
      POLL_ERR while preparing for suspend.

4/ The daemon manages the RTC alarm.  Any other process programing the alarm
   is a BUG.  Before entering suspend it will program the RTC to wake the
   system at (or slightly before) the time of the earliest active
   be-awake-after request.

5/ Possible implementation approaches for the client interactions:
   I/ A SOCK_STREAM unix domain socket which takes commands.
     On connect, server says "+READY".
     Client writes "MODE ON-DEMAND" or "MODE IMMEDIATE"
     Server replies "+MODE $MODE"

  II/ The same unix domain socket as I.=20
     Client writes "SUSPEND"
     Server replies "+RESUMED" if the suspend happened, or
                    "-BUSY"  if it didn't.
     +RESUMED is no guarantee that an measurable time was in suspend, so
     maybe it isn't needed.

 III/ A separate Unix domain socket.
     On connect, server says "Awake" meaning that this connection is ensuri=
ng
     the system will be awake now.
     Client can write a seconds-since-epoch number, which the server will e=
cho
     back when confirmed.  When that time arrives - which might be immediat=
ely
     - the server will write "Awake" again.
     When the client closes the connection, the suspend-block is removed.

  IV/ A third Unix domain socket.
     On connect, server writes a single character 'A' meaning 'system is
     awake'.
     When initiating suspend, server writes 'S' meaning 'suspend soon'.
     Client must reply to each 'S' with 'R' meaning 'ready'.  Server does n=
ot
     enter resume until the 'R' is received.
     On resume, server will write 'A' meaning 'awake' again.  Many clients
     might ignore this.

   V/ Same socket as IV, with extra message from client to server.
     Client writes 'M' (monitor) in a message with SCM_RIGHTS containing one
     or more fds.  Server will now only send 'S' when one or more of those =
fds
     are readable, but the client cannot rely on that and must (as always)
     not assume that a read will succeed, or will not block.

6/ The daemon may impose access control on be-awake messages.  In the above
   protocol it could be based on SCM_CREDENTIAL messages which might be
   required.
   It may also impose timeout on the 'R' reply from the 'S' request, or at
   least log clients which do not reply promptly.

7/ A client should not delay at all in replying to 'suspend
   soon' (S) with 'ready' (R).  It should only check if there is anything to
   do and should make a stay_awake request if there is something.  Then it
   must reply with 'R'.
   I should *not* use the fact that suspend is waiting for its reply to
   respond to an event as this misleads other clients as to the true state =
of
   the system.

8/ I haven't treated hibernate here.  My feeling is that it would be a
   different configuration for the daemon.
   If hibernate were possible and the soonest stay-awake time were longer
   than X in the future, then the daemon might configure the RTCalarm for X,
   and when that arrives, it pops out of suspend and goes into hibernate.
   But the details can wait for revision 2 of the spec..


NeilBrown

--Sig_/4HuwDH/g.IbJP/Z/KdoaY7Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpyxDznsnt1WYoG5AQIfChAAkZT2/5zelRjBrJ57esYhLXTvJrL/FSVU
Zlcj2mah3XPmCSXBlgDe06PVLLhTPHBIOi94dfZOJ36/IKxov+P/IOYj97QXBOwR
Uau9ulLJsqrOzYxoVhb1jEohet2NCLNtwQjNM9IbXXglN3d+ITCUSR6SJ19jorm0
AwQgzNxvG/mzNRz7sLbBx6zjahkQeYjCyarjx4NKciK051ranaIkLTdU/hlMVwn5
FJ6BAeIU7V8oIxxlZIC6NLR9skTjFRlAVNliYei34BWASIzDiNdjCnkCfb/3UEZP
bXExfw8/USi4lwOx1algyLkZqdvMWkoG9V/E+vHqBWXD8n/0P6XoVR3SJ1noM/IF
4q6GGdtniHlCF2Zi9VSGBL5h7/jCEFnhSGeqAyTJqjwyvzQw7+S/GMonZeEDVqFV
U1PqU0PCjfkdFj2d7O+0C6tnnmx7eWfKl4r9aJaRYnl+kFcnwmrtu41xp4a+9U3a
YsMJD+4ZBW7JF3OIIxG1pShR/QFm03n1w8JFyCZdtzKR3vN1kXFeUxxi/AnBAexo
oYNQDWDgq2kL1LQY9VIUKNmL8YQxzOxW+BxiSaEeArt5o52n5s75AX7zer0jEpFz
fvfIhn+WIIp1ypHuOFexEf+E3ml1IQOi1QcnFJZh1kLTwqWkZ/FG8/35gFfA735V
VnnCKUw3snI=
=2IF7
-----END PGP SIGNATURE-----

--Sig_/4HuwDH/g.IbJP/Z/KdoaY7Z--
