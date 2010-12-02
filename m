Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0LBIN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:13:29 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:9877 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754956Ab0LBIN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:13:28 -0500
From: Bruno Randolf <br1@einfach.org>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Date: Thu, 2 Dec 2010 17:12:49 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, blp@cs.stanford.edu,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, stefanr@s5r6.in-berlin.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <20101119222846.GA26592@hash.localnet> <1290207715.2114.10.camel@laptop>
In-Reply-To: <1290207715.2114.10.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012021712.49377.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat November 20 2010 08:01:55 Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 17:28 -0500, Bob Copeland wrote:
> > On Fri, Nov 19, 2010 at 06:07:05PM +0900, Bruno Randolf wrote:
> > > Hmm, maybe I suck in mathemathics, but I don't see a way to do that
> > > given the formula:
> > > 
> > > (((internal * (weight - 1)) + (val * factor)) / weight
> > 
> > I was thinking something along the lines of:
> > 
> > round = (1 << n) - 1;
> > (((internal * (weight - 1) + round) >> n) + val) * ((1 << n) / weight)
> > 
> > where (1 << n) is the factor and ((1 << n) / weight) can be precomputed.
> > If you think about it, this is just reciprocal multiplication in fixed-
> > point math with n bits of decimal resolution.
> > 
> > The problem is the shift of the older terms introduces roundoff error,
> > but there are some tricks you can do to maintain bounded error, e.g.
> > shifting by some smaller factor of n and scaling other terms -- in the
> > limit you reinvent floating point and then it's slower than division :)
> 
> Sure, x/y := x/z * z/y, and by picking z := 2^n, we can pre-compute z/y
> and write x/z using a shift. The problem however is always range vs
> granularity, you chose to first /z and then *z/y, this avoids some
> overflow issues but truncates the lower n bits of x.
> 
> If you first *z/y and then /z you keep your low bits but risk loosing
> the top bits to an overflow.
> 
> I guess the question is do we really need weights outside of 2^n? If
> not, you can use the weight := 2^n version. If you do, you get to pick
> either of the previously mentioned options.
> 
> Sadly gcc doesn't sanely support a u128 type, which would be very useful
> to avoid some of these overflow issues (like we used to use u64 mults
> for u32 fixed points mults).

Thank you all for your help and sorry for following up so late!

I think we don't really need weights outside of 2^n and i'm going to post a 
patch based on Peter Zijlstra's formula. Thanks again! Would it make sense to 
have the factor 2^n too, so we can bitshift there too?

bruno
