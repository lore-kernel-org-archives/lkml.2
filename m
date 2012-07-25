Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2GYUHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:07:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37048 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GYUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:07:03 -0400
Message-ID: <501051DF.5040907@redhat.com>
Date: Wed, 25 Jul 2012 22:06:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, stefanha@linux.vnet.ibm.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com>
In-Reply-To: <50104614.3080002@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/07/2012 21:16, Boaz Harrosh ha scritto:
> The picture confused me. It looked like the first element is the virtio_scsi_cmd_req
> not an sgilist-element that points to the struct's buffer.
> 
> In that case then yes your plan of making a two-elements fragment that points to the
> original scsi-sglist is perfect. All you have to do is that, and all you have to do
> at virtio is use the sg_for_each macro and you are done.
> 
> You don't need any sglist allocation or reshaping. And you can easily support
> chaining. Looks like order of magnitude more simple then what you do now

It is.

> So what is the problem?

That not all architectures have ARCH_HAS_SG_CHAIN (though all those I
care about do).  So I need to go through all architectures and make sure
they use for_each_sg, or at least to change ARCH_HAS_SG_CHAIN to a
Kconfig define so that dependencies can be expressed properly.

> And BTW you won't need that new __sg_set_page API anymore.

Kind of.

   sg_init_table(sg, 2);
   sg_set_buf(sg[0], req, sizeof(req));
   sg_chain(sg[1], scsi_out(sc));

is still a little bit worse than

   __sg_set_buf(sg[0], req, sizeof(req));
   __sg_chain(sg[1], scsi_out(sc));

Paolo
