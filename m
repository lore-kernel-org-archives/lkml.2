Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2BPN22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:28:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:58479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2BPN21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:28:27 -0500
Message-ID: <1329398878.2293.215.camel@twins>
Subject: Re: [RFC PATCH 01/14] sched: track the runnable average on a
 per-task entitiy basis
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 14:27:58 +0100
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
> +static __always_inline u64 decay_load(u64 val, int n)
> +{
> +       for (;n && val;n--) {
> +               val *= 4008;
> +               val >>= 12;
> +       }
> +
> +       return val;
> +}

> +                       sa->runnable_avg_sum =
> +                               decay_load(sa->runnable_avg_sum, 1);
> +                       sa->runnable_avg_period =
> +                               decay_load(sa->runnable_avg_period, 1); 

Since all you ever seem to do is:

  x = decay(x, n);

and frequently run over the line limits it might make sense to either
introduce a CPP helper or make the first argument a pointer and ditch
the return value so we end up with something like:

  decay(&x, n);


