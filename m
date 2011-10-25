Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1JYGQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 02:16:21 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37470 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1JYGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 02:16:19 -0400
Date: Tue, 25 Oct 2011 17:16:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Swen Schillig <swen@vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the scsi tree with the s390 tree
Message-Id: <20111025171601.c2365840409d17df161ca8b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_17_16_01_+1100_NcMMTWaYKCCW38kt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_17_16_01_+1100_NcMMTWaYKCCW38kt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
drivers/s390/cio/qdio_main.c between commit 9c20b3dd8479 ("[S390] qdio:
EQBS retry after CCQ 96") from the s390 tree and commit dfe5bb506172
("[SCSI] qdio: base support for hardware data router with zfcp") from the
scsi tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/s390/cio/qdio_main.c
index a108e28,d2c1f1b..0000000
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@@ -145,26 -151,16 +145,28 @@@ again
  		goto again;
  	}
 =20
 -	if (rc < 0) {
 -		DBF_ERROR("%4x EQBS ERROR", SCH_NO(q));
 -		DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 -		q->handler(q->irq_ptr->cdev,
 -			   QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
 -			   q->nr, q->first_to_kick, count,
 -			   q->irq_ptr->int_parm);
 -		return 0;
 +	if (rc =3D=3D 2) {
 +		BUG_ON(tmp_count =3D=3D count);
 +		qperf_inc(q, eqbs_partial);
 +		DBF_DEV_EVENT(DBF_WARN, q->irq_ptr, "EQBS part:%02x",
 +			tmp_count);
 +		/*
 +		 * Retry once, if that fails bail out and process the
 +		 * extracted buffers before trying again.
 +		 */
 +		if (!retried++)
 +			goto again;
 +		else
 +			return count - tmp_count;
  	}
 -	return count - tmp_count;
 +
 +	DBF_ERROR("%4x EQBS ERROR", SCH_NO(q));
 +	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
- 	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
- 		   0, -1, -1, q->irq_ptr->int_parm);
++	q->handler(q->irq_ptr->cdev,
++		   QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
++		   q->nr, q->first_to_kick, count,
++		   q->irq_ptr->int_parm);
 +	return 0;
  }
 =20
  /**
@@@ -207,12 -198,17 +209,12 @@@ again
  		qperf_inc(q, sqbs_partial);
  		goto again;
  	}
 -	if (rc < 0) {
 -		DBF_ERROR("%4x SQBS ERROR", SCH_NO(q));
 -		DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 -		q->handler(q->irq_ptr->cdev,
 -			   QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
 -			   q->nr, q->first_to_kick, count,
 -			   q->irq_ptr->int_parm);
 -		return 0;
 -	}
 -	WARN_ON(tmp_count);
 -	return count - tmp_count;
 +
 +	DBF_ERROR("%4x SQBS ERROR", SCH_NO(q));
 +	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 +	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
- 		   0, -1, -1, q->irq_ptr->int_parm);
++		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 +	return 0;
  }
 =20
  /* returns number of examined buffers and their common state in *state */

--Signature=_Tue__25_Oct_2011_17_16_01_+1100_NcMMTWaYKCCW38kt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOplQhAAoJEECxmPOUX5FEvqkP/R5Pr+d26s77WVbfyQsXEFDB
zJ2aogSlOj0dLQrLnU14IuUNME4rJ5ighwquNshwvvEr4DsdBMqhrffbD45qXO2H
RrXVSMx7gCW+AXn20Ad/Umn+6DxTf9tA33T9jjZFIIE452xdskLXOkUEjXjRwmb+
lkj18yW6AwYDKo5FQ27rf+CMvsK0z3FOWsBaEmTBU9Y7DWu7MS90bPBt9W8I/8qy
bivusRxhUahncDmW3VmNYwMbndiTeFrwQvcJ8lU68VNbt8DtGIIaKe7TUy1B9Jbn
Tzc9j4t5Lkpmby0QLdvmGYJGrfSaR4fyxu2SV3ItfMYtRhu7zBK8rrv8cTqW9vAV
s8/aRKdc5p5As6X4phbq5ECeTdgn65eRRTHW5DxYpDz2IJ9ywIrPiGgsosBpKA9R
hKxlyTwokgNXIB9VKPgfVFcOASa4q9s/HUvnkaW3EzbXWy85zCkG1BVR0xIvlhCP
oS2CmpLFUB65jdyXEl+vLw7qIyfZBiKBC2OSSoNF8hqAfrERh5EfrQThhDhrBTEG
d3o8kjHI4sOdkr7jcoXfU0e68tkVkWNzbIjwnegUC0NW5gHzmoKgMG6KE5kHlu8i
akirpwreo4NN0yNer0zOIIkwWAsTdX0+QBm6vy9nuF7tIpeRYOh/eXbJN0GhIZtD
MmlzTCd3A9HnD4t2aaUf
=5kOk
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_17_16_01_+1100_NcMMTWaYKCCW38kt--
