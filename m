Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0LHWNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:13:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab0LHWNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:13:36 -0500
Date: Wed, 8 Dec 2010 23:06:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: blk-throttle: Correct the placement of smp_rmb()
Message-ID: <20101208220640.GB4895@redhat.com>
References: <20101207123454.GA11997@redhat.com> <20101207160102.GB16363@redhat.com> <20101208184507.GA30071@redhat.com> <20101208190918.GI31703@redhat.com> <20101208191600.GA32753@redhat.com> <20101208193031.GJ31703@redhat.com> <20101208193308.GA1044@redhat.com> <20101208200750.GA2202@redhat.com> <20101208204624.GK31703@redhat.com> <20101208213331.GA4895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208213331.GA4895@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Oleg Nesterov wrote:
>
> Unfortunately, I can't prove this. You can ask
> Paul McKenney if you want the authoritative answer.

Well. I think we should ask ;) This is interesting.

Paul could you please shed a light?

Suppose we have 2 variables, A = 0 and B = 0.

	CPU0 does:

		A = 1;
		wmb();
		B = 1;

	CPU1 does:

		B = 0;
		mb();
		if (A)
			A = 2;

My understanding is: after that we can safely assume that

	B == 1 || A == 2

IOW. Either CPU1 notices that A was changed, or CPU0 "wins"
and sets B = 1 "after" CPU1. But, it is not possible that
CPU1 clears B "after" it was set by CPU0 _and_ sees A == 0.

Is it true? I think it should be true, but can't prove. This
reminds me the old (and long) discussion about STORE-MB-LOAD.
Iirc, finally it was decided that

	CPU0:				CPU1:

	A = 1;				B = 1;
	mb();				mb();
	if (B)				if (A)
		printf("Yes");			printf("Yes");

should print "Yes" at least once. This looks very similar to
the the previous example.

Thanks,

Oleg.

