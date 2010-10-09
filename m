Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab0JIAnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:43:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58106 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0JIAnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=llgxccVWgdA/KXl/KWjYjggB3VNnBIL0arWnFNykEueTu6yCpVKHp3qdS7HW7t8aBv
         +iUQTDciFKJRSIdOgfYyULaXWt+rMuey0GmqlwHiiDD3j2WivherZ+NKPNz1dD6zzJCn
         fy/bGJv6OML2srYDA4v0wM0POBxPu0dNMorxo=
MIME-Version: 1.0
In-Reply-To: <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com>
References: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com> <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 Oct 2010 17:43:12 -0700
Message-ID: <AANLkTimBXC9P7pf+-szK3A5FoS2Sjndr8AB9JR=7V-Sr@mail.gmail.com>
Subject: Re: Roaming / offchannel enhancements for broadcast / multicast frames
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Matt Smith <Matt.Smith@atheros.com>,
        Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
        Carolyn Waller <Carolyn.Waller@atheros.com>,
        Amod Bodas <Amod.Bodas@atheros.com>,
        David Quan <David.Quan@atheros.com>,
        Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
        Cliff Holden <Cliff.Holden@atheros.com>,
        Aeolus Yang <Aeolus.Yang@atheros.com>, Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 5:08 PM, Paul Stewart <pstew@google.com> wrote:
> On Fri, Oct 8, 2010 at 12:54 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> We spoke about how to handle broadcast / multicast frames when going
>> offchannel at the Wireless Summit [1]. A lot of these talks were lead
>> due to a Chrome side open bug [2].
>
> Thanks for getting the ball rolling, Luis.  Technically the bug is in
> ChromumOS ("Chrome" is a web browser).

Heh, yeah sorry.

>> Userspace may want to force a roam when this deadzone event hits.
>
> Why not just disassociate at this point?  I'm not sure what the
> difference is between a "dead zone" situation and a reason to
> completely disconnect.

Not sure what is best, but one reason for considering to just roam is
we are at least getting data while we roam. I hope we can iron out the
best algorithm through this thread.

>> Once we have these two in place we can then ignore bgscan requests
>> (when associated) unless a force scan command has been issued by
>> userspace, or unless we are idle.
>
> By "ignore" do you mean "postpone" or or "return an appropriate error
> to userspace"?  Either of those are acceptable.  Not doing anything at
> all wouldn't be good.

Good questions. If we postpone it means we end up queuing up all these
scan requests, unless we only let a few queue up, or just one?

> There's an additional issue about what happens
> when we are in the middle of a bgscan and new tx traffic appears.

We can force going back on channel in this case I think.

>> In the worst case scenario and unfortunately this seems to be the most
>> common one, a DTIM of 1 is used and we will have to be on channel and
>> awake every beacon interval. In this case we may want to optimize scan
>> time by not scanning passive scan channels.
>
> A compromise would be to go off-channel for less than a full beacon
> interval when doing background passive channel scans in DTIM=1
> networks.  It's certainly better than (a) not scanning at all and (b)
> arguably better than intentionally dropping mcast.  An 80% beacon-time
> passive listen will get you 80% of the beacons, assuming linear
> probability, and even more over time if you account for beacon skew
> between networks.

Sure it just also means our bgscans can take up ages, if they take up
ages and we queue up a few of them then we can get a backlog of
requests from userspace agents. I suppose we need to figure out this
fine line. But yeah -- you're right, we can do scanning for less than
a beacon interval if DTIM is 1. This can mean 1024 TUs, not sure how
long it takes for us to do a passive scan, this likely is
radio/chipset specific so we'd have to add those values maybe to the
wiphy characteristics. Worth trying and seeing if its possible.

  Luis
