Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1DLWol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:44:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab1DLWok convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimfRrFTkZqqekgs3e6OgqSc2AH9NQ@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
 <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com> <20110412182809.GA1218@redhat.com>
 <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com> <20110412192059.GA14360@redhat.com>
 <BANLkTimJgx_x=0bpBDWaUkJgZPYs3_iwsg@mail.gmail.com> <BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
 <BANLkTikoDELrA-RtA9BLm64mfoPgdADR0Q@mail.gmail.com> <BANLkTi=HyK+8DhJS3db0j2fefdOjwVMN3w@mail.gmail.com>
 <BANLkTinMAGmdEDviRwZ1-mxrAAe_WK5jvg@mail.gmail.com> <BANLkTinjGkbBMUo7MQ2Dg2yDwQ932qJ7rQ@mail.gmail.com>
 <BANLkTikRH0q3RyP_CORXjAX34-br4pqf=A@mail.gmail.com> <BANLkTinp6gaPrjQF6eXk4WHa653GShDuYQ@mail.gmail.com>
 <BANLkTinzz5TuGPAMVY39V3D0x+PgKr7eGg@mail.gmail.com> <BANLkTimfRrFTkZqqekgs3e6OgqSc2AH9NQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 15:43:48 -0700
Message-ID: <BANLkTim8BKz5suhbS9CdV8EKESiC-=+J7g@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 3:30 PM, Robert Święcki <robert@swiecki.net> wrote:
>
> btw, here might be another path which hits this (at least I think so).

So both mprotect and mlock will do the same "split/merge vma's as
necessary", but neither of them should actually ever _expand_ a
mapping or change the vm_pgoff of a vma (except to fix up the pgoff as
a vma is split).

So what I think is happening is that a previous vma operation (like
the mremap or the stack expansion) did the expand and created a vma
with a wrapping vm_pgoff. But nothing bad happened, because nobody
really _cares_ about the wrapping until later, when we split the vma.

So I think (and hope) that your mprotect issue is exactly the same as
your mlock issue, and that the deeper problem was the earlier stack
expansion.

That said, I'm not at all going to guarantee that it's about stack
expansion. There might be something else going on, and the stack
expansion was just the first thing that I could think of as doing
something similar to mremap(), causing a wrapping vm_pgoff.

                                               Linus
