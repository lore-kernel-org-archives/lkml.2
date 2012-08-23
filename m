Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2HWL6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:58:51 -0400
Received: from mail.linlab.net ([89.244.147.154]:43371 "EHLO mail.linlab.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab2HWL6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:58:47 -0400
X-DKIM: OpenDKIM Filter v2.5.1 mail.linlab.net q7NBwXaj023354
Message-ID: <50361AEA.6010807@linlab.net>
Date: Thu, 23 Aug 2012 13:58:34 +0200
From: Alex Bergmann <alex@linlab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
References: <503419D3.1080700@linlab.net> <CAFbMe2M7ekc94bQk7vTS1LhScPd49VZ-zKOCUXhqwxXtL-nkuA@mail.gmail.com>
In-Reply-To: <CAFbMe2M7ekc94bQk7vTS1LhScPd49VZ-zKOCUXhqwxXtL-nkuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.6 (mail.linlab.net [IPv6:2001:470:7142:a0::3]); Thu, 23 Aug 2012 13:58:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 06:41 PM, H.K. Jerry Chu wrote:
> On Tue, Aug 21, 2012 at 4:29 PM, Alex Bergmann <alex@linlab.net
> <mailto:alex@linlab.net>> wrote:
>
>     Hi David,
>
>     I'm not 100% sure, but it looks like I found an RFC mismatch with the
>     current default values of the TCP implementation.
>
>     Alex
>
>      From 8b854a525eb45f64ad29dfab16f9d9f681e84495 Mon Sep 17 00:00:00 2001
>     From: Alexander Bergmann <alex@linlab.net <mailto:alex@linlab.net>>
>     Date: Wed, 22 Aug 2012 00:29:08 +0200
>     Subject: [PATCH 1/1] tcp: Wrong timeout for SYN segments
>
>     Commit 9ad7c049 changed the initRTO from 3secs to 1sec in accordance to
>     RFC6298 (former RFC2988bis). This introduced a gap with RFC1122 that
>     defines a minimum retransmission window for SYN segments of at least
>     180secs.
>
>     Prior to 9ad7c049 the timeout was defined with 189secs. Now we have only
>     a timeout of 63secs.
>
>              ((2 << 5) - 1) * 3 secs = 189 secs
>              ((2 << 5) - 1) * 1 secs = 63 secs
>
>     To fulfill the MUST constraint in RFC1122 section 4.2.3.5 about R2 for
>     SYN segments, the values of TCP_SYN_RETRIES and TCP_SYNACK_RETRIES must
>     be changed to 7 reties.
>
>              ((2 << 7) - 1) * 1 secs = 255 secs
>
>     This would result in an ETIMEDOUT of 4 minutes 15 seconds.
>
>
> This issue occurred to me right after I submitted the patch for RFC6298.
> I did not commit any more change because RFC compliance aside, 180secs
> just seem like eternity in the Internet age.
>
> (See my past post on this at
> http://marc.info/?l=linux-netdev&m=130759078118866&w=2)

Okay, I missed that post during my search about the current situation.

Thanks,
Alex


> Jerry
>
>
>     Signed-off-by: Alexander Bergmann <alex@linlab.net
>     <mailto:alex@linlab.net>>
>     ---
>       include/net/tcp.h |    4 ++--
>       1 files changed, 2 insertions(+), 2 deletions(-)
>
>     diff --git a/include/net/tcp.h b/include/net/tcp.h
>     index 1f000ff..7eaae19 100644
>     --- a/include/net/tcp.h
>     +++ b/include/net/tcp.h
>     @@ -98,10 +98,10 @@ extern void tcp_time_wait(struct sock *sk, int
>     state, int timeo);
>                                       * 15 is ~13-30min depending on RTO.
>                                       */
>
>     -#define TCP_SYN_RETRIES         5      /* number of times to retry
>     active opening a
>     +#define TCP_SYN_RETRIES         7      /* number of times to retry
>     active opening a
>                                       * connection: ~180sec is RFC
>     minimum   */
>
>     -#define TCP_SYNACK_RETRIES 5   /* number of times to retry passive
>     opening a
>     +#define TCP_SYNACK_RETRIES 7   /* number of times to retry passive
>     opening a
>                                       * connection: ~180sec is RFC
>     minimum   */
>
>       #define TCP_TIMEWAIT_LEN (60*HZ) /* how long to wait to destroy
>     TIME-WAIT
>     --
>     1.7.8.6
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe netdev" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>


-- 
|. _ | _ |_   _  _ _|_
||| ||(_||_).| |(/_ |
email/sip/xmpp: alex@linlab.net
phone/enum: +49 2871 2355378
