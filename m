Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab1EDTEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:04:55 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38295 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1EDTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:04:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
In-Reply-To: Your message of "Wed, 04 May 2011 13:58:39 EDT."
             <1304531920-2890-1-git-send-email-josef@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1304531920-2890-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304535887_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 May 2011 15:04:47 -0400
Message-ID: <15392.1304535887@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DC1A350.0142,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304535887_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:

> -SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
> given position. 

Nearest, or next? Solaris defines it as "next", for a good reason - otherwise
you can get stuck in a case where the "nearest" hole is back towards the
start of the file - and "seek data" will bounce back to the next byte at
the other end of the hole.

Consider a file with this layout:

< 40K of data>  A  < 32K hole> B < 32K data> C < 8K hole> D <32K data> E ....

If you're in the range between "8K-1 before C" and "8K-1 after D", there's no
application of seeks to "nearest" data/hole that doesn't leave you oscillating
between C and D, and unable to reach B or E.  If youre at C, "nearest hole" is
where you are, and "nearest data" is at D, not B. Similarly for D - nearest
data is C, not E.

However, this is easily dealt with if you define it as "next", as then it is
simple to discover exactly where A/B/C/D/E are.


--==_Exmh_1304535887_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwaNPcC3lWbTT17ARAtbUAJ48TCUrI6d//FZI1ZEMR3BF9u21bACgmGZf
+qmyLCOG90edbKXJLEX/r2w=
=FvOo
-----END PGP SIGNATURE-----

--==_Exmh_1304535887_7352P--

