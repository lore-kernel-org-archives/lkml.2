Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab2BIQGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:06:44 -0500
Received: from mail.vyatta.com ([76.74.103.46]:55511 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051Ab2BIQGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:06:41 -0500
Date: Thu, 9 Feb 2012 08:06:38 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/50] set addr_assign_type to NET_ADDR_RANDOM if 
 a random mac address get assigned to a netdevice
Message-ID: <20120209080638.7608b588@nehalam.linuxnetplumber.net>
In-Reply-To: <201202091559.06480.danny.kukawka@bisect.de>
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
	<20120208145823.75f386c5@nehalam.linuxnetplumber.net>
	<201202091559.06480.danny.kukawka@bisect.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012 15:59:05 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> On Mittwoch, 8. Februar 2012, Stephen Hemminger wrote:
> > On Wed,  8 Feb 2012 22:10:07 +0100
> >
> > Danny Kukawka <danny.kukawka@bisect.de> wrote:
> > > The information if a device has a random MAC address is exported
> > > to the userspace via /sys/class/net/*/addr_assign_type, which
> > > export net_device->addr_assign_type.
> > >
> > > Currently only a few driver really use dev_hw_addr_random() to
> > > set addr_assign_type correctly to NET_ADDR_RANDOM.
> > >
> > > This patch change the drivers which set random addresses to
> > > change also addr_assign_type to NET_ADDR_RANDOM.
> > >
> > > To reflect if the MAC was changed from userspace via SIOCSIFHWADDR,
> > > which means it's no longer a random address set by the kernel,
> > > this patch remove NET_ADDR_RANDOM from addr_assign_type in this
> > > case.
> > >
> > > With this patch tools from userspace can now detect devices with
> > > random MAC addresses and change them to persistent addresses if
> > > needed (as e.g. in case of smsc95xx on PandaBoard).
> > >
> > > Maybe it makes sense to introduce a new state for addr_assign_type
> > > to reflect the fact, that the MAC address was changed via a ioctl
> > > from user space, e.g, with NET_ADDR_USERSPACE ?
> >
> > This reminds me that passing dev->dev_addr to dev_hw_addr_rrandom is
> > redundant for all the instances you showed, so why is it ia parameter.
> 
> There are two places in the existing code where it's used in a different way 
> in ixgbevf and igbvf, but thats changeable. I will take a look at it and 
> change dev_hw_addr_random to take simply a net_device ands set everything 
> directly.
> 
> > Also it should BUG() if address length is not 6 (ETH_ALEN).
> 
> Not needed if I change it to: 
> static inline void dev_hw_addr_random(struct net_device *dev) 
> 
> Danny

It is still needed to prevent some device driver that uses
some longer address (like Infiniband) from the thinking it is
a generic routine.  Maybe even renaming int eth_hw_addr_random()
