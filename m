Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0ITUA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:00:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55737
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509Ab0ITUA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:00:28 -0400
Date: Mon, 20 Sep 2010 13:00:47 -0700 (PDT)
Message-Id: <20100920.130047.124017922.davem@davemloft.net>
To: nbowler@elliptictech.com
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100920195256.GA14330@elliptictech.com>
References: <20100920174443.GA5515@elliptictech.com>
	<1285006844.2323.17.camel@edumazet-laptop>
	<20100920195256.GA14330@elliptictech.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>
Date: Mon, 20 Sep 2010 15:52:56 -0400

> On 2010-09-20 20:20 +0200, Eric Dumazet wrote:
>> If you change your program to send small frames (so they are not
>> fragmented), is the problem still present ?
> 
> I changed MAX_DGRAM_SIZE in the test program to 1000 (mtu on the
> interface is 1500).  The short answer is that the references are
> not leaked, and things seem to get cleaned up.  So the rest of this
> mail probably describes a separate issue.
> 
> The long answer, however, is interesting: With latest Linus' git, the
> references are cleaned up much later than I would expect.  After running
> the test program and flushing the SAD/SPD, the reference count is still
> 1.  If I repeat the test immediately, the reference count will increase
> further.  I can easily raise the reference count to, say, 100.  Now, if
> I wait a while (10 minutes or so), the reference count will still be
> 100.  However, when I run the setkey script after this delay, the
> reference count drops immediately to 1.  If I then flush the SAD/SPD, it
> drops to 0.

This is because we actually cache IPSEC routes correctly, previously
we'd create a new routing cache entry every time a lookup happened.

