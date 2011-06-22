Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab1FVCgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:36:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58846 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab1FVCgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:36:45 -0400
Date: Tue, 21 Jun 2011 19:36:41 -0700 (PDT)
Message-Id: <20110621.193641.1605224831578508501.davem@davemloft.net>
To: greg@kroah.com
CC: linux-kernel@vger.kernel.org
Subject: brcm80211 build busted on big-endian
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Jun 2011 19:36:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It tries to do "xor" operations on pointers because of how the
R_REG() and W_REG() macros are defined.

====================
#define R_REG(r) (\
        SELECT_BUS_READ( \
                ({ \
                        __typeof(*(r)) __osl_v; \
				       		switch (sizeof(*(r))) { \
                        case sizeof(u8): \
                                __osl_v = \
                                readb((volatile u8*)((r)^3)); \
                                break; \
                        case sizeof(u16): \
                                __osl_v = \
                                readw((volatile u16*)((r)^2)); \
                                break; \
                        case sizeof(u32): \
                                __osl_v = readl((volatile u32*)(r)); \
                                break; \
                        } \
                        __osl_v; \
                }), \
                OSL_READ_REG(r)) \
)
====================

This driver is a crap fest of volatile pointers and not-compile-tested
code.

I think turning on staging like this should have been done in the
-next tree so that things like this could be shaken out before it hit
Linus's tree.  Very few people were doing the necessary forced enable
of this stuff.
