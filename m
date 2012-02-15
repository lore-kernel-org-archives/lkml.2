Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2BOXhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:37:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33286 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2BOXhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:37:22 -0500
Message-ID: <1329349028.2293.190.camel@twins>
Subject: Re: [RFC PATCH 01/14] sched: track the runnable average on a
 per-task entitiy basis
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 00:37:08 +0100
In-Reply-To: <20120202013826.20844.8708.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013826.20844.8708.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
> +       /*
> +        * Use 1024us as the unit of measurement since it's a reasonable
> +        * approximation of 1ms and fast to compute.
> +        */
> +       delta >>= 10;

ns -> us ?, text talks about ms, slightly confusing

> +       if (!delta)
> +               return 0;
> +       sa->last_runnable_update = now;
> +
> +       delta_w = sa->runnable_avg_period % 1024;

so delta_w is the chunk of this p we already accounted.

> +       if (delta + delta_w >= 1024) {

if delta pushes us over 1024*1024 ns (~1ms) we roll a window.

> +               /* period roll-over */
> +               decayed = 1;
> +
> +               delta_w = 1024 - delta_w;

The distance we need to reach the next window.

> +               BUG_ON(delta_w > delta); 

somehow reading this code took forever, this suggests clarification,
either through better variable names or more comments. Could also mean
I'm a moron and should get more sleep or so :-)
