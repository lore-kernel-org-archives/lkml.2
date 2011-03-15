Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1CONOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:14:38 -0400
Received: from smtp.nokia.com ([147.243.1.47]:31464 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684Ab1CONOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:14:19 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: menage@google.com, lizf@cn.fujitsu.com
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com
Subject: [PATCH 0/2] suck some poison out of cgroups' linked lists
Date: Tue, 15 Mar 2011 15:08:41 +0200
Message-Id: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently saw cgroup_attach_task drop this bomb:
[   46.045806] Unable to handle kernel paging request at virtual address 00200200
Which is clearly linked-list poison.

Dereferencing 00100104 has also been seen nearby according to a quick 
web-search that I did.

Apparently, whether nodes are on a list is being checked with list_empty(),
and if they're on a list, they're list_del()ed. According to a subsequent 
list_empty() check, they're still on a list, as list_del() doesn't turn
the nodes into singleton lists, it simply poisons both its pointers, and
merry poison dereferencing may ensue. Oops.

There are at least 2 to address this matter, I've gone for the latter:

1) Do not use list_empty() to check if a node is on a list or not. Have
an additional new function that checks to see whether the node is either
a singleton or is poisoned. Something like list_node_{on,off}_list()?

2) Ensure that you never leave poison anywhere where you might want
to use list_empty().

It might be that these oopses are seen only because there's a marginal
race in the cgroups code, as they seem to be very rare. In that case
this patchset might not fix the core problem, but might simply hide it.
Someone with more cgroups expertise might want to investigate that 
possibility.

Patch 1 is the "hindsight is 20/20" patch which would have made 
identifying the issue trivial.

Cheers,
Phil
