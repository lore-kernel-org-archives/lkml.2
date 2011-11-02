Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840Ab1KCBmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:42:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934816Ab1KCBmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222747.652684087@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jarek Poplawski <jarkao2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [086/101] net: Fix a memmove bug in dev_gro_receive()
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

commit e5093aec2e6b60c3df2420057ffab9ed4a6d2792 upstream.

>Xin Xiaohui wrote:
> I looked into the code dev_gro_receive(), found the code here:
> if the frags[0] is pulled to 0, then the page will be released,
> and memmove() frags left.
> Is that right? I'm not sure if memmove do right or not, but
> frags[0].size is never set after memove at least. what I think
> a simple way is not to do anything if we found frags[0].size == 0.
> The patch is as followed.
...

This version of the patch fixes the bug directly in memmove.

Reported-by: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2664,7 +2664,7 @@ pull:
 			put_page(skb_shinfo(skb)->frags[0].page);
 			memmove(skb_shinfo(skb)->frags,
 				skb_shinfo(skb)->frags + 1,
-				--skb_shinfo(skb)->nr_frags);
+				--skb_shinfo(skb)->nr_frags * sizeof(skb_frag_t));
 		}
 	}
 


