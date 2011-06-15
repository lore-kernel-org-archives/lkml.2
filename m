Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1FOOF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1FOOF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:05:57 -0400
Message-ID: <4DF8BC42.4050508@redhat.com>
Date: Wed, 15 Jun 2011 10:05:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: netconsole regression w/ 8d8fc29d
References: <4DF8660A.8020800@redhat.com> <4DF868DE.9000402@redhat.com>
In-Reply-To: <4DF868DE.9000402@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 04:10 AM, Cong Wang wrote:
> 于 2011年06月15日 15:58, Rik van Riel 写道:
>> After commit 8d8fc29d02a33e4bd5f4fa47823c1fd386346093
>> (netpoll: disable netpoll when enslave a device), it is
>> no longer possible to use netconsole together with bridged
>> KVM guests.
>>
>> I can see why the change looked reasonable from a networking
>> point of view, but this has completely disabled netconsole
>> functionality for a common KVM use case.
>>
>> After the change, netconsole refuses to bind to eth0.
>>
>> Since the bridge interface does not support polling,
>> netconsole cannot use that, either.
>
>
> Bridge does support polling now. :) You can just setup
> netconsole on a bridge device.

This turns out to be mutually exclusive with attaching
virtual interfaces (for KVM guests) to a bridge.

If I start netconsole first, my KVM guests won't start.

If I start the KVM guests first, netconsole won't start,
and fails with these errors:

netconsole:: inserting netconsole module with arguments 
netconsole=6666@74.92.59.68/br0,514@74.92.59.66/00:13:72:17:4A:9C
kernel: [ 1020.927240] netconsole: local port 6666
kernel: [ 1020.927243] netconsole: local IP 74.92.59.68
kernel: [ 1020.927245] netconsole: interface 'br0'
kernel: [ 1020.927246] netconsole: remote port 514
kernel: [ 1020.927247] netconsole: remote IP 74.92.59.66
kernel: [ 1020.927252] netconsole: remote ethernet address 00:13:72:17:4a:9c
kernel: [ 1020.927256] (null):  doesn't support polling, aborting.
kernel: [ 1020.927258] netconsole: cleaning up
systemd[1]: netconsole.service: control process exited, code=exited status=1
systemd[1]: Unit netconsole.service entered failed state.

In short, I am still not able to use netconsole and bridged
KVM guests at the same time...

# brctl show
bridge name	bridge id		STP enabled	interfaces
br0		8000.0024e838995c	no		eth0
							vnet0
							vnet1
							vnet2


-- 
All rights reversed
