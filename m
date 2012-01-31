Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2AaBsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:48:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44707 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2AaBsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:48:41 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
	<20120130134312.GA14110@redhat.com>
	<20120130204920.GA27812@oksana.dev.rtsoft.ru>
Date: Mon, 30 Jan 2012 17:51:20 -0800
In-Reply-To: <20120130204920.GA27812@oksana.dev.rtsoft.ru> (Anton Vorontsov's
	message of "Tue, 31 Jan 2012 00:49:20 +0400")
Message-ID: <m1r4ygfxlz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/WSdTPQpl+aCCvgF3pFR7ePKmCjbFMGzg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <anton.vorontsov@linaro.org> writes:

> On Mon, Jan 30, 2012 at 02:43:12PM +0100, Oleg Nesterov wrote:
>> On 01/30, Anton Vorontsov wrote:
>> >
>> > We'd like to use this function in the android low memory killer driver, so
>> > let's export it.
>> 
>> I guess you mean 3/3.
>> 
>> If lowmem_shrink() can use next_tid() which is not really accurate,
>> then why tou can't simply change it to use rcu_read_lock ?
>
> Yes, in LMK driver we don't need to be accurate. I probably could use
> rcu_read_lock, but the plan was in not holding any global locks (in
> this case the rcu) at all, instead I'd like to hold just a reference
> of the task, which the driver is analyzing at this time. Once we decide
> (to kill or not to kill the task), we either send a signal (and drop
> the reference) or just drop the reference.

rcu_read_lock unless it is implemented wrong is free from a lock
perspective.  rcu_read_lock only touches local state.

>From the look of your loop it already does a walk through the entire
process list so it looks to me like playing games with get_task_struct
and put_task_struct are going to be much more expensive.

proc grabs task references because we can't hold the rcu_read_lock
over a copy_to_user because that is a sleeping function.

You don't call anything that sleeps so rcu_read_lock should be
sufficient.

Eric
