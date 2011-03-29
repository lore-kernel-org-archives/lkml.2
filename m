Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1C2ETE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:19:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48160 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1C2ETC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=eRrfGavkQ7pwbthQC6UvopIAuzdmDYNh1ZWBofqGpV9klR2K1W+u9gkjH7IpNCpAWd
         F+ILI+5+Akxlbgtd8nCOllP9rmCSx52YiUoVBmH1B2f9Nz89I6YMVpN/KgXZUqI5YJgs
         P65FnKULSxjrZMdvztasOY359XRNrO5MvGKUw=
MIME-Version: 1.0
In-Reply-To: <20110329040939.GA32764@redhat.com>
References: <20110329040939.GA32764@redhat.com>
Date: Tue, 29 Mar 2011 12:19:01 +0800
Message-ID: <AANLkTinOQ1yXqJJVo=k9YSM=xG2Fg2GSAE8z2O3dGsME@mail.gmail.com>
Subject: Re: vma corruption in today's -git
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:09 PM, Dave Jones <davej@redhat.com> wrote:
> Running a kernel that I built from a git pull from this afternoon,
> I ran a barrage of stress tests, including some of the new syscall fuzzing
> work that I've been working on.  Everything seemed just fine, except that
> after I had stopped running everything, loadavg was still at 6, with
> top showing kworker processes running at high % of cpu.
>
> I ran perf top, and got this ..
>
>  BUG: unable to handle kernel paging request at fffffffffffffff3
>  IP: [<ffffffff8118d3e9>] vma_stop.clone.3+0x18/0x33

Should be fixed by:

commit 76597cd31470fa130784c78fadb4dab2e624a723
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Mar 27 19:09:29 2011 -0700

    proc: fix oops on invalid /proc/<pid>/maps access

    When m_start returns an error, the seq_file logic will still call m_stop
    with that error entry, so we'd better make sure that we check it before
    using it as a vma.

    Introduced by commit ec6fd8a4355c ("report errors in /proc/*/*map*
    sanely"), which replaced NULL with various ERR_PTR() cases.

    (On ia64, you happen to get a unaligned fault instead of a page fault,
    since the address used is generally some random error code like -EPERM)

    Reported-by: Anca Emanuel <anca.emanuel@gmail.com>
    Reported-by: Tony Luck <tony.luck@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Américo Wang <xiyou.wangcong@gmail.com>
    Cc: Stephen Wilson <wilsons@start.ca>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
