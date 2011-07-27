Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1G0RFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:05:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40631 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1G0RFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110727165844.GA8064@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu> <20110727145745.GA11872@dumpdata.com>
 <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com>
 <20110727153015.GA16688@dumpdata.com> <CAObL_7GWGx4rYJFLpucEX=ozNpk+5ipyq0=vw16xcGetEXSuGQ@mail.gmail.com>
 <20110727154316.GA16909@dumpdata.com> <CAObL_7FncQ7DdNf2igFZW=ZzPFQLO3Vvp1c_y5EajA_KTt8iOg@mail.gmail.com>
 <20110727165844.GA8064@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 27 Jul 2011 13:05:18 -0400
X-Google-Sender-Auth: CHwKRG_uQIhhwJKI7xWq517hspI
Message-ID: <CAObL_7F4pqWGAFgrG8KiwCW4X+BOgvFfsdHNfkhhmVDqMOSuvQ@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, keir.xen@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:58 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> >> $ test_vsyscall test
>> >> Testing gettimeofday...
>> >>   vDSO offset = 0.000001s
>> >>   vsyscall offset = 0.000001s
>> >>
>> >> Testing time...
>> >>   vDSO offset = 0
>> >>   vsyscall offset = 0
>> >> Testing getcpu...
>> >>   ok!  cpu=6 node=0
>
>> I bet if you pull a new copy or remove -mavx from Makefile it will
>> work.  I got a grossly hacked-up Xen domU booted and everything seems
>> to work.
>
> It did. Both Dom0 and DomU work on AMD and Intel.
>
> In regards to the last pv-ops patch - is there no better way? The reason I am asking
> is the pv-ops hook is just a bandaid for the problem. Is the Xen syscall suppose to
> be doingsomething extra with the stack perhaps?
>

The Xen code in question is:

restore_all_guest:
        ASSERT_INTERRUPTS_DISABLED
        RESTORE_ALL
        testw $TRAP_syscall,4(%rsp)
        jz    iret_exit_to_guest

        addq  $8,%rsp
        popq  %rcx                    # RIP
        popq  %r11                    # CS
        cmpw  $FLAT_USER_CS32,%r11
        popq  %r11                    # RFLAGS
        popq  %rsp                    # RSP
        je    1f
        sysretq
1:      sysretl


So with VCGF_in_syscall set, the ireq hypercall will return via
sysretq if the saved CS is __USER_CS or FLAT_USER_CS64.  This is
faster than iretq.

The hypervisor doesn't allow the guest OS to override the values in
MSR_STAR, so FLAT_USER_CS64 gets returned to userspace.  And sysretq
is probably much faster than iretq, so unsetting VCGF_in_syscall is
probably a bad idea.

The ideal solution would be to allow the kernel to change MSR_STAR,
but this would require changing the hypervisor and the kernel.

--Andy
