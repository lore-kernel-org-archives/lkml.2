Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2LYKpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 05:45:44 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43199 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2LYKpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 05:45:42 -0500
MIME-Version: 1.0
In-Reply-To: <50D965F9.7090007@cn.fujitsu.com>
References: <CAFFEFTXxsPRf1Rmxyih0wL4O6q8G0OFmz0iRLX0tOYedYfajHw@mail.gmail.com>
	<50D93B43.8060303@cn.fujitsu.com>
	<CAFFEFTULzSysz+JCBC==VtKD8u1KO6EZnSdQ5XWM7um-zs9_pg@mail.gmail.com>
	<50D965F9.7090007@cn.fujitsu.com>
Date: Tue, 25 Dec 2012 18:45:41 +0800
Message-ID: <CAFFEFTWWNQ_NKw840mQ3gTfB9XR44EXb_=Ft4o+UoHwxv13VRg@mail.gmail.com>
Subject: Re: kernel panic when running /etc/init.d/iptables restart
From: canqun zhang <canqunzhang@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your suggestion,i will modify this patch and take tests.

2012/12/25 Gao feng <gaofeng@cn.fujitsu.com>:
> On 2012/12/25 15:25, canqun zhang wrote:
>> Hi Gao feng
>> The stack information is as follows. The kenel will panic because the
>> nf_ct_destroy is NULL.
>>
>> Reproduction:
>> (1) starting a lxc container
>> (2) iptables -t nat -A POSTROUTING -s 10.48.254.18 -o eth1 -j
>> MASQUERADE (run it on host machine)
>> (3) /etc/ini.d/iptables save (run it on host machine)
>> (4)/etc/init.d/iptables restart (run it on host machine)
>>
>
> Thanks!
> It seems that nf_conntrack_l[3,4]proto_unregister doesn't make sure
> nf_conns of the proto being destroyed.
>
> If I'm right, there is another problem even your fix this panic problem.
> the l3,14proto will be unregistered before all of it's nf_conns being destroyed.
> So even nf_ct_destroy is not NULL,in destroy_conntrack we are not able to
> find the right l4proto,the l4proto->destroy will be incorrect.resources will
> not be released correctly.
>
> So I think the root problem is we do register/unregister, set/unset both on the
> first net (init_net), Maybe it's better to do register set on the first net, and
> do unregister unset on the last net.
