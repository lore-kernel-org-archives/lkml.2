Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032461Ab2CSSX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:23:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33189 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965009Ab2CSSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:23:58 -0400
Subject: RE: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA84D@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1332176549-30960-1-git-send-email-haiyangz@microsoft.com>
	 <1332176549-30960-2-git-send-email-haiyangz@microsoft.com>
	 <1332177118.9397.32.camel@edumazet-glaptop>
	 <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA84D@TK5EX14MBXC223.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 11:23:55 -0700
Message-ID: <1332181435.9397.42.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 17:46 +0000, Haiyang Zhang wrote:

> We actually stop queue when the ring buffer is busy, see the code in netvsc.c

Then you dont need NETDEV_TX_BUSY at all.

When you used whole tx slots, you stop the queue, so start_xmit() wont
be called (and you wont recover from this useless call with
NETDEV_TX_BUSY)

> 
> > Try this on a machine with one CPU, I am pretty sure this can trigger
> > complete freezes.
> 
> I have tested with one CPU. After NETDEV_TX_BUSY is returned, the Linux
> guest OS continues to respond without any problem.

Problem is you might have used several billions cycles/instructions
without notice. Thats a busy loop and you assume consumer can empty som
tx slots while you're busy looping. Thats pretty lazy.

This path is actually hard to test. In fact most of the time its
probably never hit at all.

Some NETDEV_TX_BUSY bugs are in the code since ages and nobody
complained. Thats not a reason to add new ones.

See recents commits on this subject : Bug never triggered but it was
here fir sure.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=b8fbaef586176f6abe0eb7887ddae66e99898b79



