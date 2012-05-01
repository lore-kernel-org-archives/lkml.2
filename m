Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab2EARkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:40:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33349 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab2EARkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120430112907.14137.18910.stgit@zurg>
References: <20120430112903.14137.81692.stgit@zurg> <20120430112907.14137.18910.stgit@zurg>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 13:39:50 -0400
Message-ID: <CAHGf_=pfiFJ4N3bN_c29UpffqkzDY_priBYBuEOCyPJ13JVecw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] proc/smaps: show amount of nonlinear ptes in vma
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 7:29 AM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Currently, nonlinear mappings can not be distinguished from ordinary mappings.
> This patch adds into /proc/pid/smaps line "Nonlinear: <size> kB", where size is
> amount of nonlinear ptes in vma, this line appears only if VM_NONLINEAR is set.
> This information may be useful not only for checkpoint/restore project.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Requested-by: Pavel Emelyanov <xemul@parallels.com>
> ---
>  fs/proc/task_mmu.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index acee5fd..b1d9729 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -393,6 +393,7 @@ struct mem_size_stats {
>        unsigned long anonymous;
>        unsigned long anonymous_thp;
>        unsigned long swap;
> +       unsigned long nonlinear;
>        u64 pss;
>  };
>
> @@ -402,6 +403,7 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
>  {
>        struct mem_size_stats *mss = walk->private;
>        struct vm_area_struct *vma = mss->vma;
> +       pgoff_t pgoff = linear_page_index(vma, addr);
>        struct page *page = NULL;
>        int mapcount;
>
> @@ -414,6 +416,9 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
>                        mss->swap += ptent_size;
>                else if (is_migration_entry(swpent))
>                        page = migration_entry_to_page(swpent);
> +       } else if (pte_file(ptent)) {
> +               if (pte_to_pgoff(ptent) != pgoff)
> +                       mss->nonlinear += ptent_size;

I think this is not equal to our non linear mapping definition. Even if
pgoff is equal to linear mapping case, it is non linear. I.e. nonlinear is
vma attribute. Why do you want to introduce different definition?
