Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2GYBZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 21:25:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45829 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab2GYBZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 21:25:04 -0400
Message-ID: <1343179491.5132.112.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 13/17] Tools: hv: Implement the KVP verb -
 KVP_OP_SET_IP_INFO
From: Ben Hutchings <ben@decadent.org.uk>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, netdev@vger.kernel.org
Date: Wed, 25 Jul 2012 02:24:51 +0100
In-Reply-To: <1343145701-3691-13-git-send-email-kys@microsoft.com>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-1-git-send-email-kys@microsoft.com>
	 <1343145701-3691-13-git-send-email-kys@microsoft.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fuawdY8gKvNSWFmESB/i"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fuawdY8gKvNSWFmESB/i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-24 at 09:01 -0700, K. Y. Srinivasan wrote:
> Implement the KVP verb - KVP_OP_SET_IP_INFO. This operation configures th=
e
> specified interface based on the given configuration. Since configuring
> an interface is very distro specific, we invoke an external script to
> configure the interface.
[...]
> +static int kvp_write_file(FILE *f, char *s1, char *s2, char *s3)
> +{
> +	char str[256];
> +	int error;
> +
> +	memset(str, 0, sizeof(str));
> +	strcat(str, s1);
> +	if (s2 !=3D NULL)
> +		strcat(str, s2);
> +	strcat(str, "=3D");
> +	strcat(str, s3);
> +	strcat(str, "\n");
> +
> +	error =3D fputs(str, f);

This style of string pasting is crazy; have you never heard of
fprintf()?

[...]
> +	/*
> +	 * Set the configuration for the specified interface with
> +	 * the information provided. Since there is no standard
> +	 * way to configure an interface, we will have an external
> +	 * script that does the job of configuring the interface and
> +	 * flushing the configuration.
> +	 *
> +	 * The parameters passed to this external script are:
> +	 * 1. A configuration file that has the specified configuration.
> +	 *
> +	 * We will embed the name of the interface in the configuration
> +	 * file: ifcfg-ethx (where ethx is the interface name).
> +	 *
> +	 * Here is the format of the ip configuration file:
> +	 *
> +	 * HWADDR=3Dmacaddr

Is the interface supposed to be matched by name or by MAC address?

> +	 * BOOTPROTO=3Ddhcp (dhcp enabled for the interface)

The BOOTPROTO line may or may not appear.

> +	 * NM_CONTROLLED=3Dno (this interface will not be controlled by NM)
> +	 * PEERDNS=3Dyes

I wonder what the point is of including constant lines in the file.
What is the external script supposed to do if it these apparent
constants change in future?

> +	 * IPADDR_x=3Dipaddr
> +	 * NETMASK_x=3Dnetmask
> +	 * GATEWAY_x=3Dgateway
> +	 * DNSx=3Ddns

A strangely familiar format...

> +	 * IPV6 addresses will be tagged as IPV6ADDR, IPV6 gateway will be
> +	 * tagged as IPV6_DEFAULTGW and IPV6 NETMASK will be tagged as
> +	 * IPV6NETMASK.
> +	 */
> +
> +	memset(if_file, 0, sizeof(if_file));
> +	strcat(if_file, "/var/opt/hyperv/ifcfg-");

Like I said before about the key-value files, this should be under
/var/lib if the daemon is included in a distribution.  You should
perhaps use a macro for the "/var/opt" part so it can be overridden
depending on whether it's built as a distribution or add-on package.

> +	strcat(if_file, if_name);
> +
> +	file =3D fopen(if_file, "w");
> +
> +	if (file =3D=3D NULL) {
> +		syslog(LOG_ERR, "Failed to open config file");
> +		return HV_E_FAIL;
> +	}
> +
> +	/*
> +	 * First write out the MAC address.
> +	 */
> +
> +	mac_addr =3D kvp_if_name_to_mac(if_name);
> +	if (mac_addr =3D=3D NULL) {
> +		error =3D HV_E_FAIL;
> +		goto setval_error;
> +	}
> +
> +	error =3D kvp_write_file(file, "HWADDR", NULL, mac_addr);
> +	if (error)
> +		goto setval_error;
> +
> +	error =3D kvp_write_file(file, "ONBOOT", NULL, "yes");
> +	if (error)
> +		goto setval_error;
> +
> +	error =3D kvp_write_file(file, "IPV6INIT", NULL, "yes");
> +	if (error)
> +		goto setval_error;
[...]

This line isn't mentioned in the above comment.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-fuawdY8gKvNSWFmESB/i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUA9K4+e/yOyVhhEJAQryng//bKD7ka+9ZRPwYr44Mr/gm7QFvicDbw5m
f4u1YDAQZVFVUdafi/qR5QDcxpUfD4WiLP2swQvQ4vMW7Mpytn1xMaOBqJdof8c2
rf5vKDCf0uKcfMn9oohkc5XUjxFUuGO5sSKqMvg1kA1KYFTLoPGUXkiw8UqJ4fj9
HaN3yMnMfiAjHySnkRc2lJFBvvuf/jPNFA23URzAZh11YlvKpkAoZrjCeOt8WqBx
YJeDlGEznOWPyAiTHNIDaVRV69sXRhyG41n6E9TLgAXsgvzYfKcub302hM2AEZ32
AgLAyP3xfKj2XtaYo463YylA6bgf0eSx43r3i17FFZXg5Tx+Zd0wM04T6qnaiB1j
IMfBTdHY9cfXp18AOOiJADFb5zYNDSlIT7lenY2J4ib/5pyyEkHC47447eNnIyII
CH87/qpOdE7zLJHMCy+Od+MU/O6RijVz7D+4iUCMd7rYsKJgnBTg33D57v6e1178
EowR7oLXMrHZAvEllci+SSepvrX2vasXxDQX1r1sRCSYDXckOOXlhoRgZqkUstN7
8I+mAdzKjgBeqbvrM0DDMYlND8apB7rw5oYj/f7laD1C2HvQcBR8kGdxtYuXABC1
jDq6Q4DZuHMIvCXH/shi/rVstEcf8WuCwiN0XaXxS2hfS1ONC61QFMpZwLuk2I4e
ZhcsO7/h8Ks=
=RcvY
-----END PGP SIGNATURE-----

--=-fuawdY8gKvNSWFmESB/i--
