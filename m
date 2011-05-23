Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab1EWThl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:37:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64932 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab1EWThk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:37:40 -0400
Date: Mon, 23 May 2011 15:37:36 -0400
From: Eric B Munson <emunson@mgebm.net>
To: benh@kernel.crashing.org
Cc: robert.richter@amd.com, paulus@samba.org, oprofile-list@lists.sf.net,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oprofile, powerpc: Handle events that raise an exception
 without overflowing
Message-ID: <20110523193736.GA2997@mgebm.net>
References: <1306160560-5309-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1306160560-5309-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 23 May 2011, Eric B Munson wrote:

> Commit 0837e3242c73566fc1c0196b4ec61779c25ffc93 fixes a situation on POWE=
R7
> where events can roll back if a specualtive event doesn't actually comple=
te.
> This can raise a performance monitor exception.  We need to catch this to=
 ensure
> that we reset the PMC.  In all cases the PMC will be less than 256 cycles=
 from
> overflow.
>=20
> This patch lifts Anton's fix for the problem in perf and applies it to op=
rofile
> as well.
>=20
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> Cc: <stable@kernel.org> # as far back as it applies cleanly

I'd like to get this patch into mainline this merge window if at all possib=
le.

> ---
>  arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprof=
ile/op_model_power4.c
> index 8ee51a2..e6bec74 100644
> --- a/arch/powerpc/oprofile/op_model_power4.c
> +++ b/arch/powerpc/oprofile/op_model_power4.c
> @@ -261,6 +261,28 @@ static int get_kernel(unsigned long pc, unsigned lon=
g mmcra)
>  	return is_kernel;
>  }
> =20
> +static bool pmc_overflow(unsigned long val)
> +{
> +	if ((int)val < 0)
> +		return true;
> +
> +	/*
> +	 * Events on POWER7 can roll back if a speculative event doesn't
> +	 * eventually complete. Unfortunately in some rare cases they will
> +	 * raise a performance monitor exception. We need to catch this to
> +	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
> +	 * cycles from overflow.
> +	 *
> +	 * We only do this if the first pass fails to find any overflowing
> +	 * PMCs because a user might set a period of less than 256 and we
> +	 * don't want to mistakenly reset them.
> +	 */
> +	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <=3D 256))
> +		return true;
> +
> +	return false;
> +}
> +
>  static void power4_handle_interrupt(struct pt_regs *regs,
>  				    struct op_counter_config *ctr)
>  {
> @@ -281,7 +303,7 @@ static void power4_handle_interrupt(struct pt_regs *r=
egs,
> =20
>  	for (i =3D 0; i < cur_cpu_spec->num_pmcs; ++i) {
>  		val =3D classic_ctr_read(i);
> -		if (val < 0) {
> +		if (pmc_overflow(val)) {
>  			if (oprofile_running && ctr[i].enabled) {
>  				oprofile_add_ext_sample(pc, regs, i, is_kernel);
>  				classic_ctr_write(i, reset_value[i]);
> --=20
> 1.7.4.1
>=20

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2reAAAoJEH65iIruGRnNmAEH/RPIb6YpEtIf2/d1y6+mkJK1
97f5dWPZ8wmausN9IY1jkoSY0Jp7NNj+jHME33H54m0xPoHpScTRMvv9peUenihS
BBYDBFlIBP7HakAV1JD6i960l1/SMw8ILUo2rutou3cPKKwU0RJxQucU04UcvLUI
fcDjXLHnRooNbmp/42TZIepDSvPQQS8EXgFgxlXtoEWUTk3cD6RGjDUJcg0fswHG
He0GXeLCc0QQo6wMx+pZAmXZYhIkCDwb2+FOCUF4plyUH2Bpc3xDIOuxAhghcvRs
QkBz8Z57YF4QAB4HRTJvEj2a0uQBjYxvrLSX1kbpJtWXvcaKBKgxwR7hX9fH9rM=
=x9or
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
