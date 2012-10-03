Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2JCHXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:23:43 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:1370 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755705Ab2JCHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:23:42 -0400
Message-ID: <1349249016.1414.55.camel@x61.thuisdomein>
Subject: Re: [PATCH] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Valdis.Kletnieks@vt.edu
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 03 Oct 2012 09:23:36 +0200
In-Reply-To: <64681.1349223065@turing-police.cc.vt.edu>
References: <1349000155.1553.27.camel@x61.thuisdomein>
	 <20121001100321.GB4360@opensource.wolfsonmicro.com>
	 <64681.1349223065@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2012 07:23:36.0182 (UTC) FILETIME=[00799160:01CDA138]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 20:11 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 01 Oct 2012 11:03:21 +0100, Mark Brown said:
> > On Sun, Sep 30, 2012 at 12:15:55PM +0200, Paul Bolle wrote:
> > > Building regmap.o triggers this GCC warning:
> > >     drivers/base/regmap/regmap.c: In function regmap_raw_read:
> > >     drivers/base/regmap/regmap.c:1172:6: warning: ret may be used uninitialized in this function [-Wmaybe-uninitialized]
> > >
> > > It seems 'ret' should always be set when this function returns. See, the
> > > else-branch can leave 'ret' uninitialized only if 'val_count' is zero.
> > > But if 'val_count' is zero regmap_volatile_range() will return true.
> 
> I've not dug into it that deeply - is there a way that gcc is able to intuit
> this fact and use it for flow analysis?  If not, it's not going to be able to
> include that information in its analysis.

I know little about GCC, and even less about the analyses it uses. I
did, however, disassemble regmap_raw_read() with GDB. And the output
this generated does suggest that GCC uses one register to track 'ret'
and that this register is set to -EINVAL quite early. Ie, gdb's
disassembler's output suggests that 'ret' will not be used
uninitialized. (This I need to recheck, though.) But, even assuming I
understood the disassembled code correctly, I have no idea whether we
may expect GCC to understand the code it generates enough to know that,
yes, it did actually set 'ret' itself in that code.

> > > That implies that 'ret' will be set in the if-branch. ('val_count' could
> > > be zero if 'val_len' is, for example, zero. That would be useless input,
> > > however.)
> 
> But gcc doesn't know what "useless input" means, semantically.

Correct. When this function is compiled gcc has to take into account
that 'val_len' will be called with useless input, like zero.

By the way, GCC doesn't warn if I add an early check whether 'val_count'
is non-zero:

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..d41527b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1171,6 +1171,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
        unsigned int v;
        int ret, i;
 
+       if (!val_count)
+               return -EINVAL;
        if (val_len % map->format.val_bytes)
                return -EINVAL;
        if (reg % map->reg_stride)

That is another way to silence GCC here.


Paul Bolle

