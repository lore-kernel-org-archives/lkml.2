Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab0FHAhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:37:17 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:40311 "EHLO
	homiemail-a12.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751517Ab0FHAhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=sysclose.org; h=date:from:to:cc
	:subject:message-id:references:mime-version:content-type:
	in-reply-to; q=dns; s=sysclose.org; b=SVCL3y4AlBRNCpSDddp7jk5L3h
	Ovy/M2nnw/IZHbt2DXHUEwkMrL6iYVVtN8SY4eRl3GuGYjMkLLesn3Hm+SooVt5f
	JplCXOumEt+Ose3PCxFja93Iy0Ssv8PSLN00mmpcmM0NddbIHaRDE4v+qQVnB2Wq
	w+a49h1rKAhcl9rsE=
Date: Mon, 7 Jun 2010 21:37:07 -0300
From: Flavio Leitner <fbl@sysclose.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, amwang@redhat.com, fubar@us.ibm.com,
       mpm@selenic.com, gospo@redhat.com, nhorman@tuxdriver.com,
       jmoyer@redhat.com, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] netconsole: queue console messages to send later
Message-ID: <20100608003707.GA30604@sysclose.org>
References: <24059.1275417767@death.nxdomain.ibm.com>
 <1275938692-26997-1-git-send-email-fleitner@redhat.com>
 <20100607.165024.135517125.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100607.165024.135517125.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 04:50:24PM -0700, David Miller wrote:
> From: Flavio Leitner <fleitner@redhat.com>
> Date: Mon,  7 Jun 2010 16:24:52 -0300
> 
> > There are some networking drivers that hold a lock in the
> > transmit path. Therefore, if a console message is printed
> > after that, netconsole will push it through the transmit path,
> > resulting in a deadlock.
> > 
> > This patch fixes the re-injection problem by queuing the console
> > messages in a preallocated circular buffer and then scheduling a
> > workqueue to send them later with another context.
> > 
> > Signed-off-by: Flavio Leitner <fleitner@redhat.com>
> 
> You absolutely and positively MUST NOT do this.  Otherwise netconsole
> becomes completely useless.  Your idea has been proposed several times
> as far back as 6 years ago, it was unacceptable then and it's
> unacceptable now.
> 
> The whole point of netconsole is that we may be deep in an interrupt
> or other atomic context, the machine is about to hard hang, and it's
> absolutely essential that we get out any and all kernel logging
> messages that we can, immediately.

Got it. I've never assumed that netconsole would work reliable on 
such situations, so I thought as we have better ways now it would
be helpful. See another idea below.

> There may not be another timer or workqueue able to execute after the
> printk() we're trying to emit.  We may never get to that point.

What if in the netpoll, before we push the skb to the driver, we check
for a bit saying that it's already pushing another skb. In this case,
queue the new skb inside of netpoll and soon as the first call returns
and try to clear the bit, it will send the next skb?

printk("message 1")
...
netconsole called
netpoll sets the flag bit
pushes to the bonding driver which does another printk("message 2")
netconsole called again
netpoll checks for the flag, queue the message, returns.
so, bonding can finish up to send the first message
netpoll is about to return, checks for new queued messages, and pushes them.
bonding finishes up to send the second message
....

No deadlocks, skbs are ordered and still under the same opportunity
to send something. Does it sound acceptable?
It's off the top of my head, so probably this idea has some problems.


> Fix the locking in the drivers or layers that cause the issue instead
> of breaking netconsole.

Someday, somewhere, I know because I did this before, someone will
use a debugging printk() and will see the entire box hanging with
absolutely no message in any console because of this problem. 
I'm not saying that fixing driver isn't the right way to go but
it seems not enough to me.

-- 
Flavio
