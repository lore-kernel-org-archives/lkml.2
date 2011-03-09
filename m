Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1CIQps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:45:48 -0500
Received: from polaris.galacticasoftware.com ([216.55.199.131]:32994 "EHLO
	polaris.galacticasoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab1CIQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:45:46 -0500
Date: Wed, 9 Mar 2011 10:44:49 -0600
From: Adam Majer <adamm@zombino.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Issue NETDEV_CHANGE notification when bridge
 changes state
Message-ID: <20110309164448.GA2364@mira.lan.galacticasoftware.com>
References: <20110306051833.GA3098@mira.lan.galacticasoftware.com>
 <20110309150949.GE16951@cr0.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110309150949.GE16951@cr0.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 11:09:49PM +0800, Américo Wang wrote:
> On Sat, Mar 05, 2011 at 11:18:33PM -0600, Adam Majer wrote:
> >
> >IPv6 address autoconfiguration relies on an UP interface to processes
> >traffic normally. A bridge that is UP enters LEARNING state and this
> >state "eats" any Router Advertising packets sent to the
> >bridge. Issuing a NETDEV_CHANGE notification on the bridge interface
> >when it changes state allows autoconfiguration code to retry
> >querying router information.
> >
> ...
> 
> >+static void br_port_change_notifier_handler(struct work_struct *work)
> >+{
> >+	struct net_bridge *br = container_of(work,
> >+					     struct net_bridge,
> >+					     change_notification_worker);
> >+
> >+	rtnl_lock();
> >+	netdev_state_change(br->dev);
> >+	rtnl_unlock();
> >+}
> >+
> 
> Do you really want user-space to get this notification too?
> Why do you put it into a workqueue? Maybe it has to be called in
> process-context?

Stephen Hemminger's patch (posted as a reply in this thread but only
on the netdev mailing list) is much better as it only brings the link
up on the bridge interface when the bridge enters forwarding mode.

Effectively it does similar thing via NETDEV_CHANGE but requires no
other hacks in other code. It should make userland much happier too.


As for my patch, I've put that in the workqueue because the
notification cannot be called in interrupt context. Is there a better
way of calling code that can sleep from interrupt context?

- Adam

-- 
Adam Majer
adamm@zombino.com
