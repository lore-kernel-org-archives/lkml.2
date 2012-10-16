Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2JPPxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:53:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55779 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab2JPPxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:53:44 -0400
Date: Tue, 16 Oct 2012 11:53:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
Message-ID: <20121016155307.GF17446@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
	mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
	tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
	DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com>
 <50675038.9000108@zytor.com>
 <20121016040848.GE17446@thunk.org>
 <507CE663.2060502@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507CE663.2060502@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 09:45:23PM -0700, H. Peter Anvin wrote:
> 
> Or we could compute poolwords (and poolbits, and poolbytes) from it,
> since shifts generally are cheap.  I don't strongly care, whatever your
> preference is.

We are already calculating poolbits from poolwords:

#define POOLBITS	poolwords*32
#define POOLBYTES	poolwords*4

So you'd basically be suggesting that we define

#define POOLWORDS	(1 << (poolshift - 5))
#define POOLBYTES	(1 << (poolshift - 3))
#define POOLBITS	(1 << poolshift)

Yeah, that works; we don't use poolwords in that many places, and a
data dependent shift is cheap at least on x86 and arm (so probably all
modern platforms).

There was one aesthetic reason for using POOLWORDS, which was that
first term of the generating polynomial was the same as poolwords,
i.e:

	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
	{ 128,	103,	76,	51,	25,	1 },
	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
	{ 32,	26,	20,	14,	7,	1 },

If we change it to be:

	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
	{ 12,	103,	76,	51,	25,	1 },
	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
	{ 10,	26,	20,	14,	7,	1 },

It's a wee bit less obvious where the "12" and "10" is coming form.  I
don't see an easy way to fix this, though, other than perhaps making
sure it's clear in the comments.  Unfortunately we can't count on gcc
doing a built-in optimization for a log2 of a constant as far as I
know.... or can we?

Hmm, this does get optimized correctly at least with gcc 4.7:

#define shiftbits(words) ((int) __builtin_log2((double) (words)) + 5)

... and it looks like include/linux/log2.h already has a definition
for ilog2() which should definitely work for all versions of gcc, so
we could do this instead:

#define shiftbits(w)	(ilog2((w)) + 5)

	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
	{ shiftbits(128), 103,	76,	51,	25,	1 },
	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
	{ shiftbits(32),  26,	20,	14,	7,	1 },

						- Ted

