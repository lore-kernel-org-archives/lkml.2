Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2CaSPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:15:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59361 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab2CaSOb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120331044030.GB3077@pinguin>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-9-git-send-email-wad@chromium.org>
	<20120331044030.GB3077@pinguin>
Date: Sat, 31 Mar 2012 13:14:25 -0500
Message-ID: <CABqD9hZu+yVVPWqcrOTo0e2gKuPn-ZKP403WKUMCqVL9zHs4uA@mail.gmail.com>
Subject: Re: [PATCH v17 08/15] seccomp: add system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Vladimir Murzin <murzin.v@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/30 Vladimir Murzin <murzin.v@gmail.com>:
> Hi Will,
>
> On Thu, Mar 29, 2012 at 03:01:53PM -0500, Will Drewry wrote:
>
> snipped
>
>> +
>> +/* Limit any path through the tree to 256KB worth of instructions. */
>> +#define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
>> +
>> +static void seccomp_filter_log_failure(int syscall)
>> +{
>> +     int compat = 0;
>> +#ifdef CONFIG_COMPAT
>> +     compat = is_compat_task();
>> +#endif
>> +     pr_info("%s[%d]: %ssystem call %d blocked at 0x%lx\n",
>> +             current->comm, task_pid_nr(current),
>> +             (compat ? "compat " : ""),
>> +             syscall, KSTK_EIP(current));
>> +}
>
> snipped
>
>> +/**
>> + * seccomp_attach_user_filter - attaches a user-supplied sock_fprog
>> + * @user_filter: pointer to the user data containing a sock_fprog.
>> + *
>> + * Returns 0 on success and non-zero otherwise.
>> + */
>> +long seccomp_attach_user_filter(char __user *user_filter)
>> +{
>> +     struct sock_fprog fprog;
>> +     long ret = -EFAULT;
>> +
>> +#ifdef CONFIG_COMPAT
>> +     if (is_compat_task()) {
>> +             struct compat_sock_fprog fprog32;
>> +             if (copy_from_user(&fprog32, user_filter, sizeof(fprog32)))
>> +                     goto out;
>> +             fprog.len = fprog32.len;
>> +             fprog.filter = compat_ptr(fprog32.filter);
>> +     } else /* falls through to the if below. */
>> +#endif
>> +     if (copy_from_user(&fprog, user_filter, sizeof(fprog)))
>> +             goto out;
>> +     ret = seccomp_attach_filter(&fprog);
>> +out:
>> +     return ret;
>> +}
>
> Do we really need to surround is_compat_task() with CNFIG_COMPAT?
> It seems that this case has already handled in compat.h [1]
>
> [1] http://lxr.linux.no/#linux+v3.3/include/linux/compat.h#L566

In log_failure, it's not needed at all, but that function disappears
in a subsequent patch in the series that converts over to using the
auditing framework.  For the next use of CONFIG_COMPAT, it is more
important for guarding the compat_sock_fprog struct (which isn't
doubly defined) rather than the is_compat_task.

Thanks!
will
