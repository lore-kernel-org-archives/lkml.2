Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1GFPaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:30:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55457 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab1GFPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:30:18 -0400
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 6 Jul 2011 11:29:58 -0400
X-Google-Sender-Auth: 369hyON3CwgZW4XA8VY0siz52-0
Message-ID: <CAObL_7HV0fTQ7D2vxbowKN4NVeHyaKSdvJtjSr5Zgfegz=B2Pg@mail.gmail.com>
Subject: CONFIG_AUDITSYSCALL has pointless overhead
To: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[emailing maintainers directly because the list is subscribers-only]

$ sudo auditctl -l
No rules

<system call overhead is 68 ns>

$ sudo auditctl -A task,never

<system call overhead is now 42 ns>

This is on Fedora 15 on kernel.org's 2.6.39 and various 3.0 rc builds
on Sandy Bridge.  The auditing path that, as far as I can tell, does
nothing accounts for over one third of system call overhead.  (On
older machines this effect is a little less impressive because all
system calls are quite a bit slower.  It still takes 40ns on Nehalem,
but the base cost is closer to 120 ns.)

The culprit seems to be audit_alloc in auditsc.c, which sets
TIF_SYSCALL_AUDIT even when there isn't anything to audit.  Maybe
something else in the kernel needs audit_set_auditable, but then the
docs should indicate that setting syscall auditing to never is
different from having no rules at all.  This seems unlikely.

--Andy
