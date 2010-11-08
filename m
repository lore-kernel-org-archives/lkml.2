Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0KHTIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:08:32 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:35314 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab0KHTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:08:31 -0500
Message-ID: <4CD84A81.3000208@euromail.se>
Date: Mon, 08 Nov 2010 20:07:45 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se> <4CD724BC.8020702@seas.upenn.edu> <4CD80FCB.20903@euromail.se> <4CD82B28.4060706@seas.upenn.edu>
In-Reply-To: <4CD82B28.4060706@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFX4F-0001E3-Bx.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PFX4F-0001E3-Bx 9235065229e84a40d07b37fb5c5ca530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 05:54 PM, Rafi Rubin wrote:

> On 11/08/2010 09:57 AM, Henrik Rydberg wrote:
>> Hi Rafi,
>>
>> what tree does this patch apply to?
> 
> It should apply to the torvalds/linux-2.6 master branch.


Odd, seems the patch was damaged somehow. Applies and compiles, thanks.

> The "complex" set of parameters was intended for more advanced users to give
> some feedback to help improve the driver.  Though given the lack of feedback, I
> guess you're right that there's little reason to expose them to users.


Sounds good. Would you agree that applying a modified version of the ubuntu
patch is the simplest way forward?

> The ubuntu 10.10 code does do filtering better than without filtering, but in
> trying it I've been seeing ghosts and have needed to calibrate multiple times
> per day (though that may be the result of a new screen being a little off).
> Furthermore while ripping out the filter code, you also ripped out single touch
> support for single touch firmwares, which apparently a few people still use.


Yes, thanks, I got a report regarding the single touch firmwares and was
planning to include it.


> Even without the ghost problem, it simply does not track as well.  The ntrig
> only reports every 8-24ms which is a long enough period to move quite a
> distance.


True, since it is using a greedy algorithm. This is what the exact in-kernel
tracking code is supposed to remedy. To be precise, the ubuntu version uses the
so-obtained assignment for filtering only - the tracking is still performed in
mtdev in userspace.

> In drawing up corner cases I realized that motion where two fingers
> are co-linear with the vector of motion require quite a bit of care to avoid
> perverting the tracking.


Yes, this is one example of why exact matching is needed.

> Greedily assigning matches based purely on distance
> can cause a flip.  Even global distance minimization is not reliable when we use
> linear distance as the cost.  A full analysis would require quadric distances
> and the global minimization tends to be an n^3 approach.  I'm sure we could
> reduce that a bit, but it just seems a bit heavy handed.


The patch that started this thread implements exact matching, which means
finding the optimal slot assignments that minimizes a measure of the distance of
all movements. The implementation is very fast, but still needs to be cut off at
some arbitrary number. Four seems to be a natural breakpoint. The fact that
matching scales badly is one of the major headaches, and the reason mtdev is
implemented in userspace. The middle-way proposed here is a balance that seems
to cater for existing hardware at the same time as expecting hardware to provide
their own tracking in the future.

> By contrast just a little bit of extra work to estimate the position based on
> the difference in position of the previous two points (which every algorithm
> discussed seems to do anyway) doesn't seem that egregious.


Using exact matching instead of greedy matching is what makes it work well. It
is very robust and parameter-free. On the eclectic side, one can certainly go
beyond that by optimizing for both position differences and speed differences
(maximum smoothness). However, I doubt it makes any difference on the
finger-tracking use case.

> The style of the code still assumes that we might want to adjust the
> aggressiveness of filtering ghosts and drops.  I agree it would be nice to be
> able to come up with a single value for each and hard code it, but I'm not
> willing to just assume that I can determine that value.


The ghost detection in the ubuntu version could probably be improved a bit, but
the biggest experience gain would probably come from automatic calibration.

> Also, for graceful
> degradation and repair, I would like to be able to code it so that those
> thresholds grow a little bit as a device drifts and then drop them again when
> calibration is run.


Tricky - perhaps a measure of the number of filtered ghosts could be used to
determine when it is time to recalibrate.

>
> Also, if you're going to criticize code for complexity, I would recommend some
> comments that explain your code beyond "this is a generated table, don't change
> it".


Hehe, the quote is actually wrong. ;-)

Of course you are right. More documentation is a good thing, and I will add more
of it. The code does at least refer to the generating program, and the commit
message tells where that program can be found. To discuss details, here is a
listing of some of that code:

/*
 * Combinatorial formulation
 *
 * x_ij = 1 if slot i and contact j are connected, zero otherwise
 *
 * sum_i x_ij <= 1 for all j; each contact picks at most one slot
 *
 * sum_j x_ij <= 1 for all i; each slot is picked by at most one contact
 *
 * sum_ij x_ij == min(nslot, npos); assign every contact possible
 *
 * Arrange x_ij as a bitmask; x_00 x_01 x_02.. x_10 x_11 x_12...
 *
 * Up to five slots, this is readily enumerable.
 */

static int illegal(int nslot, int npos, unsigned x)
{
	int i, j, sum;

	for (j = 0; j < npos; j++) {
		sum = 0;
		for (i = 0; i < nslot; i++)
			sum += GETBIT(x, i * npos + j);
		if (sum > 1)
			return 1;
	}
	for (i = 0; i < nslot; i++) {
		sum = 0;
		for (j = 0; j < npos; j++)
			sum += GETBIT(x, i * npos + j);
		if (sum > 1)
			return 1;
	}

	sum = bitcount(x);
	return sum != minval(nslot, npos);
}

static int generate_assignments(int nslot, int npos)
{
	static int ncol;
	unsigned x, nx = BITMASK(nslot * npos);
	int slots[SLOT_MAX];
	int i, n = 0;

	for (x = 0; x < nx; x++) {
		if (illegal(nslot, npos, x))
			continue;
		for (i = 0; i < nslot * npos; i++) {
			if (GETBIT(x, i)) {
				if (ncol++ % 16 == 0)
					printf("\n\t%d,", i);
				else
					printf(" %d,", i);
				n++;
			}
		}
		get_slots(slots, nslot, npos, x);
		for (i = 0; i < npos; i++) {
			if (ncol++ % 16 == 0)
				printf("\n\t%d,", slots[i]);
			else
				printf(" %d,", slots[i]);
			n++;
		}
	}

	return n;
}

For every (number of used slots, number of current contacts) pair, two
consecutive arrays of values are generated. The first contains the matrix
indices corresponding to a certain mapping from contacts to slots. The second
contains the actual slot assignment.

To find the optimal matching, one simply scans through the appropriate index
array, extracting the slot assignment corresponding to the minimum sum of matrix
elements. This process is combinatorial and in general scales much worse than
for instance the hungarian algorithm, but for small numbers, it can be
implemented with very good speed.

Cheers,
Henrik
