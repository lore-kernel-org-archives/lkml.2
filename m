Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2EGOhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:37:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51415 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab2EGOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:37:37 -0400
Message-ID: <1336401445.8274.319.camel@deadeye>
Subject: Re: [ 67/75] ipw2200: Fix race condition in the command completion
 acknowledge
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>
Date: Mon, 07 May 2012 15:37:25 +0100
In-Reply-To: <20120504204230.094388730@linuxfoundation.org>
References: <20120504204230.094388730@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ss9cNVBOIEksS3Y9nOh7"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ss9cNVBOIEksS3Y9nOh7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
>=20
> commit dd447319895d0c0af423e483d9b63f84f3f8869a upstream.
>=20
> Driver incorrectly validates command completion: instead of waiting
> for a command to be acknowledged it continues execution.  Most of the
> time driver gets acknowledge of the command completion in a tasklet
> before it executes the next one. But sometimes it sends the next
> command before it gets acknowledge for the previous one. In such a
> case one of the following error messages appear in the log:
[...]
> +	now =3D jiffies;
> +	end =3D now + HOST_COMPLETE_TIMEOUT;
> +again:
>  	rc =3D wait_event_interruptible_timeout(priv->wait_command_queue,
>  					      !(priv->
>  						status & STATUS_HCMD_ACTIVE),
> -					      HOST_COMPLETE_TIMEOUT);
> +					      end - now);
> +	if (rc < 0) {
> +		now =3D jiffies;
> +		if (time_before(now, end))
> +			goto again;
> +		rc =3D 0;
> +	}
[...]

If you don't want the wait to be interrupted, use wait_event_timeout()
instead of this ridiculous loop!

Ben.

--=20
Ben Hutchings
Hoare's Law of Large Problems:
        Inside every large problem is a small problem struggling to get out=
.

--=-ss9cNVBOIEksS3Y9nOh7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6feJee/yOyVhhEJAQq8VQ/+MtBtuSQMZHJt/EHbqE6gV8Cd4aBFtBI5
T+kHXBL5X6p+p8lze3H1Cnjq1b5qW63D4poJ5+5aIH+Fg8voPqERrva2Qy988P5L
G9dpvmrBBoBKlgJ3N8k6NOwVI5rtb1Rq45Rpnw4KevfTxvjaHm7APVZDHijzyUto
JPARcSARwzXiC6CA91M+r+51S9Dlxgc/c114rKPm46VZlKNfE94dQAq39s5Km25W
BM1qNcsPemeoConvp0+V3MN1kYSZBqsGOL/VDrfS4XH2P/XrPK554tkArMjvYLDr
xh1cOsGLj/+2wqi40wS0JqTEXkwHnx7Fxqaw974tZSBQDdTyjMZcRDf6c21B9uQ7
35OEL+OhX/w58xu+wc/nM9fjspGENTe5Ucn7OouO6QvqvehK6cQbpCTjeqxgIZYM
1f+M8tsLJm+KKm0Ledn5LDSsTzG+Mazk3Ejij4z0GLRoxzjDihbowBQa/2rG1ewu
l+uJzcEOaI+gdPEtcmIsboNoD3sDt7lw3MQ+lU7fTX1HJa9/kKURtXp5PRheHX5T
64BCTw5UgULOYwVGLTFUd6rFOtSHSmqZLobFE3Fuis9Z3V+Q+uWOCgyTpHF932LH
xQ3Xl9L7IbH2BPRFsZkmhSNwKzXovKOI+bDot1GKn/Ov3MBq5dMPcfl1JjRH5dJ8
6jcjlmDOlf0=
=uDgU
-----END PGP SIGNATURE-----

--=-ss9cNVBOIEksS3Y9nOh7--
