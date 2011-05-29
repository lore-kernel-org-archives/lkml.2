Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1E2VVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:21:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43433 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1E2VVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PG+Y9itBLzoCoXokGuzFQWNIINnYY5C84pPMBl4PZdPAMMzbxToQi0NpmHkunpi9l+
         5pCXotKhyADVlyXg2QrJUvnZ6m/VJvbGBIY/cN3rtUdAM2PaIYRmpHISXwRfoNHApAQ3
         4Zcowyi655oZTwoAVczg79ZKVuBS7oC7oP/wI=
MIME-Version: 1.0
In-Reply-To: <20110529131906.GB24876@n2100.arm.linux.org.uk>
References: <1306412511.1200.90.camel@twins>
	<20110526122623.GA11875@elte.hu>
	<20110526123137.GG24876@n2100.arm.linux.org.uk>
	<20110526125007.GA27083@elte.hu>
	<BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
	<20110527120629.GA32617@elte.hu>
	<20110527205240.GT24876@n2100.arm.linux.org.uk>
	<20110529102119.GC9489@e102109-lin.cambridge.arm.com>
	<20110529102659.GY24876@n2100.arm.linux.org.uk>
	<BANLkTin-5+jE6U-3RrPjPiFVRMGNhvwVEw@mail.gmail.com>
	<20110529131906.GB24876@n2100.arm.linux.org.uk>
Date: Sun, 29 May 2011 22:21:35 +0100
X-Google-Sender-Auth: 7R5soeiqw18uxocLUP531ryGalQ
Message-ID: <BANLkTinLnb44qqo7GMrgDJA4uQGbuyQGzA@mail.gmail.com>
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2011 14:19, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Sun, May 29, 2011 at 01:01:58PM +0100, Catalin Marinas wrote:
>> BTW, we currently have a per-cpu current_mm variable in context.c
>> because switch_mm() is called before switch_to() and the CPU may
>> receive an IPI to reset the ASID in this interval. But we can remove
>> it entirely if we set the ASID in the post-switch hook and run the
>> main switch code with interrupts disabled.
>
> Unconvinced.  If we move the ASID update to the post-switch hook, then
> we have the opposite problem - an IPI can sneak in between the dropping
> of the IRQ disabling and the post-switch hook.  This could mean that
> we end up racing to update the hardware ASID value instead (we may
> have read the ASID value from the mm struct, interrupt occurs, changes
> the ASID value, returns, we program the old ASID value.)

Please note that we have this problem already, that's why Will posted
the patch to disable the interrupts around cpu_switch_mm(). With this
fix, even if cpu_switch_mm() happens in the post-switch hook, you
don't really have any problem. In the worst case you set the same
TTBR0 twice and maybe the first time with the old ASID followed
immediately by the setting of the new ASID (with the corresponding TLB
flushing). But that's all happening before getting to user space.

To my original point of getting rid of current_mm - in the post-switch
hook this would be equivalent to current->mm so no need for the
per-cpu variable.

-- 
Catalin
