Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1CIAna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:43:30 -0500
Received: from mout.perfora.net ([74.208.4.195]:60217 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab1CIAn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:43:29 -0500
From: Stephen Wilson <wilsons@start.ca>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] enable writing to /proc/pid/mem
Date: Tue,  8 Mar 2011 19:42:17 -0500
Message-Id: <1299631343-4499-1-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
X-Provags-ID: V02:K0:rlb6MljEkV8/rpehdnfnkgc1uZDLIXVPy+U1cZtihC4
 kiobIEvET4iHhW6ctO5kOfSg0+GeQIXBlO9oj6mbkURKSnYqam
 6IjLxC1EXQ0n7P0en25mHHWCypR86h2KEsBJ1hUclFwGWL7o9l
 OReip//wjiaRAnepgH0TvOehj2mPtbWiOY4tUl/PimVsLusHQc
 f/AfmoQAbt3gmpBIzrHkHl/Oti1SmV0Vw96WyaycRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a long time /proc/pid/mem has provided a read-only interface, at least
since 2.4.0.  However, a write capability has existed "forever" in tree via the
function mem_write(), disabled with an #ifdef along with the comment "this is a
security hazard".  Currently, the main problem with mem_write() is that between
the time permissions are checked and the actual write the target task could
exec a setuid-root binary.

This patch series enables safe writes to /proc/pid/mem.  The principle strategy
is to get a reference to the target task's mm before the permission check, and
to hold that reference until after the write completes.

This patch is useful as it gives debuggers a simple and efficient mechanism to
manipulate a processes address space.  Memory can be read and written using
single calls to pread(2) and pwrite(2) instead of iteratively calling
into ptrace(2).  In addition, /proc/pid/mem has always had write permissions
enabled, so clearly it *wants* to be written to. 

This series builds off previous work up for review here:

   http://lkml.org/lkml/2011/3/8/409

The general approach used was suggested to me by Alexander Viro, but any
mistakes present in these patches are entirely my own.


--
steve


Stephen Wilson (6):
      mm: use mm_struct to resolve gate vma's in __get_user_pages
      mm: factor out main logic of access_process_vm
      mm: implement access_remote_vm
      proc: disable mem_write after exec
      proc: make check_mem_permission() return an mm_struct on success
      proc: enable writing to /proc/pid/mem


 fs/proc/base.c     |   61 ++++++++++++++++++++++++++-------------------
 include/linux/mm.h |    2 +
 mm/memory.c        |   69 +++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 89 insertions(+), 43 deletions(-)



