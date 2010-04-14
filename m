Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab0DNExw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:53:52 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:11427 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0DNExv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:53:51 -0400
X-Spam-Processed: digidescorp.com, Tue, 13 Apr 2010 23:53:50 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.37.252
X-Return-Path: prvs=1720206d9c=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] microblaze: add stack unwinder
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Tue, 13 Apr 2010 23:53:46 -0500
Message-Id: <1271220827.2897.23.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been baking for awhile, I think it's ready for prime time. I've
beat on it in a noMMU kernel for awhile - backtracetest module,
kmemleak, dump_stack() in a number of different situations - all look
good. Thanks to Paul Mundt for initial advice on this feature.

I don't have MMU hardware or the ability to build a MMU kernel, so all
I've done there is check for gross compile errors. The MMU kernel
handles kernel stacks differently, which isn't an issue except in the
trap handlers (interrupt, syscall, etc.). This patch should work for MMU
kernels, but they won't trace back beyond a system trap. The intent is
to provide hooks for someone to add that capability later.

The key feature of the design is a search backwards from each return
address for the instruction that creates a stack frame.
CONFIG_FRAME_POINTER causes Microblaze gcc to use r19 as a frame
pointer, but because previous frame pointers are not stored in a
consistent location within each frame, it's not possible to avoid some
sort of search to determine frame size. (Side note, since
-fno-omit-frame-pointer isn't useful for Microblaze, it would be nice if
Microblaze could "opt-out" of FRAME_POINTER when selecting
FUNCTION_TRACER).

A brute-force search was chosen over a kallsyms-assisted search (as used
in the sh architecture) to avoid going off the rails in cases where
kallsyms chooses the closest global address instead of the true (local)
function address. Obviously there's an accuracy/speed tradeoff, but
under an assumption that most functions are reasonably-sized and most
backtraces are not performed in time-critical paths, this should be OK.

Happy unwinding,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


