Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806Ab0FKS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:29:57 -0400
Received: from science.horizon.com ([71.41.210.146]:36627 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756338Ab0FKS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:29:56 -0400
Date: 11 Jun 2010 14:29:54 -0400
Message-ID: <20100611182954.20294.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org, sqazi@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be reused
Cc: allan.stephens@windriver.com, linux@horizon.com, peterz@infradead.org,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Isn't: return a - base < b - base, the natural way to express this?

Quite right.

I see people managed to figure it out, but my, what a lot of angst
over something so familiar to any network hacker trying to figure out
if a received sequence number is in the receive window or not.

See include/net/tcp.h:
265: /* is s2<=s1<=s3 ? */
266: static inline int between(__u32 seq1, __u32 seq2, __u32 seq3)
267: {
268: 	return seq3 - seq2 >= seq1 - seq2;
269: }

(If someone wants to fix the far uglier version in net/tipc/link.h...
Allan, Cc: to you.)

If you want to handle strictly conforming ANSI C, then you have to
cast everything to unsigned before the subtraction, but in practice,
casting afterward works just as well:

	return (unsigned)a - (unsigned)base < (unsigned)b - (unsigned)base;
	return (unsigned)(a - base) < (unsigned)(b - base)

Conceptually, it's "is the distance forward from base to a less than
the distance forward from base to b"?  The "forward" is enforced by the
unsigned cast.

If the numbers wrap before UINT_MAX, the logic still works; it doesn't
care if values between PID_MAX_LIMIT and UINT_MAX are "illegal and may not
be assigned" or "by merest chance happen to not be assigned".
