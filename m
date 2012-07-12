Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2GLGAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:00:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49755 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab2GLGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:00:39 -0400
Date: Thu, 12 Jul 2012 11:29:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] uprobes: uprobe_mmap/munmap needs
 list_for_each_entry_safe()
Message-ID: <20120712055906.GD3598@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120708202917.GA18188@redhat.com>
 <20120708203001.GA18223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120708203001.GA18223@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071206-7606-0000-0000-000001F02916
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-08 22:30:01]:

> The bug was introduced by me in 449d0d7c "uprobes: Simplify the
> usage of uprobe->pending_list".
> 
> Yes, we do not care about uprobe->pending_list after return and
> nobody can remove the current list entry, but put_uprobe(uprobe)
> can actually free it and thus we need list_for_each_safe().
> 
> Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 67697db..a93b6df 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1010,7 +1010,7 @@ static void build_probe_list(struct inode *inode, struct list_head *head)
>  int uprobe_mmap(struct vm_area_struct *vma)
>  {
>  	struct list_head tmp_list;
> -	struct uprobe *uprobe;
> +	struct uprobe *uprobe, *u;
>  	struct inode *inode;
>  	int ret, count;
> 
> @@ -1028,7 +1028,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
>  	ret = 0;
>  	count = 0;
> 
> -	list_for_each_entry(uprobe, &tmp_list, pending_list) {
> +	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
>  		if (!ret) {
>  			loff_t vaddr = vma_address(vma, uprobe->offset);
> 
> @@ -1076,7 +1076,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
>  void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
>  {
>  	struct list_head tmp_list;
> -	struct uprobe *uprobe;
> +	struct uprobe *uprobe, *u;
>  	struct inode *inode;
> 
>  	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
> @@ -1093,7 +1093,7 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
>  	mutex_lock(uprobes_mmap_hash(inode));
>  	build_probe_list(inode, &tmp_list);
> 
> -	list_for_each_entry(uprobe, &tmp_list, pending_list) {
> +	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
>  		loff_t vaddr = vma_address(vma, uprobe->offset);
> 
>  		if (vaddr >= start && vaddr < end) {
> -- 
> 1.5.5.1
> 

