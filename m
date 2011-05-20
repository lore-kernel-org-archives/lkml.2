Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab1ETPf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:35:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58745 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931Ab1ETPf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:35:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: Your message of "Thu, 19 May 2011 17:02:21 +0200."
             <BANLkTikuEERvEnBvm9-zHy2Uoc=4PUwHjQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <20110519144312.38177704@lxorguk.ukuu.org.uk>
            <BANLkTikuEERvEnBvm9-zHy2Uoc=4PUwHjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305905687_2669P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 May 2011 11:34:47 -0400
Message-ID: <9885.1305905687@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DD68A18.01F8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305905687_2669P
Content-Type: text/plain; charset=us-ascii

On Thu, 19 May 2011 17:02:21 +0200, "D. Jansen" said:
> On Thu, May 19, 2011 at 3:43 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > That at least cuts down most failures (but not all - eg commits with a network
> > component such as email receives)
>
> I don't understand your email example.

If you don't understand Alan's example, maybe you shouldn't be messing with
code that's used for correctness guarantees.  But I'll spell it out for you:

You turn on laptop mode.  You check your mail.  You download 5 new messages,
which your laptop then *assures* the mail server "I've got them, we're cool".
Now, this is a pretty heavy responsibility (for example, RFC2821 says this:

6.1 Reliable Delivery and Replies by Email

   When the receiver-SMTP accepts a piece of mail (by sending a "250 OK"
   message in response to DATA), it is accepting responsibility for
   delivering or relaying the message.  It must take this responsibility
   seriously.  It MUST NOT lose the message for frivolous reasons, such
   as because the host later crashes or because of a predictable
   resource shortage.

So - the mail server then deletes the mail because the laptop has told it "Yes,
I've gotten it, it's stable, and even if I crash I won't lose it".  But since
the mail program's fsync() calls got suppressed, it really *isn't* stable, so
when you crash, the mails are gone. Poof.

Second order effects crop up after that - after you recover from the crash,
your end has no memory of downloading the 5 messages, so it tries again - only
to have the mail server say "No such message".  This is the sort of inconsistency
that gives guys at the support desk indigestion...

Understand better now?


--==_Exmh_1305905687_2669P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN1ooXcC3lWbTT17ARAsBnAKDAH4A0rmTip/j3sXI9PE8IJ6aHMQCeKWB7
bahkpzwnGqqwO+J2ExDfNKM=
=Br8w
-----END PGP SIGNATURE-----

--==_Exmh_1305905687_2669P--

