Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0IMDqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:46:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45873 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab0IMDqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:46:21 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2010 23:46:21 EDT
Message-Id: <1284349152.15254.1394658481@webmail.messagingengine.com>
X-Sasl-Enc: ICZ6uVBES6oxKWbVgrqoQSgSrwcAzwxkhrPCu04azOV2 1284349152
From: "Robert Mueller" <robm@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Bron Gondwana" <brong@fastmail.fm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Default zone_reclaim_mode = 1 on NUMA kernel is bad for file/email/web
 servers
Reply-To: robm@fastmail.fm
Date: Mon, 13 Sep 2010 13:39:12 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So over the last couple of weeks, I've noticed that our shiny new IMAP
servers (Dual Xeon E5520 + Intel S5520UR MB) with 48G of RAM haven't
been performing as well as expected, and there were some big oddities.
Namely two things stuck out:

1. There was free memory. There's 20T of data on these machines. The
   kernel should have used lots of memory for caching, but for some
   reason, it wasn't. cache ~ 2G, buffers ~ 25G, unused ~ 5G
2. The machine has an SSD for very hot data. In total, there's about 16G
   of data on the SSD. Almost all of that 16G of data should end up
   being cached, so there should be little reading from the SSDs at all.
   Instead we saw at peak times 2k+ blocks read/s from the SSDs. Again a
   sign that caching wasn't working.

After a bunch of googling, I found this thread.

http://lkml.org/lkml/2009/5/12/586

It appears that patch never went anywhere, and zone_reclaim_mode is
still defaulting to 1 on our pretty standard file/email/web server type
machine with a NUMA kernel.

By changing it to 0, we saw an immediate massive change in caching
behaviour. Now cache ~ 27G, buffers ~ 7G and unused ~ 0.2G, and IO reads
from the SSD dropped to 100/s instead of 2000/s.

Having very little knowledge of what this actually does, I'd just
like to point out that from a users point of view, it's really
annoying for your machine to be crippled by a default kernel setting
that's pretty obscure.

I don't think our usage scenario of serving lots of files is that
uncommon, every file server/email server/web server will be doing pretty
much that and expecting a large part of their memory to be used as a
cache, which clearly isn't what actually happens.

Rob
Rob Mueller
robm@fastmail.fm

