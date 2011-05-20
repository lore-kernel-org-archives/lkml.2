Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598Ab1ETQCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:02:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54244 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab1ETQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:02:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Armando Visconti <armando.visconti@st.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fixed a crash in hid_report_raw_event() function.
In-Reply-To: Your message of "Thu, 19 May 2011 21:41:22 +0200."
             <1305834082-14888-1-git-send-email-armando.visconti@st.com>
From: Valdis.Kletnieks@vt.edu
References: <1305834082-14888-1-git-send-email-armando.visconti@st.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305907324_2669P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 May 2011 12:02:04 -0400
Message-ID: <11173.1305907324@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DD6907E.0048,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305907324_2669P
Content-Type: text/plain; charset=us-ascii

On Thu, 19 May 2011 21:41:22 +0200, Armando Visconti said:
> I'm using a Data Modul EasyTouch USB multitouch controller,
> which is issuing a hid report with a size equals to 0. The rsize
> value gets set to 536870912 and Linux is crashing in the memset
> because the value is too big.
>
> Signed-off-by: Armando Visconti <armando.visconti@st.com>
> ---
>  drivers/hid/hid-core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index c3d6626..3e972e3 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1045,6 +1045,9 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>
>  	rsize = ((report->size - 1) >> 3) + 1;
>
> +	if (rsize > HID_MAX_BUFFER_SIZE)
> +		rsize = HID_MAX_BUFFER_SIZE;
> +
>  	if (csize < rsize) {
>  		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
>  				csize, rsize);

I'm thinking this is papering over the bug, and causing us to process a max-sized
buffer when the other end gave *zero* bytes back - this can't be good.

Probably should be more like this:

	if (!report->size) then	/* 
		rsize = MIN_VALID_SIZE; /* whatever it should be here */
	else {
		rsize = ((report->size - 1) >> 3) + 1;
		if (rsize > HID_MAX_BUFFER_SIZE)
			rsize = HID_MAX_BUFFER_SIZE;
	}

	if (csize < rsize) {


That last if() still looks squirrely - if we have an effectively zero rsize,
the report is short and the dbg_hid should fire.  Did we want "csize > rsize"
instead?



--==_Exmh_1305907324_2669P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN1pB8cC3lWbTT17ARArqCAKCQWd9lr6+pYPGwFS/gBUyvELvLPgCfRoi3
iB+t44ebO5hAkXs65hSK+Gs=
=drIg
-----END PGP SIGNATURE-----

--==_Exmh_1305907324_2669P--

