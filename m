Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2LYIts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:49:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27369 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab2LYItq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:49:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,352,1355068800"; 
   d="scan'208";a="6470345"
Message-ID: <50D968C3.7000306@cn.fujitsu.com>
Date: Tue, 25 Dec 2012 16:50:11 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: canqun zhang <canqunzhang@gmail.com>
CC: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: kernel panic when running /etc/init.d/iptables restart
References: <CAFFEFTXxsPRf1Rmxyih0wL4O6q8G0OFmz0iRLX0tOYedYfajHw@mail.gmail.com> <50D93B43.8060303@cn.fujitsu.com> <CAFFEFTULzSysz+JCBC==VtKD8u1KO6EZnSdQ5XWM7um-zs9_pg@mail.gmail.com>
In-Reply-To: <CAFFEFTULzSysz+JCBC==VtKD8u1KO6EZnSdQ5XWM7um-zs9_pg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/25 16:49:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/25 16:49:35,
	Serialize complete at 2012/12/25 16:49:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/25 15:25, canqun zhang wrote:
> Hi Gao feng
> The stack information is as follows. The kenel will panic because the
> nf_ct_destroy is NULL.

Thanks!
It seems that nf_conntrack_l[3,4]proto_unregister doesn't make sure
nf_conns of the proto being destroyed.

If I'm right, there is another problem even your fix this panic problem.
the l3,14proto will be unregistered before all of it's nf_conns being destroyed.
So even nf_ct_destroy is not NULL,in destroy_conntrack we are not able to
find the right l4proto,the l4proto->destroy will be incorrect.resources will
not be released correctly.

So I think the root problem is we do register/unregister, set/unset both on the
first net (init_net), Maybe it's better to do register set on the first net, and
do unregister unset on the last net.
