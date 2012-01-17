Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2AQUed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:34:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35807 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2AQUec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:34:32 -0500
MIME-Version: 1.0
In-Reply-To: <9642e1197443efe9716f418c4883489e.squirrel@webmail.greenhost.nl>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
	<CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
	<addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
	<CABqD9hbBu8cEbArJWhSr-exFUDrnLSXskP1RrTATBczH2MYzFA@mail.gmail.com>
	<293e9587acd158b91d7d1793c7e16f7c.squirrel@webmail.greenhost.nl>
	<CABqD9hY2Uhc2Gzy05+Q+_NrZAq+126+avAO0Kd81zDnEi3EXjQ@mail.gmail.com>
	<9642e1197443efe9716f418c4883489e.squirrel@webmail.greenhost.nl>
Date: Tue, 17 Jan 2012 12:34:31 -0800
X-Google-Sender-Auth: 94fzApIXHoNIaw18mEpiDyJVo_M
Message-ID: <CAGXu5jJvjq5f7Qw1ADh120jAtUsH+L4BW6CY+uaD7GFN53nPBw@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Kees Cook <keescook@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:46 PM, Indan Zupancic <indan@nul.nu> wrote:
> So call it once and store the value in a long. Then copy the low half
> to the right place and then the upper half when on 64 bits. It may not
> look too pretty, but the compiler should be able to optimise almost all
> overhead away and end up with 6 (or 12) int copies. Something like this:
>
> struct bpf_data {
>        uint32 syscall_nr;
>        uint32 arg_low[MAX_SC_ARGS];
>        uint32 arg_high[MAX_SC_ARGS];
> };
>
> void fill_bpf_data(struct task_struct *t, struct pt_regs *r, struct bpf_data *d)
> {
>        int i;
>        unsigned long arg;
>
>        d->syscall_nr = syscall_get_nr(t, r);
>        for (i = 0; i < MAX_SC_ARGS; ++i){
>                syscall_get_arguments(t, r, i, 1, &arg);
>                d->arg_low[i] = arg;
>                d->arg_high[i] = arg >> 32;
>        }
> }

If this turns out to be expensive, it might be possible to break it up
and load the arguments on demand (and cache them); i.e. have
load_pointer() or similar notice when it is about to access something
other than bpf_data.syscall_nr.

-Kees

-- 
Kees Cook
ChromeOS Security
