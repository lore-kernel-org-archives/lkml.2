Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab1LPAvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:51:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54615 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655Ab1LPAvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <4EEA8D7D.2030409@jp.fujitsu.com>
References: <cover.1323979146.git.tony.luck@intel.com>
	<f2d05667872c463ead35141ce0ad97818113e69d.1323979146.git.tony.luck@intel.com>
	<4EEA8D7D.2030409@jp.fujitsu.com>
Date: Thu, 15 Dec 2011 16:51:43 -0800
X-Google-Sender-Auth: a5UG7XwaYK6XKP_Jvo22d6FF4Fg
Message-ID: <CA+8MBbK6NdYtk4UOf1wrV-14kE2UXZO1VdCs3qfTqxAk4j4Tvw@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86, mce: handle "action required" errors
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>> +     m = *final;
>> +
>>       if (!no_way_out)
>>               mce_clear_state(toclear);
>>
>
> Small change, but again, you should describe reason why...

Yes - this is subtle (mce_clear_state() will clear what *final points to, so
make a copy in the local variable "m"). It deserves a comment, so I'll add
one.

> I know tolerant==3 is an insane option, but it is better to care about
> it here too (or it would be happy if we can remove tolerant completely).
>
> e.g.
>        if (tolerant < 3) {
>                if (no_way_out)
>                        mce_panic(...);
>                if (worst == MCE_AR_SEVERITY) {
>                        /* schedule action before return to userland */
>                        mce_save_info(m.addr);
>                        set_thread_flag(TIF_MCE_NOTIFY);
>                } else if (kill_it) {
>                        force_sig(SIGBUS, current);
>                }
>        }

Good point. But I don't see how "tolerant==3" and "AR" errors ever make sense
together. If we don't do something to fix the problem and just ignore
it, then we
will take a new machine check when we re-execute the instruction (unless the
problem magically went away ... but I don't think that is likely). So the a user
with tolerant=3 will loop taking the same machine check over and over. Which
isn't likely to be what was wanted.

>> + * TIF_MCE_NOTFY, just before returning to errorneous userland.
>
> Spell checker suggests:                       erroneous

Will fix.

>> +     if (!mi)
>> +             mce_panic("Lost address", NULL, NULL);
>
> The message is too short, isn't it?

Yes - it's a "Can't happen" error case (if we are here, then we must have saved
the address when we set TIF_MCE_NOTIFY - so the only way to not find the
address is for someone else to have corrupted out mce_info[] array). Perhaps
I should change to BUG_ON()?

> And if this case is an another version of "Memory error not recovered"
> located below then why not force_sig() but mce_panic()?

The more I look at that "Memory error not recovered" code, the more
I think that it should be a panic (almost the same logic as for tolerant=3,
in this case force_sig would prevent us from running right back into the
machine check - but we did nothing to poison the page

Thanks for looking at this.

-Tony
