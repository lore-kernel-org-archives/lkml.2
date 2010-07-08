Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0GHBSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:18:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47772
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab0GHBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:18:33 -0400
Date: Wed, 07 Jul 2010 18:18:47 -0700 (PDT)
Message-Id: <20100707.181847.62350965.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, joe@perches.com, gregkh@suse.de
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100707.174522.148565561.davem@davemloft.net>
References: <20100706142542.d723903f.sfr@canb.auug.org.au>
	<20100707.174522.148565561.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 07 Jul 2010 17:45:22 -0700 (PDT)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 6 Jul 2010 14:25:42 +1000
> 
>> After merging the net tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced these warnings:
>> 
>> drivers/scsi/sym53c8xx_2/sym_hipd.c: In function 'sym_print_msg':
>> drivers/scsi/sym53c8xx_2/sym_hipd.c:78: warning: zero-length gnu_printf format string
> 
> Thanks Stephen I'll look into this.

Yeah this is a bit ugly.

It used to be that the dev_*() format string was CPP pasted to whatever
format string the user gave.  So if the user gave an empty string it
still looked like a non-empty printf string.

But that no longer happens because we hide the implementation, and thus
the top-level printf format string, in the external functions.

It seems the construction:

/*
 * Stupid hackaround for existing uses of non-printk uses dev_info
 *
 * Note that the definition of dev_info below is actually _dev_info
 * and a macro is used to avoid redefining dev_info
 */

#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)

added to linux/device.h was meant to handle these cases, but as we see
it doesn't.

It looks like there are just a hand-ful of cases, so maybe we can tweak
them by hand.  For example, in the sym53c8xx_2 driver bits we can replace
the NULL labels passed to sym_print_msg() with a real string and therefore
remove the "" case.

Joe, any better ideas?
