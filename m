Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0JVSks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:40:48 -0400
Received: from kroah.org ([198.145.64.141]:45881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671Ab0JVSjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:39:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:01 2010
Message-Id: <20101022183601.727423229@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [62/66] execve: improve interactivity with large arguments
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -419,6 +419,8 @@ static int copy_strings(int argc, char _
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;


