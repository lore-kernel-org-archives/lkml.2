Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1EUFd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 01:33:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39404 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1EUFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 01:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RRf96umtj5NlIxAcV91jzAJAT+SB5dkcNbx7vgXe6XXneSbPbvSDWcHITBVQB/5bt9
         tPXTA5J1BPfxO++jdCq1s4ccUMtskBK74/dGZX5Pf7DsTFgfTy1X6aO3HIQlusYIfWjW
         mSfmWCL64o6gVTlsnL35avcoqrlSmD5sPSvfo=
MIME-Version: 1.0
In-Reply-To: <BANLkTikz+i6kahgoEAQPzoL9PVpywVb0ug@mail.gmail.com>
References: <BANLkTikz+i6kahgoEAQPzoL9PVpywVb0ug@mail.gmail.com>
Date: Sat, 21 May 2011 13:33:17 +0800
Message-ID: <BANLkTimQQ4fs+WPo1GkS7OH9c=b+Zan+vQ@mail.gmail.com>
Subject: Re: [PATCH] vdso: Fix memory leak of init_vdso_vars().
From: wzt wzt <wzt.wzt@gmail.com>
To: ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        tglx@linutronix.de, hpa@zytor.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4L5XUPL020108

hi, andi, any comments?

On Wed, May 18, 2011 at 3:05 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
> Fix memory leak of init_vdso_vars().
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> Reviewed-by: Coly Li <bosong.ly@taobao.com>
>
> ---
> Â arch/x86/vdso/vma.c | Â  14 ++++++++++----
> Â 1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 4b5d26f..8d9d652 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -44,19 +44,19 @@ static int __init init_vdso_vars(void)
> Â  Â  Â  Â vdso_size = npages << PAGE_SHIFT;
> Â  Â  Â  Â vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
> Â  Â  Â  Â if (!vdso_pages)
> - Â  Â  Â  Â  Â  Â  Â  goto oom;
> + Â  Â  Â  Â  Â  Â  Â  goto oom1;
> Â  Â  Â  Â for (i = 0; i < npages; i++) {
> Â  Â  Â  Â  Â  Â  Â  Â struct page *p;
> Â  Â  Â  Â  Â  Â  Â  Â p = alloc_page(GFP_KERNEL);
> Â  Â  Â  Â  Â  Â  Â  Â if (!p)
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto oom;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto oom2;
> Â  Â  Â  Â  Â  Â  Â  Â vdso_pages[i] = p;
> Â  Â  Â  Â  Â  Â  Â  Â copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
> Â  Â  Â  Â }
>
> Â  Â  Â  Â vbase = vmap(vdso_pages, npages, 0, PAGE_KERNEL);
> Â  Â  Â  Â if (!vbase)
> - Â  Â  Â  Â  Â  Â  Â  goto oom;
> + Â  Â  Â  Â  Â  Â  Â  goto oom2;
>
> Â  Â  Â  Â if (memcmp(vbase, "\177ELF", 4)) {
> Â  Â  Â  Â  Â  Â  Â  Â printk("VDSO: I'm broken; not ELF\n");
> @@ -70,7 +70,13 @@ static int __init init_vdso_vars(void)
> Â  Â  Â  Â vunmap(vbase);
> Â  Â  Â  Â return 0;
>
> - oom:
> +oom2:
> + Â  Â  Â  i--;
> + Â  Â  Â  for (; i >= 0; i--)
> + Â  Â  Â  Â  Â  Â  Â  __free_page(vdso_pages[i]);
> +oom1:
> + Â  Â  Â  __free_page(vdso_pages);
> +
> Â  Â  Â  Â printk("Cannot allocate vdso\n");
> Â  Â  Â  Â vdso_enabled = 0;
> Â  Â  Â  Â return -ENOMEM;
> --
> 1.7.1
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
