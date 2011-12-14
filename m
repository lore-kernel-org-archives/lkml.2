Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab1LNVaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:30:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1LNVaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:30:07 -0500
MIME-Version: 1.0
In-Reply-To: <4EE86C3A.2070304@linux.intel.com>
References: <cover.1323803130.git.tony.luck@intel.com>
	<80cbf65ae6e4bd610523cc8568b0c2dcb8c629b6.1323803130.git.tony.luck@intel.com>
	<4EE86C3A.2070304@linux.intel.com>
Date: Wed, 14 Dec 2011 13:30:06 -0800
X-Google-Sender-Auth: aLC9ZEGdzM_bZ0-cqkAsNAHiIEo
Message-ID: <CA+8MBbLmeTb3808Xs4boH6KwDqfeSi69yzvHVpOMUzQg47bBZQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86, mce: handle "action required" errors
From: Tony Luck <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 1:28 AM, Chen Gong <gong.chen@linux.intel.com> wrote:
>> -       if (kill_it&&  tolerant<  3)
>>
>> +       if (worst != MCE_AR_SEVERITY&&  kill_it&&  tolerant<  3)
>>                force_sig(SIGBUS, current);
>
>
> I think here it should add more comments to clarify why not killing *AR*
> case.
> Such as: "for SRAR errors, such as DCU/IFU error, on affected logical
> processors, it is reasonable that RIPV is 0."

I'll look at this - the reason to not kill for AR is that we want to
try to recover
first (e.g. page could be re-read from disk into a different physical page).
In some cases we can recover transparently to the application.
>> -       /* notify userspace ASAP */
>> -       set_thread_flag(TIF_MCE_NOTIFY);
>> +       if (worst == MCE_AR_SEVERITY) {
>
>
> how about adding one more condition check: mce_usable_address(&m) here?

I don't think it is needed - the table lookup in mce_severity() will only set
MCE_AR_SEVERITY if the ADDRV and MISCV bits are set in MCi_STATUS.

>> +               mce_save_info(m.addr);
>> +               set_thread_flag(TIF_MCE_NOTIFY);
>
>
> Here only SRAR error are flagged with TIF_MCE_NOTIFY, which means only SRAR
> error is handled in the function do_notify_resume. If so, SRAO error will
> only be handled in work_queue mce_work. If so, I think some related function
> names should be updated too. Otherwise, it will confuse people not touching
> these codes before.

Agreed - the names of the functions and the actions they perform haven't been
kept up to date.

>>  void mce_notify_process(void)
>>  {
>> +       __u64   paddr = paddr;
>
>
> you mean "__u64 paddr = 0;"?

No. The "paddr = paddr" is a gcc'ism to silence a spurious "may be used
before set" warning.  But the point will be moot in the next version because
changes inspired by Boris' comments mean that this line goes away.

> Does there exist some possibility that in the same process there are more
> than
> one error triggered? If so, maybe mce_find_info/mce_clear_info should be
> changed
> to loop-style, because here TIF_MCE_NOTIFY is cleared in the handler.
>
> Or it is impossible because overwritten will be covered by following
> condition:

I think that in current cpus it isn't possible to have more than one
error reported at the same time per process.

-Tony
