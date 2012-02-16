Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2BPDLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:11:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51627 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2BPDLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:11:05 -0500
Subject: Re: Uninline kcalloc
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1202151324060.28225@router.home>
Date: Wed, 15 Feb 2012 22:10:59 -0500
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E307A48D-2146-4052-8A84-E7FA690A6703@gmail.com>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com> <alpine.DEB.2.00.1202141605240.32407 @router.home> <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com> <alpine.DEB.2.00.1202151324060.28225@router.home>
To: Christoph Lameter <cl@linux.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15, 2012, at 2:34 PM, Christoph Lameter wrote:
> Any allocation larger than MAX_ORDER << PAGE_SHIFT will fail since the
> page allocator cannot serve larger contigous pages.

Yes, any number larger than KMALLOC_MAX_SIZE would do the trick.
The question is whether people would like to adopt

kmalloc(ARRAY_BYTES(n, size), ...);

or

knalloc(n, size, ...);

Besides, I am worried that ARRAY_BYTES is error-prone because you
have to make sure that ARRAY_BYTES is used only in *alloc, not
elsewhere, not in forms like ARRAY_BYTES(n, size) + padding_size,
etc.  If ARRAY_BYTES is mostly used with kmalloc(), and the only
safe form is kmalloc(ARRAY_BYTES(n, size), ...), then adding a new
allocator knalloc(n, size, ...) seems like a simpler choice.

BTW, here goes a partial list of places where the new allocator
could be used to simplify existing checks.

fs/cifs/cifsacl.c:912

        if (num_aces > ULONG_MAX / sizeof(struct cifs_ace *))
                return;                 
        ppace = kmalloc(num_aces * sizeof(struct cifs_ace *),
                        GFP_KERNEL);

fs/cifs/asn1.c:428

        if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
                return 0;

        *oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);

fs/nfs/callback_xdr.c:308

        if (n > ULONG_MAX / sizeof(*args->devs)) {
                status = htonl(NFS4ERR_BADXDR);
                goto out;               
        }

        args->devs = kmalloc(n * sizeof(*args->devs), GFP_KERNEL);

net/ipv4/netfilter/nf_nat_snmp_basic.c:447

        if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
                return 0;               

        *oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);

drivers/staging/comedi/comedi_fops.c:673

        insns =
            kcalloc(insnlist.n_insns, sizeof(struct comedi_insn), GFP_KERNEL);

I believe there are more places without those checks, where the new
allocator can offer better security.

- xi

