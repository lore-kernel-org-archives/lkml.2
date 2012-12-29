Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2L2LJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 06:09:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44003 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2L2LJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 06:09:26 -0500
Date: Sat, 29 Dec 2012 12:09:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Subject: Re: how to look for source code in kernel
Message-ID: <20121229110928.GA17811@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	anish singh <anish198519851985@gmail.com>,
	amit mehta <gmate.amit@gmail.com>,
	Henrique Rodrigues <henriquesilvar@gmail.com>,
	kishore kumar <kishoreopen@gmail.com>,
	Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
 <20121227184034.GA2982@debian.debian>
 <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
 <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
 <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
 <87a9syhbma.fsf@xmission.com>
 <20121228130734.GB13224@x1.alien8.de>
 <CAMuHMdVo67RrcencMOTJSL_=fGjDFBtczRpvW6D8QbVxNy-t3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdVo67RrcencMOTJSL_=fGjDFBtczRpvW6D8QbVxNy-t3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 11:03:40PM +0100, Geert Uytterhoeven wrote:
> That's the first run. Now everything is in the buffer cache (assumed
> you have enough RAM), and try again...

Right, until you do something else on the box requiring just the right
amount of memory to overflow the buffer cache working set and start
kicking out pages. Btw, the thing has 4G of RAM.

* first run:

$  time git ls-files | xargs grep -E 'struct mce\W*{'
arch/x86/include/uapi/asm/mce.h:struct mce {
arch/x86/kernel/cpu/mcheck/mce.c:               if (!final || memcmp(m, final, sizeof(struct mce))) {

real    2m48.415s
user    0m2.388s
sys     0m15.668s

* second run coming from the buffer cache, search for something else:

$ time git ls-files | xargs grep -E 'struct task_struct\W*{'
include/linux/sched.h:struct task_struct {

real    0m1.651s
user    0m0.672s
sys     0m1.048s

* do something else (kernel build, git gc, some (very leaky) userspace
memory hog, whatever :)) which kicks some buffer cache pages out:

$ time git ls-files | xargs grep -E 'struct mce\W*{'
arch/x86/include/uapi/asm/mce.h:struct mce {
arch/x86/kernel/cpu/mcheck/mce.c:               if (!final || memcmp(m, final, sizeof(struct mce))) {

real    0m37.360s
user    0m1.152s
sys     0m4.176s

so on a machine with a lot of memory and an SSD, you can probably safely
rely on the buffer cache but not on a laptop, in my experience.

Btw, cscope can also grep for regex patterns so you don't need the git
grep thing anymore, especially since it looks at tracked files only.

Thanks.

-- 
Regards/Gruss,
Boris.
