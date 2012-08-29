Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab2H2EeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:34:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33675 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2H2EeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120825084819.GD430@linlab.net>
References: <1345724123.5904.756.camel@edumazet-glaptop>
	<50362407.9070805@linlab.net>
	<1345726185.5904.835.camel@edumazet-glaptop>
	<20120824.134231.41073001349178209.davem@davemloft.net>
	<20120825084819.GD430@linlab.net>
Date: Tue, 28 Aug 2012 21:34:17 -0700
Message-ID: <CAFbMe2Pgjbttt+Z3RQ9KL05=GHqZYk5ubNH2G1-EUn_f_RBaEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Alexander Bergmann <alex@linlab.net>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 1:48 AM, Alexander Bergmann <alex@linlab.net> wrote:
> On Fri, Aug 24, 2012 at 01:42:31PM -0400, David Miller wrote:
>> Alex, this patch doesn't apply, it was completely corrupted by your email
>> client.
>>
>> Make a fresh submission, with this fixed.  But before you do, email the
>> patch to yourself and make sure you can actually apply the patch you
>> receive in your inbox.  Because that's exactly what I'm going to have
>> to do.
>
> Sorry I messed it up the last time. This time I've double checked as
> you suggested. I'll keep that in mind.
>
> From 11a292b1cff772f930a02fda02d5b741f8ea5033 Mon Sep 17 00:00:00 2001
> From: Alexander Bergmann <alex@linlab.net>
> Date: Fri, 24 Aug 2012 14:09:49 +0200
> Subject: [PATCH 1/1] tcp: Increase timeout for SYN segments
>
> Commit 9ad7c049 changed the initRTO from 3secs to 1sec in accordance to
> RFC6298 (former RFC2988bis). This reduced the time till the last SYN
> retransmission packet gets sent from 93secs to 31secs.
>
> RFC1122 is stating that the retransmission should be done for at least 3
> minutes, but this seems to be quite high.
>
>   "However, the values of R1 and R2 may be different for SYN
>   and data segments.  In particular, R2 for a SYN segment MUST
>   be set large enough to provide retransmission of the segment
>   for at least 3 minutes.  The application can close the
>   connection (i.e., give up on the open attempt) sooner, of
>   course."
>
> This patch increases the value of TCP_SYN_RETRIES to the value of 6,
> providing a retransmission window of 63secs.
>
> The comments for SYN and SYNACK retries have also been updated to
> describe the current settings.
>
> Signed-off-by: Alexander Bergmann <alex@linlab.net>
> ---
>  include/net/tcp.h |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 1f000ff..d43d6b3 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -98,11 +98,21 @@ extern void tcp_time_wait(struct sock *sk, int state, int timeo);
>                                  * 15 is ~13-30min depending on RTO.
>                                  */
>
> -#define TCP_SYN_RETRIES         5      /* number of times to retry active opening a
> -                                * connection: ~180sec is RFC minimum   */
> +#define TCP_SYN_RETRIES         6      /*
> +                                * This is how many retries it does to active
> +                                * opening a connection.
> +                                * RFC1122 says the minimum retry MUST be at
> +                                * least 180secs. Nevertheless this value is
> +                                * corresponding to 63secs of retransmission
> +                                * with the current initial RTO.
> +                                */
>
> -#define TCP_SYNACK_RETRIES 5   /* number of times to retry passive opening a
> -                                * connection: ~180sec is RFC minimum   */
> +#define TCP_SYNACK_RETRIES 5   /*
> +                                * This is how may retries it does to passive
> +                                * opening a connection.
> +                                * This is corresponding to 31secs of
> +                                * retransmission with the current initial RTO.

IMHO 31secs seem a little short. Why not change it to 6 as well because 63
secs still beats 93secs with 3sec initRTO and 5 retries.

Jerry

> +                                */
>
>  #define TCP_TIMEWAIT_LEN (60*HZ) /* how long to wait to destroy TIME-WAIT
>                                   * state, about 60 seconds     */
> --
> 1.7.8.6
>
