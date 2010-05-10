Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0EJXNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:13:43 -0400
Received: from kroah.org ([198.145.64.141]:51876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909Ab0EJW6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:20 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.522886966@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Horman <nhorman@tuxdriver.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       maximilian attems <max@stro.at>
Subject: [68/98] dccp_probe: Fix module load dependencies between dccp and dccp_probe
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 38ff3e6bb987ec583268da8eb22628293095d43b upstream.

This was just recently reported to me.  When built as modules, the
dccp_probe module has a silent dependency on the dccp module.  This
stems from the fact that the module_init routine of dccp_probe
registers a jprobe on the dccp_sendmsg symbol.  Since the symbol is
only referenced as a text string (the .symbol_name field in the jprobe
struct) rather than the address of the symbol itself, depmod never
picks this dependency up, and so if you load the dccp_probe module
without the dccp module loaded, the register_jprobe call fails with an
-EINVAL, and the whole module load fails.

The fix is pretty easy, we can just wrap the register_jprobe call in a
try_then_request_module call, which forces the dependency to get
satisfied prior to the probe registration.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dccp/probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/dccp/probe.c
+++ b/net/dccp/probe.c
@@ -164,7 +164,8 @@ static __init int dccpprobe_init(void)
 	if (!proc_net_fops_create(&init_net, procname, S_IRUSR, &dccpprobe_fops))
 		goto err0;
 
-	ret = register_jprobe(&dccp_send_probe);
+	ret = try_then_request_module((register_jprobe(&dccp_send_probe) == 0),
+					"dccp");
 	if (ret)
 		goto err1;
 


