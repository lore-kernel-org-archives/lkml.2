Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1BQL2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:28:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39982 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1BQL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aCy21eEZXz4Nbt6+ReqoifePgpbl0vuhFVYaJeBfYXmUvwjWjioUsY7i6PlMJqBO0F
         pb9Oz66fZPvFsvmwcoLosaZByVgSUw/FErwbqDvIZow0jhzWTogR0Wom1qKJT2I4qixd
         sAoN+0JqtIkVr0BdheaQftcl+IGelQM93gGDI=
Date: Thu, 17 Feb 2011 12:28:42 +0100
From: Tejun Heo <tj@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: David Miller <davem@davemloft.net>, daniel.lezcano@free.fr,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: WARNING: at kernel/lockdep.c:2323
 trace_hardirqs_on_caller+0xb9/0x16c()
Message-ID: <20110217112842.GS19830@htj.dyndns.org>
References: <4D5A90D0.9040403@free.fr>
 <AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com>
 <20110216.180347.71107177.davem@davemloft.net>
 <AANLkTim4NnyyFqprBoGpimquLP=6fjAanCrbqX=RXwC9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim4NnyyFqprBoGpimquLP=6fjAanCrbqX=RXwC9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 17, 2011 at 10:43:57AM +0800, Yong Zhang wrote:
> On Thu, Feb 17, 2011 at 10:03 AM, David Miller <davem@davemloft.net> wrote:
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > Date: Thu, 17 Feb 2011 09:37:30 +0800
> >
> >> On Tue, Feb 15, 2011 at 10:42 PM, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> >>> Hi All,
> >>>
> >>> I am running a 2.6.38-rc4-next-20110215+ kernel on qemu x86_64 and the
> >>> following traces appear in the console:
> >>>
> >>> Feb 15 15:00:24 lucid kernel: ------------[ cut here ]------------
> >>> Feb 15 15:00:24 lucid kernel: WARNING: at kernel/lockdep.c:2323
> >>> trace_hardirqs_on_caller+0xb9/0x16c()
> >>> Feb 15 15:00:24 lucid kernel: Hardware name: Bochs
> >>> Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Not tainted
> >>> 2.6.38-rc4-next-20110215+ #74
> >>> Feb 15 15:00:24 lucid kernel: Call Trace:
> >>> Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff8102b8a5>] ?
> >>> warn_slowpath_common+0x7b/0x93
> >>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
> >>> _raw_spin_unlock_irq+0x2b/0x30
> >>> Feb 15 15:00:24 lucid kernel: [<ffffffff8102b8d2>] ?
> >>> warn_slowpath_null+0x15/0x17
> >>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f796>] ?
> >>> trace_hardirqs_on_caller+0xb9/0x16c
> >>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ?
> >>> trace_hardirqs_on+0xd/0xf
> >>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
> >>> _raw_spin_unlock_irq+0x2b/0x30
> >>> Feb 15 15:00:24 lucid kernel: [<ffffffff812e167e>] ?
> >>> do_ide_request+0x32/0x590
> >>
> >> Seems related to IDE SUBSYSTEM
> >
> > Which hasn't had any changes in the past release.
> 
> OK.
> 
> Cc'ing Tejun Heo
> 
> For the back trace, I think __blk_run_queue() is the ligament.
> As from the comment of __blk_run_queue(), it must be called
> with the queue lock and interrupts disabled. And the lock
> is hold through spin_lock_irqsave(q->queue_lock, flags); at
> blk_end_bidi_request().
> 
> But in do_ide_request(), it realse the lock through
> spin_unlock_irq(q->queue_lock); which make the state
> inconsistent.
> 
> BTW, do_ide_request() also say it might_sleep(), this warning
> also trigger in Daniel's log.

This seems to be the same problem Jan reported and fixed by the
following patches.

  http://article.gmane.org/gmane.linux.kernel/1101766/raw
  http://article.gmane.org/gmane.linux.ide/48819/raw

Can you please test whether these two patches fix the problem?

Thanks.

-- 
tejun
