Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab1LKJYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 04:24:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61187 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1LKJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 04:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <1322555472.4110.8.camel@jlt3.sipsolutions.net>
References: <20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	<CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	<20111125123720.GA31564@gamma.logic.tuwien.ac.at>
	<CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
	<CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com>
	<1322387175.4044.16.camel@jlt3.sipsolutions.net>
	<CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com>
	<20111128035627.GH1422@gamma.logic.tuwien.ac.at>
	<CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com>
	<20111128042343.GA4619@gamma.logic.tuwien.ac.at>
	<20111128232525.GA12719@gamma.logic.tuwien.ac.at>
	<CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com>
	<1322555472.4110.8.camel@jlt3.sipsolutions.net>
Date: Sun, 11 Dec 2011 11:24:06 +0200
Message-ID: <CANUX_P2YeE1ixzFU5VM-oex0aTURqr54VHt5FVAL9BJ0PuRX_A@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Norbert Preining <preining@logic.at>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Intersperesed I see some other messages that are new to me:
>> > [ 4019.443129] Open BA session requested for 00:0a:79:eb:56:10 tid 0
>> > [ 4019.500149] activated addBA response timer on tid 0
>> > [ 4020.500033] addBA response timer expired on tid 0
>
> I guess the delay here is due to the synchronize_net()? That can take a
> while, 57ms seems a lot but I suppose it's possible.
>
>> > [ 4020.501626] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
>> > [ 4023.740570] switched off addBA timer for tid 0
>> > [ 4023.740578] got addBA resp for tid 0 but we already gave up
>>
>> Here is the AP is finally replying
>
> It's kinda hard to believe that the AP took 4 seconds (!) to reply to
> the frame. Where could the frame get stuck? I don't see any other work
> processing happening etc. either. It's also curious that in those 3
> seconds between these messages, we didn't actually get around to
> stopping the session, that only happens just after:
>

<snip>

>
>
> Could something be hogging the workqueues?
>


So I tried to understand what is going on with the workqueue and ended
up to see that if we are lucky, we can need the workqueue for the BA
handshake (could be AddBA / DelBA handling, or driver callback) while
we are scanning. Which basically means that we will need to wait until
the scan is over to handle these frames / callbacks. I got these
measurements while stopping the BA session:

* scanning working for roughly 3 seconds (pardon me not being precise,
but with this order of magnitude I don't care much about the single
millisecond..)
* when scanning is over, the while loop in ieee80211_iface_work
consumes 73 mgmt for about 34ms.
( how come we have so many beacons during those 3 seconds..., or maybe
all the BCAST probe request ?, my network is quite busy...)
* then the finally my stop_tx_ba_cb was served which took 10ms (time
takes by the driver).
* another series of beacons (10ms).
