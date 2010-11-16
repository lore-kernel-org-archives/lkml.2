Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0KPQeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:34:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578Ab0KPQeV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:34:21 -0500
MIME-Version: 1.0
In-Reply-To: <1289908241.2109.570.camel@laptop>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
 <1289868791-16658-3-git-send-email-ying.huang@intel.com> <1289908241.2109.570.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 08:33:26 -0800
Message-ID: <AANLkTincM=Jsu48yJ_wEinj4Vfdu3Xt8QgC50Uqav7q3@mail.gmail.com>
Subject: Re: [PATCH -v4 2/2] lib, Add lock-less NULL terminated single list
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 3:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-11-16 at 08:53 +0800, Huang Ying wrote:
>> +/**
>> + * llist_del_all - delete all entries from lock-less list
>> + * @head:      the head of lock-less list to delete all entries
>> + *
>> + * If list is empty, return NULL, otherwise, delete all entries and
>> + * return the pointer to the first entry.
>> + */
>> +struct llist_node *llist_del_all(struct llist_head *head)
>> +{
>> +       return xchg(&head->first, NULL);
>> +}
>> +EXPORT_SYMBOL_GPL(llist_del_all);
>
> Its not del_all, since it returns the actual list. move or splice might
> be better names.

I don't think it's a "move", since the result isn't actually a
list_head (it's by definition a "we remove all entries from the list,
and then we can look at the list entries in private afterwards").

So the "delete" part _is_ important - before the op, we had an atomic
list. After the op, we just have a bunch of entries (they may be a
list, but they aren't a _lock-less_ list any more: they are literally
just private entries now).

So both "move" and "splice" imply at least to me that the target is
equivalent to the source. And it really isn't. The target is something
totally different. In fact, my original objection to this code was
that there wasn't a good separation between "entries" and "lock-less
head of list", and it used the same type for both - the way the
regular list functions do. In the regular list implementation, each
list entry really is a list head too, and you can have lists that
don't even _have_ separate heads, but everything is a list entry
(common in things like the dentry "siblings" list, where each dentry
can be used as the "head" to that sibling list - all siblings are
equal).

Now, I don't know if "del_all" is necessarily the proper name, but I
do think that it's important to make it clear that as far as the
lock-lessness of the list is concerned, the operation really is about
removing all entries, and it's not some kind of symmetric operation
wrt src/dest like with normal lists.

                                  Linus
