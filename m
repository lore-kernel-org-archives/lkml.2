Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2DWWEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:04:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48452 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab2DWWEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUUGFaz0c-tHa9EGUxZaxPj_M=zrE+kE0dv5UMoA6GyN3w@mail.gmail.com>
References: <CA+icZUWVwUr19xL0Dn5mHnZjQaVjj6VYD3BMMktEWO0vgoZEXw@mail.gmail.com>
 <CA+icZUUGFaz0c-tHa9EGUxZaxPj_M=zrE+kE0dv5UMoA6GyN3w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 23 Apr 2012 16:04:25 -0600
Message-ID: <CAErSpo5vZSf_EZr6-XnAA8N2Luv6rA92YtZsidWZCZ8rarkPUQ@mail.gmail.com>
Subject: Re: Warning: pnp 00:0b: can't evaluate _CRS: 12311
To: sedat.dilek@gmail.com
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Adam Belay <abelay@mit.edu>, linux-kernel@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 6:03 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Mon, Apr 23, 2012 at 11:48 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> [ Please CC me I am not subscribed to this ML ]
>>
>> Hi,
>>
>> with a self-compiled linux-3.4-rc4 I am seeing this bugs/failures/warnings:
>>
>> [    0.241572] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
>>
>> [    0.279385]  pci0000:00: ACPI _OSC request failed (AE_ERROR),
>> returned control mask: 0x1d
>>
>> [    0.293699] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.294032] ACPI Error: Invalid/unsupported resource descriptor:
>> Type 0x00 (20120320/utresrc-650)
>> [    0.294037] pnp 00:0b: can't evaluate _CRS: 12311
>>
>> The same outputs I have seen also with an unsupported drm-intel-next
>> kernel from Ubuntu/PPA archives [1].
>>
>> What does ist mean? Is it harmless? Buggy firmware/bios?
>>
>> Do you need more background infos (dmesg, kernel-config, etc.)?
>>
>> Regards,
>> - Sedat -
>>
>> [1] http://kernel.ubuntu.com/~kernel-ppa/mainline/drm-intel-next/current/
>
> I have upgraded this Samsung series-5 notebook from BIOS version 05XK
> to 06XK, but the pnp/_CRS warning still remains.

Resource type 0 is "reserved" per the ACPI spec, so this is likely a
BIOS defect.  However, we might be able to handle it better than we
currently do.

I would expect all versions of Linux would report this error -- can
you confirm that or identify a version that didn't complain?  Also,
can you collect an acpidump (see
http://www.lesswatts.org/projects/acpi/utilities.php)?

In acpi_ut_validate_resource(), we return AE_AML_INVALID_RESOURCE_TYPE
(0x3017 == 12311), which explains the messages you see.  The comments
in acpi_ut_walk_aml_resources() suggest that we can't continue because
the length may be bogus if the type is invalid.  But I suspect that if
we just treat it as a zero-length descriptor and ignore it, things
will probably work, and that's likely what Windows does.

Bjorn
