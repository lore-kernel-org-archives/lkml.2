Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0EFAiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 20:38:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52935 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0EFAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 20:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Lg67JOLIXneh+3KIk5YbbsJ6oE279/yTh43blGn2/FpIdgauINH5LeiSysA7t/Gh8S
         pn6jgYnV0IoIBOXyXkO7x4VMY6qyloO7eBU3pgQwUUlAtv+VjvNRfc1LxFH6vdvSqqG3
         NAzKWSknJJxESTQkD2j8JtqgRe0QKjGmlNn/A=
MIME-Version: 1.0
In-Reply-To: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 6 May 2010 08:37:46 +0800
Message-ID: <w2h412e6f7f1005051737q827b8220ud02cf562c5389a8c@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o460cWmE007902

On Thu, May 6, 2010 at 8:30 AM, Changli Gao <xiaosuo@gmail.com> wrote:> kvmalloc() will try to allocate physically contiguous memory first, and try> vmalloc to allocate virtually contiguous memory when the former allocation> fails.>> kvfree() is used to free the memory allocated by kvmalloc(). It can't be used> in atomic context. If the callers are in atomic contex, they can use> kvfree_inatomic() instead.>> There is much duplicate code to do such things in kernel, so I generate the> above APIs.>> Thank Eric Dumazet for the "kv" prefix. :)>> #include <linux/kernel.h>> #include <linux/module.h>> #include <linux/mm.h>> #include <linux/init.h>> #include <linux/slab.h>> #include <linux/vmalloc.h>> #include <linux/interrupt.h>>> void *kvmalloc(size_t size)> {>        void *ptr;>>        if (size < PAGE_SIZE)>                return kmalloc(PAGE_SIZE, GFP_KERNEL);>        ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);>        if (ptr != NULL)>                return ptr;>>        return vmalloc(size);> }> EXPORT_SYMBOL(kvmalloc);>> void kvfree(void *ptr, size_t size)> {>        if (size < PAGE_SIZE)>                kfree(ptr);>        else if (is_vmalloc_addr(ptr))>                vfree(ptr);>        else>                free_pages_exact(ptr, size);> }> EXPORT_SYMBOL(kvfree);>> struct kvfree_work_struct {>        struct work_struct      work;>        void                    *head;>        void                    **ptail;> };>> DEFINE_PER_CPU(struct kvfree_work_struct, kvfree_work_struct);>> static void kvfree_work(struct work_struct *_work)> {>        struct kvfree_work_struct *work;>        void *head, *tmp;>>        work = container_of(_work, struct kvfree_work_struct, work);>        local_bh_disable();>        head = work->head;>        work->head = NULL;>        work->ptail = &work->head;>        local_bh_enable();
local_bh_disable should be local_irq_disable(), and local_bh_enable()should be local_irq_enable().
>>        while (head) {>                tmp = head;>                head = *(void **)head;>                vfree(tmp);>        }> }>> void kvfree_inatomic(void *ptr, size_t size)> {>        if (size < PAGE_SIZE) {>                kfree(ptr);>        } else if (is_vmalloc_addr(ptr)) {>                struct kvfree_work_struct *work;>>                *(void **)ptr = NULL;>                local_irq_disable();>                work = this_cpu_ptr(&kvfree_work_struct);>                *(work->ptail) = ptr;>                work->ptail = (void**)ptr;>                schedule_work(&work->work);>                local_irq_enable();>        } else {>                free_pages_exact(ptr, size);>        }> }> EXPORT_SYMBOL(kvfree_inatomic);>> static int kvfree_work_struct_init(void)> {>        int cpu;>        struct kvfree_work_struct *work;>>        for_each_possible_cpu(cpu) {>                work = per_cpu_ptr(&kvfree_work_struct, cpu);>                INIT_WORK(&work->work, kvfree_work);>                work->head = NULL;>                work->ptail = &work->head;>        }>>        return 0;> }> //pure_initcall(kvfree_work_struct_init);>> //--------------------> // for testing> static int test_init(void)> {>        int size;>        void *ptr;>>        kvfree_work_struct_init();>        for (size = 1; size < (1<<30); size <<= 1) {>                ptr = kvmalloc(size);>                if (is_vmalloc_addr(ptr)) {>                        printk("%d\n", size);>                        break;>                }>                kvfree(ptr, size);>        }>>        return 0;> }> module_init(test_init);>> static void test_exit(void)> {>        int cpu;>        struct kvfree_work_struct *work;>>        for_each_possible_cpu(cpu) {>                work = per_cpu_ptr(&kvfree_work_struct, cpu);>                cancel_work_sync(&work->work);>        }> }> module_exit(test_exit);>> MODULE_LICENSE("GPL");>


-- Regards，Changli Gao(xiaosuo@gmail.com)���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
