Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1GTRnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:43:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50307 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1GTRnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <1310430335.3550.3.camel@Joe-Laptop>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
 <1310430335.3550.3.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 20 Jul 2011 11:43:11 -0600
Message-ID: <CAJfuBxwtgOd+JAb+P2bMY7fAOb3zmgg0eLn0JmBycLpjPK783w@mail.gmail.com>
Subject: Re: [PATCH 21/21] dynamic_debug: delete pending queries
To: Joe Perches <joe@perches.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, bvanassche@acm.org,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 6:25 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-07-11 at 01:46 -0600, Jim Cromie wrote:
>> delete pending queries by re-issuing it with disabled flags
> []
>> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> []
>> @@ -505,7 +505,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
>>
>>       list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
>>               if (queries_match(query, &pq->query)) {
>> -                     /* query already in list, update flags */
>> +                     /* query already in list */
>> +                     if (!flags) {
>> +                             /* zeroed flags, remove query */
>> +                             if (verbose)
>> +                                     pr_info("delete pending: %s\n",
>> +                                             show_pending_query(pq));
>
> I think these should be pr_debug.
> I know you're only using the current style.
>
> Jason, any reason these can not be converted?
>
>

hi Joe,

one other corner case (in addition to pr_cont, which I probly should
have addressed to you)

+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__

makes pr_debug unconditionally print stuff that can be
doubled up if flags are also used.

Ive done s/pr_info/pr_debug/ locally, when combined with:
  ddebug_query="module dynamic_debug +pfmlt "
lines are too long, and are redundant

This is pretty trivial, and can be avoided by
"dont add those flags then", but I could imagine it
being a minor annoyance wherever both pr_debug
and pr_info|warn|err|etc are used together.

Perhaps pr_debug and friends should ignore pr_fmt
under CONFIG_DYNAMIC_DEBUG ?
