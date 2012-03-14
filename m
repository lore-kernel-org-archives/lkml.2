Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030563Ab2CNOlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:41:47 -0400
Received: from imta21.fe.bosch.de ([139.15.243.226]:59002 "EHLO
	imta21.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab2CNOln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:41:43 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 10:41:42 EDT
From: "EXTERNAL Waechtler Peter (Fa. TCP, CM-AI/PJ-CF31)" 
	<external.Peter.Waechtler@de.bosch.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "pwaechtler@mac.com" <pwaechtler@mac.com>
Date: Wed, 14 Mar 2012 15:31:36 +0100
Subject: [RFD] how to get something like chkspace / kinfo_getvmmap?
Thread-Topic: [RFD] how to get something like chkspace / kinfo_getvmmap?
Thread-Index: Ac0B7ylIJoLYuitSSzWf0J4wxOAPew==
Message-ID: <274124B9C6907D4B8CE985903EAA19E91B2C998E04@SI-MBX06.de.bosch.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for implementing robust exception handlers that print out a backtrace in
the signal handler, it would be nice to have a syscall to check if a
memory access would fail.

I know that one can parse /proc/self/maps (like libsigsegv does).
libunwind employs an addrspace->access_mem() method that does an
unprotected access because there is no (easy) way on Linux.


How about enhancing mincore() with a few bits that tells the caller how
the protection bits are?
The main use case is in an embedded system to avoid that the handler
(already running on an alternate signal stack) faults if the stack pointer
achieved to point into the guard page - causing backtrace() to fail.

mincore() on FreeBSD provides some more bits, but still the access bits
are missing.

     MINCORE_INCORE            Page is in core (resident).
     MINCORE_REFERENCED        Page has been referenced by us.
     MINCORE_MODIFIED          Page has been modified by us.
     MINCORE_REFERENCED_OTHER  Page has been referenced.
     MINCORE_MODIFIED_OTHER    Page has been modified.
     MINCORE_SUPER             Page is part of a "super" page. (only i386 &
                               amd64)

add

        MINCORE_PROT_W
        MINCORE_PROT_R
        MINCORE_PROT_X

So essentially I'm looking for a way for mgetprotect(2) or
mprotect(addr, len, PROT_GET, &prot_bits)?

But this is really ugly ;)


input welcome
        Peter Wächtler

