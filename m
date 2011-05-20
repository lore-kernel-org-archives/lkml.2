Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975Ab1ETOhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:37:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843Ab1ETOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KmQKgEmzjdFYSxUwnee2sFzfRj1mvre7veY3TytUEWEzPApiMWl7Y7UTIXaXfiDCcM
         DdEY6yPLQ4GFz1SX4fGQ==
Date: Fri, 20 May 2011 16:37:07 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, andi@firstfloor.org,
        ming.m.lin@intel.com
Subject: [PATCH 0/3] perf_events: update extra shared registers management
 (v2)
Message-ID: <20110520143707.GA5347@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following short series of patches improves the code
which manages the extra shared regs used by some events
on Intel processors. Those events require an extra MSR
which may be shared between siblings CPUs when HT is on.
When HT is off, the kernel still needs to ensure that
events within an event group do not try to program
different values into that extra MSR.

This series improves the current code for managing the
register sharing by using static allocation instead of
dynamically trying to find a table slot to host that
extra MSR. This greatly simplifies the code. The patch
also prepare the kernel for more registers with those
kinds of constraints (e.g, LBR_SELECT, LD_LAT).

The patch also adds the missing group validation of
events using those extra MSRs. Up until now, one could
put two instances of the those events which had incompatible
values for the extra MSR. There was no upfront check and
the group would never be scheduled. Now, such group cannot
be constructed anymore (fail early).

Finally, the third patch adds the SandyBridge support for
the offcore_response events (which use these shared MSR).
It also removes the offcore_response events  from the
SandyBridge constraint event table. Those events don't
have any constraints contrary to what's published in
the documentation.

The second version updates PATCH 1/3 which was an
older version with reg->idx initialization problems.

[PATCH 0/3] introduction
[PATCH 1/3] rework of the register sharing logic
[PATCH 2/3] add missing shared regs validation
[PATCH 3/3] add Intel SandyBridge offcore_response support

Signed-off-by: Stephane Eranian <eranian@google.com>
---
