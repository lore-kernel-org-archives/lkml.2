Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1KHBb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:31:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab1KHBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:40 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=qdgafJSPjTMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=S_Ea-Wgqr33Jo4sGqu4A:9 a=Pn-fzEzQJWhBkV75ZWYA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=I_C88h1gfEeRZN7lC6AA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013038.417995745@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/10] lockdep: Show subclass in pretty print of lockdep output
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0005-lockdep-Show-subclass-in-pretty-print-of-lockdep-out.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The pretty print of the lockdep debug splat uses just the lock name
to show how the locking scenario happens. But when it comes to
nesting locks, the output becomes confusing which takes away the point
of the pretty printing of the lock scenario.

Without displaying the subclass info, we get the following output:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(slock-AF_INET);
                                lock(slock-AF_INET);
                                lock(slock-AF_INET);
   lock(slock-AF_INET);

  *** DEADLOCK ***

The above looks more of a A->A locking bug than a A->B B->A.
By adding the subclass to the output, we can see what really happened:

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(slock-AF_INET);
                                lock(slock-AF_INET/1);
                                lock(slock-AF_INET);
   lock(slock-AF_INET/1);

  *** DEADLOCK ***

This bug was discovered while tracking down a real bug caught by lockdep.

Link: http://lkml.kernel.org/r/20111025202049.GB25043@hostway.ca

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 91d67ce..6bd915d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -490,36 +490,32 @@ void get_usage_chars(struct lock_class *class, char u=
sage[LOCK_USAGE_CHARS])
 	usage[i] =3D '\0';
 }
=20
-static int __print_lock_name(struct lock_class *class)
+static void __print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN];
 	const char *name;
=20
 	name =3D class->name;
-	if (!name)
-		name =3D __get_key_name(class->key, str);
-
-	return printk("%s", name);
-}
-
-static void print_lock_name(struct lock_class *class)
-{
-	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
-	const char *name;
-
-	get_usage_chars(class, usage);
-
-	name =3D class->name;
 	if (!name) {
 		name =3D __get_key_name(class->key, str);
-		printk(" (%s", name);
+		printk("%s", name);
 	} else {
-		printk(" (%s", name);
+		printk("%s", name);
 		if (class->name_version > 1)
 			printk("#%d", class->name_version);
 		if (class->subclass)
 			printk("/%d", class->subclass);
 	}
+}
+
+static void print_lock_name(struct lock_class *class)
+{
+	char usage[LOCK_USAGE_CHARS];
+
+	get_usage_chars(class, usage);
+
+	printk(" (");
+	__print_lock_name(class);
 	printk("){%s}", usage);
 }
=20
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY+AAoJEIy3vGnGbaoACu8QAINJRiFQqNcJrCC0OKJOQwjA
j5YT1lZc4NRvY0VtGt3rKwEPrZLD4J0rJZQciRqs9UzncUftOXdzzIzPOxYGrrzy
9IJM6G7tsZH1pPsXCE9CAHXYESwW1obGlFvlD8lZLyN/RJQ+IIIjN/F+Ylx31fHF
mrbsIam6jLBlsL78as1EJU/dzvgQUFO4xWGyBLTdiaAJa7TXhT77LYpINRlzNNZp
/TwZAFzAqNbTGTVTiR6TbPBM1JMsCK9zhImtDsxU5MOI0nSGHhdkM3uy6HSYKjdy
0cgUKOJXw/QgAO8zCyr2J0RbLD69ZKz47Ln7zjiwFZvBLPA9vOQ/3FVWWuenkKdr
GFXUGUtbdRUqur6yYPnDfGgYYV553gkOy/rtso9fxfMftaoe2rWyUSh4eMveOxd5
UoA14iQibQdr2ByXIbzODpJLpBpfw/QcTnABOp9mCvxdUCTwq7e6DgDzOOAAqCG1
NeSdDSLBpS6Nr6sIYbtM9KOm96aXh1+Tnytq0g65FylM4F91yK91eZ60FKetdOnq
/3YdPGf84vMI3rdfaseiNYQwCFQ9+fhvSjhPpOtMLuC2nvCobgy+QsPiG7YcCCvm
/5CeCf9ZJRV6Wqvw37uyX1a8VAVm6T7/DD8S1ziMWATuYfHUQ+xt486dj78b18+Q
R1WQRnA5i9S3+iYZQ/r+
=oNEv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
