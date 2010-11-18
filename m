Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0KRHtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:49:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab0KRHtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:49:01 -0500
Date: Thu, 18 Nov 2010 08:48:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Marcus Meissner <meissner@suse.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, akpm@osdl.org,
        hpa@zytor.com, w@1wt.eu, alan@lxorguk.ukuu.org.uk,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101118074804.GC32621@elte.hu>
References: <20101116104600.GA24015@suse.de>
 <20101117050759.GE22651@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117050759.GE22651@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Tue, Nov 16, 2010 at 11:46:03AM +0100, Marcus Meissner wrote:
> > Target of this starter patch and follow ups is removing any kind of
> > kernel space address information leak from the kernel.
> > 
> 
> Er. Should probably hit /proc/modules while you're at it.

Agreed. A few other kernel address things that should be hidden are:

1) /proc/<PID>/stack

Gives out kernel addresses and is a partial /proc/kallsyms table in essence. This 
got introduced recently. Useful to attackers.

Then there's a handful of physical address leaks - those are less useful but useful 
in some situations:

2) /proc/mtrr

Gives some idea about the physical layout of the machine and can give information 
about the location of certain physical devices as well. Limited but nonzero utility 
to attackers.

3) /proc/asound/cards

Can gives out the physical address of a device. Limited but nonzero utility to 
attackers.

4) /sys/devices/*/*/resources

Shows physical addresses. Limited but nonzero utility to attackers.

Plus there's some really limited fractional pieces of information - again, of 
nonzero utility to attackers:

5) /proc/net/ptype

Shows the sizes of a few kernel functions in networking code. Very limited but 
nonzero utility to attackers.

6) /sys/kernel/slab/*/ctor

Shows the sizes of a few kernel functions. Very limited but nonzero utility to 
attackers.

7) /sys/module/*/sections/*

For example:

 /sys/module/sunrpc/sections/__bug_table
 /sys/module/sunrpc/sections/__ex_table
 /sys/module/sunrpc/sections/__ksymtab
 /sys/module/sunrpc/sections/__ksymtab_gpl
 /sys/module/sunrpc/sections/__ksymtab_strings
 /sys/module/sunrpc/sections/__mcount_loc
 /sys/module/sunrpc/sections/__param

Potentially useful to attackers.

There's probably a few more i missed.

	Ingo
