Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0E1KNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:13:06 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:38160 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab0E1KNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:13:04 -0400
X-Greylist: delayed 3205 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 06:13:04 EDT
Subject: Re: Question about SIOCGIFCONF
From: Steven Whitehouse <steve@chygwyn.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1275022651.2446.35.camel@edumazet-laptop>
References: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
	 <1275022651.2446.35.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: ChyGwyn Limited
Date: Fri, 28 May 2010 10:22:19 +0100
Message-ID: <1275038539.2364.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2010-05-28 at 06:57 +0200, Eric Dumazet wrote:
> Le jeudi 27 mai 2010 à 21:02 -0600, Jeffrey Merkey a écrit :
> > Why is SIOGICONF only instrumented to return a single interface lo for
> > example.  I noticed that ifconfig always uses /proc/net/dev but the
> > older SIOCGIFCONF ioctl seems to be busted.  Anyone have an
> > explanation or is this just how the shit is these days or is the
> > fucking thing broken (seems to be). ?
> 
> Shit comes from you eyes maybe ?
> 
> Correction : Shit comes from your eyes, definitely.
> 
> Proof :
> 
> # strace -o /tmp/STRACE ifconfig -a
> # grep SIOCGIFCONF /tmp/STRACE
> ioctl(4, SIOCGIFCONF, {120, {{"lo", {AF_INET, inet_addr("127.0.0.1")}},
> {"wlan0", {AF_INET, inet_addr("192.168.1.21")}}, {"ppp0", {AF_INET,
> inet_addr("10.150.51.210")}}}}) = 0
> 
> 
> Part of ifconfig :
> 
>     ifc.ifc_buf = NULL;
>     for (;;) {
>         ifc.ifc_len = sizeof(struct ifreq) * numreqs;
>         ifc.ifc_buf = xrealloc(ifc.ifc_buf, ifc.ifc_len);
> 
>         if (ioctl(skfd, SIOCGIFCONF, &ifc) < 0) {
>             perror("SIOCGIFCONF");
>             goto out;
>         }
>         if (ifc.ifc_len == sizeof(struct ifreq) * numreqs) {
>             /* assume it overflowed and try again */
>             numreqs += 10;
>             continue;
>         }
>         break;
>     }
> 
> maybe numreqs should be firt initialized to 64, then doubled each
> round...
> 

Yes, except that this will fail if you add a protocol that is not known
about by ifconfig and it has a struct sockaddr which is larger than the
16 bytes allowed for in the ifreq. There used to be a DECnet
implementation of this ioctl() but we had to get rid of it because it
broke every single SIOCGFICONF using program (including ifconfig) on the
system for that reason.

This is partly historical. Some systems have a struct sockaddr which
includes a length parameter which means that you can always parse the
returned values, even if they are larger than 16 bytes and the protocol
is unknown. Linux does not have this length field, so you have to know
in advance a full list of all protocols which have sockaddr's greater
than 16 bytes in length in order to parse the results.

The upshot of all that is that it is much better to use rtnetlink, as
per iproute2 instead of this ioctl which is obsolete for most purposes.
A quick grep through the code suggests that ipv4 is the only protocol
which implements this ioctl currently,

Steve.


