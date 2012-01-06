Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521Ab2AFS0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:26:48 -0500
Received: from mx2.netapp.com ([216.240.18.37]:38775 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758967Ab2AFS0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:26:46 -0500
X-IronPort-AV: E=Sophos;i="4.71,469,1320652800"; 
   d="scan'208";a="614115398"
Message-ID: <1325874404.32470.6.camel@lade.trondhjem.org>
Subject: Re: Boot regression caused by commit 6829a048
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: chuck.lever@oracle.com, linux@razik.name,
        Pekka Enberg <penberg@kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jan 2012 13:26:44 -0500
In-Reply-To: <1325871176.4629.35.camel@lappy>
References: <1325871176.4629.35.camel@lappy>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jan 2012 18:26:45.0060 (UTC) FILETIME=[BE8C4840:01CCCCA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 19:32 +0200, Sasha Levin wrote: 
> Hi all,
> 
> I've noticed a boot regression caused by commit 6829a048 ("NFS: Retry
> mounting NFSROOT") which has increased boot time by 95 seconds.
> 
> The scenario is as follows:
>  - A virtual guest running under the KVM tool.
>  - Guest is using kernel automatic IP DHCP configuration ("ip=dhcp").
>  - Guest is booting from a 9p device (which is not detected as block,
> and gets mounted after NFS tries to do its mounts).
>  - No NFS server at all, no NFS parameters passed to the guest kernel.
> 
> Under this scenario, theres an additional 95 second delay before NFS
> fails and tries to boot using 9p:
> 
> [...]
> [    6.505269] md: autorun ...
> [    6.506954] md: ... autorun DONE.
> [  101.522716] VFS: Unable to mount root fs via NFS, trying floppy.
> [  101.534499] VFS: Mounted root (9p filesystem) on device 0:18.
> [...]

Can't you avoid the whole NFS root mount attempt by setting "root=2:0"
directly instead of relying on 'mount_root' to do it for you?

> This probably happens since the NFS server isn't configured, so the
> bootserver is automatically assumed to be the DHCP server, and with the
> commit above we won't simply fail immediately when the NFS code fails
> connecting to it.
> 
> I'm not quite sure about the correct solution for this. While I can
> forcefully disable NFS, is it really the right solution? Should we be
> retrying a NFS server even if one wasn't specifically set?

One option might be to check the 'root_wait' flag. We could also add
nfsroot support for the 'retry=' mount option.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

