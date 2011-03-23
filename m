Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab1CWOgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:36:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab1CWOgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:36:38 -0400
Date: Wed, 23 Mar 2011 15:36:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:x86/cleanups] x86, dumpstack: Use frame pointer during
 stack trace
Message-ID: <20110323143627.GA31377@elte.hu>
References: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
 <tip-2f8058ae197236f9d5641850ce27f67d8f3e0b39@git.kernel.org>
 <20110310230222.GB1837@nowhere>
 <1300885734.1479.6.camel@leonhard>
 <AANLkTikMaimbA=ia-Gr91JbdwFqeAcyTuQ9VzHhATent@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikMaimbA=ia-Gr91JbdwFqeAcyTuQ9VzHhATent@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2011/3/23 Namhyung Kim <namhyung@gmail.com>:
> > 2011-03-11 (금), 00:02 +0100, Frederic Weisbecker:
> >> On Thu, Mar 10, 2011 at 10:26:07PM +0000, tip-bot for Namhyung Kim wrote:
> >> > Commit-ID:  2f8058ae197236f9d5641850ce27f67d8f3e0b39
> >> > Gitweb:     http://git.kernel.org/tip/2f8058ae197236f9d5641850ce27f67d8f3e0b39
> >> > Author:     Namhyung Kim <namhyung@gmail.com>
> >> > AuthorDate: Tue, 8 Mar 2011 20:44:22 +0900
> >> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> >> > CommitDate: Thu, 10 Mar 2011 23:20:30 +0100
> >> >
> >> > x86, dumpstack: Use frame pointer during stack trace
> >> >
> >> > If CONFIG_FRAME_POINTER is set then use the frame pointer for the
> >> > stack backtrace rather than scanning whole stack blindly.
> >>
> >> We don't do it blindly, we actually check the reliability with the
> >> frame pointer.
> >>
> >> I'm not sure this patch is a good idea. stack dumps need to stay very
> >> robust and not exclusively rely on the frame pointer to be correct.
> >> At least walking blindly the stack provides a best effort dump as a last
> >> resort.
> >>
> >
> > Sounds reasonable. How about adding a boot param to control it then?
> 
> Hmm, but I'm not sure what it would be useful for. Even if one is sure that 
> his crash will have the needed reliable addresses already, having unreliable 
> ones too in the report are not a problem. Are they?

Agreed, there's no point in such a boot parameter really.

The principles for printing backtraces are the following:

 - Robustness comes first. We do not ever want to crash or miss important
   information because the frame pointer chain broke in some rarely used
   assembler code.

 - Information. Backtraces like:

     [    3.522991] Call Trace:
     [    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
     [    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
     [    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
     [    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
     [    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
     [    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
     [    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
     [    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
     [    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
     [    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

   are immensely useful, because firstly we see the 'real' backtrace:

     [    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
     [    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
     [    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
     [    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
     [    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
     [    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10

   Secondly, we also see the 'residual trace' of what is on the kernel stack:

     [    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
     [    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
     [    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
     [    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

   Which is a poor man's kernel trace really. Here it tells us that a printk
   executed shortly before the backtrace was generated. Info like this can
   be useful when rare crashes are analyzed.

So hiding that information is not really productive. If then we could think about
making the visual output more expressive. For example:

 Call Trace:
  [<ffffffff814f35b9>] panic()                   # 0x091/0x199
  [<ffffffff814f3729>]                           # ? printk+0x68/0x6a
  [<ffffffff81a981b2>] mount_block_root()        # 0x257/0x26e
  [<ffffffff81a9821f>] mount_root()              # 0x056/0x05a
  [<ffffffff81a98393>] prepare_namespace()       # 0x170/0x1a9
  [<ffffffff81a9772b>] kernel_init()             # 0x1d2/0x1e2
  [<ffffffff81003894>] kernel_thread_helper()    # 0x004/0x010
  [<ffffffff814f6880>]                           # ? restore_args+0x0/0x30
  [<ffffffff81a97559>]                           # ? kernel_init+0x0/0x1e2
  [<ffffffff81003890>]                           # ? kernel_thread_helper+0x0/0x10

Would be a 'human readable' variant that tells us the real backtrace 'at a 
glance' - perhaps in a bit clearer fashion - while still keeping the 'residual' 
entries included as well.

The downside is that tools that parse backtraces out of the syslog might get 
confused, so that aspect has to be investigated as well.

Thanks,

	Ingo
