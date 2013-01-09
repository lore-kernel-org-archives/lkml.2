Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab3AIU40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:56:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:43681 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933954Ab3AIUkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 092/123] signals: sys_ssetmask() uses uninitialized newmask
Date: Wed,  9 Jan 2013 12:35:31 -0800
Message-Id: <20130109201510.416785675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 5ba53ff648e785445a32ba39112ed07e4cf588d0 upstream.

Commit 77097ae503b1 ("most of set_current_blocked() callers want
SIGKILL/SIGSTOP removed from set") removed the initialization of newmask
by accident, causing ltp to complain like this:

  ssetmask01    1  TFAIL  :  sgetmask() failed: TEST_ERRNO=???(0): Success

Restore the proper initialization.

Reported-and-tested-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3221,6 +3221,7 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
 	int old = current->blocked.sig[0];
 	sigset_t newset;
 
+	siginitset(&newset, newmask);
 	set_current_blocked(&newset);
 
 	return old;


