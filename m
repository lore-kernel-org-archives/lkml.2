Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3AFRLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:11:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64462 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3AFRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:10:57 -0500
Subject: Re: Major network performance regression in 3.7
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130106164416.GF16031@1wt.eu>
References: <20130106013027.GV16031@1wt.eu>
	 <1357436430.1678.5111.camel@edumazet-glaptop>
	 <1357437086.1678.5135.camel@edumazet-glaptop>
	 <1357438591.1678.5205.camel@edumazet-glaptop>
	 <20130106025256.GY16031@1wt.eu>
	 <1357457724.1678.5941.camel@edumazet-glaptop>
	 <20130106092435.GZ16031@1wt.eu> <1357484342.6919.61.camel@edumazet-glaptop>
	 <20130106155123.GB16031@1wt.eu>
	 <1357490393.6919.267.camel@edumazet-glaptop>
	 <20130106164416.GF16031@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jan 2013 09:10:55 -0800
Message-ID: <1357492255.6919.336.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 17:44 +0100, Willy Tarreau wrote:
> On Sun, Jan 06, 2013 at 08:39:53AM -0800, Eric Dumazet wrote:
> > Hmm, I'll have to check if this really can be reverted without hurting
> > vmsplice() again.
> 
> Looking at the code I've been wondering whether we shouldn't transform
> the condition to perform the push if we can't push more segments, but
> I don't know what to rely on. It would be something like this :
> 
>        if (copied &&
>           (!(flags & MSG_SENDPAGE_NOTLAST) || cant_push_more))
>                 tcp_push(sk, flags, mss_now, tp->nonagle);

Good point !

Maybe the following fix then ?


diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1ca2536..7ba0717 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -941,8 +941,10 @@ out:
 	return copied;
 
 do_error:
-	if (copied)
+	if (copied) {
+		flags &= ~MSG_SENDPAGE_NOTLAST;
 		goto out;
+	}
 out_err:
 	return sk_stream_error(sk, flags, err);
 }


