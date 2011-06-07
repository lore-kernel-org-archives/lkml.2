Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1FGW0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:26:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41082 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab1FGW0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
 <1307373819.3098.40.camel@edumazet-laptop> <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins> <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins> <1307378564.3098.67.camel@edumazet-laptop>
 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop>
 <4DED976C.90009@linux.intel.com> <4DEE3944.5020005@mit.edu>
 <1307462300.3091.39.camel@edumazet-laptop> <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
 <BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com> <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 7 Jun 2011 18:26:10 -0400
Message-ID: <BANLkTi=vwJBgkKSY_Cq_jQS-71gH6uOPaw@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: Andrew Lutomirski <luto@mit.edu>
Cc: David Oliver <david@rgmadvisors.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 15:19, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, Jun 7, 2011 at 3:10 PM, David Oliver <david@rgmadvisors.com> wrote:
>> I have software which currently uses shared files for a one way
>> transfer of information, which is modeled precisely by the futex (as
>> contrasted to the mutex) model. In this case, the number of receivers
>> is undetermined, so the number of wakeups is set to maxint.
>>
>> The receivers are minimally trusted: they have read access to the
>> files, so they cannot accidentally affect other processes use of the
>> data. Requiring my files to be writeable by all clients would require
>> a serious increase in the amount of software needing to be trusted.
>
> What's wrong with adding a FUTEX_WAIT_NOCONSUME flag then?  Your
> program can use it to get exactly the semantics it wants and my
> program can use it or not depending on which semantics it wants.
>
> Then we can document in the man page that, on kernels newer than
> whichever version introduced the regression, read-only mappings of a
> file cannot be used to interfere with futexes on that file.

Hmm, I would actually call it "FUTEX_POLL", since that better reflects the
operation being performed.

Certainly you would want to avoid allowing FUTEX_POLL to "steal"
limited wakeups from FUTEX_CMP_REQUEUE or whatever, so you
also need a new "FUTEX_NOTIFY".  Alternatively I guess you could just
special-case the FUTEX_WAKE && wakeups == INTMAX combination to
also notify FUTEX_POLL processes.

I almost wonder if long-term there might possibly be some decent way
to integrate this with eventfds to allow a thread to wait for notifications from
any number of memory addresses as well as other event sources.  This
would be a similar extension to signalfd, only for futexes.

Cheers,
Kyle Moffett
