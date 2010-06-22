Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0FVRfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:35:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46210 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0FVRfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D/SNp1SlRwURhgHIhYUTTgHQLEs+INIEpQLeisShM55ig1DIYV8C7wqs1ghwsz7SAH
         TCOIJKGqp9u8EqF2b0Cx+70R/cQRm0559axFyNFiJQHqkYmN5SpyP/foilRix1rgsOUO
         ySX6VpSdSlSlhSVqfbig+65BFbEy6OCjwkqcs=
MIME-Version: 1.0
In-Reply-To: <1277217804.3057.428.camel@edumazet-laptop>
References: <AANLkTilCW2iqsNaWM9NYIomy8OxGC9jG40KpLcKMYTqL@mail.gmail.com>
	<20100621202854.de928e0a.akpm@linux-foundation.org>
	<AANLkTimsDSrEL8vT877pLYSa4A338p4Y8w0Ya6Xm7BFJ@mail.gmail.com>
	<1277217804.3057.428.camel@edumazet-laptop>
Date: Tue, 22 Jun 2010 10:36:28 -0600
Message-ID: <AANLkTikIzdbNH83SkIxCxEL2NMZmfErq7s6WgAGPtbwi@mail.gmail.com>
Subject: Re: 2.6.34 Crash in dmaengine_put()
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> OK.  This bug occurs if you OR in the IFF_UP flag while creating
>> virtual interfaces without going through the normal ifup/ifdown
>> scripts.  Looks like a hole.  I will post the trace shortly.  It's
>> easy to reproduce, take the dummy net driver, OR in the IFF_UP flag in
>> dummy_setup, and watch the kernel crash.
>>
>
> Then dont do that ?
>
> No need to send us a trace, unless you use a pristine kernel.
>
> IFF_UP changes rules are very strict, dont try to avoid them and claim
> there is a hole or something wrong.
>
> Check __dev_open() , __dev_close() and __dev_change_flags() were OR/AND
> IFF_UP is done by core network.
>
> Net drivers are not allowed to change IFF_UP themselves.
>
> (DE-600 & DE-620 being the exceptions to confirm this rule, of course)
>

Gee.  OK, its a bug.  I see the crash when unregister_netdev is
called.  Changing a flag in a driver should not cause the kernel to
crash.  You should check the code.  The dmaengine registration should
have nothing to do with registering a netdev -- period.  I have coded
arounnd it but its damn convenient to create virtual drivers on the
fly and mark them as UP without needing to configure a bunch of text
scripts to bring one up or down.

The code itself is busted because it has a check if the dmaengine ref
count goes negative.  If you are going to have a registration layer
the rest of the OS should not have to wonder about its disconnected
state.  The busted code is right at the top of dmaengine_put where it
decrements the ref count then immediately jumps to a bug.  Need a
better way here I think to prevent needless crashes.  Someone could
just alter this flag remotely and crash a server -- HOLE - :)

Jeff
