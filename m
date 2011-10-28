Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1J1BTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:19:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48549 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1J1BTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:19:32 -0400
Message-ID: <1319764761.23112.14.camel@edumazet-laptop>
Subject: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Oct 2011 03:19:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 4e60c86bd9e (gcc-4.6: mm: fix unused but set warnings)
Andi forced VM_BUG_ON(cond) to evaluate cond, even if CONFIG_DEBUG_VM is
not set :

#ifdef CONFIG_DEBUG_VM
#define VM_BUG_ON(cond) BUG_ON(cond)
#else
#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
#endif

As a side effect, get_page()/put_page_testzero() are performing more bus
transactions on contended cache line on some workloads (tcp on loopback
for example, where a page is acting as a shared buffer)

0,05 :  ffffffff815e4775:       je     ffffffff815e4970 <tcp_sendmsg+0xc80>
0,05 :  ffffffff815e477b:       mov    0x1c(%r9),%eax    // useless                  
3,32 :  ffffffff815e477f:       mov    (%r9),%rax        // useless                  
0,51 :  ffffffff815e4782:       lock incl 0x1c(%r9)                        
3,87 :  ffffffff815e4787:       mov    (%r9),%rax                          
0,00 :  ffffffff815e478a:       test   $0x80,%ah                           
0,00 :  ffffffff815e478d:       jne    ffffffff815e49f2 <tcp_sendmsg+0xd02>      

Of course, we have to understand why

(void) (atomic_read(&some_atomic) == 1);

generates asm code...

	mov  some_atomic,%eax

Ah yes, this is because of the volatile...

static inline int atomic_read(const atomic_t *v)
{
	return (*(volatile int *)&(v)->counter);
}

So maybe a fix would be to introduce an atomic_read_stable() variant ?

static inline int atomic_read_stable(const atomic_t *v)
{
	return v->counter;
}

Thanks !


