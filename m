Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2JEPuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:50:55 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50341 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2JEPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:50:52 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Nico Schottelius <nico-kernel20120920@schottelius.org>
Cc: David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
In-Reply-To: Your message of "Wed, 03 Oct 2012 23:23:11 +0200."
             <20121003212311.GA14018@schottelius.org>
From: Valdis.Kletnieks@vt.edu
References: <505B1FA0.6030100@broadcom.com> <20120921194931.GA732@schottelius.org> <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com> <20120926060653.GD16575@schottelius.org> <20120926085708.GA7839@schottelius.org> <20120927055208.GA25252@schottelius.org>
            <20121003212311.GA14018@schottelius.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1349452084_2935P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Oct 2012 11:48:04 -0400
Message-ID: <22962.1349452084@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.506F0136.0135,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1349452084_2935P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <22610.1349452075.1@turing-police.cc.vt.edu>

On Wed, 03 Oct 2012 23:23:11 +0200, Nico Schottelius said:

> does anyone of you have a clue so far what may be causing the huge
> slab usage?
>
> I've just found an interesting detail: umounting and cryptsetup
> luksClosing frees up the used memory (not sure which one was freeing
> up)

For what it's worth, I'm seeing a similar problem in linux-next on my laptop -
trying to run a backup to an external hard drive that has a LUKS partition on
it will OOM. (For some reason having the external LUKS partition is much more
problematic than the LVM-on-LUKS on the internal drive)

I've started bisecting, and gotten this far:

% git bisect log
git bisect start
# bad: [1aa44772a621e8547dc4db41b47c747469fe0ea3] Add linux-next specific files for 20121001
git bisect bad 1aa44772a621e8547dc4db41b47c747469fe0ea3
# good: [fea7a08acb13524b47711625eebea40a0ede69a0] Linux 3.6-rc3
git bisect good fea7a08acb13524b47711625eebea40a0ede69a0
# good: [526c4d73327f56f83da8b8088fd0b3c7be38c7ae] Merge remote-tracking branch 'regulator/for-next'
git bisect good 526c4d73327f56f83da8b8088fd0b3c7be38c7ae
# good: [961d70d88557405c5b7302c7d87752566468f035] Merge remote-tracking branch 'tty/tty-next'
git bisect good 961d70d88557405c5b7302c7d87752566468f035

(That's as far as I've gotten that I trust, the next bisect hits a different problem where
connecting the hard drive and *starting* cryptLuks hangs the machine hard, so I'll
have to finish bisecting that problem first, then return to bisecting this one)

I admit not being sure why you see it on a 3.5 kernel, but I only see it on stuff
that's after 3.6-rc3.

--==_Exmh_1349452084_2935P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUG8BMwdmEQWDXROgAQK/nQ//XMlZSEoXM4kjMizzv2EMI9HzxCJKzxbC
pfmVWOIkxh/eCNs/3W0oUzKmahslZjwvxTs09HT8tJzsRwBgmCVvOEFkDFW9qzg1
+daFGrBWGsWEgA306irjnmh+AHEzARE4QkVeQhaphoKv1CqmldWHPjPnzKJsbrg6
RNmyvF4c3zFpgfE7PKxAWJNWcJnSMv2DVjFg/umy71s5ikILm8n7cRKpmQ5p6SN5
FPkNlUX/aG6RJ2OpQzmD0yDLPJKu7RTY6qyz2Y0l9IIA7yxYtpyTalNZ+xXRopMK
LWFKZcz/zOnr0maum3ITPslLLQ4cPRGnzEqnuezWvW1ZeP74Uj18kkk73v2GnVye
eqX4xQTltD3YrxECaIG9+HKYWZ1buaXB7TPs5Fw02NlIe1pq8qV5W6Rs4oTJm1Dg
nRpJwuuBl3/i2vaIS6Jw/+yZ8vTcRYBPcVcEnUsKAmGVr6RFAuAJ/SWgVnw2Lj9W
BVPbrqWgtcVhT6B1D6tRT5FZKfrsal4l+ciBxtYzQH+2drdQTc7hGzwqzWpnEtek
0E7N84/0S6jh71JaPnOrEC1WufQBgDfLoKguRcW9IPXHWKq7ZNOhdGiKEavVQtHd
YOu3AuCVsB+xfS8NqmNDAdXrHw1GrMO1JkydsKA59BeXQtIvN+T2NrW/B4vJIUv0
oVYlfN9GnVw=
=dT/C
-----END PGP SIGNATURE-----

--==_Exmh_1349452084_2935P--

