Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2HHBTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:19:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58558 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2HHBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <1344324343-3817-6-git-send-email-walken@google.com>
References: <1344324343-3817-1-git-send-email-walken@google.com>
	<1344324343-3817-6-git-send-email-walken@google.com>
Date: Tue, 7 Aug 2012 18:19:12 -0700
Message-ID: <CANN689EcSPkawZMQC-L-odANez+T0mVg_w4v6iOLL5WHcKACfw@mail.gmail.com>
Subject: Re: [PATCH 5/5] rbtree: move augmented rbtree functionality to rbtree_augmented.h
From: Michel Lespinasse <walken@google.com>
To: riel@redhat.com, peterz@infradead.org, vrajesh@umich.edu,
        daniel.santos@pobox.com, aarcange@redhat.com, dwmw2@infradead.org,
        akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 12:25 AM, Michel Lespinasse <walken@google.com> wrote:
> Provide rb_insert_augmented() and rb_erase_augmented through
> a new rbtree_augmented.h include file. rb_erase_augmented() is defined
> there as an __always_inline function, in order to allow inlining of
> augmented rbtree callbacks into it. Since this generates a relatively
> large function, each augmented rbtree users should make sure to
> have a single call site.

I should probably add this to show how the code generation works out
in practice (with a gcc 4.6 based compiler)

Before this change:

       text    data     bss     dec     hex filename
       3426       0       0    3426     d62 lib/rbtree.o

    0000000000000af0 g     F .text  000000000000001e rb_last
    0000000000000b80 g     F .text  0000000000000047 rb_next
    0000000000000000 g     F .text  0000000000000165 rb_insert_color
    0000000000000bd0 g     F .text  0000000000000047 rb_prev
    00000000000004e0 g     F .text  00000000000001cd __rb_insert_augmented
    0000000000000170 g     F .text  000000000000036f rb_erase
    00000000000006b0 g     F .text  0000000000000416 rb_erase_augmented
    0000000000000ad0 g     F .text  000000000000001e rb_first
    0000000000000b10 g     F .text  000000000000006e rb_replace_node

       text    data     bss     dec     hex filename
        540       0       0     540     21c lib/interval_tree.o

    0000000000000000 l     F .text  0000000000000054
interval_tree_augment_propagate
    0000000000000060 l     F .text  000000000000000e interval_tree_augment_copy
    0000000000000070 l     F .text  000000000000003e
interval_tree_augment_rotate
    00000000000000b0 g     F .text  0000000000000065 interval_tree_insert
    0000000000000120 g     F .text  0000000000000012 interval_tree_remove
    0000000000000140 g     F .text  000000000000004c interval_tree_iter_first
    0000000000000190 g     F .text  0000000000000074 interval_tree_iter_next

After this change:

       text    data     bss     dec     hex filename
       2976       0       0    2976     ba0 lib/rbtree.o

    0000000000000000 g     F .text  000000000000025c __rb_erase_color
    0000000000000930 g     F .text  000000000000001e rb_last
    00000000000009c0 g     F .text  0000000000000047 rb_next
    0000000000000260 g     F .text  0000000000000165 rb_insert_color
    0000000000000a10 g     F .text  0000000000000047 rb_prev
    0000000000000740 g     F .text  00000000000001cd __rb_insert_augmented
    00000000000003d0 g     F .text  000000000000036f rb_erase
    0000000000000910 g     F .text  000000000000001e rb_first
    0000000000000950 g     F .text  000000000000006e rb_replace_node

       text    data     bss     dec     hex filename
        900       0       0     900     384 lib/interval_tree.o

    0000000000000000 l     F .text  000000000000003e
interval_tree_augment_rotate
    0000000000000040 g     F .text  0000000000000065 interval_tree_insert
    00000000000000b0 g     F .text  000000000000020b interval_tree_remove
    00000000000002c0 g     F .text  000000000000004c interval_tree_iter_first
    0000000000000310 g     F .text  0000000000000074 interval_tree_iter_next

So the code size effect is that the library code for augmented erase
shrinks by 450 bytes, and each augmented rb_erase user grows by (well,
this will very between users, but I think interval tree is
representative of a typical user) ~360 bytes. The rotate callback is
generated as a static function so it can be passed by pointer to the
library rebalancing routines; the copy and propagate functions are
inlined into interval_tree_remove (and the compiler is able to
determine that there are no remaining non-inlined calls, so it doesn't
generate an additional static definition).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
