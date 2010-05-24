Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0EXX16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:27:58 -0400
Received: from kroah.org ([198.145.64.141]:59447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471Ab0EXXXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:47 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.537407731@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hughd@google.com>
Subject: [26/39] profile: fix stats and data leakage
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hughd@google.com>

commit 16a2164bb03612efe79a76c73da6da44445b9287 upstream.

If the kernel is large or the profiling step small, /proc/profile
leaks data and readprofile shows silly stats, until readprofile -r
has reset the buffer: clear the prof_buffer when it is vmalloc()ed.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/profile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -127,8 +127,10 @@ int __ref profile_init(void)
 		return 0;
 
 	prof_buffer = vmalloc(buffer_bytes);
-	if (prof_buffer)
+	if (prof_buffer) {
+		memset(prof_buffer, 0, buffer_bytes);
 		return 0;
+	}
 
 	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;


