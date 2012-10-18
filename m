Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab2JREle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:41:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57555 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2JREld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:41:33 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507F8864.1070203@jp.fujitsu.com>
Date: Thu, 18 Oct 2012 13:41:08 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7 v2] mm, mempolicy: avoid taking mutex inside spinlock
 when reading numa_maps
References: <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com> <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <20121017181413.GA16805@redhat.com> <alpine.DEB.2.00.1210171219010.28214@chino.kir.corp.google.com> <20121017193229.GC16805@redhat.com> <alpine.DEB.2.00.1210171237130.28214@chino.kir.corp.google.com> <20121017194501.GA24400@redhat.com> <alpine.DEB.2.00.1210171318400.28214@chino.kir.corp.google.com> <alpine.DEB.2.00.1210171428540.20712@chino.kir.corp.google.com> <507F803A.8000900@jp.fujitsu.com> <CA+55aFy9uYifEQ20-tQXvFCYSqb2VG74XhM6ZofHJW_VuqWdZQ@mail.gmail.com>
In-Reply-To: <CA+55aFy9uYifEQ20-tQXvFCYSqb2VG74XhM6ZofHJW_VuqWdZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/18 13:14), Linus Torvalds wrote:
> On Wed, Oct 17, 2012 at 9:06 PM, Kamezawa Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>          if (vma && vma != priv->tail_vma) {
>>                  struct mm_struct *mm = vma->vm_mm;
>> +#ifdef CONFIG_NUMA
>> +               task_lock(priv->task);
>> +               __mpol_put(priv->task->mempolicy);
>> +               task_unlock(priv->task);
>> +#endif
>>                  up_read(&mm->mmap_sem);
>>                  mmput(mm);
>
> Please don't put #ifdef's inside code. It makes things really ugly and
> hard to read.
>
> And that is *especially* true in this case, since there's a pattern to
> all these things:
>
>> +#ifdef CONFIG_NUMA
>> +       task_lock(priv->task);
>> +       mpol_get(priv->task->mempolicy);
>> +       task_unlock(priv->task);
>> +#endif
>
>> +#ifdef CONFIG_NUMA
>> +       task_lock(priv->task);
>> +       __mpol_put(priv->task->mempolicy);
>> +       task_unlock(priv->task);
>> +#endif
>
> it really sounds like what you want to do is to just abstract a
> "numa_policy_get/put(priv)" operation.
>
> So you could make it be something like
>
>    #ifdef CONFIG_NUMA
>    static inline numa_policy_get(struct proc_maps_private *priv)
>    {
>        task_lock(priv->task);
>        mpol_get(priv->task->mempolicy);
>        task_unlock(priv->task);
>    }
>    .. same for the "put" function ..
>    #else
>      #define numa_policy_get(priv) do { } while (0)
>      #define numa_policy_put(priv) do { } while (0)
>    #endif
>
> and then you wouldn't have to have the #ifdef's in the middle of code,
> and I think it will be more readable in general.
>
> Sure, it is going to be a few more actual lines of patch, but there's
> no duplicated code sequence, and the added lines are just the syntax
> that makes it look better.
>

you're right, I shouldn't send an ugly patch. I'm sorry.
V2 uses suggested style, I think.

Regards,
-Kame


