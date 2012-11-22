Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2KVS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:34 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62590 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2KVS4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:30 -0500
X-Authority-Analysis: v=2.0 cv=KMfY/S5o c=1 sm=0 a=QKCpt3RAcCy1PgeoOVilzg==:17 a=2oGSFm5vdZwA:10 a=wom5GMh1gUkA:10 a=pTRqrO9sSn4A:10 a=649elMfuWG0A:10 a=svWV0_fRAAAA:8 a=erfvF8y-hRwA:10 a=B3vXKxRM_QVQcc3wN1gA:9 a=CjuIK1q_8ugA:10 a=2XGJOT-O687tTS_BhXAA:9 a=QKCpt3RAcCy1PgeoOVilzg==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 24.73.230.86
Date: Wed, 21 Nov 2012 21:15:46 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
Message-ID: <20121122021546.GA6076@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
 <CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
 <20121120161011.GD18015@shaftnet.org>
 <20121120163309.GB4990@kroah.com>
 <20121120181203.GA7922@shaftnet.org>
 <20121121093528.4fe11c26@tom-ThinkPad-T410>
 <20121121140109.GA7549@shaftnet.org>
 <CACVXFVOuGQTLKSuFmTnv50-Eo0hzZSA2gh65upWu-E+439Dvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <CACVXFVOuGQTLKSuFmTnv50-Eo0hzZSA2gh65upWu-E+439Dvsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2012 at 09:45:23AM +0800, Ming Lei wrote:
> No, it is not related closely, CONFIG_FIRMWARE_IN_KERNEL means
> that all in-kernel-tree firmware blobs should be included in kernel binar=
y,
> but CONFIG_EXTRA_FIRMARE means that one additional firmware
> image will be put into kernel binary.

Okay.

> Considered that there is no your problem in -linus tree or -next tree=20
> and the current code works for long time, maybe it is better to not=20
> touch the code. Or suggest you to study this kind of config options=20
> and firmware/Makefie first, then figure out one proper patch.

Given what you've told me (i.e. support for loading "builtin" firmware is=
=20
always required), I propose this patch instead:

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..d291e15 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -38,8 +38,6 @@ MODULE_LICENSE("GPL");
=20
 /* Builtin firmware support */
=20
-#ifdef CONFIG_FW_LOADER
-
 extern struct builtin_fw __start_builtin_fw[];
 extern struct builtin_fw __end_builtin_fw[];
=20
@@ -69,19 +67,6 @@ static bool fw_is_builtin_firmware(const struct firmware=
 *fw)
 	return false;
 }
=20
-#else /* Module case - no builtin firmware support */
-
-static inline bool fw_get_builtin_firmware(struct firmware *fw, const char=
 *name)
-{
-	return false;
-}
-
-static inline bool fw_is_builtin_firmware(const struct firmware *fw)
-{
-	return false;
-}
-#endif
-
 enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,


The empty stub functions can never be compiled, as firmware_class.c=20
isn't compiled when CONFIG_FW_LOADER isn't enabled.  So let's just nuke=20
this unused code entirely.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD4DBQFQrYrSPuLgii2759ARArH8AJ9u9qLTYW2HPFKZG2ye/s+LVqLT7ACY9TTl
aczlAErf7091El2jnLm1NQ==
=OAGa
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
