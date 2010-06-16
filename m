Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0FPNde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:33:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45155 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab0FPNdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lQQfOSDUO3+2QVUblL6EibRh1T2bOJyzDpbkv9lEDP5UA5g2VaIhigL3tZmWqeX8jW
         pblMxJ7XTD91oEi2trrPsK0zu3+lEJs+8hjzLcAHFSd8BteGyYhuyhyrthuyySJ5FQTH
         FoJ+l/Mrc2/hW8SXDgE0JZ5YJ0PNmpVWd7gs4=
MIME-Version: 1.0
In-Reply-To: <AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
	<AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
	<20100613194949.GC8055@thunk.org>
	<AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
	<20100614184244.GA11480@elliptictech.com>
	<20100614214646.GF6666@thunk.org>
	<AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
	<18402.1276625268@redhat.com>
	<AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
Date: Wed, 16 Jun 2010 14:33:31 +0100
X-Google-Sender-Auth: pUhSVHCrhwfmRhrALHLLDG2QLQU
Message-ID: <AANLkTimTAqERLRx-eSpbeXXwMh3K9f8FaZOeNY-oNmdL@mail.gmail.com>
Subject: Re: Why is kslowd accumulating so much CPU time?
From: Andy Whitcroft <apw@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 12:37 PM, Andy Whitcroft <apw@canonical.com> wrote:
>> Can you see what they're doing?
>>
>>        watch -n0 cat /sys/kernel/debug/slow_work/runqueue
>
> Turned on the debugging and applied the patch from Ted, and when
> things are bad I see constant cycling of all four threads in the
> output showing similar to the below, note only one thread shows at a
> time:
>
> Every 0.1s: cat /sys/kernel/debug/slow_work/runqueue    Wed Jun 16 12:34:52 2010
>
> THR PID   ITEM ADDR        FL MARK  DESC
> === ===== ================ == ===== ==========
>   0   897 ffff88012bb07510 12  20ms DRM_CRTC_HELPER: i915@pci:0000:00:02.0
>
> When things are working well I see the same output appearing for one
> update, about every 10s.

Ok I've added some additional debug and these appear to be being
thrown a loop by the HPD interrupt which is firing continiusly, here
is a sample from some 4 minutes after boot:

[  284.862670] APW: drm_helper_hpd_irq_event: cancel/submit
[  284.882803] APW: drm_helper_hpd_irq_event: cancel/submit
[  284.902691] APW: drm_helper_hpd_irq_event: cancel/submit
[  284.922814] APW: drm_helper_hpd_irq_event: cancel/submit
[  284.942620] APW: drm_helper_hpd_irq_event: cancel/submit
[  284.962707] APW: drm_helper_hpd_irq_event: cancel/submit
[  284.982937] APW: drm_helper_hpd_irq_event: cancel/submit
[  285.004181] APW: drm_helper_hpd_irq_event: cancel/submit
[  285.022622] APW: drm_helper_hpd_irq_event: cancel/submit
[  285.042569] APW: drm_helper_hpd_irq_event: cancel/submit
[  285.062593] APW: drm_helper_hpd_irq_event: cancel/submit
[  285.082683] APW: drm_helper_hpd_irq_event: cancel/submit

Later when things calm down we see them but much much less often:

[  379.038239] APW: drm_helper_hpd_irq_event: cancel/submit
[  379.044904] APW: drm_helper_hpd_irq_event: cancel/submit
[  382.438106] APW: drm_helper_hpd_irq_event: cancel/submit
[  382.444754] APW: drm_helper_hpd_irq_event: cancel/submit
[  385.838072] APW: drm_helper_hpd_irq_event: cancel/submit
[  385.844735] APW: drm_helper_hpd_irq_event: cancel/submit
[  389.237876] APW: drm_helper_hpd_irq_event: cancel/submit
[  389.244523] APW: drm_helper_hpd_irq_event: cancel/submit
[  392.638048] APW: drm_helper_hpd_irq_event: cancel/submit
[  392.644740] APW: drm_helper_hpd_irq_event: cancel/submit

-apw
