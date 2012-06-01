Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab2FAROZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:14:25 -0400
Received: from goliath.siemens.de ([192.35.17.28]:16419 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148Ab2FAROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:14:24 -0400
Message-ID: <4FC8F867.7080103@siemens.com>
Date: Fri, 01 Jun 2012 19:14:15 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
References: <20120601161521.26935.25606.stgit@bling.home>  <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>
In-Reply-To: <1338570192.23475.25.camel@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-01 19:03, Alex Williamson wrote:
> On Fri, 2012-06-01 at 18:39 +0200, Jan Kiszka wrote:
>> On 2012-06-01 18:16, Alex Williamson wrote:
>>> The kernel no longer allows us to pass NULL for a hard interrupt
>>> handler without IRQF_ONESHOT.  Should have been using this flag
>>> anyway.
>>
>> This make the IRQ handling tail a bit slower (due to
>> irq_finalize_oneshot). MSIs are edge-triggered, so there was no need for
>> masking in theory.
> 
> Aren't these asynchronous since we can theoretically do
> irq_finalize_oneshot while the guest is servicing the device?

If it runs on a different CPU. But usually it's more efficient to have
handler and user on the same CPU. And this work has to be processed
somewhere.

> 
>>  Hmm, can't we trust the information that an IRQ
>> grabbed here is really a MSI type?
> 
> 
> Apparently not, comment added with this check (1c6c6952):
> 
>        * The interrupt was requested with handler = NULL, so
>        * we use the default primary handler for it. But it
>        * does not have the oneshot flag set. In combination
>        * with level interrupts this is deadly, because the
>        * default primary handler just wakes the thread, then
>        * the irq lines is reenabled, but the device still
>        * has the level irq asserted. Rinse and repeat....
>        *
>        * While this works for edge type interrupts, we play
>        * it safe and reject unconditionally because we can't
>        * say for sure which type this interrupt really
>        * has. The type flags are unreliable as the
>        * underlying chip implementation can override them.

I was talking about KVM here: Can't the KVM device assignment code
ensure that only MSIs are registered as such so that the above concerns
no longer apply?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
