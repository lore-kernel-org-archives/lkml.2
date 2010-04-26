Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0DZXFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:05:30 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:61407 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0DZXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bGpGV2BtA7rDBpupANThDUTeUOxpEW7ljI0nbA/PSUwrtK7QtUHhmC1AHLj6DAsmI9
         HKx+zRxRaDl5zWl51TCDV5275cyij+8m1tXSc6//Y30bLBroayJ5/lnYjDbbzKb5jPDu
         WZZRZO24g7Sbq8WaMEV1J4NHbsteZT/RGHCUY=
MIME-Version: 1.0
In-Reply-To: <1272321478-28481-3-git-send-email-mel@csn.ul.ie>
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>
	 <1272321478-28481-3-git-send-email-mel@csn.ul.ie>
Date: Tue, 27 Apr 2010 08:05:26 +0900
Message-ID: <z2y28c262361004261605ha101b4aek7116f7a6a1d5b92@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing the 
	wrong VMA information
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3QN5YmE005139

On Tue, Apr 27, 2010 at 7:37 AM, Mel Gorman <mel@csn.ul.ie> wrote:> vma_adjust() is updating anon VMA information without any locks taken.> In contrast, file-backed mappings use the i_mmap_lock and this lack of> locking can result in races with page migration. During rmap_walk(),> vma_address() can return -EFAULT for an address that will soon be valid.> This leaves a dangling migration PTE behind which can later cause a BUG_ON> to trigger when the page is faulted in.>> With the recent anon_vma changes, there can be more than one anon_vma->lock> that can be taken in a anon_vma_chain but a second lock cannot be spinned> upon in case of deadlock. Instead, the rmap walker tries to take locks of> different anon_vma's. If the attempt fails, the operation is restarted.>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>> --->  mm/ksm.c  |   13 +++++++++++++>  mm/mmap.c |    6 ++++++>  mm/rmap.c |   22 +++++++++++++++++++--->  3 files changed, 38 insertions(+), 3 deletions(-)>> diff --git a/mm/ksm.c b/mm/ksm.c> index 3666d43..baa5b4d 100644> --- a/mm/ksm.c> +++ b/mm/ksm.c> @@ -1674,9 +1674,22 @@ again:>                spin_lock(&anon_vma->lock);>                list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {>                        vma = vmac->vma;> +> +                       /* See comment in mm/rmap.c#rmap_walk_anon on locking */> +                       if (anon_vma != vma->anon_vma) {> +                               if (!spin_trylock(&vma->anon_vma->lock)) {> +                                       spin_unlock(&anon_vma->lock);> +                                       goto again;> +                               }> +                       }> +>                        if (rmap_item->address < vma->vm_start ||>                            rmap_item->address >= vma->vm_end)>                                continue;> +> +                       if (anon_vma != vma->anon_vma)> +                               spin_unlock(&vma->anon_vma->lock);> +>                        /*>                         * Initially we examine only the vma which covers this>                         * rmap_item; but later, if there is still work to do,> diff --git a/mm/mmap.c b/mm/mmap.c> index f90ea92..61d6f1d 100644> --- a/mm/mmap.c> +++ b/mm/mmap.c> @@ -578,6 +578,9 @@ again:                      remove_next = 1 + (end > next->vm_end);>                }>        }>> +       if (vma->anon_vma)> +               spin_lock(&vma->anon_vma->lock);> +>        if (root) {>                flush_dcache_mmap_lock(mapping);>                vma_prio_tree_remove(vma, root);> @@ -620,6 +623,9 @@ again:                      remove_next = 1 + (end > next->vm_end);>        if (mapping)>                spin_unlock(&mapping->i_mmap_lock);>> +       if (vma->anon_vma)> +               spin_unlock(&vma->anon_vma->lock);> +>        if (remove_next) {>                if (file) {>                        fput(file);> diff --git a/mm/rmap.c b/mm/rmap.c> index 85f203e..bc313a6 100644> --- a/mm/rmap.c> +++ b/mm/rmap.c> @@ -1368,15 +1368,31 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,>         * are holding mmap_sem. Users without mmap_sem are required to>         * take a reference count to prevent the anon_vma disappearing>         */> +retry:>        anon_vma = page_anon_vma(page);>        if (!anon_vma)>                return ret;>        spin_lock(&anon_vma->lock);>        list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {>                struct vm_area_struct *vma = avc->vma;> -               unsigned long address = vma_address(page, vma);> -               if (address == -EFAULT)> -                       continue;> +               unsigned long address;> +> +               /*> +                * Guard against deadlocks by not spinning against> +                * vma->anon_vma->lock. If contention is found, release our> +                * lock and try again until VMA list can be traversed without> +                * contention.> +                */> +               if (anon_vma != vma->anon_vma) {> +                       if (!spin_trylock(&vma->anon_vma->lock)) {> +                               spin_unlock(&anon_vma->lock);> +                               goto retry;> +                       }> +               }> +               address = vma_address(page, vma);> +               if (anon_vma != vma->anon_vma)> +                       spin_unlock(&vma->anon_vma->lock);> +
if (address == -EFAULT)        continue;
>                ret = rmap_one(page, vma, address, arg);>                if (ret != SWAP_AGAIN)>                        break;> --> 1.6.5>>


-- Kind regards,Minchan Kim���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
