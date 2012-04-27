Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab2D0NtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 09:49:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37557 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118Ab2D0NtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 09:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>
	<fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
	<14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
	<4F97BA60.4080505@ladisch.de>
	<20120427082203.GB9233@aftab.osrc.amd.com>
	<CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>
	<CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com>
	<CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>
Date: Fri, 27 Apr 2012 09:49:16 -0400
Message-ID: <CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Josh Boyer <jwboyer@gmail.com>
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Clemens Ladisch <clemens@ladisch.de>, andymatei@gmail.com,
        "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 9:28 AM, Jeroen Van den Keybus
<jeroen.vandenkeybus@gmail.com> wrote:
>> Apparently there are
>> some pieces of hardware that generate a small number of spurious IRQs
>> "normally" and lowering the threshold to such a small value caused
>> those machines to kick into polling mode when they really didn't need
>> to.
>
> Hm. I'd really expect a spurious IRQ to happen as its name suggests:
> spuriously. What kind of hardware behaves like this ?

I'd have to go back and look through all the bug reports.  Essentially,
it wound up being "this used to work fine, now I get stuck in polling
mode".  When we dropped the patch in those cases, it went back to
working fine.

I'm not sure if it was a matter of a shared IRQ hitting quickly in
succession, or if it was really small bursts of spurious IRQs.

>> 1) While the quirk helps shield people without the buggy bridge, it
>> doesn't help the case where people have the bridge, but they have no
>> devices actually behind it.  That means such setups hit the polling
>> mode when they don't really need to as described above.
>
> Curious, the polling mode is left until a new spurious IRQ is detected.

Yes, except the threshold was lowered from 100000 to 10 in the original
patch.  Apparently that's too low.

>> 2) People, rightfully, complain that it makes inter-activity on their
>> desktop pretty laggy.  The mouse pointer jumps around a lot and key
>> strokes are often missed.  For a server class machine, I doubt it
>> would matter much but Fedora is essentially a desktop distro so that
>> tends to be a high priority.
>
> Again, I am a bit surprised. However, according to your patch:
>
>> +       if (!irq_poll_and_retry)
>> +               if (likely(desc->irq_count < 100000))
>> +                       return;
>> +       else
>> +               if (likely(desc->irq_count < 10))
>> +                       return;
>
> Don't you mean :
>
> +       if (!irq_poll_and_retry) {
> +               if (likely(desc->irq_count < 100000))
> +                       return;
> +       }
> +       else {
> +               if (likely(desc->irq_count < 10))
> +                       return;
> +       }

Indeed.  Probably do.

josh
