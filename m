Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0KSXCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:02:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:51427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0KSXCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:02:34 -0500
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Peter Zijlstra <peterz@infradead.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Bruno Randolf <br1@einfach.org>, Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <j@w1.fi>, linville@tuxdriver.com,
        randy.dunlap@oracle.com, blp@cs.stanford.edu,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, stefanr@s5r6.in-berlin.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
In-Reply-To: <20101119222846.GA26592@hash.localnet>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	 <1290010595.3777.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
	 <201011191807.06013.br1@einfach.org> <20101119222846.GA26592@hash.localnet>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 20 Nov 2010 00:01:55 +0100
Message-ID: <1290207715.2114.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 17:28 -0500, Bob Copeland wrote:
> On Fri, Nov 19, 2010 at 06:07:05PM +0900, Bruno Randolf wrote:
> > Hmm, maybe I suck in mathemathics, but I don't see a way to do that given the 
> > formula:
> > 
> > (((internal * (weight - 1)) + (val * factor)) / weight
> 
> I was thinking something along the lines of:
> 
> round = (1 << n) - 1;
> (((internal * (weight - 1) + round) >> n) + val) * ((1 << n) / weight)
> 
> where (1 << n) is the factor and ((1 << n) / weight) can be precomputed.
> If you think about it, this is just reciprocal multiplication in fixed-
> point math with n bits of decimal resolution. 
> 
> The problem is the shift of the older terms introduces roundoff error, but
> there are some tricks you can do to maintain bounded error, e.g. shifting
> by some smaller factor of n and scaling other terms -- in the limit you
> reinvent floating point and then it's slower than division :)

Sure, x/y := x/z * z/y, and by picking z := 2^n, we can pre-compute z/y
and write x/z using a shift. The problem however is always range vs
granularity, you chose to first /z and then *z/y, this avoids some
overflow issues but truncates the lower n bits of x.

If you first *z/y and then /z you keep your low bits but risk loosing
the top bits to an overflow.

I guess the question is do we really need weights outside of 2^n? If
not, you can use the weight := 2^n version. If you do, you get to pick
either of the previously mentioned options.

Sadly gcc doesn't sanely support a u128 type, which would be very useful
to avoid some of these overflow issues (like we used to use u64 mults
for u32 fixed points mults).
