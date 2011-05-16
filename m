Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1EPPnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:43:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36743 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab1EPPnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=j9GKWh+RS9jQj33IYQnMRObkwpPOJNJ96vFeAenhG7GGBwO0OwWcNT4CwNWeZzvDVG
         N7YhsVqEMmZLHA0gvYeheCPJpOTSuv2myJhWEEO+eFe4Ycz67Kcgw9vyqDXvDrDww3Yh
         jjfc21axR2WfW25NvsjUcorydcRecifRdNVo0=
MIME-Version: 1.0
In-Reply-To: <1305329059-2017-5-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 16 May 2011 17:42:52 +0200
Message-ID: <BANLkTikP==HkDSG1oKcfSKAhrWOXRqGF5w@mail.gmail.com>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 1:24 AM, Andi Kleen <andi@firstfloor.org> wrote:
> +/*
> + * POSIX sysconf subset. Some programs need this in relatively fast paths
> + * and /proc is too slow for them.
> + *
> + * Note this is only a subset of the values supported by POSIX.
> + * We assume the C library handles the others.
> + */
> +SYSCALL_DEFINE1(sysconf, int, name)
> +{
> +       switch (name) {
> +       case _SC_ARG_MAX:
> +               return rlimit_or(RLIMIT_STACK, ARG_MAX*ARG_MAX_FACTOR) /
> +                               ARG_MAX_FACTOR;
> +
> +       case _SC_CHILD_MAX:
> +               return rlimit_or(RLIMIT_NPROC, max_threads);
> +
> +       case _SC_CLK_TCK:
> +               return HZ;
> +
> +       case _SC_SEM_NSEMS_MAX:
> +               return current->nsproxy->ipc_ns->sem_ctls[1];
> +
> +       case _SC_OPEN_MAX:
> +               return rlimit_or(RLIMIT_NOFILE, sysctl_nr_open);
> +
> +       case _SC_SIGQUEUE_MAX:
> +               /* or fallback based on memory? */
> +               return rlimit_or(RLIMIT_SIGPENDING, INT_MAX);
> +
> +       case _SC_UIO_MAXIOV:
> +               return UIO_MAXIOV;
> +
> +       case _SC_PAGESIZE:
> +               return PAGE_SIZE;
> +
> +       case _SC_SYMLOOP_MAX:
> +               return SYMLOOP_MAX;
> +
> +       case _SC_PHYS_PAGES:
> +               return totalram_pages;
> +
> +       case _SC_AVPHYS_PAGES:
> +               return nr_free_pages();
> +
> +       case _SC_NPROCESSORS_CONF:
> +               return num_possible_cpus();
> +
> +       case _SC_NPROCESSORS_ONLN:
> +               return num_online_cpus();
> +
> +       case _SC_NGROUPS_MAX:
> +               return NGROUPS_MAX;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +}

...and libc will start making many such calls in a row in order to retrieve
a dozen of such values.

It's rather inefficient to return just one word.
Try to return more data per call.

Pass a pointer to the result struct and its length.
Future-proof API, such as using generously wide data types,
passing "version of struct" input parameter to facilitate incompatible
future changes, etc.

Pass a bit flag variable which says what data you want to have:
all-zeros means "give me only the cheap stuff which needs no calculations",
such as NGROUPS_MAX.
If SYSCONF_NPROCESSORS_ONLN bit is set, also return num_online_cpus().
If SYSCONF_AVPHYS_PAGES bit is set, return nr_free_pages().
Etc.

Maybe it makes sense to pass bits in the struct rather than in a parameter,
to not get caught by "we ran out of bits in the word!" problem later.

-- 
vda
