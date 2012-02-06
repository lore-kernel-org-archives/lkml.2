Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2BFUsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:48:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32831 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab2BFUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:48:44 -0500
Subject: Re: [RFC PATCH 13/14] sched: make __update_entity_runnable_avg()
 fast
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20120202013827.20844.30497.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013827.20844.30497.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 21:48:26 +0100
Message-ID: <1328561306.2482.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
> +/* Precomputed fixed inverse multiplies for multiplication by y^n */
> +const static u32 runnable_avg_yN_inv[] = {
> +       0xffffffff,0xfa83b2db,0xf5257d15,0xefe4b99b,0xeac0c6e7,0xe5b906e7,
> +       0xe0ccdeec,0xdbfbb797,0xd744fcca,0xd2a81d91,0xce248c15,0xc9b9bd86,
> +       0xc5672a11,0xc12c4cca,0xbd08a39f,0xb8fbaf47,0xb504f333,0xb123f581,
> +       0xad583eea,0xa9a15ab4,0xa5fed6a9,0xa2704303,0x9ef53260,0x9b8d39b9,
> +       0x9837f051,0x94f4efa8,0x91c3d373,0x8ea4398b,0x8b95c1e3,0x88980e80,
> +       0x85aac367,0x82cd8698,
> +};

I wonder if modern Intel isn't at the point where computing this thing
is cheaper than the cacheline miss. You can compute y^n in O(log n) time
and with n < 32 that's 5 multiplications (see fixed_power_int). Add to
that the division.

Of course there's platforms, ARM?, where reverse is likely true. Bugger
that.

> +/* Precomputed \Sum y^k { 1<=k<=n } */
> +const static u32 runnable_avg_yN_sum[] = {
> +           0, 1002, 1982, 2941, 3880, 4798, 5697, 6576, 7437, 8279, 9103,
> +        9909,10698,11470,12226,12966,13690,14398,15091,15769,16433,17082,
> +       17718,18340,18949,19545,20128,20698,21256,21802,22336,22859,23371,
> +}; 

Right, can't see a fast way to compute this..

The asymmetry in the tables annoys me though 32 vs 33 entries, hex vs
dec :-)

