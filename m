Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2C1OII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab2C1OIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:08:06 -0400
Date: Wed, 28 Mar 2012 10:01:15 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        rostedt@goodmis.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org, mjw@redhat.com
Subject: Re: [PATCH 04/15] perf: Add ability to dump user regs
Message-ID: <20120328140115.GE4826@redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com> <1332938158-5244-5-git-send-email-jolsa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332938158-5244-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri -

On Wed, Mar 28, 2012 at 02:35:47PM +0200, Jiri Olsa wrote:
> [...]
> The register value here are those of the user space context as
> it was before the user entered the kernel for whatever reason
> (syscall, irq, exception, or a PMI happening in userspace).
> [...]

As I understand the situation, there is a complication here that you
haven't accounted for.  Upon a normal syscall entry to the kernel, not
all user registers are saved explicitly for such easy retrieval.  The
others may be spilled to the stack by gcc during the various sys_*
functions or elsewhere.  It turns out that some of these saved
registers are sometimes necessary to accomplish a user-space unwind.

To recover these registers at run time, we found that the kernel stack
itself has to be partially unwound - and not via frame pointers, but
the full dwarf unwind/cfi machinery.  This RFC code does not appear
aware of the difference between the explicitly saved and the
incidentally-spilled registers, and thus may accidentally pass garbage
data to perf userspace.  Correcting this could require a kernel-space
libunwind.

- FChE
