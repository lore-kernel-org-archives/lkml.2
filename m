Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1ITXt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:49:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1ITXt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:49:26 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=hsTB6ykMC6UA:10 a=kj9zAlcOel0A:10 a=831GoBDzZyojtqxacfPZ+w==:17 a=ZYfJzNXY9a1FJpPgrpcA:9 a=CjuIK1q_8ugA:10 a=831GoBDzZyojtqxacfPZ+w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 66.66.207.215
Message-Id: <201109210021.p8L0LVCn019238@dell2.home>
To: linux-kernel@vger.kernel.org
cc: maleisner@gmail.com
Subject: OPTIMIZE_FOR_SIZE makes PPC modules sick when trampolines are used
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19235.1316564490.1@dell2.home>
Date: Wed, 21 Sep 2011 00:21:30 +0000
From: "Marty Leisner" <linux@rochester.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're using Windriver linux on a PPC  board (2.6.34).

When turning on OPTIMIZE_FOR_SIZE, we saw "strangeness" with the IPv6
module depending on when it was loaded (it either "hung" or paniced the system
with a empty stack dump -- or worked fine!!).

Editing inet6_init so:
   a) a return (after entry) worked
   b) anything (for example printk) hung/paniced returning from the module

The trampoline code uses r11.

gcc OPTIMIZE_FOR_SIZE (4.x) does (when returning from inet6_init):
     418:       39 7f 00 10     addi    r11,r31,16
     41c:       48 00 00 00     b       41c <ac6_proc_init+0x44>
                        41c: R_PPC_REL24        _rest32gpr_31_x
on function exit (_rest32gpr_31_x bases a stackpointer off r11)

If _rest32gpr_31_x has to go across a trampoline, r11 is getting clobbered.
Hence bad things happen:

The trampoline code is (if the comments are right ;-):
(from arch/powerpc/kernel/module_32.c)
	/* Stolen from Paul Mackerras as well... */
        entry->jump[0] = 0x3d600000+((val+0x8000)>>16); /* lis r11,sym@ha */
        entry->jump[1] = 0x396b0000 + (val&0xffff);     /* addi r11,r11,sym@l*/
        entry->jump[2] = 0x7d6903a6;                    /* mtctr r11 */
        entry->jump[3] = 0x4e800420;                    /* bctr */



Has anyone seen this?   An old ABI (maybe current?  Its version 3 from 1995) lists r0, r11, r12
as volatile registers which may be used for function linkage.


marty
