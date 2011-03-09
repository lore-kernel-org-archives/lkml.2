Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1CIAgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:36:50 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47687 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347Ab1CIAgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:36:49 -0500
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Andy Walls <awalls@md.metrocast.net>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        David Miller <davem@davemloft.net>, linux-media@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <1299445446.2310.157.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
	 <1299362366.2570.27.camel@localhost> <1299377017.2341.50.camel@localhost>
	 <AANLkTimU9qV11p+wTDz4SCvaoYyxpja8tmJ5D7-ki==B@mail.gmail.com>
	 <1299445446.2310.157.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 19:37:01 -0500
Message-ID: <1299631021.3023.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-08_09:2011-03-08,2011-03-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1103080182
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 16:04 -0500, Andy Walls wrote:
> On Sun, 2011-03-06 at 10:37 -0800, Hugh Dickins wrote:

> > 
> > Thanks for all the effort you are putting into investigating this: you
> > deserve a better response than I can give you.
> > 
> > mm/vmalloc.c's vmap_area handling is entirely separate from
> > mm/mmap.c's vm_area_struct handling, yet both misbehaviors would be
> > explained if a next pointer has been corrupted to NULL.
> > 
> > Probably just coincidence that they both manifest that way, though the
> > underlying problem may turn out to be one.

> > If you have not already, it would be well worth turning on
> > CONFIG_DEBUG_LIST and CONFIG_DEBUG_SLAB or CONFIG_SLUB_DEBUG with
> > CONFIG_SLUB_DEBUG_ON.

> 
> >  But you are having trouble
> > reproducing it yourself?
> 
> I can't say yet.  I'm currently two for two.

After backing up the machine and testing again, I'm now 3 for 3.

This time it happened in the memset() in kernel/module.c:move_module()
when modprobe was trying to load the cx18-alsa.ko module.

        static int move_module(struct module *mod, struct load_info
        *info)
        {
                int i;
                void *ptr;
        
                /* Do the allocs. */
                ptr = module_alloc_update_bounds(mod->core_size);
                /*
                 * The pointer to this block is stored in the module structure
                 * which is inside the block. Just mark it as not being
        a
                 * leak.
                 */
                kmemleak_not_leak(ptr);
                if (!ptr)
                        return -ENOMEM;
        
                memset(ptr, 0, mod->core_size);   <----- Ooops/BUG
        
        /home/andy/cx18dev/git/media_tree/kernel/module.c:2529
            385c:       41 8b 8c 24 64 01 00    mov    0x164(%r12),%ecx
            3863:       00 
            3864:       31 c0                   xor    %eax,%eax
            3866:       48 89 d7                mov    %rdx,%rdi
            3869:       f3 aa                   rep stos %al,%es:(%rdi)  <----- Oops/BUG
        
ptr had a value of 0x0000000000001000

I'm starting a git bisect now.

Regards,
Andy

