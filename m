Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab0J2M6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:58:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab0J2M6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:58:04 -0400
Message-ID: <4CCAC4CD.7000503@pengutronix.de>
Date: Fri, 29 Oct 2010 14:57:49 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: Tomoya <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <4CCAA3D4.8070408@dsn.okisemi.com>
In-Reply-To: <4CCAA3D4.8070408@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC4617654CB69CC8FA8EDD4A5"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC4617654CB69CC8FA8EDD4A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

On 10/29/2010 12:37 PM, Tomoya wrote:
>>>> what does this loop do? why is it nessecarry? I don't like delay loo=
ps
>>>>   in the hot path of a driver.
>>> This loop is for waiting for all tx Message Object completion.
>>> This is Topcliff CAN HW specification.
>> What do you mean with "tx Message Object completion"? Is TX done not
>> signaled via interrupt?
> Yes Tx done is signaled via interrupt.
> On the other hand, register "CANTREQx" also shows the status of Message=
 Object.
> Reading the register, CAN driver can know the Message Object is empty o=
r not.
> In case of this processing, using this register is better, I think.
>=20
>> Please explain why you need to wait multiples of
>>> 500us here in the hot TX path.
> You are right. The value "500us" was too big.
> According to Topcliff document, it takes 3~6 cycles for transferring be=
tween
> register and Message Object RAM.
> Since 50MHz is, 1cycle=3D0.02usec, 6cycle=3D0.12. May be true.
> I will modify 500usec to 1usec.
>=20
>>>>> All these check if busy in the code make me a bit nervous, can you
>>>>> please explain why they are needed. A pointer to the manual is okay=
, too.
>>>> Me too. I already ask in my previous mail how long that functions
>>>> usually blocks.
>>> When accessing read/write from/to Message RAM,
>>> Since it takes much time for transferring between Register and Messag=
e RAM,
>> Much time means how many mirco-seconds?
> ditto
>=20
>>> SW must check busy flag of CAN register.
>>> This is a Topcliff HW specification.
>> Maybe the busy check could also be done *before* the Message RAM is
>> accessed to avoid (or minimize) waiting.
> Yes, *before* is right.
> If there is *after* processing, this is a bug.
> Can you see anyway ?

Sorry I don't understand what you mean.

>> Can you give us a pointer into intel's documentation?
> You have already had Intel's data sheet(Topcliff/Atom E6xx series), rig=
ht ?
> What's document for ?

You probably know the datasheet, but I don't, although I've printed
chapter 13 from the Intel Controller Hub EG20T datasheet, but it's 50+
pages. If the hardware needs the busy waiting in the hot tx path a
pointer to the respective section in the manual is a good idea. Just
something like:

    According to the Datasheet $REFERENCE section $SECTION_NUMBER we
    need to wait until the $FOO operation finished.

>>> If you figured out how to use the endianess conversion functions from=

>>> the cpu_to_{le,be}-{le,to}_to_cpup family use them here, too.

> Sorry, I misunderstood the spec of Topcliff CAN endianess.
> I have understood endianess conversion is not necessary.
> (CAN data is set as Big-Endian in Topcliff CAN register)

>> You have to change the definition of the regs struct a bit:
>>> 	u32 if1_mcont;
>>> 	u32 if1_data[4];
>>> 	u32 reserve2;
> Uh, I can't find this. Where is this ?

Here's a patch to illustrate what I meant:

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 55ec324..5ee7589 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -150,10 +150,7 @@ struct pch_can_regs {
        u32 if1_id1;
        u32 if1_id2;
        u32 if1_mcont;
-       u32 if1_dataa1;
-       u32 if1_dataa2;
-       u32 if1_datab1;
-       u32 if1_datab2;
+       u32 if1_data[4];
        u32 reserve2;
        u32 reserve3[12];
        u32 if2_creq;

>> BTW: Where can I get this Intel Hardware to improve and test the drive=
r?
> We don't know, please contact to Intel,
> Topcliff is formally called "Atom E6xx series" http://edc.intel.com/Pla=
tforms/Atom-E6xx/

> I have completed modifying for your comments excepting above.
> Receiving many comments, your indication may be dropped. If you find, p=
lease indicate again?.
> For your confirming my modification, I show current whole of CAN driver=
=2E

The driver has already been merged. Please send incremental patches
against david's net-2.6 branch.

Cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC4617654CB69CC8FA8EDD4A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzKxNAACgkQjTAFq1RaXHPCvwCbBlPZN3JhTAIatbD1149ldBLb
IAoAoIasJRPBFVcNPhFTc+DjHJbmT0ZO
=xH16
-----END PGP SIGNATURE-----

--------------enigC4617654CB69CC8FA8EDD4A5--
