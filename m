Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab0HXW7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:59:30 -0400
Received: from kroah.org ([198.145.64.141]:40508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab0HXW7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:20 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:17 2010
Message-Id: <20100824224217.134516241@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarek Poplawski <jarkao2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [59/91] net: Fix a memmove bug in dev_gro_receive()
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit e5093aec2e6b60c3df2420057ffab9ed4a6d2792 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2735,7 +2735,7 @@ pull:
 			put_page(skb_shinfo(skb)->frags[0].page);
 			memmove(skb_shinfo(skb)->frags,
 				skb_shinfo(skb)->frags + 1,
-				--skb_shinfo(skb)->nr_frags);
+				--skb_shinfo(skb)->nr_frags * sizeof(skb_frag_t));
 		}
 	}
 


