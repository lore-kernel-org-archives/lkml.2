Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1GYLHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:07:49 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:11245
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab1GYLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:07:43 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz9371Mc85fhc85dh1432N98dKzz1202hzzz32i668h839h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOVYS4-01-0HN-02
X-M-MSG: 
Date: Mon, 25 Jul 2011 13:04:46 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Andrew Lutomirski <luto@mit.edu>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
Message-ID: <20110725110446.GD353@escobedo.osrc.amd.com>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
 <20110724211526.GA6785@elte.hu>
 <CAObL_7H1j1cewgWP6Jmkw_H9dZVh1kxRGgTLa+ju=ns4gYxMdA@mail.gmail.com>
 <20110725063836.GC694@elte.hu>
 <CAObL_7G-afftZD7ULhbyTqBsuZCs03H-HS-n8tqRC=-Q3Bs9Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <CAObL_7G-afftZD7ULhbyTqBsuZCs03H-HS-n8tqRC=-Q3Bs9Eg@mail.gmail.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2011 at 05:44:32AM -0400, Andrew Lutomirski wrote:
> On Mon, Jul 25, 2011 at 2:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > I should have mentioned it earlier, but there's a certain amount of
> > delazying patches in the tip:x86/xsave branch:
> >
> > =A0$ gll linus..x86/xsave
> > =A0300c6120b465: x86, xsave: fix non-lazy allocation of the xsave are=
a
> > =A0f79018f2daa9: Merge branch 'x86/urgent' into x86/xsave
> > =A066beba27e8b5: x86, xsave: remove lazy allocation of xstate area
> > =A01039b306b1c6: x86, xsave: add kernel support for AMDs Lightweight =
Profiling (LWP)
> > =A04182a4d68bac: x86, xsave: add support for non-lazy xstates
> > =A0324cbb83e215: x86, xsave: more cleanups
> > =A02efd67935eb7: x86, xsave: remove unused code
> > =A00c11e6f1aed1: x86, xsave: cleanup fpu/xsave signal frame setup
> > =A07f4f0a56a7d3: x86, xsave: rework fpu/xsave support
> > =A026bce4e4c56f: x86, xsave: cleanup fpu/xsave support
> >
> > it's not in tip:master because the LWP bits need (much) more work to
> > be palatable - but we could spin them off and complete them as per
> > your suggestions if they are an independent speedup on modern CPUs.
>=20
> Hans, what's the status of these?  I want to do some other cleanups
> (now or in a couple of weeks) that will probably conflict with your
> xsave work.

I know of one bug in there that occasionally causes panics at boot, see
the attached patch for a fix.


Hans


--=20
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset="us-ascii";
	name="0001-x86-xsave-clear-pre-allocated-xsave-area.patch"
Content-Disposition: attachment;
	filename="0001-x86-xsave-clear-pre-allocated-xsave-area.patch"
Content-Description: 0001-x86-xsave-clear-pre-allocated-xsave-area.patch

>From 599d3ee9a9e743377739480a8a893582f1409a8d Mon Sep 17 00:00:00 2001
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
Date: Wed, 6 Jul 2011 16:31:19 +0200
Subject: [PATCH 1/1] x86, xsave: clear pre-allocated xsave area

Bogus data in the xsave area can cause xrstor to panic, so make sure
that the pre-allocated xsave area is all nice and clean before being
used.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/kernel/process.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c5ae256..03c5ded 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,8 +28,15 @@ EXPORT_SYMBOL_GPL(task_xstate_cachep);
 
 int arch_prealloc_fpu(struct task_struct *tsk)
 {
-	if (!fpu_allocated(&tsk->thread.fpu))
-		return fpu_alloc(&tsk->thread.fpu);
+	if (!fpu_allocated(&tsk->thread.fpu)) {
+		int err = fpu_alloc(&tsk->thread.fpu);
+
+		if (err)
+			return err;
+
+		fpu_clear(&tsk->thread.fpu);
+	}
+
 	return 0;
 }
 
-- 
1.5.6.5


--qDbXVdCdHGoSgWSk--
