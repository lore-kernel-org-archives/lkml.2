Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2EaQkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:40:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49444 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755Ab2EaQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:40:36 -0400
Date: Thu, 31 May 2012 17:40:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 2/4] regmap: Make internal read/write functions reentrant
 from themselves.
Message-ID: <20120531164033.GJ2666@opensource.wolfsonmicro.com>
References: <201205311616.q4VGGZjR014516@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5cSRzy0VGBWAML+b"
Content-Disposition: inline
In-Reply-To: <201205311616.q4VGGZjR014516@sw-eng-lt-dc-vm2>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5cSRzy0VGBWAML+b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 04:19:36PM +0200, Krystian Garbaciak wrote:

> Functions _regmap_update_bits() and _regmap_write() are modified
> so they can be recurrently entered from the inside.

You should describe what you're doing here in more detail...

> The internal reading functions need no modification for current implementation
> of indirect access.

So the subject should really be "Make internal write functions
reentrant"?

> -		map->format.format_val(map->work_buf + map->format.reg_bytes
> -				       + map->format.pad_bytes, val);
> -		return _regmap_raw_write(map, reg,
> -					 map->work_buf +
> -					 map->format.reg_bytes +
> -					 map->format.pad_bytes,
> +		/* Using stack for value data, to make function reentrant */
> +		map->format.format_val(&val, val);
> +		return _regmap_raw_write(map, reg, &val,

We can't safely do this for all buses, some want to DMA and you can't
DMA from stack.  This also means that we'll no longer be able to send a
single buffer to the device as we'll never have the value immediately
following the register address and padding any more.  That'll increase
overhead on many systems, you can often see the handover on gathers on a
scope.

I don't understand why we can't take the decision to write the page
register before we start using the buffer?

Also, it seems like your mailing setup is a bit broken - these messages
aren't being threaded with each other.

--5cSRzy0VGBWAML+b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx576AAoJEBus8iNuMP3d8mMP/1q2ajQuCAMiHnWD+06Wz75G
+awxqlqptb+jkkxrbZfA8vvQEDfpb0vLiaDK0MmnsA0+Q92aN7ckpXdAZGNR93rl
bSC4RpBaXddQ/2OnjPXMmjlnsxRGdmkvO4pf59Lgvs+2/uxw40rl7E5UICZk1RzE
SizXVJUhS9Gbkr8NOIbSo2m6A+n3jtzVzNlSzWUGFZuZDHr+wlrTMjQwsvGiOQUi
H2WnFKyCNEQEBsKcxU5XUq4ZZLr6CiOfRw9jidRV32xt/US/5whltIpdwuvCd6T4
7XeaEXS8yAKn5U0S2CGszSg7tYrCs61Jxksnm0FNPR5dYCYlzlBMXxM6qhDGey7o
26GsYaAjzKRPCAXEHzUMxpog2zWs+3u1eDwzm3iEB1Wm6MEYC9MiLP1a/zeWt2wn
9FyXGgs3KCvsFSWfSp2jeX2HAeuDxjCP998BbD04MePcBp94i3GwfUhRBuU7RV7o
L+DKVHpGJBHdsdklZBjA0DnnjOCzz7LBOVsyDVs1HTNrxAJzLJGgTxUItlKP/pE/
qZIz7zzUqrmgmS2C0jPvEW2pVA3uYqhw0F1Rs1NaxaFfYzRYQ+20rf60V9uhiQaT
puDs55UW/Ah6GPUkOxLNfPpzLEPhIesP/jTPkfmzrmQkdMwZtOHHmUV0B4bWOoRG
f+5n7XrycXuNxxv81Te1
=0akM
-----END PGP SIGNATURE-----

--5cSRzy0VGBWAML+b--
