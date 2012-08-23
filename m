Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab2HWI4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:56:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:30463 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2HWI4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,299,1344236400"; 
   d="asc'?scan'208";a="190324092"
Date: Thu, 23 Aug 2012 11:56:25 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: halfdog <me@halfdog.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Search for patch for kernel stack data disclosure in
 binfmt_script during execve
Message-ID: <20120823085625.GA4683@otc-wbsnb-06>
References: <502FA000.8090700@halfdog.net>
 <5030A65D.90305@halfdog.net>
 <503553EF.1090508@halfdog.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <503553EF.1090508@halfdog.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 09:49:35PM +0000, halfdog wrote:
> Got a hint via IRC, that I should not send patch idea for review to
> "generic" list, but to maintainers and last (or relevant) comitters of co=
de.
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dc=
ommitdiff;h=3Dbf2a9a39639b8b51377905397a5005f444e9a892
>=20
> CC to generic just for the records
>=20
> halfdog wrote:
> > halfdog wrote:
> >> I'm searching for a patch for linux kernel stack disclosure in=20
> >> binfmt_script with crafted interpreter names when CONFIG_MODULES
> >> is active (see [1]).
> >=20
> > Please disregard my previous proposal [2], since it did not address
> > the problem directly (referencing local stack frame data from bprm
> > structure) but worked around it. I suspect, that this could increase
> > probability to reintroduce similar bugs.
> >=20
> > Opinions on (untested sketch for) second solution: Could someone look
> > on the source code comments and changes in patch to judge, if this is
> > going in the right direction?
> >=20
> >=20
> > Explanation of patch: Since load_script will start to irreversibly
> > change bprm structures at some point (using stack local data was one
> > of those changes), try to delay this point. Run checks if load_script
> > could be the right handler, if not give other binfmt handlers the
> > chance to do so.
> >=20
> > If binfmt_script is the right one, try to load the interpreter
> > (causing bprm modification), if failing make sure that no other binfmt
> > handler has the chance to continue on the now modified bprm data.
> >=20
> > CAVEAT: This assumes, that if binfmt_script could handle the load,
> > that it would be the one and only binfmt with that ability, so no
> > other one, e.g. binfmt_misc should have the chance to do so. If this
> > assumption is wrong, leaving binfmt_script would have to rollback all
> > bprm changes (e.g. restore old credentials).
> >=20
> > hd
> >=20
> > [1]
> > http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDi=
sclosure/
> > [2] http://lkml.org/lkml/2012/8/18/75

What about (untested):

diff --git a/fs/exec.c b/fs/exec.c
index 574cf4d..ef13850 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1438,7 +1438,8 @@ int search_binary_handler(struct linux_binprm *bprm,s=
truct pt_regs *regs)
 		}
 		read_unlock(&binfmt_lock);
 #ifdef CONFIG_MODULES
-		if (retval !=3D -ENOEXEC || bprm->mm =3D=3D NULL) {
+		if (retval !=3D -ENOEXEC || bprm->mm =3D=3D NULL ||
+				bprm->recursion_depth > BINPRM_MAX_RECURSION) {
 			break;
 		} else {
 #define printable(c) (((c)=3D=3D'\t') || ((c)=3D=3D'\n') || (0x20<=3D(c) &=
& (c)<=3D0x7e))
--=20
 Kirill A. Shutemov

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNfA5AAoJEAd+omnVudOMWn8P/jZjeaow/eN8GLyIYFMivaO0
AfMYSS4W6F+9/J9Q34erHVaaNGG1W/aKlVAPTokyo07CKIalKolSvVof8T8eO+lm
SygzOFNlp1jMqGFOqUhbbqsaq9sv/GyZa/cdOI1SBl99xeSdZor88RZKw6RLVEMT
vFnPPhdJDPjf/GqaaMtQ5QyWu1p/nFl1a9ltHP6034woqlcKLmglN4PyWmJDDOAS
SAUSb1J9fX5Ir4VZprSKm+UCgKu+E5gn2uOjoPOEsdXg76A4YgiYvvG2dkMcsklq
45HtqBxS5axBxRVVcR94BdX5lba22JafqpjNKXRvBeDwv5APghr9fUyLZwzrG8+l
rG13MVNotQi4rM8RdTWhWGr7tiwCM8jW1zpJO0VJpsa05S3Ke+6tr70VN6O165o0
CVjC1Ov6coCmtUL+jwxLjotSSCgjsXfZBG6KH8o++joxSo6qndFP2nNyeHwE/q7X
GjPWu/eqWL3EuOFjrr1fRfsH1+MWgqxKYI12xb3zBcAz0n3z38Me3kaMofKCS2/6
PKnXvdWU5XUwESwd+nIn2YdiYHfEdGN/474bz6dWXo8l5l3JVkeH7cGJL46uhLD7
3z/Hvrp7mx0oIc0ScZ97RvybGy+br4P12Wkyw5TZHMIMFaepmG9JNictgzYCYY4Y
xYo/MGQqRP/1slSyLsRQ
=OVsL
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
