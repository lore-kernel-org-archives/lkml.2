Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0LHBCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:22 -0500
Received: from kroah.org ([198.145.64.141]:33416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab0LHBCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:14 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:38 2010
Message-Id: <20101208005738.371418861@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>, Patrick McHardy <kaber@trash.net>
Subject: [169/289] netfilter: NF_HOOK_COND has wrong conditional
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit ac5aa2e3332ec04889074afdbd1479424d0227a5 upstream.

The NF_HOOK_COND returns 0 when it shouldn't due to what I believe to be an
error in the code as the order of operations is not what was intended.  C will
evalutate == before =.  Which means ret is getting set to the bool result,
rather than the return value of the function call.  The code says

if (ret = function() == 1)
when it meant to say:
if ((ret = function()) == 1)

Normally the compiler would warn, but it doesn't notice it because its
a actually complex conditional and so the wrong code is wrapped in an explict
set of () [exactly what the compiler wants you to do if this was intentional].
Fixing this means that errors when netfilter denies a packet get propagated
back up the stack rather than lost.

Problem introduced by commit 2249065f (netfilter: get rid of the grossness
in netfilter.h).

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netfilter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -215,7 +215,7 @@ NF_HOOK_COND(uint8_t pf, unsigned int ho
 	int ret;
 
 	if (!cond ||
-	    (ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN) == 1))
+	    ((ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN)) == 1))
 		ret = okfn(skb);
 	return ret;
 }


