Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2AZKvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:51:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35835 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2AZKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:51:53 -0500
Message-ID: <1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] netns: fix net_alloc_generic()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 26 Jan 2012 11:51:48 +0100
In-Reply-To: <4F212E7E.2040801@parallels.com>
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>
		 <1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F212E7E.2040801@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 14:44 +0400, Pavel Emelyanov a écrit :
> > I believe the problem is in net_namespace infrastructure, not in CAIF.
> > 
> > Could you test following patch instead ?
> > 
> > [PATCH] netns: fix net_alloc_generic()
> > 
> > When a new net namespace is created, we should attach to it a "struct
> > net_generic" with enough slots (even empty), or we can hit the following
> > BUG_ON() :
> > 
> > [  200.752016] kernel BUG at include/net/netns/generic.h:40!
> > ...
> > [  200.752016]  [<ffffffff825c3cea>] ? get_cfcnfg+0x3a/0x180
> > [  200.752016]  [<ffffffff821cf0b0>] ? lockdep_rtnl_is_held+0x10/0x20
> > [  200.752016]  [<ffffffff825c41be>] caif_device_notify+0x2e/0x530
> > [  200.752016]  [<ffffffff810d61b7>] notifier_call_chain+0x67/0x110
> > [  200.752016]  [<ffffffff810d67c1>] raw_notifier_call_chain+0x11/0x20
> > [  200.752016]  [<ffffffff821bae82>] call_netdevice_notifiers+0x32/0x60
> > [  200.752016]  [<ffffffff821c2b26>] register_netdevice+0x196/0x300
> > [  200.752016]  [<ffffffff821c2ca9>] register_netdev+0x19/0x30
> > [  200.752016]  [<ffffffff81c1c67a>] loopback_net_init+0x4a/0xa0
> > [  200.752016]  [<ffffffff821b5e62>] ops_init+0x42/0x180
> > [  200.752016]  [<ffffffff821b600b>] setup_net+0x6b/0x100
> > [  200.752016]  [<ffffffff821b6466>] copy_net_ns+0x86/0x110
> > [  200.752016]  [<ffffffff810d5789>] create_new_namespaces+0xd9/0x190
> > 
> > net_alloc_generic() should take into account the maximum index into the
> > ptr array, as a subsystem might use net_generic() anytime.
> 
> I'm not sure I understand it correctly, but subsystem can only use the
> net_generic() only (!) after the net_assign_generic() is performed.

Yes, but here, loopback_net_init() calls register_netdev()

So every subsystems _notify are called, even if subsystem _init_net()
was not yet called.

Its a chicken and egg problem.



