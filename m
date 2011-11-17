Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1KQXcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:32:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1KQXcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:32:52 -0500
Date: Thu, 17 Nov 2011 15:32:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cristian =?ISO-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: Andrei Warkentin <andreiw@vmware.com>, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, opensuse-kernel@opensuse.org,
        Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [opensuse-kernel] Re: [PATCH] include/log2.h: Fix
 rounddown_pow_of_two(1)
Message-Id: <20111117153250.f3262a29.akpm@linux-foundation.org>
In-Reply-To: <4EC5966A.4000106@opensuse.org>
References: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
	<20111117150549.15528e81.akpm@linux-foundation.org>
	<4EC5966A.4000106@opensuse.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 20:19:06 -0300
Cristian Rodr__guez <crrodriguez@opensuse.org> wrote:

> On 17/11/11 20:05, Andrew Morton wrote:
> 
> > I assume that nobody has gone off and checked whether all current
> > callers will survive this change.  If they had, they'd have looked in
> > drivers/char/ramoops.c and seen:
> > 
> > 	rounddown_pow_of_two(pdata->mem_size);
> > 	rounddown_pow_of_two(pdata->record_size);
> > 
> > These operations are no-ops.  It should be
> > 
> > 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> > 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> > 
> > That we have this many warts using these interfaces is an indication
> > that the interfaces aren't very good.  Poorly documented, at least.
> > 
> 
> making that macro an inline function and annotating with
> __attribute__((warn_unused_result)) looks like a good start for me.

The problem is:

 * - this can be used to initialise global variables from constant data

I'm surprised that this is true.  Is gcc smart enough to actually do
this?

<tests it>

--- a/fs/open.c~a
+++ a/fs/open.c
@@ -31,6 +31,10 @@
 #include <linux/ima.h>
 #include <linux/dnotify.h>
 
+#include <linux/log2.h>
+
+int blap = rounddown_pow_of_two(42);
+
 #include "internal.h"
 
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
_

ooh, it worked.
