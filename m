Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1BIV1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:27:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31653 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab1BIV1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:27:46 -0500
Date: Wed, 9 Feb 2011 13:25:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: Re: Linux 2.6.38-rc4 (hysdn: BUG)
Message-Id: <20110209132529.76927f5f.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimUg8Dm9mZotubcgPHz8_at=_hnbeWUo-LfSALp@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<20110209092419.2b335697.randy.dunlap@oracle.com>
	<AANLkTimUg8Dm9mZotubcgPHz8_at=_hnbeWUo-LfSALp@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D5306AC.00F0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011 11:44:00 -0800 Linus Torvalds wrote:

> On Wed, Feb 9, 2011 at 9:24 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > on x86_64.  no HYSDN hardware found (correct).
> > Nearly allmodconfig.
> >
> >
> > [   65.397577] HYSDN: module Rev: 1.6.6.6 loaded
> > [   65.397584] HYSDN: network interface Rev: 1.8.6.4
> > [   65.398057] HYSDN: 0 card(s) found.
> > [   65.398121] BUG: unable to handle kernel paging request at ffffffffa06c99f0
> > [   65.398269] IP: [<ffffffffa06c68ba>] hysdn_getrev+0x2e/0x50 [hysdn]
> > [   65.398379] PGD 1a14067 PUD 1a18063 PMD 6f6c1067 PTE 800000006ce8c161
> > [   65.398613] Oops: 0003 [#1] SMP DEBUG_PAGEALLOC
> > [   65.400030]
> > [   65.400030] Pid: 2497, comm: modprobe Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745
> > [   65.400030] RIP: 0010:[<ffffffffa06c68ba>]  [<ffffffffa06c68ba>] hysdn_getrev+0x2e/0x50 [hysdn]
> > [   65.400030] RSP: 0018:ffff88006eec1e68  EFLAGS: 00010206
> > [   65.400030] RAX: ffffffffa06c99f1 RBX: ffffffffa06c99e9 RCX: ffff88007c4159a0
> 
> The instruction sequence decodes to
> 
>   1e:	be 24 00 00 00       	mov    $0x24,%esi
>   23:	48 89 df             	mov    %rbx,%rdi
>   26:	e8 5b 39 c0 e0       	callq  0xffffffffe0c03986
>   2b:*	c6 40 ff 00          	movb   $0x0,-0x1(%rax)     <-- trapping instruction
> 
> which seems to be this
> 
>                 p = strchr(rev, '$');
>                 *--p = 0;
> 
> code. And yes, it's total crap, because while "p" and "rev" are "char
> *", the string that is passed in is actually of type "const char *",
> so that function is seriously broken. It's also seriously broken to
> not test that "p" is non-NULL - the function would just break if there
> is a colon in the string but not a '$'.
> 
> And hysdn_procconf_init() passes in a constant string to the thing:
> 
>     static char *hysdn_procconf_revision = "$Revision: 1.8.6.4 $";
> 
> What happens is that it breaks when we mark the constant section as
> read-only, because you have CONFIG_DEBUG_RODATA enabled.
> 
> So the fix seems to be to
>  - fix the prototype for hysdn_getrev() to not have "const".
>  - fix hysdn_procconf_init() to not pass in a constant string to it
> 
> The minimal patch would appear to be something like the appended. UNTESTED!

for your patch:

Tested-and-acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> Btw, all of this code seems to go back to before the git history even
> started, so it doesn't seem to be new. I assume you haven't tried
> booting these all-module kernels before? Or is it just the
> DEBUG_RODATA thing that is new for you?

Neither is new.  I tested and reported many-modules on 2.6.37-rc1 and
reported these 2 bugs:

https://bugzilla.kernel.org/show_bug.cgi?id=22912
https://bugzilla.kernel.org/show_bug.cgi?id=22882

and that was with CONFIG_DEBUG_RODATA=y.
I don't know how hysdn was missed at that time.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
