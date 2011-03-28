Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1C1FuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:50:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1C1FuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:50:15 -0400
Message-ID: <4D902155.8040602@redhat.com>
Date: Mon, 28 Mar 2011 13:49:09 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [Patch V2] proc: check error pointer returned by m_start()
References: <AANLkTi=mqKF=xeMYbj9LZgPfSLHSkO1JRXsNTW3LyHqu@mail.gmail.com>	<1301289993-24248-1-git-send-email-amwang@redhat.com> <AANLkTik32QRUMaKF1aZ02Crh+RFG_4VOCFgPUPnCNLZA@mail.gmail.com>
In-Reply-To: <AANLkTik32QRUMaKF1aZ02Crh+RFG_4VOCFgPUPnCNLZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年03月28日 13:46, Anca Emanuel 写道:
> On Mon, Mar 28, 2011 at 8:26 AM, Amerigo Wang<amwang@redhat.com>  wrote:
>> From: WANG Cong<xiyou.wangcong@gmail.com>
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 7c708a4..8e59169 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -124,8 +124,10 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>>                 return ERR_PTR(-ESRCH);
>>
>>         mm = mm_for_maps(priv->task);
>> -       if (!mm || IS_ERR(mm))
>> +       if (IS_ERR_OR_NULL(mm)) {
>> +               put_task_struct(priv->task);
>>                 return mm;
>> +       }
>>         down_read(&mm->mmap_sem);
>>
>>         tail_vma = get_gate_vma(priv->task->mm);
>> @@ -182,6 +184,8 @@ static void m_stop(struct seq_file *m, void *v)
>>         struct proc_maps_private *priv = m->private;
>>         struct vm_area_struct *vma = v;
>>
>> +       if (IS_ERR_OR_NULL(v))
>> +               return;
>
> Note: this is not functional equivalent with the previous patch.
>

I moved that put_task_struct() into m_start() itself.

>
> I din't test the above patch.
>
> Linus already have the fix in his tree.

Yes, I really should pull before I made a patch. :-/

Anyway, thanks for reporting and testing.
