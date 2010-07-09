Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0GIOMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:12:25 -0400
Received: from 101-97.80-90.static-ip.oleane.fr ([90.80.97.101]:36426 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0GIOMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:12:24 -0400
Date: Fri, 9 Jul 2010 16:13:24 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 2/2] pidns: Remove proc flush races when a pid
	namespaces are exiting.
Message-ID: <20100709141324.GC18586@hawkmoon.kerlabs.com>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linux Containers <containers@lists.osdl.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
References: <20100625102303.GG3773@hawkmoon.kerlabs.com> <20100625183733.GA2627@us.ibm.com> <20100625192945.GA25532@redhat.com> <20100625212618.GA11917@us.ibm.com> <20100625212758.GA30474@redhat.com> <20100625220713.GA31123@us.ibm.com> <m1r5jd5l0v.fsf_-_@fess.ebiederm.org> <m1mxu15kv4.fsf_-_@fess.ebiederm.org> <20100709121425.GB18586@hawkmoon.kerlabs.com> <m1lj9k4xfx.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-5569-1278684730-0001-2"
Content-Disposition: inline
In-Reply-To: <m1lj9k4xfx.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-5569-1278684730-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09/07/10  6:05 -0700, Eric W. Biederman wrote:
> Louis Rilling <Louis.Rilling@kerlabs.com> writes:
>=20
> > On 08/07/10 21:39 -0700, Eric W. Biederman wrote:
> >>=20
> >> Currently it is possible to put proc_mnt before we have flushed the
> >> last process that will use the proc_mnt to flush it's proc entries.
> >>=20
> >> This race is fixed by not flushing proc entries for dead pid
> >> namespaces, and calling pid_ns_release_proc unconditionally from
> >> zap_pid_ns_processes after the pid namespace has been declared dead.
> >
> > One comment below.
> >
> >>=20
> >> To ensure we don't unnecessarily leak any dcache entries with skipped
> >> flushes pid_ns_release_proc flushes the entire proc_mnt when it is
> >> called.
> >>=20
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >> ---
> >>  fs/proc/base.c         |    9 +++++----
> >>  fs/proc/root.c         |    3 +++
> >>  kernel/pid_namespace.c |    1 +
> >>  3 files changed, 9 insertions(+), 4 deletions(-)
> >>=20
> >> diff --git a/fs/proc/base.c b/fs/proc/base.c
> >> index acb7ef8..e9d84e1 100644
> >> --- a/fs/proc/base.c
> >> +++ b/fs/proc/base.c
> >> @@ -2742,13 +2742,14 @@ void proc_flush_task(struct task_struct *task)
> >> =20
> >>  	for (i =3D 0; i <=3D pid->level; i++) {
> >>  		upid =3D &pid->numbers[i];
> >> +
> >> +		/* Don't bother flushing dead pid namespaces */
> >> +		if (test_bit(PIDNS_DEAD, &upid->ns->flags))
> >> +			continue;
> >> +
> >
> > IMHO, nothing prevents zap_pid_ns_processes() from setting PIDNS_DEAD a=
nd
> > calling pid_ns_release_proc() right now. zap_pid_ns_processes() does no=
t wait
> > for EXIT_DEAD (self-reaping) children to be released.
>=20
> Good point we need something probably a lock to prevent proc_mnt from
> going away here.  We might do a little better if we were starting with
> a specific dentry, those at least have some rcu properties but that isn't
> a big help.
>=20
> Hmm.  Perhaps there is a way to completely restructure this flushing
> of dentries.  It is just an optimization after all so we don't get too ma=
ny
> stale dentries building up.
>=20
> It might just be worth it simply kill proc_flush_mnt altogether.  I know
> it is measurable when we don't do the flushing but perhaps there can
> be a work struct that periodically wakes up and smacks stale proc dentrie=
s.
>=20
> Right now I really don't think proc_flush_task is worth the hassle it
> causes.

Indeed, proc_flush_task() seems to be the only bad guy trying to access
pid_ns->proc_mnt after the death of the init process.

But I don't know enough about the performance impact of removing it.

Louis

>=20
> Grumble, Grumble more thinking to do.
>=20
> Eric
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-5569-1278684730-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkw3LoQACgkQVKcRuvQ9Q1TZYwCdF0hDAPJjDiurc9192I0ijLTs
FqwAn3L5GDtb4TBeaHFS0PJDeVxVi1Tc
=r0qJ
-----END PGP SIGNATURE-----

--=_bohort-5569-1278684730-0001-2--
