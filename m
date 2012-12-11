Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2LKRjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:39:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59771 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2LKRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:39:04 -0500
Message-ID: <50C76F9E.4080001@zytor.com>
Date: Tue, 11 Dec 2012 09:38:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com> <CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com> <50C6AB63.9070008@zytor.com> <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com> <50C6D3DF.3030209@zytor.com> <CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com> <20121211145716.GB8873@liondog.tnic> <CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com> <50C763C2.5020603@zytor.com> <CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com> <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
In-Reply-To: <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 09:15 AM, Yinghai Lu wrote:
>
> No, that is not right place. initrd could be loaded anywhere like way
> high by bootloader.
>

Only *after* your changes... the current protocol doesn't allow that.

Anyway, we need to deal with it, see below.

> to make code simple, we should have following sequence in setup_arch
>
> early_ioremap_init()
> early_update_microcode()...
> early_cpu_init()
>
> early_update_microcode could use early_ioremap to access initrd ramdisk area.

We need there to be as little machinery as possible, *especially* 
machinery involving paging, before the microcode gets loaded.  I would 
prefer if we could load the microcode before enabling paging at all, but 
that would mean running it in 32-bit mode which really isn't practical, 
so we have to deal with scaffolding here.

We really should cycle the paging off after this happens, but that 
really isn't possible until the trampoline gets set up later, since we 
may not have any other place to stand in low memory.

This complexity is the cost of allowing the kernel to load above the 4G 
mark.

Now, to be solution-focused...

I quite frankly don't see anything in early_remap_init() which can't be 
done at compile time.  All it does is set up some data structures which 
could just as well be statically generated, and then it would be 
available from the very beginning and thus usable for this purpose. Xen 
might need extra song & dance, but that can be done in Xen-specific code.

The Xen-induced (and since then expanded by others) 32-bit braindamage 
of having __FIXADDR_TOP be a variable is a huge problem, obviously, but 
it doesn't affect 64 bits which is what we're dealing with here.  There 
*is* a way to fix it on 32 bits without breaking Xen, which is to move 
the fixmap to the beginning of kernel virtual space instead of the end 
-- this boundary is known at compile time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

