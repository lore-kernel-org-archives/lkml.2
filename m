Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab1CZAWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:22:06 -0400
Received: from kroah.org ([198.145.64.141]:41589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab1CYXwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:41 2011
Message-Id: <20110325234841.538430456@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>, Eugene Teo <eugeneteo@kernel.sg>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Brad Spengler <spender@grsecurity.net>
Subject: [25/55] proc: protect mm start_code/end_code in /proc/pid/stat
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kees Cook <kees.cook@canonical.com>

commit 5883f57ca0008ffc93e09cbb9847a1928e50c6f3 upstream.

While mm->start_stack was protected from cross-uid viewing (commit
f83ce3e6b02d5 ("proc: avoid information leaks to non-privileged
processes")), the start_code and end_code values were not.  This would
allow the text location of a PIE binary to leak, defeating ASLR.

Note that the value "1" is used instead of "0" for a protected value since
"ps", "killall", and likely other readers of /proc/pid/stat, take
start_code of "0" to mean a kernel thread and will misbehave.  Thanks to
Brad Spengler for pointing this out.

Addresses CVE-2011-0726

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -489,8 +489,8 @@ static int do_task_stat(struct seq_file
 		vsize,
 		mm ? get_mm_rss(mm) : 0,
 		rsslim,
-		mm ? mm->start_code : 0,
-		mm ? mm->end_code : 0,
+		mm ? (permitted ? mm->start_code : 1) : 0,
+		mm ? (permitted ? mm->end_code : 1) : 0,
 		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,


