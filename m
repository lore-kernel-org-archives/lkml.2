Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0HKP6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:58:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:57392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0HKP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:58:36 -0400
Subject: Re: Query: Patches break with Microsoft exchange server.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: viresh kumar <viresh.kumar@st.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Valeo de Vries <valeo@valeo.co.cc>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>, mihai.dontu@gmail.com,
        richardcochran@gmail.com, "Gadiyar, Anand" <gadiyar@ti.com>
In-Reply-To: <4C62C5BD.3020808@mnsu.edu>
References: <4C5F9B25.8080401@st.com>
	 <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>
	 <4C624AE1.30504@st.com>  <4C62C5BD.3020808@mnsu.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 16:58:25 +0100
Message-ID: <1281542305.5107.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 10:46 -0500, Jeffrey Hundstad wrote:
> Exchange 2010 does not handle IMAP "chunking" (partial message transfer) 
> correctly.  Any request after about 1 megabyte of total message size 
> will fail.
> 
> Thunderbird uses this "chunking" feature to give you a status update 
> while downloading large messages.  The IMAP statements are of this type:
> 11 UID fetch 244477 (UID RFC822.SIZE BODY[]<20480.12288>)
> 
> When the 20480 is larger than 1MB Exchange "claims" there is no more.  
> Sigh.... 

I think the problem is not with the fetching -- the problem is that
Exchange lies about RFC822.SIZE before the IMAP client even starts to
fetch the message. It reports a size which is smaller than the actual
size of the message, thus leading to truncated fetches.

In Evolution we have a workaround -- we don't just stop when we get to
the reported RFC822.SIZE; we continue fetching more chunks until the
server actually stops giving us any more. It's not as efficient (because
we fall back to having only one more chunk outstanding at a time rather
than the normal three in parallel), but at least it works around this
brokenness of Exchange.

http://git.gnome.org/browse/evolution-data-server/commit/?id=9714c064

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

