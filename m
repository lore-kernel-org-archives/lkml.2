Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab0FAEJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:09:44 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:63827 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0FAEJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NmVK81IWSgYiFmOXAYE7qyDdzZCk7eZPurKR1enPq7KiypjrzDQrMDCISh5M6Nnvus
         G+ZxW2C41jOtI9FY1zrkgDiNCSy3EWsV2YrchVM97y2U4APk3XolJfGy5ymVDo3o0YKJ
         Kq7a/yAKQcOyMDgE9pQo+C+eWwHtmVdqsvFJQ=
MIME-Version: 1.0
In-Reply-To: <20100601031528.GC15411@linux-sh.org>
References: <ede63b5a20af951c755736f035d1e787772d7c28@localhost>
	<20100601031528.GC15411@linux-sh.org>
Date: Mon, 31 May 2010 21:04:42 -0700
Message-ID: <AANLkTinY8Htz2bb2I_oN5iWtAjxuDkGzAvX_4TbtmKBh@mail.gmail.com>
Subject: Re: [PATCH v2] printk: fix delayed messages from CPU hotplug events
From: Kevin Cernekee <cernekee@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
       David.Woodhouse@intel.com, rgetz@analog.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 8:15 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> If this is to be entirely restricted to CPU hotplug then you could use
> the hotcpu notifier here instead of the open-coded cpu notifier directly,
> the former wraps to the latter in the CPU hotplug case and is simply a
> nop for the regular SMP case.

I ran some tests and saw the same problem during the regular MIPS SMP
boot.  i.e. adding "while (1) { }" at the end of __cpu_up() prevents
any of the probing/calibration messages originating on CPU1 from ever
being echoed to the console.  Adding the semaphore code before the
while loop caused the CPU1 messages to reappear.

Under normal circumstances you won't ever notice the problem at boot
time, because printing "Brought up %ld CPUs" has the undocumented side
effect of flushing out any messages that got stuck during SMP init.
And if that printk() wasn't there, the next one (from NET, PCI, SCSI,
...) would surely take its place.

But in the case of MIPS CPU hotplug, there is no such printk() at the
end, and so our luck runs out.
