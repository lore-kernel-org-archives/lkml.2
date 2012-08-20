Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2HTEFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:05:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab2HTEBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [ 31/46] drivers-core: make structured logging play nice with dynamic-debug
Date: Sun, 19 Aug 2012 20:59:07 -0700
Message-Id: <20120820035836.580148816@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Cromie <jim.cromie@gmail.com>

commit af7f2158fdee9d7f55b793b09f8170a3391f889a upstream.

commit c4e00daaa96d3a0786f1f4fe6456281c60ef9a16 changed __dev_printk
in a way that broke dynamic-debug's ability to control the dynamic
prefix of dev_dbg(dev,..), but not dev_dbg(NULL,..) or pr_debug(..),
which is why it wasnt noticed sooner.

When dev==NULL, __dev_printk() just calls printk(), which just works.
But otherwise, it assumed that level was always a string like "<L>"
and just plucked out the 'L', ignoring the rest.  However,
dynamic_emit_prefix() adds "[tid] module:func:line:" to the string,
those additions all got lost.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1848,6 +1848,7 @@ int __dev_printk(const char *level, cons
 		 struct va_format *vaf)
 {
 	char dict[128];
+	const char *level_extra = "";
 	size_t dictlen = 0;
 	const char *subsys;
 
@@ -1894,10 +1895,14 @@ int __dev_printk(const char *level, cons
 				    "DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
 skip:
+	if (level[3])
+		level_extra = &level[3]; /* skip past "<L>" */
+
 	return printk_emit(0, level[1] - '0',
 			   dictlen ? dict : NULL, dictlen,
-			   "%s %s: %pV",
-			   dev_driver_string(dev), dev_name(dev), vaf);
+			   "%s %s: %s%pV",
+			   dev_driver_string(dev), dev_name(dev),
+			   level_extra, vaf);
 }
 EXPORT_SYMBOL(__dev_printk);
 


