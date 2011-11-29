Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1K2G7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:59:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62782 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1K2G7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:59:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111128232525.GA12719@gamma.logic.tuwien.ac.at>
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
Date: Tue, 29 Nov 2011 08:59:22 +0200
Message-ID: <CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Ok, here we go. First of all, it seems that the problem is solved
> inthe sense that the connection stays alive all the time and does not
> disappear. OTOH, I now get quite a lot of messages, that might point
> either to a broken AP here, or something else:

The code that actually fixes the problem you were seeing deals with a
case were the AP is a bit "late". We request something from the AP,
give up and only then the AP replies to our request. This flow wasn't
handled properly. So yes, your AP is still replying late, and debug
message will get printed (especially if you have enabled the
MAC80211_HT_DEBUG because I asked you to), but at least you will be
able to continue working.
When yesterday I told you that your log looks too good, I meant that I
didn't see that your AP was late and basically I didn't see you
entered the flows that we weren't handling properly before the fix.

>
> After resume I see:
> [ 3995.266230] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [ 3995.270239] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [ 4002.943037] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
> [ 4002.945672] wlan0: authenticated
> [ 4002.951806] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
> [ 4002.964652] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
> [ 4002.964662] wlan0: associated
> [ 4007.088934] Rx A-MPDU request on tid 0 result 0
>
> then it starts with these, and there are *many* of them, literally
> several hundreds
> [ 4019.340036] ieee80211 phy1: release an RX reorder frame due to timeout on earlier frames
>
> Intersperesed I see some other messages that are new to me:
> [ 4019.443129] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> [ 4019.500149] activated addBA response timer on tid 0
> [ 4020.500033] addBA response timer expired on tid 0

Here we are giving up because the AP is late.

> [ 4020.501626] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
> [ 4023.740570] switched off addBA timer for tid 0
> [ 4023.740578] got addBA resp for tid 0 but we already gave up

Here is the AP is finally replying

> [ 4023.740619] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
> [ 4023.768544] Open BA session requested for 00:0a:79:eb:56:10 tid 0

Here we are trying again

> [ 4023.784292] activated addBA response timer on tid 0
> [ 4023.786294] switched off addBA timer for tid 0
> [ 4023.786301] Aggregation is on for tid 0
> [ 4023.786480] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0

Successfully this time.

>
>
> [ 4107.143615] Open BA session requested for 00:0a:79:eb:56:10 tid 6

Are you using VoIP ?

> [ 4107.180359] activated addBA response timer on tid 6
> [ 4107.182333] switched off addBA timer for tid 6
> [ 4107.182338] Aggregation is on for tid 6
> [ 4107.182567] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
> [ 4124.093846] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
> [ 4124.093856] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0
> [ 4124.094270] Rx A-MPDU request on tid 0 result 0
>
>
> At the end there are mostly two lines, the
> [ 5983.321525] net_ratelimit: 1 callbacks suppressed
> [ 5983.321537] ieee80211 phy1: release an RX reorder frame due to timeout on earlier frames
>
> Where for every 10-20 of the second one there is one of the first one.

Yes, your AP doesn't seem to resend lost frames, or we don't send  BAR
properly ?

>
> =============================
> Anyway, the connection might stumble now and then a bit, but it does
> not break down, so I don't complain ;-)
>
> BIG THANKS to everyone!!!
>

Thanks for you testing and patience.
