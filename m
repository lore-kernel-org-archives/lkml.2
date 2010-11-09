Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0KIM7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:59:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45554 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0KIM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:59:49 -0500
Message-ID: <4CD945B4.4060408@pengutronix.de>
Date: Tue, 09 Nov 2010 13:59:32 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <005301cb7ffa$5b63cd90$66f8800a@maildom.okisemi.com> <00fe01cb8009$62e11410$66f8800a@maildom.okisemi.com>
In-Reply-To: <00fe01cb8009$62e11410$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEC8162DD2057550F76EC6216"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEC8162DD2057550F76EC6216
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: quoted-printable

On 11/09/2010 01:26 PM, Tomoya MORINAGA wrote:
>>>> Can you please explain me your locking sheme? If I understand the
>>>> documenation correctly the two message interfaces can be used mutual=
=2E
>>>> And you use one for rx the other one for tx.
>>>
>>> I show our locking scheme.
>>> When CPU accesses MessageRAM via IF1, CPU protect until read-modify-w=
rite
>>> so that IF2 access not occurred, vice versa.
>>
>> Why is that needed?
>=20
> For MessageRAM data consistency.

As far as I understand the datasheet the access to IF1 and IF2 is
completely independent. Why do you lock here?

[...]

>>>> Please use just "debug" level not warning here. Consider to use
>>>> netdev_dbg() instead. IMHO the __func__ can be dropped and the
>>>> "official" name for the error is "Error Warning".
>>>
>>> I want to know the reason.
>>> Why is it not dev_warn but netdev_dbg ?
>>
>> If you use warning level it would end up on the console or and in the
>> syslog. It's quite complicated (for programs) to get information from
>> there. This is why we send CAN error frames. They hold the same
>> information but int a binary form, thus it's easier to process.
>=20
> I understand the reason.
> BTW, Why do you say not dev_dbg but netdev_dbg ?

Sorry - netdev_dbg() is easier to use, its first argument is the
netdevice, while dev_dbg needs a device and that's deeply hidden in the
netdevice.

[...]

>>>>> +static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device=
 *ndev)
>>>>> +{
>>>>> + unsigned long flags;
>>>>> + struct pch_can_priv *priv =3D netdev_priv(ndev);
>>>>> + struct can_frame *cf =3D (struct can_frame *)skb->data;
>>>>> + int tx_buffer_avail =3D 0;
>>>>
>>>> What I'm totally missing is the TX flow controll. Your driver has to=

>>>> ensure that the package leave the controller in the order that come
>>>> into the xmit function. Further you have to stop your xmit queue if
>>>> you're out of tx objects and reenable if you have a object free.
>>>>
>>>> Use netif_stop_queue() and netif_wake_queue() for this.
>>>
>>> In this code, I think "out of tx objects" cannot be  occurred.
>>
>> It's not a matter of code it's the hardware. You cannot put more than =
a
>> certain number of CAN frames into the hardware. If you have a CAN bus =
at
>> a certain speed, you can only send a certain number of CAN frames in a=

>> second. So you cannot push more than this amount of frames/s into the
>> hardware.
>>
>>> Nevertheless, are netif_stop_queue() and netif_wake_queue() is necess=
ary ?
>>
>> Yes.
>=20
> I can' understand your issue.
> Please can you hear my opinion?
>=20
> Please see the head of pch_xmit.
>=20
>>> + if (priv->tx_obj =3D=3D (PCH_OBJ_NUM + 1)) { /* Point tail Obj + 1 =
*/
>>> +  while (ioread32(&priv->regs->treq2) & 0xfc00)
>>> +   udelay(1);
>=20
> When points tail of Tx message object,
> this driver waits until completion of all tx messaeg objects.

Looping busy it not an option here.

> Thus, application/driver ought not to be able to put Tx object exceed t=
he number of tx message object.
> Thus I think these code(netif_stop_queue/netif_wake_queue) are complete=
ly redundant.

Nope - please remove the waiting completely and convert your flow
control to netif_stop_queue/netif_wake_queue.

cheers, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigEC8162DD2057550F76EC6216
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzZRbgACgkQjTAFq1RaXHPSNACfe9Z3OSyF7KYrgUd0zPJyd7JR
4L4Anj46U33eA0XBJ4SjrSp4q5XwhvUS
=/mhx
-----END PGP SIGNATURE-----

--------------enigEC8162DD2057550F76EC6216--
