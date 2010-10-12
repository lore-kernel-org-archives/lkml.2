Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0JLTBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:01:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab0JLTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:01:32 -0400
Message-ID: <4CB4B06A.5090809@vlnb.net>
Date: Tue, 12 Oct 2010 23:00:58 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] tcm: Unify virtual subsystem plugin emulation code
References: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org> <20101010073202.GA16772@lst.de>
In-Reply-To: <20101010073202.GA16772@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Ch5oREMSMDL9qZRRi8JftB163FXrbR10Tx6kG5GsigW
 KOORkXVIH//NrEQlDGGmyiYXgqTAhpRqngqrObEcRdsoxspS5g
 xm98Hk1S69FBc7EZ72lHfUG5Yf2tz+k2f9oVd11BgBFu2GfXzj
 lLu3rWYNE0VypwuPp0VtM+c3rJamD+OPPChJy3Waixko6jPY8D
 nsg7f1dNX45rQCneBuUsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig, on 10/10/2010 11:32 AM wrote:
> What you did in this patch is a good step toward getting rid of the
> scsi logic in the backend, but it's quite enough yet.  For one thing
> the backends really shouldn't know anything about scsi commands, so
> the call to transport_emulate_control_cdb should happen before even
> calling into the backend.  Second your ->emulate_foo callbacks still
> are far too SCSI-specific, e.g. WRITE SAME witht unmap bit and UNMAP
> emulation really should just go into a single ->discard callback
> for the backend.  And instead of calling into the backend again for
> readcap emulation just set block_size and size attributs on a per-
> device object and let common code handle it.  Similarly for inquity
> just set the device type and other variables and handle it in common
> code.  That avoid the special se_subsystem_api_cdb vector and simplifies
> the code a lot conceptually a lot. Together with calling
> transport_emulate_control_cdb directly from core code before going
> into ->do_task that does all the required work to make the backends
> independent of the scsi protocol, so we could also use it e.g.
> for ATA or virtio targets.

I strongly disagree with this approach to allow non-SCSI transports to
use facilities provided by a generic (SCSI) target subsystem. This
approach is bad, because you enforce the SCSI target subsystem to
implement in its interface "the least common denominator" of all
services non-SCSI transports can requests, which leads to:

1. The SCSI target subsystem code overcomplication, so making it much
harder to audit and more buggy.

2. You creates hidden inter-transport dependencies inside of the target
subsystem, so by fixing services for one transport you can break another.

3. By introducing additional processing to hide SCSI internals you hurt
performance, especially for the mainline SCSI case.

Moreover, my experience tells me that fully hiding SCSI internals of the
target subsystem is hardly feasible at all.

There is another, much better approach to allow non-SCSI transports to
use facilities provided by the SCSI target subsystem: leave the generic
target subsystem fully SCSI-centric and create for each non-SCSI
transport a helper library which would allow to translate its requests
to the corresponding SCSI requests and SCSI sense to their error codes.

All non-SCSI transports I know, including ATA, are, basically, subsets
of SCSI facilities, so translation of their requests to the
corresponding SCSI commands would be a straightforward task. For
instance, discard would be translated to SCSI UNMAP.

This approach would bring:

1. Clear, easy auditable target subsystem's code.

2. Clear separation of SCSI and non-SCSI processing among different SCSI
and non-SCSI target drivers.

3. The best performance in all cases.

Vlad



