Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab0G3Ou0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:50:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab0G3OuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:50:25 -0400
Message-ID: <4C52E692.3070405@kernel.org>
Date: Fri, 30 Jul 2010 16:49:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Sridhar Samudrala <samudrala@us.ibm.com>,
        Jeff Dike <jdike@linux.intel.com>, Juan Quintela <quintela@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        David Stevens <dlstevens@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: locking/rcu cleanup
References: <20100729122325.GA24337@redhat.com>
In-Reply-To: <20100729122325.GA24337@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 14:49:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/29/2010 02:23 PM, Michael S. Tsirkin wrote:
> I saw WARN_ON(!list_empty(&dev->work_list)) trigger
> so our custom flush is not as airtight as need be.

Could be but it's also possible that something has queued something
after the last flush?  Is the problem reproducible?

> This patch switches to a simple atomic counter + srcu instead of
> the custom locked queue + flush implementation.
> 
> This will slow down the setup ioctls, which should not matter -
> it's slow path anyway. We use the expedited flush to at least
> make sure it has a sane time bound.
> 
> Works fine for me. I got reports that with many guests,
> work lock is highly contended, and this patch should in theory
> fix this as well - but I haven't tested this yet.

Hmmm... vhost_poll_flush() becomes synchronize_srcu_expedited().  Can
you please explain how it works?  synchronize_srcu_expedited() is an
extremely heavy operation involving scheduling the cpu_stop task on
all cpus.  I'm not quite sure whether doing it from every flush is a
good idea.  Is flush supposed to be a very rare operation?

Having custom implementation is fine too but let's try to implement
something generic if at all possible.

Thanks.

-- 
tejun
