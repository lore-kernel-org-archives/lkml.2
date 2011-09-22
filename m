Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035Ab1IVFOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 01:14:53 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:38504 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1IVFOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 01:14:50 -0400
MIME-Version: 1.0
In-Reply-To: <1316665687.9107.10.camel@minggr>
References: <1316628589.7341.11.camel@localhost.localdomain>
	<CAF1ivSbZf5zgJphyaLeUZfSgz-oPvAY0bG6V2OMeWPS60nsxxQ@mail.gmail.com>
	<CADZ9YHhk0idJ6DQOfGmHJtY2RrHyk=D_m-wcOgN1rPp7_ommBg@mail.gmail.com>
	<1316665687.9107.10.camel@minggr>
Date: Thu, 22 Sep 2011 11:14:49 +0600
Message-ID: <CADZ9YHjheS-j9kLDjCe3LrxLOOJ24ZSGDCgMukPShorJRQzwNQ@mail.gmail.com>
Subject: Re: [PATCH] acpi: Fix possible recursive locking in hwregs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 10:28 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Thu, 2011-09-22 at 11:35 +0800, Rakib Mullick wrote:
>> On Thu, Sep 22, 2011 at 6:59 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> > On Thu, Sep 22, 2011 at 2:09 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> >> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status,
>> >> acpi_os_release_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then
>> >> without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which also tries to
>> >> hold acpi_gbl_hardware_lock and thus causes possible recursive lock.
>> >
>> > No, acpi_ev_walk_gpe_list holds acpi_gbl_gpe_lock.
>> >
>> Yes, right. Actually, acpi_os_release_lock() tries to hold
>> acpi_gbl_gpe_lock without releasing acpi_gbl_hardware_lock. Right?
>
> Do you mean "acpi_ev_walk_gpe_list() tries to hold
> acpi_gbl_gpe_lock..."?
>
I wanted to mean, acpi_os_acquire_lock() tries to hold
acpi_gbl_gpe_lock without releasing acpi_gbl_hardware_lock.  Actually,
this recursive locking scenario showed up on my modified kernel and
fails to suspend. But, never happened on mainline kernel. Looking at
the warning it seems to me that, it's safe to release the
acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list() and also
solves the problem. Calling acpi_ev_walk_gpe_list() doesn't require
acpi_gbl_hardware_lock to be held. This is the reason behind the
patch.

> We have below locks sequence. I don't see the problem.
>
> acpi_hw_clear_acpi_status:
>
>     <acquire acpi_gbl_hardware_lock>
>
>         acpi_ev_walk_gpe_list:
>             <acquire acpi_gbl_gpe_lock>
>             ...
>             <release acpi_gbl_gpe_lock>
>         ...
>     <release acpi_gbl_hardware_lock>
>
>>
>> Thanks,
>> Rakib
>
>
>
