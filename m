Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1IVU53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:57:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32358 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1IVU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:57:28 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 0/3] Replace kmalloc with vmalloc in seq_files
Date: Thu, 22 Sep 2011 13:57:06 -0700
Message-Id: <1316725029-22737-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a seq_file is implemented with single_open, the show function will
be called with a kmalloc'd PAGE_SIZE buffer.  If the show function
produces more data than can fit in the buffer, the buffer will be thrown
away, and the show function will be called again with a buffer twice as
large.  This process repeats until the show function does not overflow
the buffer, or kmalloc fails.

seq_files are often used for debugging data.  When the system is under
memory pressure, and dumping debugging data starts trying to allocate
large physically contiguous buffers, it often makes the problem worse.

Since there is no need for a physically contiguous buffer, this patch
set converts the kmalloc'd buffers into vmallocs.  There are two
seq_file users that kmalloc buffer and place it directly into the
seq_file structure, later to be freed by seq_release.  Convert those
to call a new seq_reserve function that will do the correct allocation
for them.
