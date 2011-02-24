Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1BXQea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:34:30 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:20197 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1BXQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:34:28 -0500
Subject: Re: module loading with CAP_NET_ADMIN
From: Ben Hutchings <bhutchings@solarflare.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees.cook@canonical.com>, Eugene Teo <eugene@redhat.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20110224151238.GA16916@albatros>
References: <20110224151238.GA16916@albatros>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 24 Feb 2011 16:34:25 +0000
Message-ID: <1298565265.2613.16.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2011 16:34:28.0595 (UTC) FILETIME=[B4C44C30:01CBD440]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17974.004
X-TM-AS-Result: No--22.486800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 18:12 +0300, Vasiliy Kulikov wrote:
> Hi netdev folks,
> 
> I'd like to discuss the ability to load any modules from /lib/modules/
> by a process with CAP_NET_ADMIN.  Since Linux 2.6.32 [1] there is such
> possibility:
> 
> root@albatros:~# grep Cap /proc/$$/status
> CapInh: 0000000000000000
> CapPrm: fffffffc00001000
> CapEff: fffffffc00001000
> CapBnd: fffffffc00001000
> root@albatros:~# lsmod | grep xfs
> root@albatros:~# ifconfig xfs
> xfs: error fetching interface information: Device not found
> root@albatros:~# lsmod | grep xfs
> xfs                   767011  0 
> exportfs                4226  2 xfs,nfsd

Eek!

> Ability of CAP_NET_ADMIN to load the driver to work with a particular
> network device is rational;  however, one may load any module not even
> related to network this way.  Hopefully, this is not equal to
> CAP_SYS_MODULE since the module set is restricted to /lib/modules
> (additionally may be disabled with /proc/sys/kernel/modules_disabled),
> but the idea of non-netdev module loading is weird.
> 
> My proposal is changing request_module("%s", name) to something like
> request_module("netdev-%s", name) inside of dev_load() and adding
> aliases to related drivers.

AFAIK these interface-name aliases are usually defined by distribution
configuration files rather than within the modules themselves.  And that
behaviour is pretty much obsolete now that we have hotplug and udev.

> This would allow to load only netdev
> modules via these ioctls.  I'm not sure what modules should be patches -
> at least real physical netdevices have names different from drivers'
> names, so they don't need patching.  I suppose the list is not big.

The only modules I can see that declare aliases like this are:

net/ipv4/ip_gre.c:MODULE_ALIAS("gre0");
net/ipv4/ipip.c:MODULE_ALIAS("tunl0");
net/ipv6/sit.c:MODULE_ALIAS("sit0");

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

