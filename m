Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0LGSwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:52:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:46355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0LGSwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:52:05 -0500
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Colin Walters <walters@verbum.org>, Ray Lee <ray-lk@madrabbit.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinOQ5sWigfW844dSBc2PvVwFj5c7yu+scNXxMcv@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116130413.GA29368@redhat.com>
	 <1289917109.5169.131.camel@maggy.simson.net>
	 <20101116150319.GA3475@redhat.com>
	 <1289922108.5169.185.camel@maggy.simson.net>
	 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
	 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	 <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
	 <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	 <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
	 <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
	 <AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com>
	 <AANLkTi=7FRCK9R2PVCTdtSqKo9FZemD5cXQTFoOKLEFB@mail.gmail.com>
	 <AANLkTinOQ5sWigfW844dSBc2PvVwFj5c7yu+scNXxMcv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Dec 2010 19:51:29 +0100
Message-ID: <1291747889.2032.985.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 12:47 -0800, Linus Torvalds wrote:
> Nice levels are _not_ about group scheduling. They're about
> priorities. And since the cgroup code doesn't even support priority
> levels for the groups, it's a really *horrible* match. 

It does in fact, nice maps to a weight, we then schedule so that each
entity (be it task or group) gets a proportional amount of time relative
to the other entities (of the same parent).

The scheduler basically solves the following differential equation:
  dt_i = w_i * dt / \Sum_j w_j


For tasks we map nice to weight like:

static const int prio_to_weight[40] = {
 /* -20 */     88761,     71755,     56483,     46273,     36291,
 /* -15 */     29154,     23254,     18705,     14949,     11916,
 /* -10 */      9548,      7620,      6100,      4904,      3906,
 /*  -5 */      3121,      2501,      1991,      1586,      1277,
 /*   0 */      1024,       820,       655,       526,       423,
 /*   5 */       335,       272,       215,       172,       137,
 /*  10 */       110,        87,        70,        56,        45,
 /*  15 */        36,        29,        23,        18,        15,
};

For groups we expose the weight directly in cgroupfs://cpu.shares with a
default equivalent to nice-0 (1024).

So 'nice make -j9' will run make and all its children with weight=110,
if this task hierarchy has ~9 runnable tasks it will get about as much
time as a single nice-0 competing task.

[ 9*110 = 990, 1*1024 = 1024, which gives: 49% vs 51% ]


Now group scheduling is in fact closely related to nice, the only thing
group scheduling does is:

  w_i = \unit * \Prod_j { w_i,j / \Sum_k w_k,j }, where:

     j \elem i and its parents
     k \elem entities of group j (where a task is a trivial group)

Where we compute a task's effective weight (w_i) by multiplying it with
the effective weight of their ancestors.

Suppose a grouped make -j9 against 1 competing task (all nice-0 or
equivalent), and make's 9 active children [a..i] in the group G:


        R
      /   \
     t     G
          / \
         a...i

So w_t = 1024, w_G = 1024 and w_[a..i] = 1024.

Now, per the above the effective weight (weight as in the root group) of
each grouped task is:

  w_[a..i] = 1024 * 1024/2048 * 1024/9216 ~= 56
  w_t      = 1024 * 1024/2048             = 512

[ \Sum w_[a..i] = 512, vs 512 gives: 50% vs 50% ]

So effectively: nice make -j9, and stuffing the make -j9 in a group are
roughly equivalent.

The only difference between groups and nice is the interface, with nice
you set the weight directly, with groups you set it implicitly,
depending on the runnable task state.

