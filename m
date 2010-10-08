Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab0JHUCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:02:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35536 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab0JHUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=SDbMX89eH3c2wOhCrpmnKp9mV5vTiL3OxdTialFdZCc2mBWnYuOTnyTaf2XNl+adkw
         UGqrGwEQTeeGW3CEdDTMiM6YnkJhuZ7C6zwNOrRjxORTzYYRstPd+eANzVXhOpA0HaQr
         g7D9PeO3T3BVgghOqNmqnuDyfFO5JXzfOMul4=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 Oct 2010 12:54:24 -0700
Message-ID: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com>
Subject: Roaming / offchannel enhancements for broadcast / multicast frames
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Matt Smith <Matt.Smith@atheros.com>,
        Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
        Carolyn Waller <Carolyn.Waller@atheros.com>,
        Amod Bodas <Amod.Bodas@atheros.com>,
        David Quan <David.Quan@atheros.com>,
        Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
        Cliff Holden <Cliff.Holden@atheros.com>,
        Aeolus Yang <Aeolus.Yang@atheros.com>, Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We spoke about how to handle broadcast / multicast frames when going
offchannel at the Wireless Summit [1]. A lot of these talks were lead
due to a Chrome side open bug
[2].  Chrome has dealt the critical issues by preventing doing a scan
when we are doing DHCP but we need a resolution in the long term. At
the summit I do not believe we made any solid conclusions but we did
throw out a lot of ideas. After the summit a few of us at Atheros met
and reviewed strategies to consider for doing this the best way
possible. I'd like to summarize our latest conclusions and plan on
addressing this and see if we can reach some consensus and priorities.

First, we need a force scan command API. This can be used by userspace
when it knows it wants to roam and it can allow mac80211 to drop
broadcast / multicast frames as there is a priority to roam / scan
over keeping these frames. Then we can implement a deadzone event that
userspace can pick up which will let userspace know we can RX from an
AP but cannot TX to it. We can send this event once the connection
monitor hits a trigger but the beacon monitor is still OK. Note how
some hardware has its own beacon monitor so we'll also need these
drivers to send these events to mac80211. Userspace may want to force
a roam when this deadzone event hits. Once we have these two in place
we can then ignore bgscan requests (when associated) unless a force
scan command has been issued by userspace, or unless we are idle. To
determine if we are idle we can use the existing dynamic power save
timers.

Then we need to move to mac80211 the code that checks we have RX'd all
multicast frames / broadcast frames prior to going to power save or
going offchannel. In the worst case scenario we will have missed the
last broadcast / multicast frame, so we can rely on the next beacon as
an indication the AP is done with all buffered broadcast / multicast
frames. ath9k already has code for all of this, so this just need to
be shifted to mac80211 for drivers that do software scan. In the worst
case scenario and unfortunately this seems to be the most common one,
a DTIM of 1 is used and we will have to be on channel and awake every
beacon interval. In this case we may want to optimize scan time by not
scanning passive scan channels. I still do believe we will drop some
broadcast / multicast frames in this case though, but avoiding a
bgscan  when we are not-idle should cure most critical frame drops.

I've documented all this on our respective TODO wiki [3]. If you have
further ideas or tweaks to this approach please chime in and feel free
do edit the wiki as you see fit. this is a good time to invite people
to also subscribe to the wiki for edits.

  Luis

[1] http://wireless.kernel.org/en/developers/Summits/SanFranciscoBayArea-2010
[2] http://code.google.com/p/chromium-os/issues/detail?id=5713&q=ath9k&colspec=ID%20Stars%20Pri%20Area%20Type%20Status%20Summary%20Modified%20Owner%20Mstone
[3] http://wireless.kernel.org/en/developers/todo-list
