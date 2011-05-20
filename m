Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604Ab1ETK1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:27:40 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:38587 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1ETK1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JSn7A69v2kQMI2z4j7NHNfFkw+hiEySXXRTlUTU9mW84u1/w0KXX4KGFgLQ5XYaU8N
         3U99F4RUS6t6wfrNPvo2JPMfyei0ntzyBMBurMNj2CRk63Ea5+cJRW0Ci7R0JmSSrzQ4
         sU6WfiagnzOlPCZIVeMLqRj6gLfR0xxA6P3ZY=
MIME-Version: 1.0
In-Reply-To: <20110518202025.GC4175@nuttenaction>
References: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
	<20110518.152653.1486764697527722925.davem@davemloft.net>
	<BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
	<20110518.155200.801089483916944725.davem@davemloft.net>
	<20110518202025.GC4175@nuttenaction>
Date: Fri, 20 May 2011 03:27:37 -0700
Message-ID: <BANLkTimtA9BB7g5cOm8c9sGChQjf1P0Q-Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: David Miller <davem@davemloft.net>, tsunanet@gmail.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 1:20 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> * David Miller | 2011-05-18 15:52:00 [-0400]:
>
>>I've already changed the initial TCP congestion window in Linux to 10
>>without some stupid draft being fully accepted.
>>
>>I'll just as easily accept right now a patch right now which lowers
>>the initial RTO to 1 second and adds the 3 second RTO fallback.
>
> I like the idea to make the initial RTO a knob because we in a isolated MANET
> environment have a RTT larger then 1 second. Especially the link layer setup
> procedure over several hops demand some time-costly setup time. After that the
> RTT is <1 second. The current algorithm works great for us. So this RTO change
> will be counterproductive: it will always trigger a needless timeout.
>
> The main problem for us is that Google at all pushing their view of Internet
> with a lot of pressure. The same is true for the IETF IW adjustments, which is
> unsuitable for networks which operates at a bandwidth characteristic some
> years ago. The _former_ conservative principle "TCP over everything" is
> forgotten.

Not sure how our various parameter tuning proposals deviate from the "TCP over
everything" principle?

Note that the design goal of rfc2988bis is to try to benefit 98% of
traffic while
keeping any negative impact to the remaining 2% at a minimum. This is why we
limit the use of < 3sec initRTO to at most once. This way the negative impact
of the 1sec initRTO to a path with RTT > 1sec is limited mostly to one
additional,
small, spuriously retransmitted SYN or SYN-ACK pkt, and the unnecessary
reduction of IW to 1 segment.

We actually thought about removing the IW reduction part but unfortunately the
text belongs to a different rfc5681, which is at a higher maturity
level ("draft-standard")
than rfc2988 hence can't be done as part of rfc2988bis. Anyway I have
since added
the recommendation to the IW10 draft. See draft-ietf-tcpm-initcwnd-01.txt.

The bottom line is the damage of rfc2988bis to any network with
initRTT > 1sec is
limited to one spurious retransmitted SYN/SYN-ACK. In the current Linux code,
the SYN/SYN-ACK retransmit is forgotten on the passive open side by the time
3WHS is completed so there is nothing needed to be done. But for the active
open side SYN retransmit will cause not long IW to be reduced to 1, but also
reduction of ssthresh, which is not part of rfc5681 so some more work is needed.
I can provide a patch (or work with tsuna) to ensure a correct fix is made.

Jerry

>
> Hagen
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
