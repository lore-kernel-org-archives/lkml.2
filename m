Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0JVS5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:57:24 -0400
Received: from kroah.org ([198.145.64.141]:34508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759564Ab0JVS5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:36 2010
Message-Id: <20101022185236.371676975@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [101/103] execve: improve interactivity with large arguments
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit 7993bc1f4663c0db67bb8f0d98e6678145b387cd upstream.

This adds a preemption point during the copying of the argument and
environment strings for execve, in copy_strings().  There is already
a preemption point in the count() loop, so this doesn't add any new
points in the abstract sense.

When the total argument+environment strings are very large, the time
spent copying them can be much more than a normal user time slice.
So this change improves the interactivity of the rest of the system
when one process is doing an execve with very large arguments.

Signed-off-by: Roland McGrath <roland@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -420,6 +420,8 @@ static int copy_strings(int argc, char _
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;


