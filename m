Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1C1N46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:56:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46640 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1C1N45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=xAQedaQl33Yy27fR0Ji6ipVU3Jts3F00W+ZK0RPqQqhsg4vRgr51jf1IIgjmY87kgQ
         lb8kxP64X1otAh8XpdrETeNOwieqorhLZ5rTHut/pCvs3DcGeDVi8dprLNrn3hoEm9gC
         WftvcIgXWCwvfoyr6S7fkVfj+H04byJKSvJkI=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RFC/RFT 0/6] nommu: improve the vma list handling
Date: Mon, 28 Mar 2011 22:56:41 +0900
Message-Id: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I was reading nommu code, I found that it handles the vma list/tree in
an unusual way. IIUC, because there can be more than one identical/overrapped
vmas in the list/tree, it sorts the tree more strictly and does a linear
search on the tree. But it doesn't applied to the list (i.e. the list could
be constructed in a different order than the tree so that we can't use the
list when finding the first vma in that order).

Since inserting/sorting a vma in the tree and link is done at the same time,
we can easily construct both of them in the same order. And linear searching
on the tree could be more costly than doing it on the list, it can be
converted to use the list.

Also, after the commit 297c5eee3724 ("mm: make the vma list be doubly linked")
made the list be doubly linked, there were a couple of code need to be fixed
to construct the list properly.

Patch 1/6 is a preparation. It maintains the list sorted same as the tree and
construct doubly-linked list properly. Patch 2/6 is a simple optimization for
the vma deletion. Patch 3/6 and 4/6 convert tree traversal to list traversal
and the rest are simple fixes and cleanups.

Note that I don't have a system to test on, so these are *totally untested*
patches. There could be some basic errors in the code. In that case, please
kindly let me know. :)

Anyway, I just compiled them on my x86_64 desktop using this command:

  make mm/nommu.o

(Of course this required few of dirty-fixes to proceed)

Also note that these are on top of v2.6.38.

Any comments are welcome.

Thanks.


---
Namhyung Kim (6):
  nommu: sort mm->mmap list properly
  nommu: don't scan the vma list when deleting
  nommu: find vma using the sorted vma list
  nommu: check the vma list when unmapping file-mapped vma
  nommu: fix a potential memory leak in do_mmap_private()
  nommu: fix a compile warning in do_mmap_pgoff()

 mm/nommu.c |  103 +++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 58 insertions(+), 45 deletions(-)

--
1.7.4

