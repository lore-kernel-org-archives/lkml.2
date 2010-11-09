Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0KIUd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:33:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64825 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0KIUdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ufa3SjkCJn+p8lBI3g1FfvNTJUK4PXNkWwwkJ1HZikd3hoiTNwPJ8V2sFFAyOzQ/yM
         8A2iYI11aXcJ2sSK2sh3+q6e6NWAbPdXFHfnZthMMLM4dFnPW+pVG2QokjIDnTFmwlCs
         BhOYtJ7PLSKi378vAkJcWwO/EWeJgcCih6Gps=
Date: Tue, 9 Nov 2010 23:33:18 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, jon.maloy@ericsson.com,
        allan.stephens@windriver.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: tipc: fix information leak to userland
Message-ID: <20101109203317.GA24933@albatros>
References: <1288545032-16481-1-git-send-email-segooon@gmail.com>
 <20101109.092630.260076036.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109.092630.260076036.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:26 -0800, David Miller wrote:
> From: Vasiliy Kulikov <segooon@gmail.com>
> Date: Sun, 31 Oct 2010 20:10:32 +0300
> 
> > Structure sockaddr_tipc is copied to userland with padding bytes after
> > "id" field in union field "name" unitialized.  It leads to leaking of
> > contents of kernel stack memory.  We have to initialize them to zero.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> 
> Applied.
> 
> Patches #1 and #2 were given feedback which I need you to integrate
> and submit new patches based upon, thanks.

About #2:

I still think that this:

    if (dev)
        strncpy(uaddr->sa_data, dev->name, 14);
    else
        memset(uaddr->sa_data, 0, 14);

is better than this:

    memset(uaddr->sa_data, 0, 14);
    dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
    if (dev)
        strlcpy(uaddr->sa_data, dev->name, 15);

Doesn't it?  Explicitly filling with zero on the same "if" level is
slightly easier to read and understand.

-- 
Vasiliy
