Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2AaPgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:36:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2AaPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:36:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock held
Date: Tue, 31 Jan 2012 15:35:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>
References: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com> <20120130125429.56f6f7d0.akpm@linux-foundation.org> <4F27EBBF.6040103@gmail.com>
In-Reply-To: <4F27EBBF.6040103@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201311535.53526.arnd@arndb.de>
X-Provags-ID: V02:K0:eU6K2LfY0GjaZdaQ669JT05ZfCmeVdytWdttZsW3QWc
 O9VoFkIb9iNjOSRFEznt1A94TgyXQjbRDVrhIis7cDobbekfMd
 aRt4LBXWehPk+ZcP8L4zD+EmzixI5bVfJl1AMNMtU1to/my98t
 PJWtZLdPMpnVRGEKjePYd1JHHKaNPmCACRvCvpK8JELFWpf+Wj
 B3uHD29B+q9UcbdttHGKpWEzqyrvUo3UqzG1M2Rk6n2w+gIAgF
 jsPiXqJTsshT55Y5oPGpUU4FRWS6YBlnGqCKfuA+A+KbNo8NKo
 F4n9dkoi4jiwd64VPbgQZNZiETonxnc9c2pEBNByWOBr43Bjrd
 7zBwwaXxvHFKKd4LGkWg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 January 2012, Cong Wang wrote:
> @@ -323,14 +323,16 @@ static void lkdtm_do_action(enum ctype which)
>         }
>         case CT_WRITE_AFTER_FREE: {
>                 size_t len = 1024;
> -               u32 *data = kmalloc(len, GFP_KERNEL);
> +               u32 *data = kmalloc(len, GFP_ATOMIC);
>  
>                 kfree(data);
> -               schedule();
> +               udelay(100);
>                 memset(data, 0x78, len);
>                 break;
>         }

I can't think of why the udelay would have any positive effect here,
if the idea of the schedule was to let some other process allocate and
use the memory.

Can't you just get rid of the count_lock if you use an atomic_t for the
count and use appropriate accesses on it?

	Arnd
