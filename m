Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210Ab1ESSLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:11:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51916 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934064Ab1ESSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:29 -0400
X-Sasl-enc: R3ga5vUZUXXSJNRJJkayWRRy0uQrx/pkpHFeUjtCGMOS 1305828568
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:00 2011
Message-Id: <20110519180600.405831917@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Robert Richter <robert.richter@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [64/71] x86, mce, AMD: Fix leaving freed data in a list
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit d9a5ac9ef306eb5cc874f285185a15c303c50009 upstream.

b may be added to a list, but is not removed before being freed
in the case of an error.  This is done in the corresponding
deallocation function, so the code here has been changed to
follow that.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E1,E2;
identifier l;
@@

*list_add(&E->l,E1);
... when != E1
    when != list_del(&E->l)
    when != list_del_init(&E->l)
    when != E = E2
*kfree(E);// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/1305294731-12127-1-git-send-email-julia@diku.dk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -509,6 +509,7 @@ recurse:
 out_free:
 	if (b) {
 		kobject_put(&b->kobj);
+		list_del(&b->miscj);
 		kfree(b);
 	}
 	return err;


