Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1BXPMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:12:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33290 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1BXPMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:12:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ImO9p6NChzTWP0tMOVhqX41pU8u5FVekZgSBHxNv+mi3+vWT0n4O+IW16fQaD6V9+u
         dCTdv+N15L933zIbizrWMTC0JpUD/wE2vwENopAsZUGmjRevwqgZbu4rH3OLgXUgEhK1
         rY7cM88Ddu0dSEVcvKHQ4OqBljZRG+1vngI2I=
Date: Thu, 24 Feb 2011 18:12:38 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugene@redhat.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: module loading with CAP_NET_ADMIN
Message-ID: <20110224151238.GA16916@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi netdev folks,

I'd like to discuss the ability to load any modules from /lib/modules/
by a process with CAP_NET_ADMIN.  Since Linux 2.6.32 [1] there is such
possibility:

root@albatros:~# grep Cap /proc/$$/status
CapInh: 0000000000000000
CapPrm: fffffffc00001000
CapEff: fffffffc00001000
CapBnd: fffffffc00001000
root@albatros:~# lsmod | grep xfs
root@albatros:~# ifconfig xfs
xfs: error fetching interface information: Device not found
root@albatros:~# lsmod | grep xfs
xfs                   767011  0 
exportfs                4226  2 xfs,nfsd

Ability of CAP_NET_ADMIN to load the driver to work with a particular
network device is rational;  however, one may load any module not even
related to network this way.  Hopefully, this is not equal to
CAP_SYS_MODULE since the module set is restricted to /lib/modules
(additionally may be disabled with /proc/sys/kernel/modules_disabled),
but the idea of non-netdev module loading is weird.

My proposal is changing request_module("%s", name) to something like
request_module("netdev-%s", name) inside of dev_load() and adding
aliases to related drivers.  This would allow to load only netdev
modules via these ioctls.  I'm not sure what modules should be patches -
at least real physical netdevices have names different from drivers'
names, so they don't need patching.  I suppose the list is not big.

Any comments are welcome.


[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a8f80e8ff94ecba629542d9b4b5f5a8ee3eb565c


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
