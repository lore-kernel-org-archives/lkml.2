Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab0D0EMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 00:12:25 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59733 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0D0EMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 00:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X8W+zqSh9F3eQnq3EGQQJ8dTKi95gLiPekcNyegV7aYmve/Hr3ikQ8kU0Tkqwsovgq
         XgAdBV/PszWeRH+ll4VEg1VFZL7t+ELo6BoHOPkI4m5VFAQBKRy6o2vgdKe+kRueL6Qf
         EpAz/+wQgGq2AB7uAQVXo7w9OgdCIpLvMFLTA=
MIME-Version: 1.0
In-Reply-To: <1272295140.2434.8.camel@yio.site>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100419145934.GA10893@kroah.com>
	 <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
	 <20100425163711.GA20196@kroah.com>
	 <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com>
	 <20100425193658.GA24039@kroah.com>
	 <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
	 <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
	 <1272295140.2434.8.camel@yio.site>
Date: Tue, 27 Apr 2010 09:42:22 +0530
Message-ID: <q2ia2a2c8671004262112q74bb78az866cbf11e35ce5ee@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
From: Sujith Manoharan <m.sujith@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Greg KH <greg@kroah.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 8:49 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> I guess, the assumption that vfree() will free pages which are allocated
> by custom code, and not by vmalloc(), is not true.
>
> The attached changes seem to fix the issue for me.

I have the same issue with ath9k_htc. Repeated module load/unload
results in an eventual panic.

I checked your patch (on top of John Linville's wireless-testing tree)
and was unable to load the driver as FW download to the target failed
after the first iteration.

> -                       /* Pages will be freed by vfree() */
> -                       fw_priv->page_array_size = 0;
> -                       fw_priv->nr_pages = 0;

Am completely ignorant about this code, but this seemed a bit fishy,
so I removed this chunk from the patch and tried. It seemed to be working.

But then, I got this trace. (Which was present before your patch too).
I do see ath9k_htc_txep() in the trace, but am still not sure it
there's a memory leak in the driver.

udevd version: 151

[  606.888511] udevd[4744]: segfault at 7f0fdb19bf80 ip
00007f0fdb4f8231 sp 00007fff9a0cd590 error 5 in
ld-2.11.1.so[7f0fdb4ef000+1e000]
[  606.888556] BUG: Bad page map in process udevd
pte:ffff88007b8b18e0 pmd:7c7e9067
[  606.888559] addr:00007f0fdb095000 vm_flags:08000070 anon_vma:(null)
mapping:ffff88007cc4c998 index:108
[  606.888565] vma->vm_ops->fault: filemap_fault+0x0/0x480
[  606.888569] vma->vm_file->f_op->mmap: generic_file_mmap+0x0/0x60
[  606.888573] Pid: 4744, comm: udevd Tainted: G      D    2.6.34-rc5-wl #32
[  606.888575] Call Trace:
[  606.888581]  [<ffffffff810ad644>] print_bad_pte+0x1a4/0x210
[  606.888584]  [<ffffffff810ae6e1>] unmap_vmas+0x4c1/0x970
[  606.888589]  [<ffffffff810b3b8d>] exit_mmap+0xdd/0x1a0
[  606.888594]  [<ffffffff810396d8>] mmput+0x48/0x100
[  606.888597]  [<ffffffff8103e1c1>] exit_mm+0x101/0x130
[  606.888600]  [<ffffffff8104058c>] do_exit+0x6ac/0x770
[  606.888603]  [<ffffffff8104069c>] do_group_exit+0x4c/0xc0
[  606.888607]  [<ffffffff8104c6f7>] get_signal_to_deliver+0x307/0x4c0
[  606.888612]  [<ffffffff81002180>] do_signal+0x70/0x7c0
[  606.888616]  [<ffffffff81026b9a>] ? do_page_fault+0xca/0x3e0
[  606.888621]  [<ffffffff81301575>] ? printk+0x3c/0x3f
[  606.888624]  [<ffffffff810d9790>] ? do_unlinkat+0x60/0x1c0
[  606.888628]  [<ffffffff81002925>] do_notify_resume+0x55/0x80
[  606.888632]  [<ffffffff81304942>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  606.888635]  [<ffffffff81305a66>] retint_signal+0x46/0x90
[  606.888638] swap_free: Bad swap file entry c07fffffffd023c3
[  606.888641] BUG: Bad page map in process udevd
pte:ffffffffa04786b0 pmd:7c7e9067
[  606.888644] addr:00007f0fdb096000 vm_flags:08000070 anon_vma:(null)
mapping:ffff88007cc4c998 index:109
[  606.888646] vma->vm_ops->fault: filemap_fault+0x0/0x480
[  606.888649] vma->vm_file->f_op->mmap: generic_file_mmap+0x0/0x60
[  606.888652] Pid: 4744, comm: udevd Tainted: G    B D    2.6.34-rc5-wl #32
[  606.888654] Call Trace:
[  606.888657]  [<ffffffff810ad644>] print_bad_pte+0x1a4/0x210
[  606.888660]  [<ffffffff810ae6e1>] unmap_vmas+0x4c1/0x970
[  606.888668]  [<ffffffffa04786b0>] ? ath9k_htc_txep+0x0/0xe0 [ath9k_htc]
[  606.888672]  [<ffffffff810b3b8d>] exit_mmap+0xdd/0x1a0
[  606.888675]  [<ffffffff810396d8>] mmput+0x48/0x100
[  606.888678]  [<ffffffff8103e1c1>] exit_mm+0x101/0x130
[  606.888681]  [<ffffffff8104058c>] do_exit+0x6ac/0x770
[  606.888684]  [<ffffffff8104069c>] do_group_exit+0x4c/0xc0
[  606.888688]  [<ffffffff8104c6f7>] get_signal_to_deliver+0x307/0x4c0
[  606.888692]  [<ffffffff81002180>] do_signal+0x70/0x7c0
[  606.888695]  [<ffffffff81026b9a>] ? do_page_fault+0xca/0x3e0
[  606.888698]  [<ffffffff81301575>] ? printk+0x3c/0x3f
[  606.888701]  [<ffffffff810d9790>] ? do_unlinkat+0x60/0x1c0
[  606.888705]  [<ffffffff81002925>] do_notify_resume+0x55/0x80
[  606.888708]  [<ffffffff81304942>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  606.888711]  [<ffffffff81305a66>] retint_signal+0x46/0x90


Sujith
