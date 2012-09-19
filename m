Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2ISV3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:29:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2ISV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:29:04 -0400
Date: Wed, 19 Sep 2012 14:29:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
In-Reply-To: <20120919191652.GA14631@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012, Konrad Rzeszutek Wilk wrote:

> From 0806b133b5b28081adf23d0d04a99636ed3b861b Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 19 Sep 2012 11:23:01 -0400
> Subject: [PATCH 1/2] debugfs: Add lock for u32_array_read
> 
> Dave Jones spotted that the u32_array_read was doing something funny:
> 
> =============================================================================
> BUG kmalloc-64 (Not tainted): Redzone overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff88001f4b4970-0xffff88001f4b4977. First byte 0xbb instead of 0xcc
> INFO: Allocated in u32_array_read+0xd1/0x110 age=0 cpu=6 pid=32767
>         __slab_alloc+0x516/0x5a5
>         __kmalloc+0x213/0x2c0
>         u32_array_read+0xd1/0x110
> .. snip..
> INFO: Freed in u32_array_read+0x99/0x110 age=0 cpu=0 pid=32749
>         __slab_free+0x3f/0x3bf
>         kfree+0x2d5/0x310
>         u32_array_read+0x99/0x110
> 
> Linus tracked it down and found out that "debugfs is racy for that case
> [read calls in parallel on the debugfs]. At least the file->private_data
> accesses are, for the case of that "u32_array" case.
> 
> In fact it is racy in ...  the whole "file->private_data" access ..
> If you have multiple readers on the same file, the whole
> 
> 	if (file->private_data) {
> 		kfree(file->private_data);
> 		file->private_data = NULL;
> 	}
> 
> 	file->private_data = format_array_alloc("%u", data->array,
>                                                               data->elements);
> 
> thing is just a disaster waiting to happen." He suggested
> putting a lock which this patch does.
> 

Since these are non-seekable files, it must also race to find *ppos == 0.

> The consequence of this is that it will trigger more spinlock usage,
> as this particular debugfs is used to provide a histogram of spinlock
> contention. But memory corruption is a worst offender then that.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>

Tested-by: David Rientjes <rientjes@google.com>
