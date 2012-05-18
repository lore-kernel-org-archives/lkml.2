Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103Ab2ERF4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:56:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab2ERF4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:56:36 -0400
Message-ID: <4FB5E48E.5090209@opensuse.org>
Date: Fri, 18 May 2012 01:56:30 -0400
From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Lekensteyn <lekensteyn@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, rocko <rockorequin@hotmail.com>
Subject: Re: [PATCH] ACPI / PCI / PM: Fix device PM regression related to
 D3hot/D3cold
References: <201205180039.35318.rjw@sisk.pl>
In-Reply-To: <201205180039.35318.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/12 18:39, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
>
> Commit 1cc0c998fdf2cb665d625fb565a0d6db5c81c639 (ACPI: Fix D3hot
> v D3cold confusion) introduced a bug in __acpi_bus_set_power() and
> changed the behavior of acpi_pci_set_power_state() in such a way that
> it generally doesn't work as expected if PCI_D3hot is passed to it
> as the second argument.
>
> First off, if ACPI_STATE_D3 (equal to ACPI_STATE_D3_COLD) is passed
> to __acpi_bus_set_power() and the explicit_set flag is set for the
> D3cold state, the function will try to execute AML method called
> "_PS4", which doesn't exist.
>
> Fix this by adding a check to ensure that the name of the AML method
> to execute for transitions to ACPI_STATE_D3_COLD is correct in
> __acpi_bus_set_power().  Also make sure that the explicit_set flag
> for ACPI_STATE_D3_COLD will be set if _PS3 is present and modify
> acpi_power_transition() to avoid accessing power resources for
> ACPI_STATE_D3_COLD, because they don't exist.
>
> Second, if PCI_D3hot is passed to acpi_pci_set_power_state() as the
> target state, the function will request a transition to
> ACPI_STATE_D3_HOT instead of ACPI_STATE_D3.  However,
> ACPI_STATE_D3_HOT is now only marked as supported if the _PR3 AML
> method is defined for the given device, which is rare.  This causes
> problems to happen on systems where devices were successfully put
> into ACPI D3 by pci_set_power_state(PCI_D3hot) which doesn't work
> now.  In particular, some unused graphics adapters are not turned
> off as a result.
>
> To fix this issue restore the old behavior of
> acpi_pci_set_power_state(), which is to request a transition to
> ACPI_STATE_D3 (equal to ACPI_STATE_D3_COLD) if either PCI_D3hot or
> PCI_D3cold is passed to it as the argument.
>
> This approach is not ideal, because generally power should not
> be removed from devices if PCI_D3hot is the target power state,
> but since this behavior is relied on, we have no choice but to
> restore it at the moment and spend more time on designing a
> better solution in the future.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=43228
> Reported-by: rocko<rockorequin@hotmail.com>
> Reported-by: Cristian Rodríguez<crrodriguez@opensuse.org>
> Reported-and-tested-by: Peter<lekensteyn@gmail.com>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---

Ok, tested this one in the affected box, it works.

echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
[   77.436767] VGA switcheroo: switched nouveau off
[   77.437004] [drm] nouveau 0000:01:00.0: Disabling display...
[   77.437110] [drm] nouveau 0000:01:00.0: Disabling fbcon...
[   77.437113] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[   77.437157] [drm] nouveau 0000:01:00.0: Evicting buffers...
[   77.439175] [drm] nouveau 0000:01:00.0: Idling channels...
[   77.439316] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[   77.771133] [drm] nouveau 0000:01:00.0: And we're gone!
[   78.082258] nouveau 0000:01:00.0: power state changed by ACPI to D3

laptop's fan is silent again :-) , thanks for fixing it !



