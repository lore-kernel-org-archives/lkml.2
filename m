Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab0LIHuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:50:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:20280 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0LIHuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QFl1nVW4bi0jpPy73JnZgzO4Dx/rxyG0FaCrfvsqoY+ElvNyDITVrGgcP8iEotSbcp
         QuSuNlZCIBKy0DXqvoug==
From: Michel Lespinasse <walken@google.com>
To: Nick Piggin <npiggin@kernel.dk>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] RFC: page munlock issues when breaking up COW
Date: Wed,  8 Dec 2010 23:49:37 -0800
Message-Id: <1291880979-16309-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending this up as RFC only as I've only done minimal testing so far -
I would actually be particularly interested in comments about any corner
cases I must make sure to test for...

It looks like there is a race in the do_wp_page() code that munlocks the
old page after breaking up COW. The pte still points to that old page,
so I don't see that we are protected against vmscan mlocking back the
page right away. This can be easily worked around by moving that code to
the end of do_wp_page(), after the pte has been pointed to the new page.

Also, the corresponding code in __do_fault() seems entirely unnecessary,
since there was never a pte pointing to the old page in our vma.

I found this by code inspection only, and while I believe I understand
this code well by now, there is always the possibility that I may have
missed something. I hope Nick can comment, since he wrote this part of
the code.

Michel Lespinasse (2):
  mlock: fix race when munlocking pages in do_wp_page()
  mlock: do not munlock pages in __do_fault()

 mm/memory.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

-- 
1.7.3.1

