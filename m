Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab0I0JNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:13:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:47353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962Ab0I0JNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:13:14 -0400
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4CA057EA.7000609@redhat.com>
Date: Mon, 27 Sep 2010 11:13:12 +0200
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de>
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27.09.2010, at 10:38, Avi Kivity wrote:

> On 09/19/2010 06:28 PM, Avi Kivity wrote:
>> On machines without monitor/mwait we use an sti; hlt sequence to atomically
>> enable interrupts and put the cpu to sleep.  The sequence uses the "interrupt
>> shadow" property of the sti instruction: interrupts are enabled only after
>> the instruction following sti has been executed.  This means an interrupt
>> cannot happen in the middle of the sequence, which would leave us with
>> the interrupt processed but the cpu halted.
>> 
>> The interrupt shadow, however, can be broken by an nmi; the following
>> sequence
>> 
>>    sti
>>      nmi ... iret
>>      # interrupt shadow disabled
>>      intr ... iret
>>    hlt
>> 
>> puts the cpu to sleep, even though the interrupt may need additional processing
>> after the hlt (like scheduling a task).
>> 
>> sti is explicitly documented not to force an interrupt shadow; though many
>> processors do inhibit nmi immediately after sti.
>> 
>> Avoid the race by checking, during an nmi, if we hit the safe halt sequence.
>> If we did, increment the instruction pointer past the hlt instruction; this
>> allows an immediately following interrupt to return to a safe place.
>> 
>> Signed-off-by: Avi Kivity<avi@redhat.com>
> 
> Ping.

Wow, this is incredibly ugly :). Can't we just mask NMIs when the interrupt shadow is active?


Alex

