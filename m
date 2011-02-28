Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1B1Qkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:40:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34643 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab1B1QiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f8Q50HPHoAFgMg7UrKn+zTHQB+7bUzorO2+jm8csh5FAOI3IHd5rZXlisUO7qi5iid
         y4c8WF5Zcr4rF/uSfywqwnBlFb8ghm5XfcRzPvT+uO7oN3OxmjaS3V7DnhTcYNCmr9a7
         zbbGNFeuEwLY8thEYxsYBpi6WAIDPUcgCpvLk=
MIME-Version: 1.0
In-Reply-To: <cbb9e1113901f1a324359b6ed3f1a611@localhost>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	<alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	<1298793252.8726.45.camel@edumazet-laptop>
	<AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	<20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	<AANLkTimofhhH5omyk=HhkyaNG+MGqoac4rDf=dPuR7K-@mail.gmail.com>
	<cbb9e1113901f1a324359b6ed3f1a611@localhost>
Date: Mon, 28 Feb 2011 11:37:45 -0500
Message-ID: <AANLkTimh1xWU9V9phOKZZMgOWKOmDDSBYfofnnOjjRh=@mail.gmail.com>
Subject: Re: txqueuelen has wrong units; should be time
From: Albert Cahalan <acahalan@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:38 AM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> On Sun, 27 Feb 2011 18:33:39 -0500, Albert Cahalan wrote:
>
>> I suppose there is a need to allow at least 2 packets despite any
>> time limits, so that it remains possible to use a traditional modem
>> even if a huge packet takes several seconds to send.
>
> That is a good point! We talk about as we may know every use case of
> Linux. But this is not true at all. One of my customer for example operates
> the Linux network stack functionality on top of a proprietary MAC/Driver
> where the current packet queue characteristic is just fine. The
> time-drop-approach is unsuitable because the bandwidth can vary in a small
> amount of time over a great range (0 till max. bandwidth). A sufficient
> buffering shows up superior in this environment (only IPv{4,6}/UDP).

I don't think the current non-time queue is just fine for him.
I can see that time-based discard-on-enqueue would not be
fine either. He needs time-based discard-on-dequeue.
Good for him is probably:

On dequeue, discard all packets that are too old.
On enqueue, assume max bandwidth and discard all
packets that have no hope of surviving the dequeue check.
(the enqueue check is only to prevent wasting RAM)
Exception: always keep at least 2 packets.

Better is something that would allow random drop.
The trouble here is that bandwidth varies greatly.
Some sort of undelete functionality is needed...?

Assuming the difficulty with implementing random drop
is solvable, I think this would work for the rest of us too.

Keeping the timeout really low is important because it isn't
OK to eat up all the latency tolerance in one hop. You have
an end-to-end budget of 20 ms for usable GUI rubber banding.
The budget for gaming is about 80 and for VoIP is about 150.
