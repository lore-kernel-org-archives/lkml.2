Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0IKBP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 21:15:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54119 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0IKBP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 21:15:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=sef3MA5KJQRY0E94eiS6dKDA73u4yz+GUPDB7A6vZk9isLTX1WnXUjfatXqTcVBPm
	FhU8xc3SYJy81nzhLnr/Q==
From: Venkatesh Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: x86: Extend mtrr lookup to support regions spanning MTRR range
Date: Fri, 10 Sep 2010 18:15:31 -0700
Message-Id: <1284167733-2683-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtrr_type_lookup [start:end] looked up the resultant MTRR type for that
range, based on fixed and all variable MTRR ranges. It did check for multiple
MTRR var ranges overlapping [start:end] and returned the net type.

However, if the [start:end] range spanned across any var MTRR range,
mtrr_type_lookup would return an error return of 0xFE. This was based on
typical usage of mtrr_type_lookup in PAT mapping, where region being
mapped would not normally span across MTRR ranges and also trying
to keep the code simple.

Mark recently reported the problem with this limitation. When there are
two continguous MTRR's of type "writeback" and if there is a memory mapping
over a region starting in one MTRR range and ending in another MTRR range,
such mapping will fallback to "uncached" due to the above limitation.

Change below adds support for such lookups spanning multiple MTRR ranges.
We now have a wrapper mtrr_type_lookup that dynamically splits such a region
into smaller chunks that fit within one MTRR range and does a
__mtrr_type_lookup on it and combine the results later.

Reported-by: Mark Langsdorf <mark.langsdorf@amd.com>

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

---

[ Sorry if this a duplicate. I missed out cc'ing lkml earlier ]

