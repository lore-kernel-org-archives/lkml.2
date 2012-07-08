Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2GHVSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:18:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46998 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752431Ab2GHVSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:18:24 -0400
Message-ID: <1341782304.13174.21.camel@joe2Laptop>
Subject: Re: [PATCH 3/5] uprobes: fix overflow in
 vma_address/find_active_uprobe
From: Joe Perches <joe@perches.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 08 Jul 2012 14:18:24 -0700
In-Reply-To: <20120708203006.GA18233@redhat.com>
References: <20120708203006.GA18233@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 22:30 +0200, Oleg Nesterov wrote:
> vma->vm_pgoff is "unsigned long", it should be promoted to loff_t
> before the multiplication to avoid the overflow.
[]
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
[]
> @@ -117,7 +117,7 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
>  	loff_t vaddr;
>  
>  	vaddr = vma->vm_start + offset;
> -	vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +	vaddr -= (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>  
>  	return vaddr;
>  }
> @@ -1450,7 +1450,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  
>  			inode = vma->vm_file->f_mapping->host;
>  			offset = bp_vaddr - vma->vm_start;
> -			offset += (vma->vm_pgoff << PAGE_SHIFT);
> +			offset += ((loff_t)vma->vm_pgoff << PAGE_SHIFT);

It's be nice to take remove the unnecessary parenthesis
and make it consistent with the vaddr use above it too.


