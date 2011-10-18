Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1JRHT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:19:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35134 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1JRHT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAJn8CcFded9JCh+G=dQJtjkWGrg-qXbJu2U66TX=r4PVpjQNSA@mail.gmail.com>
References: <20111018060747.GA462@program>
	<CAJn8CcFded9JCh+G=dQJtjkWGrg-qXbJu2U66TX=r4PVpjQNSA@mail.gmail.com>
Date: Tue, 18 Oct 2011 15:19:55 +0800
Message-ID: <CAEQi4bein3Vh8AFMyvGR16Ww8df7939F6PLrdDyYN7pECDcMgA@mail.gmail.com>
Subject: Re: [PATCH] kernel/nsproxy.c: Fix memory leak of create_new_namespaces().
From: wzt wzt <wzt.wzt@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com, xemul@openvz.org,
        ebiederm@xmission.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the wrong patch, thanks Feng to point it out.

On Tue, Oct 18, 2011 at 2:26 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>
>
> On Tue, Oct 18, 2011 at 2:07 PM, wzt <wzt.wzt@gmail.com> wrote:
>>
>> copy_pid_ns() has allocted some memory via create_pid_namespace(), if
>> copy_net_ns()
>> failed via create_new_namespaces(), it will cause memory leak. The
>> copy_utsname()
>> have the same problem.
>>
>> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>>
>> ---
>>  kernel/nsproxy.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
>> index 9aeab4b..fdcec31 100644
>> --- a/kernel/nsproxy.c
>> +++ b/kernel/nsproxy.c
>> @@ -99,14 +99,18 @@ static struct nsproxy *create_new_namespaces(unsigned
>> long flags,
>>        return new_nsp;
>>
>>  out_net:
>> -       if (new_nsp->pid_ns)
>> +       if (new_nsp->pid_ns) {
>>                put_pid_ns(new_nsp->pid_ns);
>> +               free_pid_ns(&new_nsp->pid_ns->kref);
>
> It is freed in put_pid_ns() if the last user is gone. Please check the
> implementation of put_pid_ns().
>
>>
>> +       }
>>  out_pid:
>>        if (new_nsp->ipc_ns)
>>                put_ipc_ns(new_nsp->ipc_ns);
>>  out_ipc:
>> -       if (new_nsp->uts_ns)
>> +       if (new_nsp->uts_ns) {
>>                put_uts_ns(new_nsp->uts_ns);
>> +               free_uts_ns(&new_nsp->pid_ns->kref);
>
>  same
>>
>> +       }
>>  out_uts:
>>        if (new_nsp->mnt_ns)
>>                put_mnt_ns(new_nsp->mnt_ns);
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
