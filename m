Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2BQMtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:49:40 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63218 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2BQMtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <1328561306.2482.32.camel@laptop>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013827.20844.30497.stgit@kitami.mtv.corp.google.com> <1328561306.2482.32.camel@laptop>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 04:49:08 -0800
Message-ID: <CAPM31RJ6jv-ERZ=kP2x3037z-iR+V96cS=MyFBC2Ohs-3Vq2WQ@mail.gmail.com>
Subject: Re: [RFC PATCH 13/14] sched: make __update_entity_runnable_avg() fast
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 12:48 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>> +/* Precomputed fixed inverse multiplies for multiplication by y^n */
>> +const static u32 runnable_avg_yN_inv[] = {
>> +       0xffffffff,0xfa83b2db,0xf5257d15,0xefe4b99b,0xeac0c6e7,0xe5b906e7,
>> +       0xe0ccdeec,0xdbfbb797,0xd744fcca,0xd2a81d91,0xce248c15,0xc9b9bd86,
>> +       0xc5672a11,0xc12c4cca,0xbd08a39f,0xb8fbaf47,0xb504f333,0xb123f581,
>> +       0xad583eea,0xa9a15ab4,0xa5fed6a9,0xa2704303,0x9ef53260,0x9b8d39b9,
>> +       0x9837f051,0x94f4efa8,0x91c3d373,0x8ea4398b,0x8b95c1e3,0x88980e80,
>> +       0x85aac367,0x82cd8698,
>> +};
>
> I wonder if modern Intel isn't at the point where computing this thing
> is cheaper than the cacheline miss. You can compute y^n in O(log n) time
> and with n < 32 that's 5 multiplications (see fixed_power_int). Add to
> that the division.
>
> Of course there's platforms, ARM?, where reverse is likely true. Bugger
> that.
>
>> +/* Precomputed \Sum y^k { 1<=k<=n } */
>> +const static u32 runnable_avg_yN_sum[] = {
>> +           0, 1002, 1982, 2941, 3880, 4798, 5697, 6576, 7437, 8279, 9103,
>> +        9909,10698,11470,12226,12966,13690,14398,15091,15769,16433,17082,
>> +       17718,18340,18949,19545,20128,20698,21256,21802,22336,22859,23371,
>> +};
>
> Right, can't see a fast way to compute this..
>
> The asymmetry in the tables annoys me though 32 vs 33 entries,

We could shrink yN sum to 32 entries but then
__compute_runnable_contrib() ends up a lot uglier with a bunch of
conditionals about the n=0 case.  (and if we did that the same
argument could then be made for making runnable_avg_yN_inv 31
entries.. at which point we're asymmetric again.. ahhhhh!! must go
sort my pencils..)

>hex vs dec :-)
>

So I personally think hex versus dec is somewhat reasonable in that:

\Sum y^n converges to a/(1-r) -- about ~47k -- which is a very human
readable number.  It's easy to do the mental math on what a given
entry in that table is going to do to your runnable_avg / runnable_sum
from just looking at it.

Conversely, for the inverse multiplies they're the completely
unintelligible ~0*y^k.  We could write them in decimal, but the table
would just be enormous.

Since the second case would be enormously ugly and we already have
precedent for using hex for inverses wmult; the only unified option is
then to use hex for both.  But then I personally certainly can't
eyeball the numbers for \Sum y^n in the same fashion.  But perhaps
this is something we can lose.
