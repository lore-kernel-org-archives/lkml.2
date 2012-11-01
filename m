Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2KARZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:25:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2KARZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121101094721.2a57719c@redhat.com>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
	<20121101110512.GA31271@liondog.tnic>
	<20121101094721.2a57719c@redhat.com>
Date: Thu, 1 Nov 2012 10:25:23 -0700
X-Google-Sender-Auth: eYmnfflfOEFY-Q7meTnb5wOW2GM
Message-ID: <CA+8MBbK5J1qWqTZjC6nHsVbqk05t0yF1F7d-_0PQpvBQBXgO1w@mail.gmail.com>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report conflicts
From: Tony Luck <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 4:47 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Take a look at arch/x86/kernel/cpu/mcheck/mce-apei.c:
>
>         void apei_mce_report_mem_error(int corrected, struct cper_sec_mem_err *mem_err)
>         {
>                 struct mce m;
>
>                 /* Only corrected MC is reported */
>                 if (!corrected || !(mem_err->validation_bits &
>                                         CPER_MEM_VALID_PHYSICAL_ADDRESS))
>                         return;
>
>                 mce_setup(&m);
>                 m.bank = 1;
>                 /* Fake a memory read corrected error with unknown channel */
>                 m.status = MCI_STATUS_VAL | MCI_STATUS_EN | MCI_STATUS_ADDRV | 0x9f;
>                 m.addr = mem_err->physical_addr;
>                 mce_log(&m);
>                 mce_notify_irq();
>         }
>
> Bank information there is fake; status is fake. Only addr is really filled
> there; it works only for corrected errors.

This went in like this to help out the Westmere-EX processors that
didn't fill out MCi_ADDR for corrected errors. APEI could get the
address from some platform CSRs ... reporting via /dev/mcelog
so that predictive analysis in mcelog(8) would work on these machines.

I don't think we can rip it out yet ... not until those machines are
shuffled off to recycle heaven.

But perhaps we should get smarter about which machines we enable
APEI on?  If we get everything we need from the machine check banks,
then the detour via the BIOS to report the same thing again isn't helpful.

-Tony
