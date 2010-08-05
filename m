Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab0HEMon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:44:43 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:45965 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759136Ab0HEMol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:44:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Date: Thu, 5 Aug 2010 14:44:28 +0200
User-Agent: KMail/1.9.10
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201007282334.08063.rjw@sisk.pl> <20100729142245.4AA5.A69D9226@jp.fujitsu.com> <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008051444.32432.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 July 2010 07:24:29 KAMEZAWA Hiroyuki wrote:
> On Thu, 29 Jul 2010 14:23:33 +0900 (JST)
>
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Can you please add explicit commenting in the code?
>
> How about this ?
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> At hibernation, all pages-should-be-saved are written into a image (here,
> swap). Then, swap_map[], memmap etcs are also saved into disks.
>
> But, swap allocation happens one by one. So, the final image of swap_map[]
> is different from saved one and the commit
> c9e444103b5e7a5a3519f9913f59767f92e33baf changes page's state while
> assiging swap. Because memory can be modified in hibernation is only
> not-to-be-save memory. it's a breakage.
>
> This patch fixes it by disabling swap entry reuse at hibernation.

6 days with no crash - so the patch seems to work.



> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/swapfile.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.34.org/mm/swapfile.c
> ===================================================================
> --- linux-2.6.34.org.orig/mm/swapfile.c
> +++ linux-2.6.34.org/mm/swapfile.c
> @@ -315,8 +315,15 @@ checks:
>  	if (offset > si->highest_bit)
>  		scan_base = offset = si->lowest_bit;
>
> -	/* reuse swap entry of cache-only swap if not busy. */
> -	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> +	/*
> + 	 * reuse swap entry of cache-only swap if not busy &&
> + 	 * when we're called via pageout(). At hibernation, swap-reuse
> + 	 * is harmful because it changes memory status...which may
> + 	 * be saved already.
> + 	 */
> +	if (vm_swap_full()
> +		&& usage == SWAP_HAS_CACHE
> +		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
>  		int swap_was_freed;
>  		spin_unlock(&swap_lock);
>  		swap_was_freed = __try_to_reclaim_swap(si, offset);
>


-- 
Ondrej Zary
