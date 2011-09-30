Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1I3CPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1I3CPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:15:39 -0400
Message-ID: <4E85263D.3030905@xsintricity.com>
Date: Thu, 29 Sep 2011 22:15:25 -0400
From: Doug Ledford <dledford@xsintricity.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch] Fix up return value from mq_open()
X-Enigmail-Version: 1.3
OpenPGP: id=D30533DF
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA443B04D4C7917DCFDEBC62F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA443B04D4C7917DCFDEBC62F
Content-Type: multipart/mixed;
 boundary="------------070605020505000208020001"

This is a multi-part message in MIME format.
--------------070605020505000208020001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Commit d40dcdb ipc/mqueue.c: fix mq_open() return value
changed the return value for mq_open() to return

EMFILE - The process already has the maximum number of files and
               message queues open.

instead of

ENOMEM - Insufficient memory.

While the portion of d40dcdb that introduced using ERR_PTR() to
propagate the condition were helpful, the change to the type of error
was not.  The specific test that was failing was a memory space test.
It can fail if there are too many message queues open and this one would
cause us to exceed the tasks counter for memory bytes capacity (aka, int
wrap) or it can fail if the total number of bytes already allocated plus
this allocation will exceed the user's RLIMIT for POSIX message queues.
 However, depending on the values passed in via an attribute struct,
this could happen on the 1st file or the 100th file.  There is no direct
relationship to file count in this test.  There is only a direct
correlation to memory usage.  Therefore return the code to giving ENOMEM
instead of EMFILE.

(If the attachment is a problem I'll find another mailer to use and resen=
d).

--=20
Doug Ledford <dledford@xsintricity.com>
              GPG KeyID: D30533DF




--------------070605020505000208020001
Content-Type: text/plain;
 name="ipc-mqueue-return-value.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ipc-mqueue-return-value.patch"

commit b80e4058e2b4234fb33a9fd84b4ce288e8ba65cb
Author: Doug Ledford <dledford@redhat.com>
Date:   Thu Sep 29 19:02:47 2011 -0400

    ipc/mqueue: make the error returns match the conditions
   =20
    We should not return -EMFILE when the problem is memory usage.
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 0474ddb..3e53604 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -165,7 +165,7 @@ static struct inode *mqueue_get_inode(struct super_bl=
ock *sb,
 		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
-			ret =3D -EMFILE;
+			ret =3D -ENOMEM;
 			goto out_inode;
 		}
 		u->mq_bytes +=3D mq_bytes;

--------------070605020505000208020001--

--------------enigA443B04D4C7917DCFDEBC62F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6FJkQACgkQBJO4D9MFM983vACfcF8yFMgVxrbL7y0Gvav1wayl
XpkAn3fF+z532Vc399f+mGinrafrg7oy
=ObOX
-----END PGP SIGNATURE-----

--------------enigA443B04D4C7917DCFDEBC62F--
