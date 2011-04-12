Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1DLOjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:39:08 -0400
Received: from kroah.org ([198.145.64.141]:57901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab1DLOjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:39:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:58 2011
Message-Id: <20110412143558.883841857@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <boyu.mt@taobao.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [102/105] ext4: fix a double free in ext4_register_li_request
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tao Ma <boyu.mt@taobao.com>

commit 46e4690bbd9a4f8d9e7c4f34e34b48f703ad47e0 upstream.

In ext4_register_li_request, we malloc a ext4_li_request and
inserts it into ext4_li_info->li_request_list. In case of any
error later, we free it in the end.  But if we have some error
in ext4_run_lazyinit_thread, the whole li_request_list will be
dropped and freed in it. So we will double free this ext4_li_request.

This patch just sets elr to NULL after it is inserted to the list
so that the latter kfree won't double free it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2978,6 +2978,12 @@ static int ext4_register_li_request(stru
 	mutex_unlock(&ext4_li_info->li_list_mtx);
 
 	sbi->s_li_request = elr;
+	/*
+	 * set elr to NULL here since it has been inserted to
+	 * the request_list and the removal and free of it is
+	 * handled by ext4_clear_request_list from now on.
+	 */
+	elr = NULL;
 
 	if (!(ext4_li_info->li_state & EXT4_LAZYINIT_RUNNING)) {
 		ret = ext4_run_lazyinit_thread();


