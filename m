Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2K0QvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:51:15 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:39779 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2K0QvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121127163910.GL12969@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
	<20121127154455.GK12969@redhat.com>
	<CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
	<20121127163910.GL12969@redhat.com>
Date: Tue, 27 Nov 2012 17:51:12 +0100
Message-ID: <CAFTL4hyzVLismy0ckx0Tu47EAgNn9WjAFEx=ptF5587-zp65hQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Gleb Natapov <gleb@redhat.com>:
> On Tue, Nov 27, 2012 at 04:56:30PM +0100, Frederic Weisbecker wrote:
>> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
>> > For KVM_PV_REASON_PAGE_NOT_PRESENT it behaves like an exception.
>>
>> Ok.
>> There seem to be a bug in kvm_async_pf_task_wait(). Using
>> idle_cpu(cpu) to find out if the current task is the idle task may not
>> work if there is pending wake up. Me may schedule another task but
>> when that other task sleeps later we can't schedule back to idle until
>> the fault is completed.
>>
>> The right way is to use is_idle_task(current)
> But if there is pending wake up then scheduling to the waked up task is
> exactly what we want.

Ok, but what if that task goes to sleep soon after beeing scheduled
and there is no other task on the runqueue and the page fault has not
been handled yet? The only thing you can do is to schedule the idle
task. But the idle task is waiting for the fault completion so you
can't do that.
