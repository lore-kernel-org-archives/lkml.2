Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1B1Ln5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:43:57 -0500
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:38538 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470Ab1B1Ln4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:43:56 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.44
Message-ID: <20110228134338.1241484mkljbz4w0@hayate.sektori.org>
Date: Mon, 28 Feb 2011 13:43:38 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Albert Cahalan <acahalan@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
 <1298793252.8726.45.camel@edumazet-laptop>
 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
 <1298837273.8726.128.camel@edumazet-laptop>
In-Reply-To: <1298837273.8726.128.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Dumazet <eric.dumazet@gmail.com>:

> Le dimanche 27 février 2011 à 12:55 +0200, Jussi Kivilinna a écrit :
>> Quoting Albert Cahalan <acahalan@gmail.com>:
>>
>> > On Sun, Feb 27, 2011 at 2:54 AM, Eric Dumazet  
>> <eric.dumazet@gmail.com> wrote:
>> >> Le dimanche 27 février 2011 à 08:02 +0100, Mikael Abrahamsson a écrit :
>> >>> On Sun, 27 Feb 2011, Albert Cahalan wrote:
>> >>>
>> >>> > Nanoseconds seems fine; it's unlikely you'd ever want
>> >>> > more than 4.2 seconds (32-bit unsigned) of queue.
>> > ...
>> >> Problem is some machines have slow High Resolution timing services.
>> >>
>> >> _If_ we have a time limit, it will probably use the low resolution (aka
>> >> jiffies), unless high resolution services are cheap.
>> >
>> > As long as that is totally internal to the kernel and never
>> > getting exposed by some API for setting the amount, sure.
>> >
>> >> I was thinking not having an absolute hard limit, but an EWMA based one.
>> >
>> > The whole point is to prevent stale packets, especially to prevent
>> > them from messing with TCP, so I really don't think so. I suppose
>> > you do get this to some extent via early drop.
>>
>> I made simple hack on sch_fifo with per packet time limits
>> (attachment) this weekend and have been doing limited testing on
>> wireless link. I think hardlimit is fine, it's simple and does
>> somewhat same as what packet(-hard)limited buffer does, drops packets
>> when buffer is 'full'. My hack checks for timed out packets on
>> enqueue, might be wrong approach (on other hand might allow some more
>> burstiness).
>>
>
>
> Qdisc should return to caller a good indication packet is queued or
> dropped at enqueue() time... not later (aka : never)
>
> Accepting a packet at t0, and dropping it later at t0+limit without
> giving any indication to caller is a problem.
>
> This is why I suggested using an EWMA plus a probabilist drop or
> congestion indication (NET_XMIT_CN) to caller at enqueue() time.
>
> The absolute time limit you are trying to implement should be checked at
> dequeue time, to cope with enqueue bursts or pauses on wire.
>

Would it be better to implement this as generic feature instead of  
qdisc specific? Have qdisc_enqueue_root do ewma check:

static inline int qdisc_enqueue_root(struct sk_buff *skb, struct Qdisc *sch)
{
	qdisc_skb_cb(skb)->pkt_len = skb->len;
	if (likely(!sch->use_timeout)) {
ewma_ok:
		return qdisc_enqueue(skb, sch) & NET_XMIT_MASK;
	}

	status = qdisc_check_ewma_status()
	if (status == ok)
		goto ewma_ok;

	if (status == overlimits)
		...drop...

	if (status == congestion) {
		ret = qdisc_enqueue(skb, sch) & NET_XMIT_MASK;
		return (ret == success) ? NET_XMIT_CN : ret;
	}
}

And add qdisc_dequeue_root:

static inline struct sk_buff *qdisc_dequeue_root(struct Qdisc *sch)
{
	skb = sch->dequeue(sch);

	if (skb && unlikely(sch->use_timeout))
		qdisc_update_ewma(skb);

	return skb;
}

Then user could specify any qdisc to use timeout or not with tc. Maybe  
go even as far as have some default timeout for default qdisc(?)

-Jussi


