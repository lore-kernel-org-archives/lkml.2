Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0KIDbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:31:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54974 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab0KIDbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vNnJfUCXfTLGOQH2iZfuLteJBqJCDwtr08LayG2fjk5ebc04QJ4eNVGW7MArAHgKF0
         X1+N4NdXHG1u3xmmbV9kn8fAnKbe8W6dYBaUSVwgAVD0UTs+Y4eu114xEesl5ywrgWW7
         qRpepRRHcPJKpJfEFpSyZKScV4CQoEzgW2n2w=
Date: Tue, 9 Nov 2010 11:30:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Message-ID: <20101109033024.GA5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 12:32:47PM -0800, Mike Waychison wrote:
>As preparation for moving netpoll_targets out of netconsole and making
>them available to other clients, introduce new Kconfig options.
>
>CONFIG_NETPOLL_TARGETS
>
>Access to targets APIs.  Only supports parameter based parsing of
>targets (via the kernel command line or module paramters).
>
>CONFIG_NETPOLL_TARGETS_DYNAMIC
>
>Extends the support that netpoll_targets provides by allowing for the
>dynamic creation of targets in configfs on a per client basis.
>
>Signed-off-by: Mike Waychison <mikew@google.com>
>---
> drivers/net/Kconfig      |   16 +++++++++++++---
> drivers/net/netconsole.c |   10 +++++-----
> 2 files changed, 18 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>index f6668cd..b014cd6 100644
>--- a/drivers/net/Kconfig
>+++ b/drivers/net/Kconfig
>@@ -3367,14 +3367,15 @@ config NET_FC
> 
> config NETCONSOLE
> 	tristate "Network console logging support"
>+	select NETPOLL_TARGETS
> 	---help---
> 	If you want to log kernel messages over the network, enable this.
> 	See <file:Documentation/networking/netconsole.txt> for details.
> 
> config NETCONSOLE_DYNAMIC
> 	bool "Dynamic reconfiguration of logging targets"
>-	depends on NETCONSOLE && SYSFS
>-	select CONFIGFS_FS
>+	depends on NETCONSOLE
>+	select NETPOLL_TARGETS_DYNAMIC
> 	help
> 	  This option enables the ability to dynamically reconfigure target
> 	  parameters (interface, IP addresses, port numbers, MAC addresses)
>@@ -3382,7 +3383,16 @@ config NETCONSOLE_DYNAMIC
> 	  See <file:Documentation/networking/netconsole.txt> for details.
> 
> config NETPOLL
>-	def_bool NETCONSOLE
>+	def_bool false
>+
>+config NETPOLL_TARGETS
>+	bool
>+	select NETPOLL
>+
>+config NETPOLL_TARGETS_DYNAMIC
>+	bool
>+	select CONFIGFS_FS
>+	select NETPOLL_TARGETS
> 

Hey, have you tried CONFIG_CONFIGFS_FS=m? :)

Actually, I tried almost the same thing, but finally failed due to
CONFIG_CONFIGFS_FS=m. NETPOLL can't be a module, and configfs can be,
thus you can't use the API provided by configfs.

So, either we need to de-modulize configfs or replace configfs API
with sysfs API. Personally, I prefer the former one, I don't think
configfs should be a module as long as it can provide API's
for other subsystems, like debugfs.

Thanks.
