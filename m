Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0I3HFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:05:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0I3HFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:05:14 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web servers
References: <52C8765522A740A4A5C027E8FDFFDFE3@jem>
	<20100921090407.GA11439@csn.ul.ie>
	<20100927110049.6B31.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1009270828510.7000@router.home>
Date: Thu, 30 Sep 2010 09:05:05 +0200
In-Reply-To: <alpine.DEB.2.00.1009270828510.7000@router.home> (Christoph
	Lameter's message of "Mon, 27 Sep 2010 08:53:58 -0500 (CDT)")
Message-ID: <87aamzww2m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:
>
> 1. Fix the ACPI information to indicate lower memory access differences
>    (was that info actually acurate?) so that zone reclaim defaults to off.

The reason the ACPI information is set this way is that the people who
tune the BIOS have some workload they care about which prefers zone
reclaim off and they know they can force this "faster setting" by faking
the distances.

Basically they're working around a Linux performance quirk.

Really I think some variant of Motohiro-san's patch is the right
solution: most problems with zone reclaim are related to IO 
intensive workloads and it never made sense to have the unmapped
disk cache local on a system with reasonably small NUMA factor.

The only problem is on extremly big NUMA systems where remote nodes
are so slow that it's too slow even for read() and write().
I have been playing with the idea of adding a new "nearby interleave"
NUMA mode for this, but didn't have time to implement it so far.

For application I don't think we can ever solve it completely, this
probably always needs some kind of tuning. Currently the NUMA policy
APIs are not too good for this because they are too static, e.g. in some
cases "nearby" without fixed node affinity would also help here.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
