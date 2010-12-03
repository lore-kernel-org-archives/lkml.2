Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0LCXCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:02:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0LCXCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sn8o6Uk5KqiYa0V1zMHc8nXVvf4K3rrzxbEI/aYPoN7dZXuooAUQgXLV27ZHnwkIS9
         +p6unHJVhznT9M3sQAMg==
MIME-Version: 1.0
In-Reply-To: <1291335412-16231-1-git-send-email-walken@google.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
Date: Fri, 3 Dec 2010 15:02:33 -0800
Message-ID: <AANLkTi=3VJRa4g4UcDM+Z_vYHAuCwwHM=DyOOPD41MPe@mail.gmail.com>
Subject: Re: [PATCH 0/6] mlock: do not hold mmap_sem for extended periods of time
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I forgot to add you on the original submission, but I think you'd be
best qualified to look at the two patches implementing
rwsem_is_contended()...

On Thu, Dec 2, 2010 at 4:16 PM, Michel Lespinasse <walken@google.com> wrote:
> Currently mlock() holds mmap_sem in exclusive mode while the pages get
> faulted in. In the case of a large mlock, this can potentially take a
> very long time, during which various commands such as 'ps auxw' will
> block. This makes sysadmins unhappy:
>
> real    14m36.232s
> user    0m0.003s
> sys     0m0.015s
> (output from 'time ps auxw' while a 20GB file was being mlocked without
> being previously preloaded into page cache)
>
> I propose that mlock() could release mmap_sem after the VM_LOCKED bits
> have been set in all appropriate VMAs. Then a second pass could be done
> to actually mlock the pages, in small batches, releasing mmap_sem when
> we block on disk access or when we detect some contention.
>
> Patches are against v2.6.37-rc4 plus my patches to avoid mlock dirtying
> (presently queued in -mm).
>
> Michel Lespinasse (6):
>  mlock: only hold mmap_sem in shared mode when faulting in pages
>  mm: add FOLL_MLOCK follow_page flag.
>  mm: move VM_LOCKED check to __mlock_vma_pages_range()
>  rwsem: implement rwsem_is_contended()
>  mlock: do not hold mmap_sem for extended periods of time
>  x86 rwsem: more precise rwsem_is_contended() implementation

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
