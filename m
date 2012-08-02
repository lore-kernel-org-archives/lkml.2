Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2HBNeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:34:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2HBNeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:34:06 -0400
Date: Thu, 2 Aug 2012 15:33:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] parisc: fix personality flag check in copy_thread()
In-Reply-To: <1343912818.5073.48.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LNX.2.00.1208021531540.4820@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012155330.14910@pobox.suse.cz>   <alpine.LNX.2.00.1208020911300.14910@pobox.suse.cz>  <1343897272.5073.5.camel@dabdike.int.hansenpartnership.com>  <alpine.LNX.2.00.1208021342120.4820@pobox.suse.cz>
 <1343912818.5073.48.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, James Bottomley wrote:

> > In case of parsic, let's take a process with current->personality == 
> > PER_LINUX32 callling personality(PER_LINUX | UNAME26). The
> > 
> >         if (personality(current->personality) == PER_LINUX32
> >             && personality == PER_LINUX)
> >                 personality = PER_LINUX32;
> > 
> > would that have no effect, and sys_personality() would be called with 
> > (PER_LINUX | UNAME26) instead of PER_LINUX32, just because of UNAME26 
> > being set as well. That doesn't seem really correct. Is it?
> 
> Heh, no.  This is a nasty mess.  

Indeed.

> Our assumption was that we own the flags ... hence the code.  There are 
> some flags we can't allow to be set or reset ... but that's only for the 
> mythical 64 bit userspace, so I suppose we just ignore that for now and 
> fix it if this ever appears.
>
> I don't like the hidden assumption that PER_LINUX == 0, but otherwise
> the code looks fine.
> 
> How about 
> 
> personality = (personality & ~PER_MASK) | PER_LINUX32;
> 
> and
> 
> err = (personality & ~PER_MASK) | PER_LINUX;

Agreed, that's a little bit nicer way how to express it (modulo the 
fact that the last 'personality' in your example should in fact be 'err'). 
Updated patch below, thanks.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 2/4] parisc: fix personality flag check in copy_thread()

Directly comparing task_struct->personality against PER_* is not fully
correct, as it doesn't take flags potentially stored in top three bytes
into account.

Analogically, directly forcefully setting personality to PER_LINUX32 or
PER_LINUX discards any flags stored in the top three bytes.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
v0->v1: fix the bit ops to reflect the fact that PER_LINUX is actually 0
v2->v2: express the PER_LINUX==0 fact in the bitops in a more obvious way

 arch/parisc/kernel/process.c    |    2 +-
 arch/parisc/kernel/sys_parisc.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d4b94b3..2c05a92 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -309,7 +309,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 		cregs->ksp = (unsigned long)stack
 			+ (pregs->gr[21] & (THREAD_SIZE - 1));
 		cregs->gr[30] = usp;
-		if (p->personality == PER_HPUX) {
+		if (personality(p->personality) == PER_HPUX) {
 #ifdef CONFIG_HPUX
 			cregs->kpc = (unsigned long) &hpux_child_return;
 #else
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index c9b9322..7f9658e 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -225,12 +225,12 @@ long parisc_personality(unsigned long personality)
 	long err;
 
 	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
+	    && personality(personality) == PER_LINUX)
+		personality = (personality & ~PER_MASK) | PER_LINUX32;
 
 	err = sys_personality(personality);
-	if (err == PER_LINUX32)
-		err = PER_LINUX;
+	if (personality(err) == PER_LINUX32)
+		err = (err & ~PER_MASK) | PER_LINUX;
 
 	return err;
 }

-- 
Jiri Kosina
SUSE Labs
