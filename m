Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2FZA4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:56:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42881 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab2FZA4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 26 Jun 2012 02:56:18 +0200
Message-ID: <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 2:40 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jun 25, 2012 at 5:23 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> Ok, but I thought you wanted the "properly handle continuations" that we
>> now have in the kernel.  I must be mistaken.
>
> We had that before too. It has nothing to do with merging the data,
> and the problem was just an outright *bug* in the initial record-based
> implementation. Nothing to do with buffering.
>
> Line continuations should happen if the previous printk didn't end
> with a '\n', and if the next one doesn't have a level. That was always
> the rule. It's a simple rule, and it works.
>
> Now, we can (and Key did) tweak the rule a little bit for cases that
> never actually happen in practice.
>
> So sure, add the "we only continue on the same line if we're the same
> process as the last process that did the printk" rule to the above
> rule. In practice it really doesn't matter, since partial lines are
> rare to begin with. And taking interrupt depth into account is another
> nice tweak. But it's a tweak, it's not important. Nobody really cares,
> but you can try to do a bit better.
>
> And none of the above has to do with *buffering*. The above rules are
> 100% the same whether you buffer or not.
>
> Sure, with buffering, you can handle the insane cases and try to get
> interspersed partial lines to do the right thing. And Kay did that.
> And it turns out to (a) never matter and (b) cause problems for
> debugging. So just saying "stop doing it" is the no-brainer solution.
> Don't buffer printouts to the display, because bad things may happen
> before the buffer is flushed.

Buffering has nice effects though:
It makes continuation lines appear as one record in the buffer, not as
n individual prints with n headers.

It fully isolates the race-sensitive continuation print users from the
normal terminated print users. With buffering, races against each
other are a lot more unlikely to happen, because the normal terminated
line prints never affect the sensitive continuation users, and we
would need two racy continuation users to race against each other. And
we did see the interleaving all the time with the old printk.

Here is what our test module has produced. And that could only be
achieved by doing buffering:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=c313af145b9bc4fb8e8e0c83b8cfc10e1b894a50

I'm not arguing anymore, but I have to defend that buffering produces
far better results than without. Granted, besides for continuation
users that crash the kernel and want to see the partial line they
printed.

Kay
