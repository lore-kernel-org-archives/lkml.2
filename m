Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2BFV1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:27:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44449 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab2BFV1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:27:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120206191854.GA16702@kroah.com>
References: <20120203163056.GA4190@redhat.com> <20120206162930.GA5117@oksana.dev.rtsoft.ru>
 <20120206163542.GA10104@kroah.com> <20120206185909.GB7741@oksana.dev.rtsoft.ru>
 <20120206191854.GA16702@kroah.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 6 Feb 2012 16:27:32 -0500
Message-ID: <CAHGf_=r+nReQSfdvU7+FAhMRBkZPzQ2Jg6Puw9SmvW7WijpN7A@mail.gmail.com>
Subject: Re: [PATCH 1/6] oom: Make find_lock_task_mm() sparse-aware
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/6 Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Feb 06, 2012 at 10:59:09PM +0400, Anton Vorontsov wrote:
>> On Mon, Feb 06, 2012 at 08:35:42AM -0800, Greg KH wrote:
>> [...]
>> > > -extern struct task_struct *find_lock_task_mm(struct task_struct *p);
>> > > +extern struct task_struct *__find_lock_task_mm(struct task_struct *p);
>> > > +
>> > > +#define find_lock_task_mm(p)                                             \
>> > > +({                                                                       \
>> > > + struct task_struct *__ret;                                      \
>> > > +                                                                 \
>> > > + __cond_lock(&(p)->alloc_lock, __ret = __find_lock_task_mm(p));  \
>> > > + __ret;                                                          \
>> > > +})
>> >
>> > Please use the proper "do...while" style thing here for multi-line,
>> > complex #defines like the rest of the kernel does so that you don't end
>> > up debugging horrible problems later.
>>
>> Unfortunately this isn't possible in this case. Unlike '({})' GCC
>> extension, do-while statement does not evaluate to a value, i.e.
>> 'x = do { 123; } while (0);' is illegal.
>
> Ah, you are right, my bad, sorry about that.
>
> greg k-h

Some __cond_lock() caller are inline functions. Is this bad? inline function
is always recommended than macros.
