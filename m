Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BGItg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:49:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43376
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab1BGItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:49:35 -0500
Date: Mon, 07 Feb 2011 00:50:10 -0800 (PST)
Message-Id: <20110207.005010.28814928.davem@davemloft.net>
To: dtor@vmware.com
Cc: schwab@linux-m68k.org, geert@linux-m68k.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Early crash
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110207081933.GA11855@dtor-ws.eng.vmware.com>
References: <m2bp2udllv.fsf@igel.home>
	<20110203002459.GA26729@dtor-ws.eng.vmware.com>
	<20110207081933.GA11855@dtor-ws.eng.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>
Date: Mon, 7 Feb 2011 00:19:33 -0800

> So here is the patch that explicitly specifies alignment for struct
> module_version_attribute. I tested it on i386 and x86_64 and I believe
> it will fix the issue with m68k but I do not have access to such a box.

While this may or may not fix the m68k issue, this isn't really
sufficient to make this thing work in all cases.  And the older
tracepoint commits referenced in this thread are known to cause
problems with platforms such as sparc64.

You can't reliably put structures into independent objects, put them
into a special section, and then expect array access over them (via
the section boundaries) after linking the objects together to just
"work".

Your attribute specification is only a lower-bound.

GCC can and does use variable alignment choices in different situations,
so the align directive in the various objects can all be different.  So
the array iteration will assume the iterations should use one object
size, but within the linked together section the alignments are all
different so the inter-struct gap is different.

The only portable mechanism that will work in all cases, as we've
found recently for tracepoints and similar, is to make an array of
plain pointers to the objects in the special section.

See:

http://marc.info/?l=linux-kernel&m=129674396021733&w=2
http://marc.info/?l=linux-kernel&m=129674399621795&w=2
http://marc.info/?l=linux-kernel&m=129674396121739&w=2
http://marc.info/?l=linux-kernel&m=129674396021735&w=2
