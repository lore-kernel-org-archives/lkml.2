Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031065Ab2CNV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030964Ab2CNV3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:29:18 -0400
Message-ID: <4F610D81.3020300@redhat.com>
Date: Wed, 14 Mar 2012 17:28:33 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "\"Eric W. Biederman\" (commit_signer:2/9=22%)" 
	<ebiederm@xmission.com>,
        "Joe Korty (commit_signer:2/9=22%)" <joe.korty@ccur.com>,
        "David Howells (commit_signer:2/9=22%)" <dhowells@redhat.com>
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com> <4EEE3124.7070605@gmail.com> <20111218103836.258eedb8.akpm@linux-foundation.org>
In-Reply-To: <20111218103836.258eedb8.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2167723106F7BE4365CED7F1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2167723106F7BE4365CED7F1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/18/2011 01:38 PM, Andrew Morton wrote:
> On Sun, 18 Dec 2011 13:29:56 -0500 KOSAKI Motohiro <kosaki.motohiro@gma=
il.com> wrote:
>=20
>> (12/9/11 5:35 PM), kosaki.motohiro@gmail.com wrote:
>>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>>
>>> Mqueue limitation is slightly naieve parameter likes other ipcs
>>> because unprivileged user can consume kernel memory by using ipcs.
>>>
>>> Thus, too aggressive raise bring us security issue. Example,
>>> current setting allow evil unprivileged user use 256GB (=3D 256
>>> * 1024 * 1024*1024) and it's enough large to system will belome
>>> unresponsive. Don't do that.
>>>
>>> Instead, every admin should adjust the knobs for their own systems.
>>>
>>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>> Acked-by: Doug Ledford<dledford@redhat.com>
>>> Acked-by: Joe Korty<joe.korty@ccur.com>
>>> Cc: Amerigo Wang<amwang@redhat.com>
>>> Cc: Serge E. Hallyn<serue@us.ibm.com>
>>> Cc: Jiri Slaby<jslaby@suse.cz>
>>
>> Andrew, can you please pick up this series into your tree? because you=
r
>> tree have related Doug mqueue patch series.
>=20
> Soon.  I need to go back and read the email trail regarding Doug's patc=
hes.

This has obviously fallen through the cracks.  Can we please see if we
can get this put to bed.

Andrew, long and short of the story on this entire patch set is:

A) Current Linus kernel is broken in regards to customer needs, maximums
are too low.
B) My patch set upped maximums and also upped the default maximums on
the system, but inadvertently also upped the default mqueue size the
original patch that my entire patch set is more or less reverting tied
maximums and defaults together.  This broke some apps that didn't pass
an attr struct to open as it caused a default sized mqueue to exceed a
non-root RLIMIT for message queue bytes.
C) My next patches brought defaults back down by decoupling defaults
from maximums.  This then broke some apps again that wanted to be able
to fiddle with the maximum settings in /proc and have that modify the
default value for an app that didn't pass an attr struct (fortunately,
all of these apps appear to be nothing more than regression test suites
at the moment where the people writing the suite used a combination of
setting the maximum size in proc, then running a test program that
created a default queue and checking it, then re-running with different
sizes in /proc, etc).
D) Motohiro and I argued for some time over this behavior until we both
agreed that apps can not be written to rely upon the maximum setting of
the system wide mqueue limits as their default queue size as this is
fundamentally unfriendly behavior to any multi-application OS (the
situation of two apps both needing specific, different queue sizes, and
both expecting to get them by default by twiddling values in /proc is
simply not supportable).  In the end, we agreed that the best approach
to solve the problem was to leave the defaults decoupled from the
maximums, but add a default knob in /proc so that if there are any apps
out there that have been coded to expect this behavior, then there is a
workaround path for them until they get coded to use an attr struct on
open instead of relying on values twiddled in /proc.  This is what
Motohiro's patch set does as well as a few other cleanups.

Hopefully that clears things up, and given the unsupportability of the
current design in Linus' kernel (changing maximums changes defaults for
all apps and encourages poor programming choices) we can move this
forward please.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig2167723106F7BE4365CED7F1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPYQ2BAAoJELgmozMOVy/dnCcQAMH5FzotoFrapO/Aho1rkrty
xFk361X+Jp8JagbBQFCLJMuX/t0mSIk5lSG2zlndsROPzKSP8JNEm8Ro4pZvOD7P
PjR3LfzkJJHVjMrhnNUqtfpPlNDpYWG3fFDyEWtxDlIlyAYUVFJe6QKXrBPi04dM
Z1uozy7x9dvS2pF2F6D02Q/2DxthJdq0BDGVFoqhYvZWA7ivSzA/zIAK+QVb2zZ4
nrgMpY+zOhouzRilAlcqn4CmKsJV7y4dRAG8uXfw0aFhJ7ETxLfSgGnMshB9w8iG
uUGf/OR6O9O8kgQJkWEHUnqkQb6SsinXz4Nzxv2eiAJaqe+W78myL0KS6Q9SYyYg
WogLS8uMhkrKKgk34hdjHTYWvbWOIwkhRbO5Yd2ZC7j0vu2diSW8Y+qCogJMf8gW
X4cuUmYxYceaxay78k96UQWxRVRafglgrf/ERfpytxc2vm0OG2hw0KaS1p5RogGY
A6vTz+B69wvbqjfoEvMxi9UAwbFOMXBhfnx0wi215GbBlXHTShREa9Vexub+5Ojm
wK9nnJQqq9oBEwQS1f2BQp6lfqpTwgs61rBLcZzyDcJkJtM0ltWzArwNEQhv23rn
0zQxR4ZJtJ4ORNROgqlAa8g7vSed6WBZZbAOvewR8v8woQ0Vl3d2oRl7hQCpPYLd
4PxPUzXLTrICazOLDknT
=1C/S
-----END PGP SIGNATURE-----

--------------enig2167723106F7BE4365CED7F1--
