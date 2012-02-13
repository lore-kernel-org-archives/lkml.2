Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2BMMtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 07:49:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58591 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2BMMt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 07:49:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
	<CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
	<m1ipjc3fsk.fsf@fess.ebiederm.org>
	<CAE9FiQVLnyRB+pAqi22C5mCbHOOVKxsBhQKaB6P0p9f2LBL8bA@mail.gmail.com>
Date: Mon, 13 Feb 2012 04:52:10 -0800
In-Reply-To: <CAE9FiQVLnyRB+pAqi22C5mCbHOOVKxsBhQKaB6P0p9f2LBL8bA@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 11 Feb 2012 20:17:43 -0800")
Message-ID: <m1zkcmyjyd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/b47R3r7bWoQl0TZJ/IW3UHguzycnnKr0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Sat, Feb 11, 2012 at 7:13 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>> After reverting this commit, kdump is working again.
>>>
>>> So assume you need to drop this patch.
>>
>> It sounds like there is a bug in ioapic initialization in the context of
>> VT-d.  Where do you fail?
>>
> before get debug print out from second kernel, the system get reset.

Ouch.

Don can you work with with Yinghai to figure out what is different
between your test configuration and his?

YH did you have early printk enabled?

YH Did I understand you properly that things work if you don't enable
VT-d?   By VT-d are you referring to interrupt remapping?

For anyone watching.  The premise of this patch was that we can boot
the kernel without resorting to legacy tricks that require us to
put the interrupt controllers in PIT mode.

Apparently there is some weird corner case that YH can reproduce that
Don did not have in his test set that YH does that causes things to
fail.

I really don't see any likely candidates when looking at the code.  The
most I can see is some code that we don't run when interrupt remapping
is enabled in disable_IO_APIC.

So I suspect we have a bug in our apic initialization somewhere, but
apic initialization should happen after printk are enabled.  Or at least
after early printks so the reset YH is reporting doesn't make much sense.

Eric
