Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab1GUN0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:26:13 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49030 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1GUN0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:26:09 -0400
Date: Thu, 21 Jul 2011 15:26:27 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20110721132627.GY7561@ics.muni.cz>
References: <20110720082640.GZ7561@ics.muni.cz>
 <4E280964.6070000@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E280964.6070000@ct.jp.nec.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 21 Jul 2011 15:25:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 08:11:32PM +0900, Kiyoshi Ueda wrote:
> I don't understand why you are saying request-based device-mapper makes
> serious troubles.
> BIO merging is done in the block layer.  Don't you see the same thing
> if you use sd devices (/dev/sdX)?

no, if I use sd devices directly, it does not overload ksoftirqd and this is
obvious. The problem with overloading ksoftirqd has roots in request based
stuff in dm layer, in particular in dm_softirq_done() call. 

> Also, what do you see with the latest upstream kernel (say, 3.0-rc7)?

I didn't check it with this kernel. I don't see many changes in request based
stuff in dm.

> If you see your problem only with request-based device-mapper, please
> elaborate about below:
>     - end_clone_bio() has someting like quadratic complexity.
>         * What do you mean the "quadratic complexity"?

end_clone_bio calls blk_update_request which calls __blk_recalc_rq_segments
which has code:
for_each_bio(bio) {
        bio_for_each_segment(bv, bio, i) {

in total, it seems that *whole* bio list is traversed again and again as some parts
are done and some not which leads to comlexity O(n^2) with respect to number
of bio and segments. But this is just wild guess. The real problem could be
elsewhere.

However, oprofile or sysprof show that ksoftirq spends most time in
__blk_recalc_rq_segments().

>     - each request contains more then 100 bios which makes serious
>       troubles for ksoftirqd call backs.
>         * What do you mean the "serious troubles for ksoftirqd call backs"?

serious troubles means that ksoftirqd eats 100% CPU and slows down I/O
significantly (from 2.8GB/s to 500MB/s).

-- 
Luká¹ Hejtmánek
