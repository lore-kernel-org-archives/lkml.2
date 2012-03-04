Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2CDMjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 07:39:10 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45410 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2CDMjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 07:39:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.219.234 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120304121841.GA23277@1984>
References: <1330621743-12883-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120304121841.GA23277@1984>
Date: Sun, 4 Mar 2012 18:09:08 +0530
Message-ID: <CAOD=uF6UvL2oEmJmgak4X5L0PR+qQi2=Vr22AUsAxLLOfi44rw@mail.gmail.com>
Subject: Re: Resend [PATCH] netfilter: Fix copy_to_user too small size parametre.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

where is it broken ?
Can you please explain ?

Regards
Santosh

On Sun, Mar 4, 2012 at 5:48 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 01, 2012 at 10:39:03PM +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> user-space ebtables expects 32 bytes-long names, but xt_match uses
>> 29 bytes. Fill the remaining bytes with zeroes.
>>
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>>  net/bridge/netfilter/ebtables.c |   14 +++++++++++---
>>  1 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
>> index 5864cc4..21f337a 100644
>> --- a/net/bridge/netfilter/ebtables.c
>> +++ b/net/bridge/netfilter/ebtables.c
>> @@ -1335,7 +1335,10 @@ static inline int ebt_make_matchname(const struct ebt_entry_match *m,
>>      const char *base, char __user *ubase)
>>  {
>>       char __user *hlp = ubase + ((char *)m - base);
>> -     if (copy_to_user(hlp, m->u.match->name, EBT_FUNCTION_MAXNAMELEN))
>> +     char name[EBT_FUNCTION_MAXNAMELEN] = {};
>> +
>> +     strncpy(name, m->u.match->name, sizeof(name));
>> +     if (copy_to_user(hlp, name, EBT_FUNCTION_MAXNAMELEN))
>>               return -EFAULT;
>>       return 0;
>>  }
>> @@ -1344,7 +1347,10 @@ static inline int ebt_make_watchername(const struct ebt_entry_watcher *w,
>>      const char *base, char __user *ubase)
>>  {
>>       char __user *hlp = ubase + ((char *)w - base);
>> -     if (copy_to_user(hlp , w->u.watcher->name, EBT_FUNCTION_MAXNAMELEN))
>> +     char name[EBT_FUNCTION_MAXNAMELEN] = {};
>> +
>> +     strncpy(name, w->u.watcher->name, sizeof(name));
>> +     if (copy_to_user(hlp , name, EBT_FUNCTION_MAXNAMELEN))
>>               return -EFAULT;
>>       return 0;
>>  }
>> @@ -1355,10 +1361,12 @@ ebt_make_names(struct ebt_entry *e, const char *base, char __user *ubase)
>>       int ret;
>>       char __user *hlp;
>>       const struct ebt_entry_target *t;
>> +     char name[EBT_FUNCTION_MAXNAMELEN] = {};
>>
>>       if (e->bitmask == 0)
>>               return 0;
>>
>> +     strncpy(name, t->u.target->name, sizeof(name));
>>       hlp = ubase + (((char *)e + e->target_offset) - base);
>>       t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
>
> This is broken, t dereference is incorrect. Unfortunately I've applied
> your patch. I'll apply a patch to fix this upon it.
