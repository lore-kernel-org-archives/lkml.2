Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1HZQV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:21:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab1HZQV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:21:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=YszaWeGHtjt9gP7i8LQwQ/wsBgejJKQgMmb2TNDPC4xtMHy84ibaz3Ha9wTfOYiyt
	OMhLJdFUieLt/Jx32NtYw==
MIME-Version: 1.0
In-Reply-To: <20110826062224.GA3903@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com> <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
 <20110826062224.GA3903@sun>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Aug 2011 10:21:02 -0600
Message-ID: <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ralf Jung <ralfjung-e@gmx.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 12:22 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Aug 25, 2011 at 06:17:06PM -0600, Bjorn Helgaas wrote:
>> On Thu, Aug 25, 2011 at 5:33 PM, Suresh Siddha
>> <suresh.b.siddha@intel.com> wrote:
>> > On Thu, 2011-08-25 at 16:05 -0700, Bjorn Helgaas wrote:
>> >> Previously we reserved 1024 bytes, but that's more space than the IOAPIC
>> >> consumes, and it can cause conflicts with nearby devices.  The known
>> >> requirement is 68 bytes (sizeof(struct io_apic)), and rounding up to a
>> >> power-of-2 gives us 128.
>> >>
>> >
>> > Bjorn, Given the info from Intel that most of its io-apic
>> > implementations has registers up to 0xff offset (reserved), does
>> > reserving just the 128 bytes for the io-apic cause any address conflicts
>> > if the next 128 bytes are allocated (by the OS) for any other device.
>>
>> If the OS allocated the next 128 bytes to another device, it sounds
>> like it would cause a conflict on Intel boxes.  This must be an area
>> that differs between vendors.  I haven't seen a spec that mentions 256
>> bytes as the required minimum MMIO size for IOAPICs, and apparently
>> the AMD IOAPIC decodes 240 bytes or fewer.
>>
>
> Hi Bjorn,
>
> the former idea (as far as I remember) of all this IO_APIC_SLOT_SIZE
> was to be sure the io-apics are allocated with 1K step (which
> is requirements for io-apics), but definitely it doesn't consume
> that much space neither it decode the whole range.
>
> Which means, I would prefer if we have (since we change IO_APIC_SLOT_SIZE
> anyway) some additional check and WARN_ON in this code. Something like
>
>  if (io-apic-base-address & 0x3ff)
>   WARN_ON();
>
> Hm? (also we have bad_ioapic() check, probably should put such test
> there instead).

Is there some spec that requires all IOAPICs to be 1K aligned?  I
don't doubt that's the case; I'd just like to see something more
concrete than folklore.  I'm pretty sure there's some (possibly
secret) "IOAPIC architecture spec," and a section reference to it
would be nice.  Even before my patch, I don't think we actually
checked or enforced any *alignment* -- we only set the size.  I don't
know if it's worth it unless we have a problem it would fix, and it's
conceivable that we'd start warning about a perfectly functional
IOAPIC that's 128-byte aligned.

Bjorn
