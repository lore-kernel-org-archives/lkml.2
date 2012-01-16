Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2APUPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:15:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33933 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2APUPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120116183730.GB21112@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
	<CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
	<20120113173153.GA24273@redhat.com>
	<CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
	<CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
	<20120116183730.GB21112@redhat.com>
Date: Mon, 16 Jan 2012 14:15:10 -0600
Message-ID: <CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/13, Will Drewry wrote:
>>
>> On Fri, Jan 13, 2012 at 1:01 PM, Will Drewry <wad@chromium.org> wrote:
>> > On Fri, Jan 13, 2012 at 11:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >>
>> >> Me too. I see no point in using user_regs_struct.
>> >
>> > I'll rev the change to use pt_regs and drop all the helper code.  If
>> > no one says otherwise, that certainly seems ideal from a performance
>> > perspective, and I see pt_regs exported to userland along with ptrace
>> > abi register offset macros.
>>
>> On second thought, pt_regs is scary :)
>>
>> From looking at
>>   http://lxr.linux.no/linux+v3.2.1/arch/x86/include/asm/syscall.h#L97
>> and ia32syscall enty code, it appears that for x86, at least, the
>> pt_regs for compat processes will be 8 bytes wide per register on the
>> stack.  This means if a self-filtering 32-bit program runs on a 64-bit host in
>> IA32_EMU, its filters will always index into pt_regs incorrectly.
>
> Yes, thanks, I forgot about compat tasks again. But this is easy, just
> we need regs_64_to_32().

Yup - we could make the assumption that is_compat_task is always
32-bit and the pt_regs is always 64-bit, then copy_and_truncate with
regs_64_to_32.  Seems kinda wonky though :/

> Doesn't matter. I think Indan has a better suggestion.

I disagree, but perhaps I'm not fully understanding!

Thanks!
will
