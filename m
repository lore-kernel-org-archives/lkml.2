Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2B0UPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:15:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34963 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246Ab2B0UPl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:15:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.182.155.68 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <CABqD9hbtFDU_vgBOajG2jJxQoHubcwYWJuHPLjgZkZyjGkQ2uQ@mail.gmail.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-6-git-send-email-wad@chromium.org>
	<20120227170922.GA10608@redhat.com>
	<CABqD9hbtFDU_vgBOajG2jJxQoHubcwYWJuHPLjgZkZyjGkQ2uQ@mail.gmail.com>
Date: Mon, 27 Feb 2012 12:15:38 -0800
X-Google-Sender-Auth: hVWI9r70jetrHVp0DtsfQoLRkds
Message-ID: <CAGXu5j+TzwCHpX6sGkQj4QDeZTR=MkGGaXawzAYbxCJQoT_9aQ@mail.gmail.com>
Subject: Re: [PATCH v11 06/12] seccomp: add system call filtering using BPF
From: Kees Cook <keescook@chromium.org>
To: Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 11:54 AM, Will Drewry <wad@chromium.org> wrote:
> On Mon, Feb 27, 2012 at 11:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 02/24, Will Drewry wrote:
>>> +static struct seccomp_filter *get_seccomp_filter(struct seccomp_filter *orig)
>>> +{
>>> +     if (!orig)
>>> +             return NULL;
>>> +     /* Reference count is bounded by the number of total processes. */
>>> +     atomic_inc(&orig->usage);
>>> +     return orig;
>>> +}
>>> ...
>>> +void copy_seccomp(struct seccomp *child, const struct seccomp *parent)
>>> +{
>>> +     /* Other fields are handled by dup_task_struct. */
>>> +     child->filter = get_seccomp_filter(parent->filter);
>>> +}
>>
>> This is purely cosmetic, but imho looks a bit confusing.
>>
>> We do not copy seccomp->mode and this is correct, it was already copied
>> implicitely. So why do we copy ->filter? This is not "symmetrical", afaics
>> you can simply do
>>
>>        void copy_seccomp(struct seccomp *child)
>>        {
>>                if (child->filter)
>>                        atomic_inc(child->filter->usage);
>>
>> But once again, this is cosmetic, feel free to ignore.
>
> Right now get_seccomp_filter does the NULL check, so really this could
> be reduced to adding an external get_seccomp_filter(p->seccomp.filter)
> in place of copy_seccomp().
>
> As to removing the extra arg, that should be fine since the parent
> can't drop its refcount when copy_seccomp is called.  At the very
> least, I can make that change so it reads more cleanly.

I had various conflicting thoughts while looking over the refcounting:

- get_seccomp_filter is defined static, and has a single caller: copy_seccomp()
- put isn't static, and has a single caller: kernel/fork.c:free_task()
- having only get_/put_ touch ->usage seems cleaner to me
- seccomp_attach_filter touches ->usage without get_seccomp_filter
- having the initializing routine use atomic_set(..., 1) is a common pattern

In a fit of extreme bike-shedding, I can't decide which is more sensible:

- rename put_seccomp_filter to free_seccomp_filter and inline the
get_seccomp_filter logic into copy_seccomp().

or

- create a wrapper for put_seccomp_filter named free_seccomp_filter so
that get_/put_ can both be static.

-Kees

-- 
Kees Cook
ChromeOS Security
