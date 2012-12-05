Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2LEVi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:38:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LEVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:38:56 -0500
Date: Wed, 5 Dec 2012 13:38:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Mohr <andi@lisas.de>,
        linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Message-Id: <20121205133853.770451ca.akpm@linux-foundation.org>
In-Reply-To: <20121205153121.GA28556@liondog.tnic>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
	<20121205142935.GA12119@liondog.tnic>
	<20121205152756.5afec12c@pyramind.ukuu.org.uk>
	<20121205153121.GA28556@liondog.tnic>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 16:31:21 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Dec 05, 2012 at 03:27:56PM +0000, Alan Cox wrote:
> > On Wed, 5 Dec 2012 15:29:35 +0100
> > Borislav Petkov <bp@alien8.de> wrote:
> > 
> > > On Wed, Dec 05, 2012 at 08:09:01AM +0100, Andreas Mohr wrote:
> > > > Hi,
> > > > 
> > > > drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
> > > > drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
> > > > exhaustive tests is always true [-Wlogical-op]
> > > > drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
> > > > exhaustive tests is always true [-Wlogical-op]
> > > > drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
> > > > exhaustive tests is always true [-Wlogical-op]
> > > > 
> > > > 
> > > > That's already the second less enticing -Wlogical-op issue
> > > > which was discovered by accident during less than two days
> > 
> > No it's not. It's been reported in bugzilla. I sent patches ages ago.
> > They were ignored. Coverity has had it tagged for years (and a ton more
> > of them you've not noticed yet)
> > 
> > http://article.gmane.org/gmane.linux.acpi.devel/56753/match=test_alpha
> > 
> > This isn't discovered, this is in the "If you stick your fingers in your
> > ears and hum you can't hear the screaming" category.
> 
> Hillarious!
> 
> Andrew, would you please pick up Alan's patch? It clearly fixes an
> ancient bug in the pnpacpi code.
> 

Bjorn had a review comment which appears to remain unaddressed:

: The original is definitely broken.
: 
: I think the corrected test allows PNP IDs containing '@', which
: doesn't appear legal per sec 6.1.5 of the ACPI 5.0 spec.  Should this
: be
: 
: +       if (!('A' <= (c) && (c) <= 'Z')) \
: 
: instead?

Also, the original patch is missing a signed-off-by.  Here's what I
have queued:

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: pnpacpi: fix incorrect TEST_ALPHA() test

TEST_ALPHA() is broken and always returns 0.

[akpm@linux-foundation.org: return false for '@' as well, per Bjorn]
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/pnpacpi/core.c~pnpacpi-fix-incorrect-test_alpha-test drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnpacpi-fix-incorrect-test_alpha-test
+++ a/drivers/pnp/pnpacpi/core.c
@@ -58,7 +58,7 @@ static inline int __init is_exclusive_de
 	if (!(('0' <= (c) && (c) <= '9') || ('A' <= (c) && (c) <= 'F'))) \
 		return 0
 #define TEST_ALPHA(c) \
-	if (!('@' <= (c) || (c) <= 'Z')) \
+	if (!('A' <= (c) && (c) <= 'Z')) \
 		return 0
 static int __init ispnpidacpi(const char *id)
 {
_

