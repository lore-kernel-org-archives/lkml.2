Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228Ab2CAB50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:57:26 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53284 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965244Ab2CAB5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:57:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of surovegin@google.com designates 10.229.76.195 as permitted sender) smtp.mail=surovegin@google.com; dkim=pass header.i=surovegin@google.com
MIME-Version: 1.0
In-Reply-To: <20120301.105126.193682835.d.hatayama@jp.fujitsu.com>
References: <CANrfoUXd4L2bjBO+L8ZBCkc1dfnZahn39sB25zsrUMqGA5zY5A@mail.gmail.com>
 <20120301013200.GF16483@verge.net.au> <CANrfoUVTSh6jWckz2jt9+X6E6FSPL5OwqWNrcXchbo1BwkCLgw@mail.gmail.com>
 <20120301.105126.193682835.d.hatayama@jp.fujitsu.com>
From: Eugene Surovegin <surovegin@google.com>
Date: Wed, 29 Feb 2012 17:56:54 -0800
Message-ID: <CANrfoUXGyjXeWSHWXzTq1r9Trd8riSWkF4+DoejJXRBnHkDPvw@mail.gmail.com>
Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: horms@verge.net.au, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com, ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 5:51 PM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> From: Eugene Surovegin <surovegin@google.com>
> Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
> Date: Wed, 29 Feb 2012 17:39:55 -0800
>
>> On Wed, Feb 29, 2012 at 5:32 PM, Simon Horman <horms@verge.net.au> wrote:
>>> On Wed, Feb 29, 2012 at 05:23:10PM -0800, Eugene Surovegin wrote:
>>>> On Wed, Feb 29, 2012 at 5:18 PM, Simon Horman <horms@verge.net.au> wrote:
>>>>
>>>> > On Wed, Feb 29, 2012 at 09:21:23AM -0800, Eugene Surovegin wrote:
>>>> > > Per-CPU allocations are not guaranteed to be physically contiguous.
>>>> > > However, kdump kernel and user-space code assumes that per-CPU
>>>> > > memory, used for saving CPU registers on crash, is.
>>>> > > This can cause corrupted /proc/vmcore in some cases - the main
>>>> > > symptom being huge ELF note section.
>>>> > >
>>>> > > Force page alignment for note_buf_t to ensure that this assumption holds.
>>>> >
>>>> > Ouch. I'm surprised there is an allocation on crash, perhaps
>>>> > it could at least be done earlier? And am I right in thinking
>>>> > that this change increases the likely hood that the allocation
>>>> > could fail?
>>>> >
>>>>
>>>> I'm not following. This allocation is done on start-up, not on crash.
>>>> If you cannot allocate this much memory on system boot, I'm not sure what
>>>> else you can do on this system....
>>>
>>> Sorry, my eyes deceived me. You are correct and I agree.
>>>
>>> Is it the case that note_buf_t is never larger than PAGE_SIZE?
>>> If so I your patch looks good to me.
>>
>> Currently, maximum note size is hardcoded in kexec-tools to 1024
>> (MAX_NOTE_BYTES).
>> Usually it's way less. IIRC on x86_64 it's 336 bytes.
>>
>
> This is elf_prstatus and I guess it's mostly equal to registers.
>
> crash> p sizeof(struct elf_prstatus)
> $3 = 336
> crash> ptype struct elf_prstatus
> type = struct elf_prstatus {
>    struct elf_siginfo pr_info;
>    short int pr_cursig;
>    long unsigned int pr_sigpend;
>    long unsigned int pr_sighold;
>    pid_t pr_pid;
>    pid_t pr_ppid;
>    pid_t pr_pgrp;
>    pid_t pr_sid;
>    struct timeval pr_utime;
>    struct timeval pr_stime;
>    struct timeval pr_cutime;
>    struct timeval pr_cstime;
>    elf_gregset_t pr_reg; <-- this
>    int pr_fpvalid;
> }
>
> What kinds of architecture does have so many registers? It's just my
> interest. Or possibly other kinds of notes is written here?

I'm not sure about other archs, but we don't write there anything
except for 'elf_prstatus' and sentinel "final" note.

--
Eugene
