Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1KRT75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:59:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1KRT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:59:56 -0500
Date: Fri, 18 Nov 2011 11:59:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Joe Perches <joe@perches.com>, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmalloc.c: eliminate extra loop in
 pcpu_get_vm_areas error path
Message-Id: <20111118115955.410af035.akpm@linux-foundation.org>
In-Reply-To: <1321616630-28281-1-git-send-email-consul.kautuk@gmail.com>
References: <1321616630-28281-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 17:13:50 +0530
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> If either of the vas or vms arrays are not properly kzalloced,
> then the code jumps to the err_free label.
> 
> The err_free label runs a loop to check and free each of the array
> members of the vas and vms arrays which is not required for this
> situation as none of the array members have been allocated till this
> point.
> 
> Eliminate the extra loop we have to go through by introducing a new
> label err_free2 and then jumping to it.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  mm/vmalloc.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b669aa6..1a0d4e2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2352,7 +2352,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
>  	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
>  	if (!vas || !vms)
> -		goto err_free;
> +		goto err_free2;
>  
>  	for (area = 0; area < nr_vms; area++) {
>  		vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
> @@ -2455,6 +2455,7 @@ err_free:
>  		if (vms)
>  			kfree(vms[area]);
>  	}
> +err_free2:
>  	kfree(vas);
>  	kfree(vms);
>  	return NULL;

Which means we can also do the below, yes?  (please check my homework!)

--- a/mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix
+++ a/mm/vmalloc.c
@@ -2449,10 +2449,8 @@ found:
 
 err_free:
 	for (area = 0; area < nr_vms; area++) {
-		if (vas)
-			kfree(vas[area]);
-		if (vms)
-			kfree(vms[area]);
+		kfree(vas[area]);
+		kfree(vms[area]);
 	}
 err_free2:
 	kfree(vas);
_


