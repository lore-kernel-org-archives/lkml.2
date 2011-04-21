Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1DUNq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:46:59 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60945 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1DUNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VF0IKNkKgjYCl9H5dlPGwi/a3xXsrscEOB1p0bAtAm5wJvalgpWx3N9oEh/PAhbU3w
         n9NJ/55AI5YRBW9AwO5uL59grndFI0bPQmflZ81LIRsp9FqmHGy9yGTVxxp32Vbfsgze
         irYwkiJWUx+SyBS9UU8sWneFuDbBe9lIt9JZ0=
MIME-Version: 1.0
In-Reply-To: <1303393450.2035.142.camel@laptop>
References: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
	<1303393450.2035.142.camel@laptop>
Date: Thu, 21 Apr 2011 21:46:57 +0800
Message-ID: <BANLkTinYu00M9No_Pqxp+gpEZAmPJPDt1g@mail.gmail.com>
Subject: Re: [PATCH] sched: try to fix mm leak when freeing sched groups
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3LDl3uw025245

On Thu, Apr 21, 2011 at 9:44 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-04-21 at 21:37 +0800, Hillf Danton wrote:
>> When freeing sched groups, there is a sg (== sched_group_nodes[i]) not
>> got freed.
>> The relevant code is reshuffled to be clearer, and correct.
>
> The code doesn't even appear to exist, what kernel are you patching?
>
Hi Peter

It is linux-2.6.39-rc1.tar.bz2 downloaded at kernel.org, and
          >> --- a/kernel/sched.c  2011-03-30 03:09:48.000000000 +0800
is the time stamp, right?

thanks
          Hillf

>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/kernel/sched.c  2011-03-30 03:09:48.000000000 +0800
>> +++ b/kernel/sched.c  2011-04-21 21:09:00.000000000 +0800
>> @@ -7106,7 +7106,7 @@ static void free_sched_groups(const stru
>>                       continue;
>>
>>               for (i = 0; i < nr_node_ids; i++) {
>> -                     struct sched_group *oldsg, *sg = sched_group_nodes[i];
>> +                     struct sched_group *sg = sched_group_nodes[i];
>>
>>                       cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
>>                       if (cpumask_empty(nodemask))
>> @@ -7114,13 +7114,11 @@ static void free_sched_groups(const stru
>>
>>                       if (sg == NULL)
>>                               continue;
>> -                     sg = sg->next;
>> -next_sg:
>> -                     oldsg = sg;
>> -                     sg = sg->next;
>> -                     kfree(oldsg);
>> -                     if (oldsg != sched_group_nodes[i])
>> -                             goto next_sg;
>> +                     do {
>> +                             struct sched_group *next = sg->next;
>> +                             kfree(sg);
>> +                             sg = next;
>> +                     } while (sg != sched_group_nodes[i]);
>>               }
>>               kfree(sched_group_nodes);
>>               sched_group_nodes_bycpu[cpu] = NULL;
>
>
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
