Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2JKBKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:10:45 -0400
Received: from ozlabs.org ([203.10.76.45]:46465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2JKBKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:10:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, avi@redhat.com
Subject: Re: [PATCH 0/3] virtio-net: inline header support
In-Reply-To: <5073D1D8.3060905@redhat.com>
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au> <506C192E.5060700@redhat.com> <87bogj2j1b.fsf@rustcorp.com.au> <506D3610.7000103@redhat.com> <87ipaq1jtt.fsf@rustcorp.com.au> <506D8DD5.20904@redhat.com> <87391t1nkq.fsf__40391.6521034718$1349505001$gmane$org@rustcorp.com.au> <507029EB.2050405@redhat.com> <878vbg8cma.fsf@rustcorp.com.au> <5073D1D8.3060905@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 11 Oct 2012 10:33:31 +1030
Message-ID: <87k3ux98oc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> Il 09/10/2012 06:59, Rusty Russell ha scritto:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>> Il 05/10/2012 07:43, Rusty Russell ha scritto:
>>>> That's good.  But virtio_blk's scsi command is insoluble AFAICT.  As I
>>>> said to Anthony, the best rules are "always" and "never", so I'd really
>>>> rather not have to grandfather that in.
>>>
>>> It is, but we can add a rule that if the (transport) flag
>>> VIRTIO_RING_F_ANY_HEADER_SG is set, the cdb field is always 32 bytes in
>>> virtio-blk.
>> 
>> Could we do that?  It's the cmd length I'm concerned about; is it always
>> 32 in practice for some reason?
>
> It is always 32 or less except in very obscure cases that are pretty
> much confined to iSCSI.  We don't care about the obscure cases, and the
> extra bytes don't hurt.
>
> BTW, 32 is the default cdb_size used by virtio-scsi.
>
>> Currently qemu does:
>> 
>>     struct sg_io_hdr hdr;
>>     memset(&hdr, 0, sizeof(struct sg_io_hdr));
>>     hdr.interface_id = 'S';
>>     hdr.cmd_len = req->elem.out_sg[1].iov_len;
>>     hdr.cmdp = req->elem.out_sg[1].iov_base;
>>     hdr.dxfer_len = 0;
>> 
>> If it's a command which expects more output data, there's no way to
>> guess where the boundary is between that command and the data.
>
> Yep, so I understood the problem right.

OK.  Well, Anthony wants qemu to be robust in this regard, so I am
tempted to rework all the qemu drivers to handle arbitrary layouts.
They could use a good audit anyway.

This would become a glaring exception, but I'm tempted to fix it to 32
bytes at the same time as we get the new pci layout (ie. for the virtio
1.0 spec).  The Linux driver would carefully be backwards compatible, of
course, and the spec would document why.

Cheers,
Rusty.

