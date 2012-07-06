Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2GFGrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2GFGrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:47:52 -0400
Message-ID: <4FF68A0B.8000402@redhat.com>
Date: Fri, 06 Jul 2012 08:47:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <1341513550.5508.7.camel@badari-desktop>
In-Reply-To: <1341513550.5508.7.camel@badari-desktop>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/07/2012 20:39, Badari Pulavarty ha scritto:
> On Tue, 2012-07-03 at 15:19 +0200, Paolo Bonzini wrote:
>> This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
>> which exposes the cache mode in the configuration space and lets the
>> driver modify it.  The cache mode is exposed via sysfs.
>>
>> Even if the host does not support the new feature, the cache mode is
>> visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> Hi Paolo,
> 
> Curious - What is the host side change to support this ? QEMU would
> close and re-open the device/file with the corresponding flags
> (O_SYNC) ?

QEMU is not using O_SYNC anymore; instead, it manually issues a flush
after each write.  We found this didn't penalize performance (in fact,
for qcow2 metadata writes the fdatasyncs will be more coarse and there
is a small improvement).  So, when you toggle writethrough to writeback
QEMU simply has to stop forcing flushes, and vice versa if you go to
writethrough.

> And also, is there a way to expose cache=none (O_DIRECT) to the guest ?

Not yet.  The main problem is that while we can invent something in
virtio-blk, I'm not sure if there is an equivalent in SCSI for example.

Paolo
