Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2HRWbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:31:11 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:50419 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2HRWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:31:08 -0400
Subject: Re: [GIT PULL] tcm_vhost: Initial merge of vhost level target
 fabric driver
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Zhi Yong Wu <wuzhy@cn.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20120818200432.GA26215@redhat.com>
References: <1343697577.22538.661.camel@haakon2.linux-iscsi.org>
	 <20120818200432.GA26215@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Aug 2012 15:31:05 -0700
Message-ID: <1345329065.25161.364.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 23:04 +0300, Michael S. Tsirkin wrote:
> Hi Nicholas,
> I just noticed this problem in the interface:
> 
> +#include <linux/vhost.h>
> +
> +/*
> + * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
> + *
> + * ABI Rev 0: July 2012 version starting point for v3.6-rc merge
> candidate +
> + *            RFC-v2 vhost-scsi userspace.  Add GET_ABI_VERSION ioctl
> usage
> + */
> +
> +#define VHOST_SCSI_ABI_VERSION 0
> +
> +struct vhost_scsi_target {
> +       int abi_version;
> +       unsigned char vhost_wwpn[TRANSPORT_IQN_LEN];
> +       unsigned short vhost_tpgt;
> +};
> +
> 
> Here TRANSPORT_IQN_LEN is 224, which is a multiple of 4.
> Since vhost_tpgt is 2 bytes and abi_version is 4, the total size would
> be 230.  But gcc needs struct size be aligned to first field size, which
> is 4 bytes, so it pads the structure by extra 2 bytes to the total of
> 232.
> 
> This padding is very undesirable in an ABI:
> - it can not be initialized easily
> - it can not be checked easily
> - it can leak information between kernel and userspace
> 

Hmmmm, yes.  Very good reasons to avoid ABI ambiguity  ..

> Simplest solution is probably just to make the padding
> explicit:
> 
> +struct vhost_scsi_target {
> +       int abi_version;
> +       unsigned char vhost_wwpn[TRANSPORT_IQN_LEN];
> +       unsigned short vhost_tpgt;
> +       unsigned short reserved;
> +};
> +
> 
> I think we should fix this buglet before it goes out to users.
> 

<nod>, fixing this up in target-pending/master now w/ your reported-by
+signoff, and will change vhost-scsi's copy of these defs for next
week's RFC-v3 posting.

Thanks MST!

--nab

