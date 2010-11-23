Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0KWKpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:45:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47368 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0KWKpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:45:53 -0500
Subject: Re: [PATCH] x86, perf, nmi:  Disable perf if counters are not
 accessable
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, jason.wessel@windriver.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
References: <1290462923-30734-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 11:46:06 +0100
Message-ID: <1290509166.2072.384.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 16:55 -0500, Don Zickus wrote:
> +static bool check_hw_exists(void)
> +{
> +       u64 val, val_new;
> +
> +       val = 0xabcdUL;
> +       (void) checking_wrmsrl(x86_pmu.perfctr, val);
> +       rdmsrl_safe(x86_pmu.perfctr, &val_new);
> +       if (val != val_new)
> +               return false;
> +
> +       return true;
> +} 

If I can make any sense of the implementation of native_read_msr_safe()
then I think it doesn't actually sets val_new in case it faults, it just
returns -EIO.

So I changed it to:

static bool check_hw_exists(void)
{
        u64 val, val_new = 0;
        int ret = 0;

        val = 0xabcdUL;
        ret |= checking_wrmsrl(x86_pmu.perfctr, val);
        ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
        if (ret || val != val_new)
                return false;

        return true;
}

And have applied the patch,

Thanks Don!
