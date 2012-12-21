Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2LUNEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:04:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2LUNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:04:28 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NT_6bBl6HocA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2YELVqqeHisA:10 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=jWKSiNj9IdgEQznNnnMA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=2Uic3XbOqCnz-qcj:21 a=ZXoTVN85ac4fntqp:21 a=enz70vlK868dElRz_04A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121221130426.806436461@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 08:03:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jovi Zhang <bookjovi@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] tracing: Verify target file before registering a uprobe event
References: <20121221130323.940466074@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Verify-target-file-before-registering-a-upro.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jovi Zhang <bookjovi@gmail.com>

Without this patch, we can register a uprobe event for a directory.
Enabling such a uprobe event would anyway fail.

Example:
$ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

However dirctories cannot be valid targets for uprobe.
Hence verify if the target is a regular file during the probe
registration.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 4ff9ca4..0bef43c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -257,6 +257,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto fail_address_parse;
=20
 	inode =3D igrab(path.dentry->d_inode);
+	 if (!S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
+		ret =3D -EINVAL;
+		goto fail_address_parse;
+	}
=20
 	argc -=3D 2;
 	argv +=3D 2;
@@ -356,7 +360,7 @@ fail_address_parse:
 	if (inode)
 		iput(inode);
=20
-	pr_info("Failed to parse address.\n");
+	pr_info("Failed to parse address or file.\n");
=20
 	return ret;
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ1F5aAAoJEOdOSU1xswtMPyAIAIfnwy2gmhNs6tTdYU0ijgT5
ua4/+3XkmSMZ3HDliRQZ7zQ+IKFoiuewGbZ+jMF1S7SkYyBmTNYGlIQpwYMxju0v
zFgQWZzmvdFbirEdQ1rFo9U6SQ/IqHlRrwO0tjopyW+0PKSCXSaZxxX3A57PiBrX
NOyfy+bf/F69CpAUHtkf1GR0JWtwDdGKSWhFRB8t/37ng+M+MBs2qR+wyIzN+uDp
jPa6UEQxkVkJm2YMWyBzmrixXQX9J6vXoTMPMqvapgV/4CIowtv6sZA9cYou8sTv
60I0HUoitnoQf0E6wIHvGj800aLivh6njx+5LOs/rUkm8hfz7oLNhpGwf1yCrHs=
=dkDR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
