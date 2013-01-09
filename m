Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3AIA4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:56:04 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39044 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3AIA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130109004340.GA12234@konrad-lan.dumpdata.com>
References: <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<20130107152622.GD3219@phenom.dumpdata.com>
	<CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	<87y5g4z7rp.fsf@xmission.com>
	<CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
	<CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
	<20130109004340.GA12234@konrad-lan.dumpdata.com>
Date: Tue, 8 Jan 2013 16:56:00 -0800
X-Google-Sender-Auth: diMh4sLHBKGhAAqG5XWx2Yr9XZI
Message-ID: <CAE9FiQUbP3T_mo3jCWW6rneyn+50+yTbWUxZCh-8Doy0zNGjSA@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 4:43 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> The swiotlb_full check I don't believe is neccessary. You won't ever get
> to that unless swiotlb_map_page has at least provided a bounce buffer.

yes, the code get there, when I boot the kernel with
"memmap=4095M$1M intel_iommu=off"

please check the call trace:

[  209.878091] usb 1-3: new high-speed USB device number 2 using ehci-pci
[  209.878096] DMA: Out of SW-IOMMU space for 8 bytes at device 0000:00:1a.7
[  209.878117] Kernel panic - not syncing: DMA: Random memory could be DMA read
[  209.878117]
[  209.878120] Pid: 2057, comm: khubd Not tainted
3.8.0-rc2-yh-00443-g262039c-dirty #1091
[  209.878121] Call Trace:
[  209.878132]  [<ffffffff8214a607>] panic+0xc0/0x1ce
[  209.878143]  [<ffffffff814dc013>] swiotlb_full+0xa3/0xc0
[  209.878147]  [<ffffffff814dccf3>] swiotlb_map_page+0x93/0xe0
[  209.878157]  [<ffffffff81c6800d>] usb_hcd_map_urb_for_dma+0xcd/0x510
[  209.878166]  [<ffffffff810eb758>] ? lockdep_init_map+0x518/0x570
[  209.878170]  [<ffffffff81c68a0d>] usb_hcd_submit_urb+0x5bd/0x690
[  209.878174]  [<ffffffff81c699b6>] usb_submit_urb+0x306/0x3c0
[  209.878179]  [<ffffffff81c6abb2>] usb_start_wait_urb+0x82/0x120
[  209.878183]  [<ffffffff81c69f7e>] ? usb_alloc_urb+0x1e/0x60
[  209.878187]  [<ffffffff81c6aeae>] usb_control_msg+0xde/0x130
[  209.878194]  [<ffffffff81196f80>] ? kmem_cache_alloc_trace+0x60/0x150
[  209.878198]  [<ffffffff81c62ad7>] hub_port_init+0x2a7/0xa10
[  209.878203]  [<ffffffff81c65542>] hub_port_connect_change+0x492/0x9c0
[  209.878211]  [<ffffffff82163f4e>] ? mutex_unlock+0xe/0x10
[  209.878215]  [<ffffffff81c65f9b>] hub_thread+0x52b/0x830
[  209.878222]  [<ffffffff810c3f94>] ? local_clock+0x34/0x60
[  209.878229]  [<ffffffff810afa00>] ? wake_up_bit+0x40/0x40
[  209.878233]  [<ffffffff81c65a70>] ? hub_port_connect_change+0x9c0/0x9c0
[  209.878237]  [<ffffffff810af088>] kthread+0xe8/0xf0
[  209.878241]  [<ffffffff810aefa0>] ? __init_kthread_worker+0x70/0x70
[  209.878248]  [<ffffffff8216f59c>] ret_from_fork+0x7c/0xb0
[  209.878251]  [<ffffffff810aefa0>] ? __init_kthread_worker+0x70/0x70
