Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2LKSmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:42:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54518 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2LKSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:42:08 -0500
MIME-Version: 1.0
In-Reply-To: <50C7795D.3000404@zytor.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
	<CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
	<50C6D3DF.3030209@zytor.com>
	<CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com>
	<20121211145716.GB8873@liondog.tnic>
	<CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
	<50C763C2.5020603@zytor.com>
	<CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com>
	<20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C7752C.2000709@zytor.com>
	<50C7795D.3000404@zytor.com>
Date: Tue, 11 Dec 2012 10:42:06 -0800
X-Google-Sender-Auth: e2tkLU4xb3aZaVawvB9hoxLj-kA
Message-ID: <CAE9FiQV03xToOaR3NcMtWDv=2MCMYwtY7p97BY3sAC1suYAhNA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:20 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/11/2012 10:02 AM, H. Peter Anvin wrote:
>>
>>
>> The more I think about it, the more I think the right answer is the one
>> we have pretty stated all along: if using the 64-bit entry point it is
>> the responsibility of the boot loader to make sure the kernel, the setup
>> data, and the initramfs are all mapped on entry.
>>

arch/x86/kernel/head_64.S::startup_64

is setting up its own page table

>
> This, in turn, brings up another major problem with the 64-bit entry point:
> right now it assumes page tables set up the way the current kernels expect
> them, but the way the kernel expects pages to be laid out on the future is
> almost guaranteed to change.  We need to formalize the expectations of the
> page table layout at 64-bit entry, and check to see what the implications of
> that are.
>
> In particular, we may need to build a set of scaffolding page tables in the
> brk when entered from the 64-bit entry point and switch to them a lot
> sooner.  We wouldn't have to do that when coming from the 16/32-bit entry
> points since we'd control the layout of those page tables.
>
> Oh how fun...

now in for-x86-boot:
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commit;h=8e4e093e6d140f1316953437fdde4e826f5cfd98

it adds extra mapping from the whole kernel when kernel is loaded above 1G.
from round_down(_text, 2M) to round_up(_end -1, 2M).

Do you mean we need to add extra mapping for realmode_data, cmdline,
ramdisk too? (not include setup_data, and it is accessed via
early_ioremap later).

but if the user memmap to exclude some page, we will still need to
relocate the ramdisk.

Yinghai
