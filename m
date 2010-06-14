Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0FNVkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:40:51 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44730 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab0FNVks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:40:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: prevent print_graph_duration buffer overflow
In-Reply-To: Your message of "Sun, 13 Jun 2010 17:01:34 EDT."
             <1276462894.2356.6.camel@cndougla-ubuntu>
From: Valdis.Kletnieks@vt.edu
References: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com> <1276449108-21328-2-git-send-email-chase.douglas@canonical.com> <40245.1276462373@localhost>
            <1276462894.2356.6.camel@cndougla-ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276551633_4535P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jun 2010 17:40:33 -0400
Message-ID: <15749.1276551633@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4C16A1D3.0108,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1276551633_4535P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 Jun 2010 17:01:34 EDT, Chase Douglas said:
> On Sun, 2010-06-13 at 16:52 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Sun, 13 Jun 2010 13:11:48 EDT, Chase Douglas said:
> > > Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
> > > condition. We know the exact size of nsecs_str, so use it instead of
> > > math that may overflow.
> > 
> > >  	/* Print nsecs (we don't want to exceed 7 numbers) */
> > >  	if ((s->len - len) < 7) {
> > > -		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
> > > +		snprintf(nsecs_str, sizeof(nsecs_str), "%03lu", nsecs_rem);
> > 
> > We only get into this code after we've checked that the length is under 7
> > characters.  How much overflow can happen as long as the sizeof(nsecs_str) is a
> > sane size (like at least 8 chars)?  Probably a better bet would be doing the
> > right thing and 'BUILD_BUG_ON(sizeof(nsecs_str) < 8);'?
> 
> nsecs_str is a local variable defined just above this block of code as:
> 
> 	char nsecs_str[5];
> 
> I was hitting cases where s->len == 64 and len == 63, leading to the
> size argument of snprintf being 7 on a 5 byte string. I didn't delve too
> much into the reasoning for the if statement, but I think it's math is
> not actually related to the size of nsecs_rem but to some other string
> length.

This is starting to smell like that patch is just papering over a bug...

I saw that '8 -' and made the rash assumption that was the size of the array.
Is 5 in fact big enough and the  's->len - len' calculation is broken, or
should it be bigger?  As you noted, that length calculation is looking a tad
sketchy.  (And if we're stuck with '5' because it's a magic number for
somebody's formatting purposes, maybe it needs to be a #define?)


--==_Exmh_1276551633_4535P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMFqHRcC3lWbTT17ARApA8AJ9CfCXXt7RI5tPV04WGkDakNWtyhwCfdT3/
NbmtT5a9rFl1gjG7tIKWhGA=
=ZuBY
-----END PGP SIGNATURE-----

--==_Exmh_1276551633_4535P--

