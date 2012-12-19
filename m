Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2LSJT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:19:57 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52059 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2LSJTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:19:53 -0500
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 04:19:52 EST
Message-ID: <50D1806B.7030603@redhat.com>
Date: Wed, 19 Dec 2012 09:52:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        stefanha@redhat.com, nab@linux-iscsi.org
Subject: Re: [PATCH v2 0/5] Multiqueue virtio-scsi, and API for piecewise
 buffer submission
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <96853954.7ghLePd55F@donald.sf-tec.de>
In-Reply-To: <96853954.7ghLePd55F@donald.sf-tec.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/12/2012 23:18, Rolf Eike Beer ha scritto:
> Paolo Bonzini wrote:
>> Hi all,
>>
>> this series adds multiqueue support to the virtio-scsi driver, based
>> on Jason Wang's work on virtio-net.  It uses a simple queue steering
>> algorithm that expects one queue per CPU.  LUNs in the same target always
>> use the same queue (so that commands are not reordered); queue switching
>> occurs when the request being queued is the only one for the target.
>> Also based on Jason's patches, the virtqueue affinity is set so that
>> each CPU is associated to one virtqueue.
>>
>> I tested the patches with fio, using up to 32 virtio-scsi disks backed
>> by tmpfs on the host.  These numbers are with 1 LUN per target.
>>
>> FIO configuration
>> -----------------
>> [global]
>> rw=read
>> bsrange=4k-64k
>> ioengine=libaio
>> direct=1
>> iodepth=4
>> loops=20
>>
>> overall bandwidth (MB/s)
>> ------------------------
>>
>> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
>> 1                  540               626                     599
>> 2                  795               965                     925
>> 4                  997              1376                    1500
>> 8                 1136              2130                    2060
>> 16                1440              2269                    2474
>> 24                1408              2179                    2436
>> 32                1515              1978                    2319
>>
>> (These numbers for single-queue are with 4 VCPUs, but the impact of adding
>> more VCPUs is very limited).
>>
>> avg bandwidth per LUN (MB/s)
>> ----------------------------
>>
>> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
>> 1                  540               626                     599
>> 2                  397               482                     462
>> 4                  249               344                     375
>> 8                  142               266                     257
>> 16                  90               141                     154
>> 24                  58                90                     101
>> 32                  47                61                      72
> 
> Is there an explanation why 8x8 is slower then 4x8 in both cases?

Regarding the "in both cases" part, it's because the second table has
the same data as the first, but divided by the first column.

In general, the "strangenesses" you find are probably within statistical
noise or due to other effects such as host CPU utilization or contention
on the big QEMU lock.

Paolo


 8x1 and 8x2
> being slower than 4x1 and 4x2 is more or less expected, but 8x8 loses against 
> 4x8 while 8x4 wins against 4x4 and 8x16 against 4x16.
> 
> Eike
> 

