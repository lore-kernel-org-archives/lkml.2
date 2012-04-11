Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2DKGkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:40:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62221 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2DKGkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:40:05 -0400
Date: Wed, 11 Apr 2012 10:39:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120411063957.GA11629@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215160652.GA17680@redhat.com>
 <20120215162752.GF4533@moon>
 <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
 <20120409222443.GW1625@moon>
 <4F836F3E.9090207@zytor.com>
 <20120410223758.GL24857@moon>
 <20120410230833.GA17620@redhat.com>
 <4F84C2FA.8090703@zytor.com>
 <20120410234206.GA19251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410234206.GA19251@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 01:42:06AM +0200, Oleg Nesterov wrote:
> On 04/10, H. Peter Anvin wrote:
> >
> > On 04/10/2012 04:08 PM, Oleg Nesterov wrote:
> > >
> > > OK, since this is discussed again...
> > >
> > > Can this comment can also explain why do we obfuscate the pointers
> > > by type? I mean, I don't really understand why the one-dimensional
> > > cookies[2] is "not enough" from security pov.
> >
> > Because it's cheap.  "Just enough" is not what you want to shoot for,
> > ever, you want to get past the "just enough" point and then consider
> > "what can I get for cheap at this point"?
> 
> OK, I am not arguing. Just I thought that the small note like
> "we are doing this per-type to obfuscate even more" can help.
> I wouldn't have asked, but Cyrill rewrites this comment anyway.
> 
> Perhaps this is just me, but my first (and wrong) impression was
> that somehow this is needed for correctness.

Hi Oleg, would the form below sounds good?

---
Subject: Add a comment on kcmp obfuscation method

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 kernel/kcmp.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6.git/kernel/kcmp.c
===================================================================
--- linux-2.6.git.orig/kernel/kcmp.c
+++ linux-2.6.git/kernel/kcmp.c
@@ -17,6 +17,20 @@
  * reasons, still the comparison results should be suitable for
  * sorting. Thus, we obfuscate kernel pointers values and compare
  * the production instead.
+ *
+ * The obfuscation is done in two steps. First -- we use xor on
+ * kernel pointer with random value, which puts pointer into
+ * a new position in reordered space. Second -- we multiply
+ * the xor production with big odd random number to permute
+ * bits even more (the odd multiplier guarantees that the product
+ * is unique ever after the high bits are truncated, since any odd
+ * number is relative prime to 2^n).
+ *
+ * The obfuscation is done with per-type cookie values to increase
+ * initial entropy of results.
+ *
+ * Note also the obfuscation itself is invisible to user-space
+ * and if needed it can be changed to any suitable scheme.
  */
 static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
 
