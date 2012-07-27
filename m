Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2G0VnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:43:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58084 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2G0VnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <1343417168.32120.38.camel@twins>
References: <1342787467-5493-1-git-send-email-walken@google.com>
	<1342787467-5493-5-git-send-email-walken@google.com>
	<1343417168.32120.38.camel@twins>
Date: Fri, 27 Jul 2012 14:43:15 -0700
Message-ID: <CANN689HjQthCn=nOiSea1yzKbzsea8b_dOERhKMNrthkxANdBw@mail.gmail.com>
Subject: Re: [PATCH 4/6] rbtree: faster augmented insert
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-07-20 at 05:31 -0700, Michel Lespinasse wrote:
>> --- a/lib/rbtree.c
>> +++ b/lib/rbtree.c
>> @@ -88,7 +88,8 @@ __rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
>>                 root->rb_node = new;
>>  }
>>
>> -void rb_insert_color(struct rb_node *node, struct rb_root *root)
>> +inline void rb_insert_augmented(struct rb_node *node, struct rb_root *root,
>> +                               rb_augment_rotate *augment)
>
> Daniel probably knows best, but I would have expected something like:
>
> __always_inline void
> __rb_insert(struct rb_node *node, struct rb_root *root,
>             const rb_augment_rotate *augment)
>
> Where you force inline and use a const function pointer since GCC is
> better with inlining them -- iirc, Daniel?

This hasn't been necessary with my compiler, but I can see how this
might help with older gcc versions. I really haven't investigated that
much and would be open to daniel's suggestions there.

To answer your question in the next email, we're using a gcc 4.6
variant with some local patches. TBH I don't know precisely what's in
there, however I think our compiler team makes a good job of working
with upstream so whatever changes they have are probably coming to a
future gcc version :)

>>  {
>>         struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
>>
>> @@ -152,6 +153,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
>>                                         rb_set_parent_color(tmp, parent,
>>                                                             RB_BLACK);
>>                                 rb_set_parent_color(parent, node, RB_RED);
>> +                               augment(parent, node);
>
> And possibly:
>                 if (augment)
>                         augment(parent, node);
>
> That would obviate the need for the dummy..

__rb_insert() gets instanciated two times, one as rb_insert_color()
with dummy callbacks, and one as rb_insert_augmented() itself with
user-passed callbacks. Using NULL instead of dummy callbacks would
generate the same code in the rb_insert_color() instance, but not in
the version that takes user-passed callbacks (i.e. there would be an
extra check for NULL there, which we don't want).

>> +void rb_insert_color(struct rb_node *node, struct rb_root *root) {
>
> placed your { wrong..

Oops (caught myself a few times doing that, missed this one
apparently... thanks for noticing)

>> +       rb_insert_augmented(node, root, dummy);
>> +}
>>  EXPORT_SYMBOL(rb_insert_color);
>
> And use Daniel's __flatten here, like:
>
> void rb_insert_color(struct rb_node *node, struct rb_root *root)
> __flatten
> {
>         __rb_insert(node, root, NULL);
> }
> EXPORT_SYMBOL(rb_insert_color);
>
> void rb_insert_augmented(struct rb_node *node, struct rb_root *root,
>                          const rb_augment_rotate *augment) __flatten
> {
>         __rb_insert(node, root, augment);
> }
> EXPORT_SYMBOL(rb_insert_augmented);

Looks good, I'll try that and resubmit.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
