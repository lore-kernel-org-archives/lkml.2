Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2AQVcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:32:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33646 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab2AQVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:32:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
References: <20120117142759.GE16213@moon>
	<CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
	<20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com>
Date: Tue, 17 Jan 2012 13:35:00 -0800
In-Reply-To: <4F15C249.3000602@zytor.com> (H. Peter Anvin's message of "Tue,
	17 Jan 2012 10:47:37 -0800")
Message-ID: <m1obu29fnf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19U4Z0tt2SNo4viu45SAHS2RzCmqQ/Eldg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
>> On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
>>> On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>> +#define KCMP_EQ		0
>>>> +#define KCMP_LT		1
>>>> +#define KCMP_GT		2
>>>
>>> LT and GT are meaningless.
>>>
>> 
>> I found symbolic names better than open-coded values. But sure,
>> if this is problem it could be dropped.
>> 
>> Or you mean that in general anything but 'equal' is useless?
>> 
>
> Why on Earth would user space need to know which order in memory certain
> kernel objects are?

For checkpoint restart and for some other kinds of introspection what is
needed is a comparison function to see if two processes share the same
object.  The most interesting of these objects from a checkpoint restart case
are file descriptors, and there can be a lot of file descriptors.

The order in memory does not matter.  What does matter is that the
comparison function return some ordering between objects.  The algorithm
for figuring out of N items which of them are duplicates is O(N^2) if
the comparison function can only return equal or not equal.  The
algorithm for finding duplications is only O(NlogN) if the comparison
function will return an ordering among the objects.

> Keep in mind that this is *exactly* the kind of information which makes
> rootkits easier.

I would be very surprised if basic in memory ordering information was
not already available from simple creation ordering.

If using the in memory ordering is a problem in practice there are a lot
of other possible ways to order the kernel objects.  Allocating sequence
numbers for the kernel objects, passing the pointers through a
cryptographically secure hash before comparing them, etc.

It does look like Cyrill's patch description lacked the important bit of
information about the algorithm complexity requiring an ordering among
kernel objects.  Cyrill you probably want to describe more prominently
what is happening now and why in your patch description rather than give
the history of different approaches.

Eric
