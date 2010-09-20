Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab0ITUSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:18:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52495 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab0ITUST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vSW2SrDrh2quJZuog8fh0+ZApfofsIgPyFrs/UOsyhdW+P0xWn/qAJ+GQ23bVEd5Gk
         p9Zqdc27/43E8SHQYrpZBUVjDsEB2C90S3/APTDLdVUXG05XpxvN35T50Sa52GpPuFg3
         tVVwgOfdE6GLPt+z1KcsCkSdscunIuhybCIgg=
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100920195256.GA14330@elliptictech.com>
References: <20100920174443.GA5515@elliptictech.com>
	 <1285006844.2323.17.camel@edumazet-laptop>
	 <20100920195256.GA14330@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 22:17:33 +0200
Message-ID: <1285013853.2323.148.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 20 septembre 2010 à 15:52 -0400, Nick Bowler a écrit :
> On 2010-09-20 20:20 +0200, Eric Dumazet wrote:
> > If you change your program to send small frames (so they are not
> > fragmented), is the problem still present ?
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
> 
> This behaviour is new: newer than the reported leak.  For example, with
> 2.6.34, everything works perfectly with MAX_DGRAM_SIZE set to 1000 (the
> SAs are destroyed immediately when the SAD/SPD are flushed), but the
> leak occurs with MAX_DGRAM_SIZE set to 10000.
> 

Thanks Nick

I suspect a skb->truesize bug somewhere.

I can see atomic_read(&sk->sk_wmem_alloc) becoming negative after a
while...

I am investigating and let you know.

Thanks


