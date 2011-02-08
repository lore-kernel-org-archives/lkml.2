Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1BHAsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:48:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:21237 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1BHAsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VtpEOKj9wudqcWTuxo/NW3fzdkE27MyaDkmnOtVq5hsQ09HCYsn6PZxtPBlX6xxVPO
         qBhECcd48c6DWiSB2SHQ==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] page munlock issues when breaking up COW
Date: Mon,  7 Feb 2011 16:47:34 -0800
Message-Id: <1297126056-14322-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like there is a race in the do_wp_page() code that munlocks the
old page after breaking up COW. The pte still points to that old page,
so I don't see that we are protected against vmscan mlocking back the
page right away. This can be easily worked around by moving that code to
the end of do_wp_page(), after the pte has been pointed to the new page.

Also, the corresponding code in __do_fault() seems entirely unnecessary,
since there was never a pte pointing to the old page in our vma.

Michel Lespinasse (2):
  mlock: fix race when munlocking pages in do_wp_page()
  mlock: do not munlock pages in __do_fault()

 mm/memory.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

-- 
1.7.3.1
