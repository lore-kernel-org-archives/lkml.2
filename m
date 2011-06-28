Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab1F1Qxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:53:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51017 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759044Ab1F1Qvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:51:45 -0400
Subject: Re: [PATCH V7 2/4 net-next] skbuff: Add userspace zero-copy
 buffers in skb
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, eric.dumazet@gmail.com, avi@redhat.com, arnd@arndb.de,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110627.155426.51839633424542723.davem@davemloft.net>
References: <1306610588.5180.87.camel@localhost.localdomain>
	 <1309189510.21764.1.camel@localhost.localdomain>
	 <20110627.155426.51839633424542723.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 09:51:32 -0700
Message-ID: <1309279892.3559.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 15:54 -0700, David Miller wrote:
> From: Shirley Ma <mashirle@us.ibm.com>
> Date: Mon, 27 Jun 2011 08:45:10 -0700
> 
> > To support skb zero-copy, a pointer is needed to add to skb share
> info.
> > Do you agree with this approach? If not, do you have any other
> > suggestions?
> 
> I really can't form an opinion unless I am shown the complete
> implementation, what this give us in return, what the impact is, etc. 

zero-copy skb buffers can save significant CPUs. Right now, I only
implements macvtap/vhost zero-copy between KVM guest and host. The
performance is as follow:

Single TCP_STREAM 120 secs test results 2.6.39-rc3 over ixgbe 10Gb NIC
results:

Message BW(Gb/s)qemu-kvm (NumCPU)vhost-net(NumCPU) PerfTop irq/s
4K      7408.57         92.1%           22.6%           1229
4K(Orig)4913.17         118.1%          84.1%           2086    

8K      9129.90         89.3%           23.3%           1141
8K(Orig)7094.55         115.9%          84.7%           2157

16K     9178.81         89.1%           23.3%           1139
16K(Orig)8927.1         118.7%          83.4%           2262

64K     9171.43         88.4%           24.9%           1253
64K(Orig)9085.85        115.9%          82.4%           2229

You can see the overall CPU saved 50% w/i zero-copy.

The impact is every skb allocation consumed one more pointer in skb
share info, and a pointer check in skb release when last reference is
gone.

For skb clone, skb expand private head and skb copy, it still keeps copy
the buffers to kernel, so we can avoid user application, like tcpdump to
hold the user-space buffers too long.

Thanks
Shirley

