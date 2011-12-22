Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1LVAQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:16:05 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42674 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1LVAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:16:03 -0500
Date: Thu, 22 Dec 2011 11:15:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20111222111552.f47d2033aa6d5dea00919e47@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_11_15_52_+1100_d40QUZOaK1t4jQRO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_11_15_52_+1100_d40QUZOaK1t4jQRO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc ppc64_defconf=
ig)
failed like this:

In file included from ipc/util.c:28:0:
include/linux/security.h: In function 'security_real_capable':
include/linux/security.h:1886:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1886:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1886:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1886:25: error: dereferencing pointer to incomplet=
e type
include/linux/security.h:1886:25: error: dereferencing pointer to incomplet=
e type

And so on ... These are the references to __task_cred() which dereferences
a "struct task_struct *".  Adding an include of linux/sched.h back to
linux/security.h (which was removed by commit ae1a442f9d95 ("trim
security.h")) results in this error (to be fair, the include of
linux-sched.h really belongs in cred.h):

arch/powerpc/platforms/cell/spu_syscalls.c:68:22: error: expected ')' befor=
e 'const'

Which was caused by commit 2dbc0a0f41d4 ("switch spu_create(2) to use of
SYSCALL4, make it use umode_t").  That commit (along with a whole string
of others around it) was supposedly authored July 27, 2011, so it would
have been nice to see them earlier then this in linux-next.  :-(

I have used the vfs tree from next-20111216 (which is unfortunately
empty) again for today.

BTW, the x86_64 allmodconfig build (with out the sched.h include
restored) does not get any of these errors, so sches.h must be being
indirectly included, so you are not saving anything on x86_64 by removing
the sched.h include from security.h.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Dec_2011_11_15_52_+1100_d40QUZOaK1t4jQRO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8na4AAoJEECxmPOUX5FEVB0QAIlK2+hKqssCKSXyJn+n0lmz
TyOknMmLRpOZSKcM24FYt19iXVSlBO4BnMfMt9q3DcUSCneYaWWrQSRw477RrEHk
BwiITpi7zjBNXlqoEc6xurN0GIueLn/++Y/zg5QBjjNXnuodr3dmet+4RQogVxAo
zItLSNJXs2J6RLBD76Wa3f6RMO4UrgkUuH17tOrAtRFOlysjO/0dWsVmsOyTSj5T
kOvL0wgZzWg8/57kUnIDl0oKBl2QlDOrEYSzCdF9FBu6nFDkXPjNNikDnzIEY8Vt
+F2dVzqEbR9vh0Xc/7Z9f1flzgzNXFQRVgJ/BHAfdO76bdl0Um1dMOwYfXzf+hqR
N3E9lWCUN4h/h1NlLHV5I/1OFKNlCAl16/RQ5pcHRLV72nQ3sSo5cNZ7/bXkpa0d
ufq377a8ZmSwGY0eEDs0zontllNHKtMHqrDmQqQ+LMe90uaiP2AnmZkfotfTXzAy
7aTO+BGehoxHAdFunTYVbMHzuZHpOiz3BhwxX6ygXR8WuI8VHzaexyumFDgXtADt
RiT4pZqnZY0EOw1XUFsPJOv97eMsIJAXotb8kr6fFHl/Bua5aWhN3j9qIzrCM+c6
FsWN2Zh0t3g6VwGesT78QFRSRGsDeQi4HVAHzA/Mk8eYGgInMJgNJ4/ZbUsBh8E4
lbbEfmpXQidogrWRFF3X
=Quy3
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_11_15_52_+1100_d40QUZOaK1t4jQRO--
