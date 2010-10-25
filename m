Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0JYH0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:26:46 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51955 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0JYH0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:26:44 -0400
Date: Mon, 25 Oct 2010 16:27:34 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Gleb Natapov <gleb@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
Message-Id: <20101025162734.fdc02309.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20101025012124.GA31262@redhat.com>
References: <20101025012124.GA31262@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 03:21:24 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> I have observed the following bug trigger:
> 
> 1. userspace calls GET_DIRTY_LOG
> 2. kvm_mmu_slot_remove_write_access is called and makes a page ro
> 3. page fault happens and makes the page writeable
>    fault is logged in the bitmap appropriately

This may be the reason why my commit is a corruption magnifier.
My patch moved the vmalloc() right after
kvm_mmu_slot_remove_write_access() and made this chance bigger:
because vmalloc() takes some time.

  Thanks,
    Takuya


> 4. kvm_vm_ioctl_get_dirty_log swaps slot pointers
> 
> a lot of time passes
> 
> 5. guest writes into the page
> 6. userspace calls GET_DIRTY_LOG
> 
> At point (5), bitmap is clean and page is writeable,
> thus, guest modification of memory is not logged
> and GET_DIRTY_LOG returns an empty bitmap.
> 
> The rule is that all pages are either dirty in the current bitmap,
> or write-protected, which is violated here.
