Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0EZGfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:35:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:24974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab0EZGfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,302,1272870000"; 
   d="scan'208";a="801929118"
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by
 transactional API (take 2)
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "acme@infradead.org" <acme@infradead.org>,
       "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>
In-Reply-To: <1274801531.5882.1670.camel@twins>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	 <1274794518.5882.1280.camel@twins>
	 <AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	 <1274796225.5882.1389.camel@twins>
	 <AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	 <AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
	 <1274801531.5882.1670.camel@twins>
Content-Type: text/plain
Date: Wed, 26 May 2010 14:34:18 +0800
Message-Id: <1274855658.3429.24.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 23:32 +0800, Peter Zijlstra wrote:
> On Tue, 2010-05-25 at 17:02 +0200, Stephane Eranian wrote:
> > Ok, the patch look good expect it needs:
> > 
> > static int x86_pmu_commit_txn(const struct pmu *pmu)
> > {
> >         ......
> >         /*
> >          * copy new assignment, now we know it is possible
> >          * will be used by hw_perf_enable()
> >          */
> >         memcpy(cpuc->assign, assign, n*sizeof(int));
> > 
> >         cpuc->n_txn = 0;
> > 
> >         return 0;
> > }
> > 
> > Because you always call cancel_txn() even when commit()
> > succeeds. I don't really understand why. I think it could be
> > avoided by clearing the group_flag in commit_txn() if it
> > succeeds. It would also make the logical flow more natural. Why
> > cancel something that has succeeded. You cancel when you fail/abort.
> 
> Gah, I forgot about that. I think I suggested to Lin to do that and then
> promptly forgot.

cancel_txn() clears the transaction flag, so it is needed after both
success and fail transaction, although the function name is a bit
misleading.

Peter's patch adds the clear of transaction flag into each
implementation of ->commit_txn.

So cancel_txn() is only called after fail transaction now.

Thanks,
Lin Ming

> 
> Let me add that and at least push this patch fwd, we can try and clean
> up that detail later on.

