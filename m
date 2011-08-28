Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1H1MfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 08:35:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35267 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1H1MfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 08:35:17 -0400
Message-ID: <4E5A35CB.7060005@gentoo.org>
Date: Sun, 28 Aug 2011 15:34:19 +0300
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/19] 2.6.32.46-longterm review
References: <20110826220137.GA14059@kroah.com>
In-Reply-To: <20110826220137.GA14059@kroah.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2011 01:01 AM, Greg KH wrote:
> This is the start of the longterm review cycle for the 2.6.32.46 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>
> Responses should be made by Monday, August 29, 2011, 12:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.46-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Hi,

upstream commit d5aa407f59f5b83d2c50ec88f5bf56d40f1f8978 ("tunnels: fix
netns vs proto registration ordering") , which was included in
2.6.32.44-longterm, was not backported correctly, and results in a NULL
pointer dereference in ip6_tunnel.c for longterm kernels 2.6.32.44 and
2.6.32.45.

The bug has been reported at the Gentoo [1] and Debian [2] bugzillas,
and fixed in the latest grsec-patches [3], but I haven't found a report
for this at the lkml (or at the kernel's bugzilla).

The fix is trivial, and I think it can be included in 2.6.32.46, if
possible.
If you want, I can submit it with a new email to stable@kernel.org.

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 7fb3e02..53e0d51 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1466,7 +1466,7 @@ static int __init ip6_tunnel_init(void)
 {
        int  err;
 
-       err = register_pernet_device(&ip6_tnl_net_ops);
+       err = register_pernet_gen_device(&ip6_tnl_net_id, &ip6_tnl_net_ops);
        if (err < 0)
                goto out_pernet;

Btw, this has been fixed in grsec-patches, and an identical patch has
also been posted at the Debian bugzilla, so I'm not sure about the
Signed-off-by and Reported-by tags.

[1] https://bugs.gentoo.org/show_bug.cgi?id=380609
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=633738
[3] http://grsecurity.net/changelog-stable.txt

-- 
Stratos Psomadakis
<psomas@gentoo.org>

