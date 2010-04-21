Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0DUKQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:16:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41229 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab0DUKQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:16:52 -0400
Subject: Re: mprotect() failed: Cannot allocate memory
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: libc-help@sourceware.org, linux-kernel@vger.kernel.org
In-Reply-To: <201004210105.20942.pluto@agmk.net>
References: <201004210105.20942.pluto@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 12:16:50 +0200
Message-ID: <1271845010.1776.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 01:05 +0200, Paweł Sikora wrote:
> hi,
> 
> i'm trying to debug an ugly application with ElectricFence.
> in fact, on x86-64 box with 8GB ram and 16GB swap i'm getting following error:
> 
> "ElectricFence Exiting: mprotect() failed: Cannot allocate memory"
> 
> the program has been compiled with gcc-4.5, glibc-2.11.1, kernel-2.6.32.
> did you ever come across such (kernel/glibc) limitations?
> 
> here's a simple testcase which triggs -ENOMEM in mprotect().

You probably depleted the max map count, see:
  /proc/sys/vm/max_map_count

We have a limit on the number of maps you can have, those mprotect()
calls split you maps like crazy, see also /proc/$pid/maps.

eg. change your second test program to include something like:

  char buf[128];
  snprintf(buf, sizeof(buf), "cat /proc/%d/maps", (int)getpid());
  system(buf);

at the end after lowering your NN count to fit, and observe the result
of those mprotect() calls.

