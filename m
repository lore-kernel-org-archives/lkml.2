Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3AJP1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:27:13 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58461 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3AJP1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:27:10 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>
Subject: Re: [PATCH] Fix wrong EOF compare
In-Reply-To: <1357797904-11194-1-git-send-email-minchan@kernel.org>
Organization: http://mina86.com/
References: <1357797904-11194-1-git-send-email-minchan@kernel.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 10 Jan 2013 16:26:58 +0100
Message-ID: <xa1ta9shm531.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10 2013, Minchan Kim <minchan@kernel.org> wrote:
> getc returns "int" so EOF could be -1 but storing getc's return
> value to char directly makes the vaule to 255 so below condition
> is always false.

Technically, this is implementation defined and I believe on many
systems char is signed thus the loop will end on EOF or byte 255.

Either way, my point is the patch is correct, but the comment is not. ;)

Of course, even better if the function just used fgets(), ie. something
like:

int read_block(char *buf, int buf_size, FILE *fin)
{
	char *curr =3D buf, *const buf_end =3D buf + buf_size;

	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
		if (*curr =3D=3D '\n') /* empty line */
			return curr - buf;
		curr +=3D strlen(curr);
	}

	return -1; /* EOF or no space left in buf. */
}

which is much shorter and does not have buffer overflow issues.

> It happens in my ARM system so loop is not ended, then segfaulted.
> This patch fixes it.
>
>                 *curr =3D getc(fin); // *curr =3D 255
>                 if (*curr =3D=3D EOF) return -1; // if ( 255 =3D=3D -1)
>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Andy Whitcroft <apw@shadowen.org>
> Cc: Alexander Nyberg <alexn@dsv.su.se>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  Documentation/page_owner.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/page_owner.c b/Documentation/page_owner.c
> index f0156e1..b777fb6 100644
> --- a/Documentation/page_owner.c
> +++ b/Documentation/page_owner.c
> @@ -32,12 +32,14 @@ int read_block(char *buf, FILE *fin)
>  {
>  	int ret =3D 0;
>  	int hit =3D 0;
> +	int vaule;
>  	char *curr =3D buf;
>=20=20
>  	for (;;) {
> -		*curr =3D getc(fin);
> -		if (*curr =3D=3D EOF) return -1;
> +		value =3D getc(fin);
> +		if (value =3D=3D EOF) return -1;
>=20=20
> +		*curr =3D value;
>  		ret++;
>  		if (*curr =3D=3D '\n' && hit =3D=3D 1)
>  			return ret - 1;

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ7t3CAAoJECBgQBJQdR/0wt8QAILGSILht+e942SFJr/1IZZz
sbaqiRznalDUm1Hj/00uiOP67LFs2t7XXrnlVk0G2P1oCGzxDNFdDonayYoNxwyU
rwDBtmkEB79/794fSZATN87Ufi3Ye3Jl92QmO12EoYIrXTz+oqk1ESDfMs/xdvlk
Jp0UspTVBbGbfGb5S8coDHxqXcT6DZQyYLxpbAvVvYQDhVtVPaKdUiDvNrdkjmnA
++fyVL4+mUSZUzpAVEOY1aaiM5O8gqYQR0l7aZzahEPrfNptSF+BPLIzp4py3u+l
FSdxBHMt8ICq7Ka5ibQjvV9Vx30bf89pBmC91Om3ESS0E7S83EX5F+UIs1q7BT7k
4R0TcH3kNnaZ8mAp+1/qH0rfXzfUxpWJoINLi/xa4VcxT1eucYSmQ6534NiWx1aY
sYTvO1xiY5HXVBHef4vdn3Ru/HFxfFTjvs+mVR382/p+PkAi/Ctvd7WDCn220ZBQ
6rW7/TRJbKiafJgvZH/PmiDdXe/l/VIUvsStFUntVNos1+/QO/Uze0JzMQOzYsyt
WMda1cMNSHn5zEznfsBcaIlKa8/jKyl1QRiMg4OYVnfClWMoifDuqlCMm76TY4H3
ftGRdauqJH+joG1UDRbG4xiZ1CukqEc1sNkTKVsE3f3jM2+6grxcwfjukHBjYmvU
5LmNmlN+NzhSYV/zS6sd
=5XLl
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
