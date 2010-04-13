Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab0DMJF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:05:57 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:62945 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0DMJFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:05:55 -0400
X-Greylist: delayed 2092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 05:05:55 EDT
Date: Tue, 13 Apr 2010 10:30:50 +0200
From: Michal Svoboda <michal.svoboda@agents.felk.cvut.cz>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: SO_REUSEADDR with UDP (again)
Message-ID: <20100413083050.GA16331@myhost.felk.cvut.cz>
Mail-Followup-To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FELK-MailScanner-Information: 
X-MailScanner-ID: o3D8UoMG041981
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.9,
	required 5, autolearn=not spam, BAYES_00 -1.90)
X-FELK-MailScanner-From: michal.svoboda@agents.felk.cvut.cz
X-FELK-MailScanner-To: linux-kernel@vger.kernel.org
X-FELK-MailScanner-Watermark: 1271752253.03473@LNtpta3uX9/7k86Zj6+Edg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,

I found SO_REUSEADDR on UDP sockets to behave somewhat nasty. If you
create a UDP socket with that flag and bind it to a port, then anyone
doing the same later will "steal" your packets, ie.

1. process A binds to port 12345 with SO_REUSEADDR, packets to that port
   go to process A
2. process B binds to port 12345 with SO_REUSEADDR, packets to that port
   now go to process B
3. A dies, fires up again, packets go back to A
4. A dies, does not fire up, packets go to B, as if they were stacked

And this works even if A and B are owned by different users, thus anyone
can "steal" packets from anyone as long as they use SO_REUSEADDR.
However, in most programs that's the default.

Furthermore, one can lock-out a particular source from being "stolen" by
using connect() to that source, ie.

1. process A binds to port 12345 with SO_REUSEADDR, gets the packets
2. B does the same, gets the packets, but also connect()s to the source
   of the packets
3. A can now restart or try to bind again, but does not get the packets
   (from that source)

(I haven't tested the case if A also issues a connect() even if it does
not receive packets.)

All of this seems confusing to me, and the fact that users can steal
packets from each other seems like a mild security risk. I've found some
discussions about this from circa 2002, but the above cases were not
mentioned. So - a problem or not?


Michal Svoboda



--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvEK7oACgkQg/fU9pp1uX6MwgCePKNfOLprpWMJkktY58+ecrHk
bsQAoK64DSajY4aYJqdrWtqfzhSnmW9W
=5h2P
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
