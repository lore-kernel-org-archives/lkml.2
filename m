Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1LLMpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:45:42 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48347 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752274Ab1LLMpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:45:39 -0500
Date: Mon, 12 Dec 2011 06:45:38 -0600
From: Robin Holt <holt@sgi.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Robin Holt <holt@sgi.com>, Greg Kroah-Hartmann <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: question about link_mem_sections()
Message-ID: <20111212124538.GC2547@sgi.com>
References: <CAPXgP10gRKAgo1ExkvLyNqceKpGujcov90umPQCRiNJ=qTwU_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP10gRKAgo1ExkvLyNqceKpGujcov90umPQCRiNJ=qTwU_A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 01:35:50PM +0100, Kay Sievers wrote:
> Robin,
> 
> you added find_memory_block_hinted() with:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=63d027a63888e993545d10fdfe4107d543f01bca
> 
> I try to understand what's going on here, because we need to switch
> away from 'struct sysdev'.
> 
> In the loop over the node data you call find_memory_block_hinted() in
> a row, which might all take a reference. At the end of the section you
> drop only the last reference of the iteration. The code before your
> change dropped all references inside the loop.
> 
> Could you please explain the intended behaviour?
> 
> If all is right, we should at least move the now wrong comment where is belongs.

Take a look at that commit's parent's parent:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=c25d1dfbd403209025df41a737f82ce8f43d93f5

This adds the kset_find_obj_hinted() function.  That function expects
the kobject_get to have already been done on the object passed in and
will release that reference when it advances to the next object.

Within the loop of the link_mem_sections(), we need to retain the
kobject_get reference between calls to find_memory_block_hinted() and
rely upon that functions call to kset_find_obj_hinted() to release all
but the last reference.

I hope that explains things.  If not, please feel free to ping me again.

Thanks,
Robin
