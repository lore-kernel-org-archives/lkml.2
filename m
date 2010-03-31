Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0CaXCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:02:45 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56209 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393Ab0CaXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:02:44 -0400
Date: Wed, 31 Mar 2010 16:02:37 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [Patch] bonding: fix potential deadlock in bond_uninit()
Message-ID: <20100331160237.73560dfe@s6510>
In-Reply-To: <m1d3ykzq5a.fsf@fess.ebiederm.org>
References: <20100331105559.5607.38643.sendpatchset@localhost.localdomain>
	<m1d3ykzq5a.fsf@fess.ebiederm.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 04:28:33 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Amerigo Wang <amwang@redhat.com> writes:
> 
> > bond_uninit() is invoked with rtnl_lock held, when it does destroy_workqueue()
> > which will potentially flush all works in this workqueue, if we hold rtnl_lock
> > again in the work function, it will deadlock.
> >
> > So unlock rtnl_lock before calling destroy_workqueue().
> 
> Ouch.  That seems rather rude to our caller, and likely very
> dangerous.
> 
> Is this a deadlock you actually hit, or is this something lockdep
> warned about?
> 
> My gut feel says we need to move the destroy_workqueue into
> the network device destructor.
> 
> Eric

Why is there one workqueue per bond device rather than just one workqueue for
all bonding devices controlled by the module instance? It would be cleaner
on removal and less space and overhead.  I can't see that doing arp/mii or alb
work is high parallel and load activity.
