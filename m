Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182Ab2CORrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:47:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42540 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2CORrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWvOpJ1N=QLQ3MHRqVGw7pz1Fuma60pJSwzqP5Jc5PF3Q@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
 <1331362837-10740-24-git-send-email-yinghai@kernel.org> <CAErSpo5cCC4HySedQ85BFKkPQ0VuYWX+NTjZLd4GpcATh1ix3g@mail.gmail.com>
 <CAE9FiQWvOpJ1N=QLQ3MHRqVGw7pz1Fuma60pJSwzqP5Jc5PF3Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Mar 2012 11:47:18 -0600
Message-ID: <CAErSpo7qi8pE-tiXriMcF5LLY6c=BWnVy-G3MYmjh=1XrqypGA@mail.gmail.com>
Subject: Re: [PATCH v2 23/37] PCI, ACPI: Add pci_root_hp hot add hotplug notification
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:03 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Mar 12, 2012 at 8:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> It is from acpiphp_glue.c
>>>
>>> How to use it?
>>> Find out root bus number to acpi root name mapping from dmesg or /sys
>>>
>>>  echo "\_SB.PCIB 0" > /proc/acpi/sci/notify
>>> to add it back
>>
>> Nope.  That might be a way to exercise this for debug purposes (and it
>> only works when /proc/acpi/sci/notify is compiled in), but we
>> definitely don't want normal users to deal with ACPI pathnames like
>> this.
>
> before this patch set, only way is: Users really put one root bus in
> and press buton etc to trigger notification
> to get it work.
>
>>
>> Most of this functionality belongs in the ACPI core, not here.  The
>> core should be handling these notify events and turning them into
>> .add() and .remove() calls to the driver.
>>
>> But since the ACPI core doesn't do that yet, we have to do it in the
>> driver, like we do for CPU, memory, etc.  That part is fine.  But I
>> think it at least belongs *in* the driver, i.e., in pci_root.c, not in
>> a new pci_root_hp.c file.
>
> don't want to pollute pci_root.c.
>
> in separated file, we can use CONFIG_HOTPLUG in Makefile instead of pci_root.c

I don't buy this argument.  Most of this functionality should someday
be in the ACPI core.  Until then, it is intimately connected to the
stuff in pci_root.c.  It is not "pollution."

>> There definitely should not be another acpi_walk_namespace() and
>> another list of ACPI host bridges.  The core *does* already walk the
>> namespace and call acpi_pci_root_add() for us.  And the driver already
>> has a list of host bridges (acpi_pci_roots).
>
> no, we may not have acpi_pci_root there.

I don't understand what you're saying here.  I think you should be
basically implementing the "turn notify events into add/remove calls"
functionality.  This is what *should* be in the ACPI core, but isn't
yet.  If you put this in the driver, and hopefully follow the style
already used by the processor/memory/etc. drivers, it will be easier
to someday move it into the ACPI core.

Bjorn
