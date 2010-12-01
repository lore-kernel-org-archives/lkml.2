Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0LAV1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 16:27:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43104 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0LAV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 16:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M4cimjANcLVrsFgWa3ekNO1xCT7ViyutCwi+NBAvIZVdOWhKtbKseHtZ/H3kA842fH
         YjsHVqKe9RUp0PPWgCEvEEl+AkT9k8rMwXroNo7hShpACGBg54V48ke/KALiqt7XD/MV
         oJlb+qlWU01qByfz1XuvF7k6e08AVGKqW+cB4=
Date: Wed, 1 Dec 2010 16:27:38 -0500
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101201212738.GA16944@roll>
References: <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll> <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop> <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette> <1291030726.32004.4.camel@laptop> <20101129194041.GA8280@roll> <1291071677.32004.527.camel@laptop> <1291129145.32004.874.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <1291129145.32004.874.camel@laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 30, 2010 at 03:59:05PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-30 at 00:01 +0100, Peter Zijlstra wrote:
> >=20
> > Ok, that's good testing.. so its still not quite the same as NO_HZ=3Dn,
> > how about this one?
> >=20
> > (it seems to drop down to 0.00 if I wait a few minutes with top -d5)
>=20
> OK, so here's a less crufty patch that gets the same result on my
> machine, load drops down to 0.00 after a while.
>=20
> It seems a bit slower to reach 0.00, but that could be because I
> actually changed the load computation for NO_HZ=3Dn as well, I added a
> rounding factor in calc_load(), we no longer truncate the division.
>=20
> If people want to compare, simply remove the third line from
> calc_load(): load +=3D 1UL << (FSHIFT - 1), to restore the old behaviour.

For some bizzare reason, this version has a small but noticable amount of
jitter and never really seems to hit 0.00 on my machine, tends to jump
around at low values between 0.03 to 0.08 on a routine basis:

16:20:42 up 16:31,  4 users,  load average: 0.00, 0.01, 0.05

the jitter seems to have no visible reason for it happening; with no
networking, disk access or a process waking up and demanding attention from
the cpu, it goes back up.

Mind this is obviously NOT as horrible as it was originally, but I'd like to
find out why it's acting so differently.

I'm going to try this variant again with that line you were talking about
disabled and see if it reacts differently. I get the feeling if it's the
rounding factor - since you say that was changed for BOTH nohz=3Dy and n, t=
hat
it's not really a problem in the first place, and likely is very low load
that wasn't being accurately reported before.


Tim McGrath
--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTPa9ypEncCrqzVruAQJ8Bgf/U6Bdx+PfSNpNJRpqUTdLpCAcztNksJUl
3Acaz3QqsSWp7njtJ5khQPslpQBXG1sMqr1z7AXub+6Xc/PFC5465bcNcMFkR0tn
ZHmO8oYB7uUozGZ9GduEHb6P/V+t4+khQeug1LBtVQeR6CIBUeyr0flGx0ZiHX6M
ggmHrnr13vaxyujKhqKO+IWrSHJDiXUQfK+HNHh9zoRD6uIbMlTCYLkDBghDJ1Lq
30g/EofLMTNzYATjO+2HFGBV3bsRUOBsom0TivjFAdL4QnRk8/QewuqQfkQIldFU
cVqUhvqeCYKiOvd0EJoIwPWqTyF8G8M9K0NPrf/vBLTpDCjziTiw1g==
=X/+o
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
