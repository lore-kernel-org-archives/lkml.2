Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0HYMTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:19:41 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:51547 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751972Ab0HYMTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:19:37 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 08:19:36 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=NHKlSqJxHGqT6iJ+4Lje1mVaG5yRDIuSKt6KW7ZvdQ8RnBVc7TWK+9dBimBHbI6qn+a+dfPNeQdT67WT3cf4dJj5NacA43rfHMbQvaYMFuTTEa/VV82WPD/6eR5DFluFjwh9Y/CTAp15tAjWZyFC8Hc84IDhOSSuuMoObZo3Mqg=;
Date: Wed, 25 Aug 2010 16:10:58 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Marc Aurele La France <tsi@ualberta.ca>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: MTU for serving NFS on Infiniband
Message-ID: <20100825121058.GA28498@ms2.inr.ac.ru>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca> <20100823080543.319143e3@nehalam> <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca> <1282672647.2302.15.camel@achroite.uk.solarflarecom.com> <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca> <1282688441.22839.34.camel@localhost> <20100824153920.63360072@s6510> <1282715698.2467.681.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282715698.2467.681.camel@edumazet-laptop>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> It is, but ip_append_data() is allocating a huge head if MTU is huge.

Hmm, strange, as I remember, it was supposed to work right.

If the device supports SG (which is required to accept non-linear skbs anyway),
then ip_append_* should allocate skbs not rounded up to mtu and we should
allocate small skb with NFS header only. Does not it work?

I can only guess one possible trap: people could do _one_ huge ip_append_data()
(instead of "planned" scenario, when the header is sent with ip_append_data()
and the following payload is appended with ip_append_page()). Huge ip_append_data()
will generate huge skb indeed. Is this the problem?


BTW this issue could be revisited and this "will generate huge" can be reconsidered.
Automatic generation of fragmented skbs was deliberately suppressed, because it was
found that all devices existing at the moment when this code was written
are strongly biased against SG. Current code tries to _avoid_ generating
non-linear skbs, unless it is intended for zero-copy, which compensated
bias against SG. Modern hardware should work better.

Alexey
