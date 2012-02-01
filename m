Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2BAP1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:27:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2BAP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:27:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/2] lkdtm: use atomic_t to replace count_lock
Date: Wed, 1 Feb 2012 15:27:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>, Dave Young <dyoung@redhat.com>
References: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202011527.35366.arnd@arndb.de>
X-Provags-ID: V02:K0:xllbs2gTGc+agR/LJkUuKpJzBHuwcqWh3ygc+QVcqeS
 xHfATCV76Zu8jodb0b9H9tmvPNRyqBr5PBISKEccQwEQNuiDT7
 0a1GcB7P+B9HUOmfSr3etO2ymnIHCj3b05IsIwZQwQv1HrJrCv
 5Zf7+8EaDQIfi4WbrEune7RGBLz1DVLl4A5bd9kYKTiukN9RJa
 0UVQ6kmqPJ/cH/WfIBp2Q4ejmlxSlry/KfaWA8hjhUSpFZjLoI
 HJwi8WekNHSCEkzsTgKsZMfUANq92zc0MT5BtNbPvTRwCL72WY
 NgvfA2eeDVk8n5P3mi8G3pi+MZHViLxD30sea2wjM0fQ8d1se8
 IAeSyli2IUT25TSfFsec=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 February 2012, Cong Wang wrote:
>  static void lkdtm_handler(void)
>  {
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&count_lock, flags);
> -       count--;
>         printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
> -                       cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
> +                       cp_name_to_str(cpoint), cp_type_to_str(cptype), atomic_dec_return(&count));
>  
> -       if (count == 0) {
> +       if (!atomic_cmpxchg(&count, 0, cpoint_count))
>                 lkdtm_do_action(cptype);
> -               count = cpoint_count;
> -       }
> -       spin_unlock_irqrestore(&count_lock, flags);
>  }

This use is not atomic, you could have two threads doing atomic_dec_return
at the same time, and after that the value will be -1 so the atomic_cmpxchg
does not trigger.

In order to have an atomic here, you have to use a loop around
atomic_cmpxchg, like


	int old, new;
	old = atomic_read(&count);
	do {
		new = old ? old - 1 : cpoint_count;
		old = cmpxchg(&count, old, new);
	} while (old != new);

I suppose you could also just keep the spinlock and move lkdtm_do_action()
outside of it?

	Arnd
