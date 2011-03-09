Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1CICdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:33:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37079 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1CICdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:33:32 -0500
Date: Wed, 9 Mar 2011 02:33:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Wilson <wilsons@start.ca>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] enable writing to /proc/pid/mem
Message-ID: <20110309023303.GZ22723@ZenIV.linux.org.uk>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca>
 <20110309013017.GY22723@ZenIV.linux.org.uk>
 <20110309021524.GA4838@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309021524.GA4838@fibrous.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:15:25PM -0500, Stephen Wilson wrote:

> I think we could also remove the intermediate copy in both mem_read() and
> mem_write() as well, but I think such optimizations could be left for
> follow on patches.

How?  We do copy_.._user() in there; it can trigger page faults and
that's not something you want while holding mmap_sem on some mm.
Looks like a deadlock country...  So we can't do that from inside
access_process_vm() or its analogs, which means buffering in caller.
