Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2FMScS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:32:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46686 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2FMScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:32:17 -0400
Date: Wed, 13 Jun 2012 14:24:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: xen/mce - mcelog at 100% cpu
Message-ID: <20120613182458.GA5813@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
 <20120612124015.GB559@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612124015.GB559@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 08:40:15AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 12, 2012 at 07:51:03AM +0000, Liu, Jinsong wrote:
> > >From aa2ce7440f16002266dc8464f749992d0c8ac0e5 Mon Sep 17 00:00:00 2001
> > From: Liu, Jinsong <jinsong.liu@intel.com>
> > Date: Tue, 12 Jun 2012 23:11:16 +0800
> > Subject: [PATCH] xen/mce: schedule a workqueue to avoid sleep in atomic context
> > 
> > copy_to_user might sleep and print a stack trace if it is executed
> > in an atomic spinlock context.
> > 
> > This patch schedule a workqueue for IRQ handler to poll the data,
> > and use mutex instead of spinlock, so copy_to_user sleep in atomic
> > context would not occur.
> 
> Ah much better. Usually one also includes the report of what the
> stack trace was. So I've added that in.

So another bug which is that mcelog is spinning at 100% CPU (and only
under Xen).

It seems to be doing:

ppoll([{fd=4, events=POLLIN}, {fd=3, events=POLLIN}], 2, NULL, [], 8) = 1 ([{fd=3, revents=POLLIN}])
read(3, "", 2816)                       = 0
ppoll([{fd=4, events=POLLIN}, {fd=3, events=POLLIN}], 2, NULL, [], 8) = 1 ([{fd=3, revents=POLLIN}])
read(3, "", 2816) 

constantly.
