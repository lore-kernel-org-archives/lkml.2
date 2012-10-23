Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab2JWVas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:30:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2JWVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:30:46 -0400
Date: Tue, 23 Oct 2012 14:30:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-Id: <20121023143045.183657c4.akpm@linux-foundation.org>
In-Reply-To: <20121023071549.GC7020@moon>
References: <20121022191452.785366817@openvz.org>
	<20121022122934.d2e2fa57.akpm@linux-foundation.org>
	<5085B1A8.4020609@parallels.com>
	<20121022205641.GL2303@moon>
	<20121022213449.GH31440@moon>
	<20121022145158.53bddfc1.akpm@linux-foundation.org>
	<20121023061341.GA7020@moon>
	<20121022233025.09ec2d92.akpm@linux-foundation.org>
	<20121023063430.GB7020@moon>
	<20121023071549.GC7020@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 11:15:49 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Tue, Oct 23, 2012 at 10:34:30AM +0400, Cyrill Gorcunov wrote:
> > On Mon, Oct 22, 2012 at 11:30:25PM -0700, Andrew Morton wrote:
> > ...
> > > > Yup, but not only that, this kind of trick hides associativity between
> > > > VM_ constant and mnemonic, so on changes one would have to figure out
> > > > which position some flag has in this foo[] array, so I vote for not
> > > > use it :-)
> > > 
> > > Well you could do
> > > 
> > > struct {
> > > 	char x[2];
> > > } y[] = {
> > > 	[CLOG2(VM_DONTEXPAND)] =	{ 'd', 'e' },
> > > 	[CLOG2(VM_ACCOUNT)] =		{ 'a', 'c' },
> > > 	[CLOG2(VM_NORESERVE)] =		{ 'n', 'r' },
> > > };
> > > 
> > > 	...
> > > 
> > > 	for (i = 0; i < BITS_PER_LONG; i++) {
> > > 		if (flags & (1 << i))
> > > 			seq_printf("%c%c ", y[i][0], y[i][1]);
> > > 	}
> > > 
> > > where CLOG2() is extracted from the guts of ilog2().
> > > 
> > > I'll stop now :)
> > 
> > Yup, this one will be a wy better. Letme try it out :)
> 
> ilog2 works well enough here as well.
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: procfs: add VmFlags field in smaps output v3
> 
> During c/r sessions we've found that there is no way at the moment to
> fetch some VMA associated flags, such as mlock() and madvise().
> 
> This leads us to a problem -- we don't know if we should call for
> mlock() and/or madvise() after restore on the vma area we're bringing
> back to life.
> 
> This patch intorduces a new field into "smaps" output called VmFlags,
> where all set flags associated with the particular VMA is shown as two
> letter mnemonics.
> 
> [ Strictly speaking for c/r we only need mlock/madvise bits but it has been
>   said that providing just a few flags looks somehow inconsistent.  So all
>   flags are here now. ]
> 
> This feature is made available on CONFIG_CHECKPOINT_RESTORE=n kernels, as
> other applications may start to use these fields.
> 
> The data is encoded in a somewhat awkward two letters mnemonic form, to
> encourage userspace to be prepared for fields being added or removed in
> the future.
> 

Wow.  This version generates 1k less kernel bloat than v2!  Gee, and I
only sent that email as a late-night joke ;)

fs/proc/task_mmu.o with neither patch:
   text    data     bss     dec     hex filename
  14849     112    5312   20273    4f31 fs/proc/task_mmu.o

fs/proc/task_mmu.o with the v2 patch:
  16074     112    5776   21962    55ca fs/proc/task_mmu.o

fs/proc/task_mmu.o with the v3 patch:
  15446     112    5368   20926    51be fs/proc/task_mmu.o

fs/proc/task_mmu.o with the v3 patch and the below fix:
  15123     112    5352   20587    506b fs/proc/task_mmu.o

So the delta has gone from 1700 bytes down to 300.  Seems that it pays
to be anal about these things ;)


Don't forget the `static'!  Without it, the compiler will need to
construct the array as a temporary on the stack each time the function
is called - it's just terrible.  (There's no reason why the compiler
can't insert the static for us as an optimisation, and I think later
gcc's may have got smarter about this).

Was there a reason why you added the ".l = " to the initialiser?  My
gcc is happy without it.

Also...  what happens if there's an unrecognised bit set in `flags'? 
Memory corruption or code skew could cause this.  We emit a couple of
NULs into the procfs output, which I guess is an OK response to such a
condition.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix

make mnemonics[] static, remove unneeded init code, tidy whitespace

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   58 ++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-add-vmflags-field-in-smaps-output-v3-fix Documentation/filesystems/proc.txt
diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v3-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v3-fix
+++ a/fs/proc/task_mmu.c
@@ -531,39 +531,37 @@ static void show_smap_vma_flags(struct s
 	/*
 	 * Don't forget to update Documentation/ on changes.
 	 */
-
-	const struct {
+	static const struct {
 		const char l[2];
 	} mnemonics[BITS_PER_LONG] = {
-		[ilog2(VM_READ)]	= { .l = {'r', 'd'} },
-		[ilog2(VM_WRITE)]	= { .l = {'w', 'r'} },
-		[ilog2(VM_EXEC)]	= { .l = {'e', 'x'} },
-		[ilog2(VM_SHARED)]	= { .l = {'s', 'h'} },
-		[ilog2(VM_MAYREAD)]	= { .l = {'m', 'r'} },
-		[ilog2(VM_MAYWRITE)]	= { .l = {'m', 'w'} },
-		[ilog2(VM_MAYEXEC)]	= { .l = {'m', 'e'} },
-		[ilog2(VM_MAYSHARE)]	= { .l = {'m', 's'} },
-		[ilog2(VM_GROWSDOWN)]	= { .l = {'g', 'd'} },
-		[ilog2(VM_PFNMAP)]	= { .l = {'p', 'f'} },
-		[ilog2(VM_DENYWRITE)]	= { .l = {'d', 'w'} },
-		[ilog2(VM_LOCKED)]	= { .l = {'l', 'o'} },
-		[ilog2(VM_IO)]		= { .l = {'i', 'o'} },
-		[ilog2(VM_SEQ_READ)]	= { .l = {'s', 'r'} },
-		[ilog2(VM_RAND_READ)]	= { .l = {'r', 'r'} },
-		[ilog2(VM_DONTCOPY)]	= { .l = {'d', 'c'} },
-		[ilog2(VM_DONTEXPAND)]	= { .l = {'d', 'e'} },
-		[ilog2(VM_ACCOUNT)]	= { .l = {'a', 'c'} },
-		[ilog2(VM_NORESERVE)]	= { .l = {'n', 'r'} },
-		[ilog2(VM_HUGETLB)]	= { .l = {'h', 't'} },
-		[ilog2(VM_NONLINEAR)]	= { .l = {'n', 'l'} },
-		[ilog2(VM_ARCH_1)]	= { .l = {'a', 'r'} },
-		[ilog2(VM_DONTDUMP)]	= { .l = {'d', 'd'} },
-		[ilog2(VM_MIXEDMAP)]	= { .l = {'m', 'm'} },
-		[ilog2(VM_HUGEPAGE)]	= { .l = {'h', 'g'} },
-		[ilog2(VM_NOHUGEPAGE)]	= { .l = {'n', 'h'} },
-		[ilog2(VM_MERGEABLE)]	= { .l = {'m', 'g'} },
+		[ilog2(VM_READ)]	= { {'r', 'd'} },
+		[ilog2(VM_WRITE)]	= { {'w', 'r'} },
+		[ilog2(VM_EXEC)]	= { {'e', 'x'} },
+		[ilog2(VM_SHARED)]	= { {'s', 'h'} },
+		[ilog2(VM_MAYREAD)]	= { {'m', 'r'} },
+		[ilog2(VM_MAYWRITE)]	= { {'m', 'w'} },
+		[ilog2(VM_MAYEXEC)]	= { {'m', 'e'} },
+		[ilog2(VM_MAYSHARE)]	= { {'m', 's'} },
+		[ilog2(VM_GROWSDOWN)]	= { {'g', 'd'} },
+		[ilog2(VM_PFNMAP)]	= { {'p', 'f'} },
+		[ilog2(VM_DENYWRITE)]	= { {'d', 'w'} },
+		[ilog2(VM_LOCKED)]	= { {'l', 'o'} },
+		[ilog2(VM_IO)]		= { {'i', 'o'} },
+		[ilog2(VM_SEQ_READ)]	= { {'s', 'r'} },
+		[ilog2(VM_RAND_READ)]	= { {'r', 'r'} },
+		[ilog2(VM_DONTCOPY)]	= { {'d', 'c'} },
+		[ilog2(VM_DONTEXPAND)]	= { {'d', 'e'} },
+		[ilog2(VM_ACCOUNT)]	= { {'a', 'c'} },
+		[ilog2(VM_NORESERVE)]	= { {'n', 'r'} },
+		[ilog2(VM_HUGETLB)]	= { {'h', 't'} },
+		[ilog2(VM_NONLINEAR)]	= { {'n', 'l'} },
+		[ilog2(VM_ARCH_1)]	= { {'a', 'r'} },
+		[ilog2(VM_DONTDUMP)]	= { {'d', 'd'} },
+		[ilog2(VM_MIXEDMAP)]	= { {'m', 'm'} },
+		[ilog2(VM_HUGEPAGE)]	= { {'h', 'g'} },
+		[ilog2(VM_NOHUGEPAGE)]	= { {'n', 'h'} },
+		[ilog2(VM_MERGEABLE)]	= { {'m', 'g'} },
 	};
-
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
_

