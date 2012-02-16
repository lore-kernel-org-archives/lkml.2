Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2BPPb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:31:28 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:37060 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751204Ab2BPPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:31:27 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JWVGAaQVM1kt_kXpZFy46yhdTF_pUm32Z7v5haUxieDvLV1
 WQUX18b4HrZSwC8JqE2JOKkivTM_6OlmYlDpsSuzuF..klK86trGA_4PQZj8
 FLAGssRgmWljorCw5e89U1sa880AW0KWvMIzgCYx.nXd7cmlHi7eTcdCBma8
 Lb87gc11WyCnJ0LQdCZfVZFsT98mVu7Hyz_DkfTB0imkdsmmBBr2.tDVzNW_
 rlDNg4VjmPl6Ofa9_tLDYAT5okqLiTN5eQlaTgrSRUtUMQqlL2GJmkMry5A1
 TH2WsjLQ5ZiwD54fc70eASV.uGl5XiIQiyj7i8WUKZruTPJWoSJ7.5v4xcPV
 W8pW6w5e7MNEQvwEZnFyBVozpHqXv0FriOL17aUflB3mHsngejBF_jDzvwiQ
 g
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 16 Feb 2012 08:51:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <E307A48D-2146-4052-8A84-E7FA690A6703@gmail.com>
Message-ID: <alpine.DEB.2.00.1202160845320.25847@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home>
 <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home>
 <20120214124518.f42bc03e.akpm@linux-foundation.org> <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com> <alpine.DEB.2.00.1202141605240.32407
 @router.home> <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com> <alpine.DEB.2.00.1202151324060.28225@router.home> <E307A48D-2146-4052-8A84-E7FA690A6703@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Xi Wang wrote:

> On Feb 15, 2012, at 2:34 PM, Christoph Lameter wrote:
> > Any allocation larger than MAX_ORDER << PAGE_SHIFT will fail since the
> > page allocator cannot serve larger contigous pages.
>
> Yes, any number larger than KMALLOC_MAX_SIZE would do the trick.
> The question is whether people would like to adopt
>
> kmalloc(ARRAY_BYTES(n, size), ...);

Well it would be f.e.

	kmalloc_node(calculate_array_size(sizeof(struct bla), n), GFP_KERNEL, my_numa_node)

	or

	vmalloc(calculate_array_size(sizeof(struct blu), n));

Then there is

vzalloc
kzalloc
vmalloc_32
alloc_bootmem (MAXORDER limit may not work)
alloc_remap

...

This would also work for special subsystem allocations like

usb_alloc_coherent
dm_vcalloc
devres_alloc

....


The use of a function or macro makes the overflow check much more
universal and allows these array allocations to occur with different
allocation functions throughout the kernel.

Please do not increase the number of allocation functions needlessly with
new variants.

