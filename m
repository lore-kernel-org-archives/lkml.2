Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2KUAl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:41:29 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64526 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2KUAl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:41:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121121002412.1c957ad2@pyramind.ukuu.org.uk>
References: <20121120204238.GA19554@www.outflux.net>
	<20121120211312.57f1b63d@pyramind.ukuu.org.uk>
	<CAGXu5jJv58UGwsWM=+ZSnaNpymh6Sm6xSjc0JuT+QoZ9U2++rw@mail.gmail.com>
	<20121120235353.3092c8d2@pyramind.ukuu.org.uk>
	<CAGXu5jKS1OQPxiBPewtfOTJqntOMFnw4n08-zP7=87nD+z6eSg@mail.gmail.com>
	<20121121002412.1c957ad2@pyramind.ukuu.org.uk>
Date: Tue, 20 Nov 2012 16:41:27 -0800
X-Google-Sender-Auth: Wu_iJnI4QcB0aiI5xLaDK5VsNzI
Message-ID: <CAGXu5jLeo2Qcn8x=CtBXoNaz7UsZaZTbhjFevqon2JbBhm+Otw@mail.gmail.com>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 4:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > You just broke my bullshitometer
>> >
>> > It's a single syscall from your init binary, its microseconds.
>>
>> Whatever, I still see it as a needless inefficiency.
>
> As opposed to adding permanent kernel code and having to change the
> setting by recompilation, and not being able to deploy this with older
> kernels.

Some organizations only support their single "current" kernel, and
always move forward.

> Right now you can add one call to your user space and it just works, with
> old kernels, with new kernels, with Android etc. You think its *more
> efficient* to add permanently loaded kernel hacks.

I'm not interested in those things. That said, if it genuinely agreed
that this clear lack of security best-practice (W^X) in the kernel
isn't the place to fix it, I'll move on. There are still legacy video
drivers and things that can't operate with this configuration, but the
kernel mounting devtmpfs shouldn't _require_ userspace to clean up
after a buggy kernel.

> Wrong. Big time wrong. A page is 4096 bytes, your change is probably
> about 8. So 1 in 512 builds will see an extra page of kernel space used
> assuming an even distribution. For each of those users the moment they've
> had a few page faults your solution is *less* efficient, and the moment
> they've paged one page because of having less memory your solution has
> become vastly less efficient.

My patch doesn't change the code size there after the most recent
change to use a constant value again, so the only change I can see
would be if someone built with /proc/config.gz which would show the
new config.

> So can we put the crap about efficiency away please. This basically reads
> like
>
> "Mummy, the mount syscall looks complicated let me hack everyones kernel
>  with a crass extra Kconfig option because I'm crap"

I think you just switched from calling my code crap to calling me crap.

>> > You don't want to stop mmap with PROT_EXEC on /dev/mem as that breaks a
>> > load of stuff, you want to stop people adding stuff to that file system
>> > and executing it.
>>
>> Well, initially the latter, yes. But as it turns out, setting noexec
>> also stops PROT_EXEC on /dev/mem. Since the systems I'm building for
>> all use KMS, there's no need to execute regions of /dev/mem (e.g. VESA
>> BIOS init, etc).
>
> I have news for you: this is the upstream kernel, you specific personal
> needs should not define what is good design - this isn't GNOME.

Heh, I support your dig at GNOME, but refute this being a "specific
personal need". Best-practices are clear here. The only reason the
kernel hasn't been doing it is fear of breaking legacy video drivers.

> If you block exec on anything but devices then all is happy. You could
> even block it on anything but specific devices. At that point you could
> get rid of the config option and make it more useful.

Security is layers, and is never perfect. We already do a fair bit of
process confinement, but this change seemed to be clear low-hanging
fruit.

> We don't need extra confusion Kconfig options, we don't need extra kernel
> code combinations to fail to maintain. Your patch offers *NO* feature
> advantages over the existing kernel.

I disagree. It allows a system builder to opt-in to correcting a
kernel flaw introduced by the need to support legacy devices in the
case where an initramfs isn't used.

> NAK

I don't understand why you're so violently opposed to letting an
arguably flawed constant get fixed. I'm not even asking for this to be
on by default.

-Kees

-- 
Kees Cook
Chrome OS Security
