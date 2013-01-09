Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3AITN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:13:29 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44834 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3AITN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:13:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOON0PcrqtXKBxK48uQvmRvEKkmhfPHC4F_6HmWvHKN6Qbw@mail.gmail.com>
References: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
	<87txqruq8p.fsf@xmission.com>
	<CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
	<CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
	<20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<CAKocOON0PcrqtXKBxK48uQvmRvEKkmhfPHC4F_6HmWvHKN6Qbw@mail.gmail.com>
Date: Wed, 9 Jan 2013 11:13:26 -0800
X-Google-Sender-Auth: DEiCA9Zlg1OnYFqNVwE6yuw5m-A
Message-ID: <CAE9FiQVo_RismQPa_js6NEbhMAAgREUkrzKJtkig8p9GxhZUVQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 10:01 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> After several revisions, I am loosing track. Could you please write a
> change log and explain the change to the existing behavior. If you
> could addresses the following areas, it will be easier figure if we
> are missing something (if any):
>
> 1. What happens when switolb is forced with iommu=soft on a system
> with and without not enough low mem?

panic later when device try to map_single with it.
instead of panic early during swiotlb allocation.

> 2. What happens when swiotlb is not forced, but iommu driver sets
> swiotlb=1 after it gets done with its iommu initialization on a system
> with and without enough low mem.

panic later when device try to map_single with it.
instead of panic early during swiotlb allocation.

> 3. What happens when nopanic is used and when will the system fail?
> Will it fail when driver runs into errors. I am hoping this won't be a
> silent failure. Please see more on this below:

according to eric/konrad, I make all use nopanic path,
and only mips, and x86-xen still panic early when
swiotlb_init_with_tab is called
directly.

hope mips, and x86-xen guys could convert to calling swiotlb_init instead.

>
> I did dma mapping error analysis a few months ago and found several
> drivers that don't check dma mapping errors, don't unmap dma buffers
> etc. Returning mapping error from switolb could cause problems when we
> have drivers that don't check mapping errors. These drivers might not
> fail cleanly either and could cause data corruption.

Now, we are using panic with them, later after those drivers get fixed, we
can change to returning MAP_ERROR instead.

>
> Here is a link to the dma mapping error analysis I did:
>
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

good, looks like need one generic way to fix the problem, like another wrapper?

Thanks

Yinghai
