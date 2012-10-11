Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab2JKNoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:44:03 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48771 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2JKNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <87txu17lss.fsf@rustcorp.com.au>
References: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
 <87txu17lss.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 11 Oct 2012 10:43:38 -0300
Message-ID: <CAMOw1v6Cn4VODJ1yEaRwMusf-zUeNjKOYegRkdsKyaqFkjtHRw@mail.gmail.com>
Subject: Re: [Request for review] Revised delete_module(2) manual page
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-man <linux-man@vger.kernel.org>,
        Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 11, 2012 at 12:02 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> Hello Kees, Rusty,
>>
>> The current delete_module(2) page is severely out of date (basically,
>> its content corresponds to 2.4 days, and was even pretty thin in
>> covering that). So, I took a shot at revising the page to Linux 2.6+
>> reality. Would it be possible that you could review it?
>
> OK.  Main suggestion is that I discussed with Lucas removing the
> !O_NONBLOCK case.  It's not supported by modprobe -r, and almost
> unheard-of for rmmod (it's --wait).
>
> In practice, people want the unload-or-fail semantics, or the
> force-unload semantics.


I'm all for removing this option. My idea was to complain loudly if
user tries to use it:
http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=commit;h=8447b865aaac9139485dccdcc576725ddec2e7fa

But maybe it's good to just remove it altogether


>
>> Otherwise, by default,
>> .BR delete_module ()
>> marks a module so that no new references are permitted.
>> If the module's reference count
>> (i.e., the number of processes currently using the module) is nonzero,
>> it then places the caller in an uninterruptible sleep
>> state until all reference count is zero,
>> at which point the call unblocks.
>> When the reference count reaches zero, the module is unloaded.
>
> So this should be inverted:
>
>         Otherwise (assuming O_NONBLOCK, see flags below), if the
>         module's reference count (i.e., the number of processes
>         currently using the module) is nonzero, the call fails.
>
>> The
>> .IR flags
>> argument can be used to modify the behavior of the system call.
>
> It is usually set to O_NONBLOCK, which may be required in future kernel
> versions (see NOTES).
>
>> The following values can be ORed in this argument:
>> .TP
>> .B O_TRUNC
>> .\"   KMOD_REMOVE_FORCE in kmod library
>> Force unloading of the module, even if the following conditions are true:
>> .RS
>> .IP * 3
>> The module has no
>> .I exit
>> function.
>> By default, attempting to unload a module that has no
>> .I exit
>> function fails.
>> .IP *
>> The reference count for (i.e., the number of processes currently using)
>> this module is nonzero.
> ...
>> .IP
>> Using this flag taints the kernel (TAINT_FORCED_RMMOD).
>> .IP
>> .IR "Using this flag is dangerous!"
>> If the kernel was not built with
>> .BR CONFIG_MODULE_FORCE_UNLOAD ,
>> this flag is silently ignored.
>
> NOTES:
>
> If O_NONBLOCK is not set, then the kernel may enter uninterruptible
> sleep until the module reference count reaches zero.  This is not
> generally desirable, so this flag may be compulsory in future kernel
> configurations.

What do you think? Mark as deprecated now and remove when kernel
removes it? Or remove now?


Lucas De Marchi
