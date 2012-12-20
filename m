Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2LTEwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 23:52:44 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:58896 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2LTEwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 23:52:36 -0500
Date: Wed, 19 Dec 2012 20:52:37 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: migrate_misplaced_transhuge_page: no page_count check?
Message-ID: <alpine.LNX.2.00.1212192011320.25992@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel, Ingo,

I want to raise again a question I raised (in offline mail with Mel)
a couple of weeks ago.

I see only a page_mapcount check in migrate_misplaced_transhuge_page,
and don't understand how migration can be safe against the possibility
of an earlier call to get_user_pages or get_user_pages_fast (intended
to pin a part of the THP) without a page_count check.

(I'm also still somewhat worried about unidentified attempts to
pin the page concurrently; but since I don't have an example to give,
and concurrent get_user_pages or get_user_pages_fast wouldn't get past
the pmd_numa, let's not worry too much about my unidentified anxiety ;)

migrate_page_move_mapping and migrate_huge_page_move_mapping check
page_count, but migrate_misplaced_transhuge_page doesn't use those.
__collapse_huge_page_isolate and khugepaged_scan_pmd (over in
huge_memory.c) take commented care to check page_count lest GUP.

I can see that page_count might often be raised by concurrent faults
on the same pmd_numa, waiting on the lock_page in do_huge_pmd_numa_page.
That's unfortunate, and maybe you can find a clever way to discount
those.  But safety must come first: don't we need to check page_count?

Hugh
