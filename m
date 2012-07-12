Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab2GLXKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:10:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162844Ab2GLXFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:05:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Liu <lliubbo@gmail.com>, Hugh Dickins <hughd@google.com>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [ 65/68] fs: ramfs: file-nommu: add SetPageUptodate()
Date: Thu, 12 Jul 2012 16:02:39 -0700
Message-Id: <20120712175041.167683999@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Liu <lliubbo@gmail.com>

commit fea9f718b3d68147f162ed2d870183ce5e0ad8d8 upstream.

There is a bug in the below scenario for !CONFIG_MMU:

 1. create a new file
 2. mmap the file and write to it
 3. read the file can't get the correct value

Because

  sys_read() -> generic_file_aio_read() -> simple_readpage() -> clear_page()

which causes the page to be zeroed.

Add SetPageUptodate() to ramfs_nommu_expand_for_mapping() so that
generic_file_aio_read() do not call simple_readpage().

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -110,6 +110,7 @@ int ramfs_nommu_expand_for_mapping(struc
 
 		/* prevent the page from being discarded on memory pressure */
 		SetPageDirty(page);
+		SetPageUptodate(page);
 
 		unlock_page(page);
 		put_page(page);


