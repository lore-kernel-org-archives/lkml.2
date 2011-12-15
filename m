Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab1LOOHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 09:07:45 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:37811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1LOOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 09:07:43 -0500
Subject: Re: iwlagn is getting very shaky
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Norbert Preining <preining@logic.at>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
In-Reply-To: <CANUX_P0sCPAWTsSVXpL3w5witnVi6wrtzTgJ0y6HjC-TYC9swg@mail.gmail.com> (sfid-20111211_205719_337550_081FCE1C)
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
	 <CANUX_P2YeE1ixzFU5VM-oex0aTURqr54VHt5FVAL9BJ0PuRX_A@mail.gmail.com>
	 <CANUX_P0sCPAWTsSVXpL3w5witnVi6wrtzTgJ0y6HjC-TYC9swg@mail.gmail.com>
	 (sfid-20111211_205719_337550_081FCE1C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 15:07:33 +0100
Message-ID: <1323958053.3337.48.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I finally looked at this ...

On Sun, 2011-12-11 at 21:56 +0200, Emmanuel Grumbach wrote:
> >> Could something be hogging the workqueues?

> > So I tried to understand what is going on with the workqueue and ended
> > up to see that if we are lucky, we can need the workqueue for the BA
> > handshake (could be AddBA / DelBA handling, or driver callback) while
> > we are scanning. Which basically means that we will need to wait until
> > the scan is over to handle these frames / callbacks. I got these
> > measurements while stopping the BA session:
> >
> > * scanning working for roughly 3 seconds (pardon me not being precise,
> > but with this order of magnitude I don't care much about the single
> > millisecond..)

Oh. I see, while scanning we won't process the work queue.

> > * when scanning is over, the while loop in ieee80211_iface_work
> > consumes 73 mgmt for about 34ms.
> > ( how come we have so many beacons during those 3 seconds..., or maybe
> > all the BCAST probe request ?, my network is quite busy...)
> > * then the finally my stop_tx_ba_cb was served which took 10ms (time
> > takes by the driver).
> > * another series of beacons (10ms).
> 
> What about flushing the workqueue before we scan ?
> This is not a bullet proof solution of course, we will still encounter
> bad races, but at least  we would flush what we can before the
> workqueue becomes unable for 4 seconds (!).

Yeah, that seems like a good thing. Actually I had an idea about this
before -- drain & stop the workqueue for any functions in mac80211/cfg.c
so that mac80211 essentially becomes single-threaded.

> We can also delay the scan if we are in the middle of {add,del}BA
> handshake, which is the only flow I can think about that needs
> responsiveness. The other frame exchanges are MLME ones and involve
> the wpa_supplicant (unless we are using the late WEXT). Hopefully the
> wpa_supplicant won't request to scan in the middle of association or
> so. There might be other features (mesh or whatever), that may be
> hidden from the wpa_supplicant and require good responsiveness from
> the wq too.

Hm, yeah, that would be an idea too, but I'm not sure it's easy to do
right now.

johannes

