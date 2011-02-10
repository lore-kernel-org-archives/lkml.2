Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1BJVCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:02:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37573
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756996Ab1BJVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:02:50 -0500
Date: Thu, 10 Feb 2011 13:03:25 -0800 (PST)
Message-Id: <20110210.130325.112603217.davem@davemloft.net>
To: steiner@sgi.com
Cc: mingo@elte.hu, raz@scalemp.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de, cpw@sgi.com,
        travis@sgi.com, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [BUG] soft lockup while booting machine with more than 700
 cores
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110210205648.GA10341@sgi.com>
References: <1297236453.2756.9.camel@raz.scalemp.com>
	<20110210123937.GD26094@elte.hu>
	<20110210205648.GA10341@sgi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>
Date: Thu, 10 Feb 2011 14:56:48 -0600

> We also noticed that the rebalance_domains() code references many per-cpu
> run queue structures. All of the structures have identical offsets relative
> to the size of a cache leaf. The result is that all index into the same lines in the
> L3 caches. That causes many evictions. We tried an experimental to
> stride the run queues at 128 byte offsets. That helped in some cases but the
> results were mixed.  We are still experimenting with the patch.

I think chasing after cache alignment issues misses the point entirely.

The core issue is that rebalance_domains() is insanely expensive, by
design.  It's complexity is N factorial for the idle non-HZ cpu that is
selected to balance every single domain.

A statistic datastructure that is approximately 128 bytes in size is
repopulated N! times each time this global rebalance thing runs.

I've been seeing rebalance_domains() in my perf top output on 128 cpu
machines for several years now.  Even on an otherwise idle machine,
the system churns in thus code path endlessly.



