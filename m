Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0I3E7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:59:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33019 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0I3E7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cYRNvbH2TdY2bkOMLolVGp+7zrtGMCjhzPP3UPaDRULTNOBUaQBJIWbQIkfCZC6QcF
         n5vv55QQVFjIDdK5UX/h/71Nkp8zqgIIjAkOkG0uXt11PWTikIGQrw49Rq70UBWqgwKE
         RtJB/uM1sGEGycr5U81it6JvJ3JqYN1wuPezI=
Subject: Re: Scheduler latency problems when using NAND
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Mason <mason@postdiluvian.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100929221401.GA32583@postdiluvian.org>
References: <20100929221401.GA32583@postdiluvian.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 07:56:58 +0300
Message-ID: <1285822618.11684.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 18:14 -0400, Mark Mason wrote:
> Hi all,
> 
> I hope this is the right place for this question.  I'm having some
> problems with scheduler latency when using UBIFS, and I'm hoping for
> some suggestions.

Hi Mark, this e-mail is not specific to UBIFS, so I suggest you keep
lkml to CC.

I cannot really suggest you much. Off the top of my head - try to enable
preemption in your kernel. But in general, it sounds like you actually
need the RT tree. Also there is the ftrace latency tracer - try to use
it.

> Linux 2.6.29-6, with a newer MTD, dating from probably around six
> months ago.  Embedded PowerPC 8315, with built-in NAND controller,
> using nand/fsl_elbc_nand.c.  NAND is a Samsung K9WAG08U1B two-die
> stack (one package with two chip selects), 2Gbyte x 8 bit.  The system
> has plenty of memory, but is short on CPU.
> 
> The application is storing streaming video, almost entirely large
> sequential files, roughly 250K to 15M, to a 1.6G filesystem.  There's
> no seeking or rewriting, just creat, write, close, repeat.  No
> compression is used on the filesystem.
> 
> The problem I'm seeing is excessively large scheduler latency when
> data is flushed to NAND.
> 
> Originally this had been happening during erases.  I noticed that
> hundreds of erases (up to around 700) were being issued in rapid
> succession, and I was seeing other threads unable to run for sometimes
> as much as the expected 7 seconds (I measured 1.1 ms per erase).  To
> address this, I split the erase command in two halves - FIR_OP_CM0 |
> FIR_OP_PA | FIR_OP_CM2 and FIR_OP_CW1 | FIR_OP_RS - with schedule()
> called in between.  This had the effect if issuing the erase, calling
> schedule(), then waiting for the erase to complete if it hadn't
> already, but usually it had.
> 
> I'm surprised this helped so much, since the calling thread should
> have been put to sleep for the duration of the erase by the call to
> wait_event_timeout(), but it definitely did - I guess it was the
> explicit schedule().
> 
> The erases are no longer a significant bottleneck, but now the writes
> are.  A page program takes 200us, which seems too short for an
> explicit schedule(), and I am seeing periods with the busy line
> asserted in back-to-back 200us chunks for most of a second.
> 
> I have played with thread priorities a bit, but I wound up with too
> many threads being "most important".  There is some hardware that
> can't tolerate large latencies, and unfortunately the existing code
> base doesn't have enough separation between critical and non-critical
> tasks to allow us to run just the critical stuff at a higher priority.
> 
> On average, the system can keep up with the load, but it has problems
> with the burstiness of the flushes to NAND, so I'm hoping for some
> ideas to smooth the traffic out, or even a totally different way to
> approach the problem.  I tried lowering the priority of the UBI
> background thread, the failure mode there is pretty obvious.  I tried
> lowering dirty_background_centisecs, that helped a little bit, but not
> enough, and there's also a SATA drive, although a smaller commit
> interval probably wouldn't bother it since the traffic is similar.
> 
> I'm contemplating something along the lines of a smaller commit
> interval, an even higher background thread priority, and a sleep with
> a schedule during the page program, but that many extra context
> switches are liable to be a problem - there's no L2 cache on this CPU,
> so context switches are extra expensive.
> 
> Does anyone have any suggestions, ideas, hints, advice, etc?
> 
> Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

