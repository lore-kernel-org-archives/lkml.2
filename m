Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2HFMiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab2HFMiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:38:04 -0400
Message-ID: <501FBAA2.6050205@redhat.com>
Date: Mon, 06 Aug 2012 15:37:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag> <5018F7E6.4020909@redhat.com> <5018F9F6.70307@profihost.ag> <5018FC9B.8040808@redhat.com> <501E4615.7060801@profihost.ag> <501E4AFD.3020806@redhat.com> <501E96BB.5060702@profihost.ag> <501EC2E2.8010802@profihost.ag> <501F8226.9090500@redhat.com> <501F846C.50903@profihost.ag> <501FB4A8.6080609@redhat.com>
In-Reply-To: <501FB4A8.6080609@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 03:12 PM, Avi Kivity wrote:
> On 08/06/2012 11:46 AM, Stefan Priebe - Profihost AG wrote:
> 
>> But still i got the segfault and core dump - this is my main problem? I
>> mean qemu-kvm master isn't declared as stable. So i don't care about the
>> slowness here.
>> 
>> What can we do about the core dump and crash?
> 
> Okay, I reproduced it; it seems aio=native is the culprit.  You can try
> aio=threads as a workaround.
> 
> Copying some relevant people (context: aio=native on qemu-kvm-1.1.1
> segfaults pretty early during guest install)
> 

The following ought to fix it:


From: Avi Kivity <avi@redhat.com>
Date: Mon, 6 Aug 2012 15:35:02 +0300
Subject: [PATCH] virtio-mlk: fix use-after-free while handling scsi commands

The scsi passthrough handler falls through after completing a
request into the failure path, resulting in a use after free.

Reprducible by running a guest with aio=native on a block device.

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Avi Kivity <avi@redhat.com>

diff --git a/hw/virtio-blk.c b/hw/virtio-blk.c
index f21757e..552b3b6 100644
--- a/hw/virtio-blk.c
+++ b/hw/virtio-blk.c
@@ -254,6 +254,7 @@ static void virtio_blk_handle_scsi(VirtIOBlockReq *req)
 
     virtio_blk_req_complete(req, status);
     g_free(req);
+    return;
 #else
     abort();
 #endif


-- 
error compiling committee.c: too many arguments to function
