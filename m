Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab0FKUdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:33:52 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:3149 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0FKUdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:33:51 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKE6EkyrR7Hu/2dsb2JhbACefHGlJ5lqhRgEg0w
X-IronPort-AV: E=Sophos;i="4.53,404,1272844800"; 
   d="scan'208";a="543431666"
Date: Fri, 11 Jun 2010 13:33:50 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-kernel@vger.kernel.org"@cisco.com,
       linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4][RFC] Introduction to sk_buff state checking
Message-ID: <20100611203350.GA28383@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add state checking for sk_buffs

Several common errors in sk_buff usage can be caught by maintaining and
checking the sk_buff state. States are: free, allocated, and queued. Simply
reporting an error is not sufficient; it may be the previous state change
that was erroneous. Thus, the ability to record the location of the previous
state change is essential.

This patch was previously submitted and David Miller objected to to the
overhead of recording the previous state change. Specifically, he wrote:

	The specifics are that if you showed me something that
	added a "u16", at most, I'd go to bat for you and support
	your work going upstream.

With only three states, only two bits are required to record the current
state but recording the location of the call that changed the state in
no more than 14 bits posed an interesting challenge. This patchset contains
the infrastructure required to map between a small value, the "callsite ID",
and the location of the call. 

There are four patches in this patchset:
1.	This introduction
2.	A patch allowing the site of a call to be passed over multiple calls
	without modifying the intervening functions.
3.	A patch providing infrastructure that allows the location of a call,
	the "callsite ID" to be encoded in a small integer.
4.	Modifications to the sk_buff functions to add the two-bit state
	and a 14-bit callsite ID, check the state, and report failures.
	
Restrictions
o	Call site IDs are never reused, so it is possible to exceed the
	maximum number of IDs by having a large number of call locations.
	In addition, it does not recognize that the same module has been
	unloaded and reloaded, so calls from the reloaded module will be
	assigned new IDs. Detection of incorrect operations on an sk_buff
	is not affected by exhaustion of call site IDs, but it may not be
	possible to determine the location of the last operation.
	CONFIG_DEBUG_SKB_ID_SIZE is set to reduce the sk_buff growth to 16
	bits and should handle most cases. It could be made larger to allow
	more call site IDs, if necessary.
o	The callsite structures for a module will be freed when that module
	is unloaded, even though sk_buffs may be using IDs corresponding to
	those call sites. To allow useful error reporting, the call site
	information in a module being unloaded is copied. If a module is
	unloaded and CONFIG_CALLSITE_TERSE is enabled, the address of
	the call site is not longer valid, so only the function name and
	offset are printed. If CONFIG_CALLSITE_TERSE is enabled and the
	is loaded, the address is also reported.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
