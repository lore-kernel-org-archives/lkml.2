Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0ITTxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:53:15 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:46910 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753802Ab0ITTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:53:13 -0400
Date: Mon, 20 Sep 2010 15:52:56 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
Message-ID: <20100920195256.GA14330@elliptictech.com>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
References: <20100920174443.GA5515@elliptictech.com>
 <1285006844.2323.17.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285006844.2323.17.camel@edumazet-laptop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-20 20:20 +0200, Eric Dumazet wrote:
> If you change your program to send small frames (so they are not
> fragmented), is the problem still present ?

I changed MAX_DGRAM_SIZE in the test program to 1000 (mtu on the
interface is 1500).  The short answer is that the references are
not leaked, and things seem to get cleaned up.  So the rest of this
mail probably describes a separate issue.

The long answer, however, is interesting: With latest Linus' git, the
references are cleaned up much later than I would expect.  After running
the test program and flushing the SAD/SPD, the reference count is still
1.  If I repeat the test immediately, the reference count will increase
further.  I can easily raise the reference count to, say, 100.  Now, if
I wait a while (10 minutes or so), the reference count will still be
100.  However, when I run the setkey script after this delay, the
reference count drops immediately to 1.  If I then flush the SAD/SPD, it
drops to 0.

This behaviour is new: newer than the reported leak.  For example, with
2.6.34, everything works perfectly with MAX_DGRAM_SIZE set to 1000 (the
SAs are destroyed immediately when the SAD/SPD are flushed), but the
leak occurs with MAX_DGRAM_SIZE set to 10000.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
