Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab1FVTUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:20:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:39981 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab1FVTUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="18420771"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dehrenberg@google.com
Subject: RFC: Micro-optimize direct IO submission path
Date: Wed, 22 Jun 2011 12:18:36 -0700
Message-Id: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by the recent fast path DIO patch from Daniel
Ehrenberg.

I spent some time micro optimizing the "slow" direct IO submission 
part.  This should get rid of large parts of the memset and dio
access costs that Dan noticed.

I moved everything that isn't needed in the completion handler
back into the stack, to make it more likely it's cache hot.

It also inlines everything to allow the compiler to optimize more.
In particular it can split up the sdio structure into individual
variables now and then get rid of unnecessary initializations.
This costs some text size, but I think it's worth for such a hot 
path.

And the dio is a slab now, which avoids some fast path overhead.

Dan, could you please test this patch in your test case, comparing against
the fast path again?

Please test with CONFIG_CC_OPTIMIZE_FOR_SIZE and CONFIG_OPTIMIZE_INLINING
both disabled.

Thanks,

-Andi
