Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab0EGEcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:32:52 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:42612 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0EGEcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jPGdP2UAkdYGBOXQ77BAFT18DipNenOb+v2DoR3umdvxsRMYVRwftsqep+pKw6Ge6N
         bimf4hAMHjtsblQCxfDC8BsHcCpqlv0J90lVH0pibWJwtXQV8DdCsh5qdLYhLxPUEjQO
         GD2lVfaOqhUWzFCtZwlkjr/p48h+M1nDpI2BY=
MIME-Version: 1.0
In-Reply-To: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 7 May 2010 12:32:30 +0800
Message-ID: <t2p412e6f7f1005062132lbcaf5192ua6ead4872465a766@mail.gmail.com>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
To: akpm@linux-foundation.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
       Changli Gao <xiaosuo@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 8:30 AM, Changli Gao <xiaosuo@gmail.com> wrote:
> void kvfree(void *ptr, size_t size)
> {
>        if (size < PAGE_SIZE)
>                kfree(ptr);
>        else if (is_vmalloc_addr(ptr))
>                vfree(ptr);
>        else
>                free_pages_exact(ptr, size);
> }

I found a way to eliminate the size argument of kvfree() and
kvfree_inatomic(). We can check where the page_head is slab or
compound, as pages owned by slab  subsystem always have Slab flag set
or are compound.

                page = virt_to_head_page(ptr);
                if (PageSlab(page) || PageCompound(page))
                        kfree(ptr);
                else
                        free_pages_exact(ptr, page->private);

And we can save the size argument in page->private after
alloc_pages_eact() returns.

        ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
        if (ptr != NULL) {
                virt_to_head_page(ptr)->private = size;
                return ptr;
        }

here is the test code:

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mm.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>
#include <linux/interrupt.h>

#define kmalloc(size, gfp) ({ \
        void *ptr = kmalloc(size, gfp); \
        if (ptr != NULL) \
                printk("kmalloc: %p(%u)\n", ptr, size); \
        ptr; })

#define alloc_pages_exact(size, gfp) ({ \
        void *ptr = alloc_pages_exact(size, gfp); \
        if (ptr != NULL) \
                printk("alloc_pages_exact: %p(%u)\n", ptr, size); \
        ptr; })

#define vmalloc(size) ({ \
        void *ptr = vmalloc(size); \
        if (ptr != NULL) \
                printk("vmalloc: %p(%u)\n", ptr, size); \
        ptr; })

#define kfree(ptr) do { printk("kfree: %p\n", ptr); kfree(ptr); } while (0)
#define vfree(ptr) do { printk("vfree: %p\n", ptr); vfree(ptr); } while (0)
#define free_pages_exact(ptr, size) do { \
                printk("free_pages_exact: %p(%u)\n", ptr, size); \
                free_pages_exact(ptr, size); \
        } while (0)

void *kvmalloc(size_t size)
{
        void *ptr;

        if (size < PAGE_SIZE)
                return kmalloc(size, GFP_KERNEL);
        ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
        if (ptr != NULL) {
                virt_to_head_page(ptr)->private = size;
                return ptr;
        }

        return vmalloc(size);
}
EXPORT_SYMBOL(kvmalloc);

static void kvfree_work(struct work_struct *work)
{
        vfree(work);
}

static void __kvfree(void *ptr, bool inatomic)
{
        if (unlikely(ZERO_OR_NULL_PTR(ptr)))
                return;
        if (is_vmalloc_addr(ptr)) {
                if (inatomic) {
                        struct work_struct *work;

                        work = ptr;
                        BUILD_BUG_ON(sizeof(struct work_struct) > PAGE_SIZE);
                        INIT_WORK(work, kvfree_work);
                        schedule_work(work);
                } else {
                        vfree(ptr);
                }
        } else {
                struct page *page;

                page = virt_to_head_page(ptr);
                if (PageSlab(page) || PageCompound(page))
                        kfree(ptr);
                else
                        free_pages_exact(ptr, page->private);
        }
}

void kvfree(void *ptr)
{
        __kvfree(ptr, false);
}
EXPORT_SYMBOL(kvfree);

void kvfree_inatomic(void *ptr)
{
        __kvfree(ptr, true);
}
EXPORT_SYMBOL(kvfree_inatomic);

//--------------------
// for testing
static int test_init(void)
{
        int size;
        void *ptr;

        for (size = 1; size < (1<<30); size <<= 1) {
                ptr = kvmalloc(size);
                if (ptr == NULL)
                        return -1;
                if (is_vmalloc_addr(ptr)) {
                        kvfree(ptr);
                        break;
                }
                kvfree(ptr);
        }
        ptr = kvmalloc(size);
        if (ptr == NULL)
                return -1;
        kvfree_inatomic(ptr);

        return 0;
}
module_init(test_init);

static void test_exit(void)
{
}
module_exit(test_exit);

MODULE_LICENSE("GPL");

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
