Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab0GHXQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:16:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35002 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab0GHXQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U9MRPyniIRgXba3dd67VGL5C6K6cgylRyh/r9qkyuhecZsAOQ8WgzAnV6jkhhEcLL9
         aGSZJ0QA6Yq6jZkqSFyn3G8yKY/0YL6/zlOyg3Yqh4rhLL8JE4rC/l3KsHzW5lx4uhYk
         azbINyaPiC+Bq+a5OCC+toUH4Ml08VRfnTnPA=
MIME-Version: 1.0
In-Reply-To: <20100708152656.34cfd24f.akpm@linux-foundation.org>
References: <1278418937.1949.22.camel@jaunty>
	<20100708152656.34cfd24f.akpm@linux-foundation.org>
Date: Fri, 9 Jul 2010 09:16:07 +1000
Message-ID: <AANLkTimKFMWzd3hVS7TBRTHkppgZF-ky4bGFDOeDBbhk@mail.gmail.com>
Subject: Re: 2.6.35-rc4 Graphics performance issue and freeing invalid memtype 
	messages on boot.
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graphics hardware is NV250 type card.

Some quick testing last night showed this patch fixed both the boot
messages and graphics performance.
[tip:x86/urgent] rbtree: Undo augmented trees performance damage and regression
http://marc.info/?l=linux-kernel&m=127833440902862&w=2


On Fri, Jul 9, 2010 at 8:26 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> (Rafael, Maciej: two probably-separate post-2.6.34 regressions here)
>
> On Tue, 06 Jul 2010 22:22:17 +1000
> Andrew Hendry <andrew.hendry@gmail.com> wrote:
>
>>
>> Some extra messages when booting with -rc4. Didn't get them in -rc3.
>> [    1.387013] swapper:1 freeing invalid memtype bf788000-bf789000
>> [    1.387409] swapper:1 freeing invalid memtype bf789000-bf78a000
>> [    5.999675] modprobe:548 freeing invalid memtype d0000000-d0040000
>> [    6.068347] modprobe:548 freeing invalid memtype d0140000-d0150000
>> [    6.068647] modprobe:548 freeing invalid memtype d0150000-d0160000
>> [    6.069661] modprobe:548 freeing invalid memtype d0170000-d01f0000
>> [    6.085969] modprobe:548 freeing invalid memtype d01f0000-d0200000
>> [    6.087673] modprobe:548 freeing invalid memtype d0210000-d0220000
>> [    6.087900] modprobe:548 freeing invalid memtype d0220000-d0230000
>> [    6.088092] modprobe:548 freeing invalid memtype d0230000-d0240000
>> [    6.088317] modprobe:548 freeing invalid memtype d0240000-d0250000
>
> hrmpf, one of those wonderful messages where neither it nor its source
> code give you any clue regarding what caused it nor how to fix it.
>
> please, apply this:
>
> --- a/arch/x86/mm/pat.c~a
> +++ a/arch/x86/mm/pat.c
> @@ -359,7 +359,7 @@ int free_memtype(u64 start, u64 end)
>        entry = rbt_memtype_erase(start, end);
>        spin_unlock(&memtype_lock);
>
> -       if (!entry) {
> +       if (WARN_ON(!entry)) {
>                printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
>                        current->comm, current->pid, start, end);
>                return -EINVAL;
>
>
> and let's at least see where it's coming from.
>
>> Not sure if its related, but also have a noticeable performance issue with graphics under rc4.
>> Dragging and resizing windows, screen updates, and jumpy cursor are all slow.
>> Playing a full screen video under vlc gets only 1-2 frames per second, but plays fine under rc3.
>> Tested a kernel compile, it was roughly the same.
>> Userspace is ubunutu 10.04 64bit.
>>
>> Any hints? Otherwise will start a bisect tomorrow night.
>>
>> Config attached, lspci, rc3 and rc4 boot messages below:
>
> What graphics hardware are you using?
>
>
