Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0KHJhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:37:54 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:47755 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0KHJhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:37:53 -0500
Date: Mon, 8 Nov 2010 10:37:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: memcg writeout throttling, was: [patch 4/4] memcg: use native
 word page statistics counters
Message-ID: <20101108093715.GJ23393@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
 <20101106010357.GD23393@cmpxchg.org>
 <AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
 <20101107215030.007259800@cmpxchg.org>
 <20101107220353.964566018@cmpxchg.org>
 <AANLkTinh+LEQYGe9dDOKBwNnVVXMiFYpDqkqvvpNe9H8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinh+LEQYGe9dDOKBwNnVVXMiFYpDqkqvvpNe9H8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:07:35AM +0900, Minchan Kim wrote:
> BTW, let me ask a question.
> dirty_writeback_pages seems to be depends on mem_cgroup_page_stat's
> result(ie, negative) for separate global and memcg.
> But mem_cgroup_page_stat could return negative value by per-cpu as
> well as root cgroup.
> If I understand right, Isn't it a problem?

Yes, the numbers are not reliable and may be off by some.  It appears
to me that the only sensible interpretation of a negative sum is to
assume zero, though.  So to be honest, I don't understand the fallback
to global state when the local state fluctuates around low values.

This function is also only used in throttle_vm_writeout(), where the
outcome is compared to the global dirty threshold.  So using the
number of writeback pages _from the current cgroup_ and falling back
to global writeback pages when this number is low makes no sense to me
at all.

I looks like it should rather compare the cgroup state with the cgroup
limit, and the global state with the global limit.

Can somebody explain the reasoning behind this?  And in case it makes
sense after all, put a comment into this function?

Thanks!
